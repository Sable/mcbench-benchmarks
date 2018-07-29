% minCEntropy clustering: partitional clustering using the minimum conditional Entropy objective
%(C) Nguyen Xuan Vinh, 2010. Contact:  vinh.nguyenx@gmail.com, vinh.nguyen@monash.edu
%Input:
%   a: data, rows for objects, cols for features
%   K: number of desired clusters
%   C0: given clustering
%   sigma_factor: default kernel with sigma_0=1/2 the average pairwise distance, specify sigma_factor to obtain
%                 a new kernel width,  sigma=sigma_0/sigma_factor
%   n_run: optional, number of runs, default: 1
%   m: optional, trade-off factor = [1, +inf], higher value for higher clustering quality, lower for more diversity. 
%   alpha: unused
%   SS: optional, preprovided kernel matrix
%   C: optional, initial clustering
%Output:
%   max_mem: best clustering over n_run runs
%   max_obj: max objective value
%   all_mem: all clusterings of n_run runs
%   S: kernel similarity matrix
%Reference:
%   [1] N. X. Vinh, Epps, J., "minCEntropy: a Novel Information Theoretic Approach for the Generation of
%       Alternative Clusterings,"  in IEEE Int. Conf. on Data Mining (ICDM) 2010.
%Example:
%
% X = [randn(100,2)+5;randn(100,2)+[5*ones(100,1) -5*ones(100,1)];  randn(100,2)-5;randn(100,2)+[-5*ones(100,1) 5*ones(100,1)]];
% C0=[ones(1,200) 2*ones(1,200)];
% figure;scatter(X(:,1),X(:,2),30,C0,'o');title('Original clustering');
% [mem]=minCEntropy_plus(X,2,C0,1,3,10);  %% run minCEntropy+ 10 times,
%                                         %% with m=3, K=2, sigma=sigma_0
% figure;scatter(X(:,1),X(:,2),30,mem);title('minCEntropy^+ alternative clustering');
%

function [max_mem,max_obj,all_mem,S]=minCEntropy_plus(a,K,C0,sigma_factor,m,n_run,alpha,SS,C)


if nargin<4 sigma_factor=[1];end;
if nargin<5 m=2.5;end;
if nargin<6 n_run=1;end;
if nargin<7 alpha=2;end; %balanced objective
if nargin<9 hasC=-1;end; %no initial clustering

[n dim]=size(a);
if nargin<8 %compute kernel matrix
    SE=sqdistance(a');
    sigma0=sum(sum(sqrt(SE)))/n^2/2; %1/2 average pairwise distance
    sigma0=real(sigma0);
    sigma=sigma0/sigma_factor;
    sig2=4*sigma^2;
    S=exp(-SE/sig2);
else
    S=SS; %preprovided kernel matrix
end
Spc=zeros(n,K);%point->cluster similarity
G=zeros(1,K);%cluster quality

max_obj=-inf;
min_obj=inf;
max_mem=[];
all_mem=zeros(n_run,n);

for run=1:n_run
%initial clustering
if hasC==-1
     fprintf('No initial clustering. Using random clustering...\n');
     C=round(rand(1,n)*(K-1))+1;
     %C=kmeans(a,K,'Maxiter',0);
     %plot2Ddata(a,C);
     %title('Random clustering');
else
     if dim==2 
        plot2Ddata(a,C);
        title('Initial provided alternative clustering'); 
     end;
end

Conti=Contingency(C0,C);%contingency table
Conti2=Conti.^2;
Conti_mag=sum(Conti); %marginal

mem=C;
change_count=0;   
setup();

obj1=sum(G./Nj);  %quality
obj2=sum(sum(Conti2)./Conti_mag); %diversity
if run==1 alpha=obj1/obj2/m;end;  %update alpha in the first run only


fprintf('\nInitial clustering. Total: %f Quality: %f, Diversity: %f\n',obj1-obj2,obj1,-obj2);

isContinue=1;
while isContinue
isContinue=0;
for i=1:n

   cur_clus=mem(i);   
   %check point->cluster similarity
   max_inc=-inf; % maximum objective increase
   for new_clus=1:K
      if new_clus==cur_clus continue;end;
      
%       cond1=(G(cur_clus)-2*Spc(i,cur_clus))/(Nj(cur_clus)-1);
%       cond1=cond1+(G(new_clus)+2*Spc(i,new_clus))/(Nj(new_clus)+1);      
%       cond1=cond1-G(cur_clus)/Nj(cur_clus)-G(new_clus)/Nj(new_clus);
      
      cond1=G(cur_clus)/(Nj(cur_clus)-1)/Nj(cur_clus)-G(new_clus)/(Nj(new_clus)+1)/Nj(new_clus)-2*Spc(i,cur_clus)/(Nj(cur_clus)-1)+2*Spc(i,new_clus)/(Nj(new_clus)+1);
      
      C0_clus=C0(i);
      sum1=sum(Conti2(:,cur_clus));
      sum2=sum(Conti2(:,new_clus));
      cond2=sum1/Conti_mag(cur_clus)+sum2/Conti_mag(new_clus) ; %diversity
      
      sum1=sum1-(Conti(C0_clus,cur_clus))^2+(Conti(C0_clus,cur_clus)-1)^2;
      sum2=sum2-(Conti(C0_clus,new_clus))^2+(Conti(C0_clus,new_clus)+1)^2;
      cond2=cond2-sum1/(Conti_mag(cur_clus)-1)-sum2/(Conti_mag(new_clus)+1) ; %diversity
      
      if cond1+alpha*cond2>max_inc
         max_inc=cond1+alpha*cond2;
         max_clus=new_clus;
      end
   end
      
   if(max_inc>0) %make change        
         new_clus=max_clus;
         
         Conti(C0_clus,cur_clus)= Conti(C0_clus,cur_clus)-1;
         Conti(C0_clus,new_clus)= Conti(C0_clus,new_clus)+1;
         Conti_mag(cur_clus)=Conti_mag(cur_clus)-1;
         Conti_mag(new_clus)=Conti_mag(new_clus)+1;         
         Conti2(C0_clus,cur_clus)= (Conti(C0_clus,cur_clus))^2;
         Conti2(C0_clus,new_clus)= (Conti(C0_clus,new_clus))^2;
         
         change_count=change_count+1;
         isContinue=1;
         
         %update tables     
         for t=1:n
            if t==i continue;end;
            Spc(t,cur_clus)=Spc(t,cur_clus)-S(t,i);
            Spc(t,new_clus)=Spc(t,new_clus)+S(t,i);
         end
         
         G(cur_clus)=G(cur_clus)-2*Spc(i,cur_clus);
         G(new_clus)=G(new_clus)+2*Spc(i,new_clus);
         
         %update membership
         mem(i)=new_clus;  
         Nj(cur_clus)=Nj(cur_clus)-1;
         Nj(new_clus)=Nj(new_clus)+1;
         
         CC(i,cur_clus)=false;
         CC(i,new_clus)=true;

         cur_clus=new_clus;
          
   end %update
    
end%for i=1:n  one round through the data set
end%while point can still move

obj1=sum(G./Nj);  %quality
obj2=sum(sum(Conti2)./Conti_mag); %diversity
fprintf('Finished clustering. Total changes: %d, Total: %f Quality: %f, Diversity: %f\n',change_count,obj1-obj2,obj1,-obj2);

if max_obj<obj1-alpha*obj2  %update best clustering
    max_obj=obj1-alpha*obj2;
    max_mem=mem;
end

if min_obj>obj1-alpha*obj2  %update best clustering
    min_obj=obj1-alpha*obj2;
    min_mem=mem;
end
all_mem(run,:)=mem;
end%for run
fprintf('Final clustering. Max obj: %f, Min obj: %f\n',max_obj,min_obj);



%----------end main function------------------
    function setup()
        for i=1:n
           for j=1:K
                Spc(i,j)=sum(S(i,mem==j));  % point -> cluster similarity
           end
        end

        for j=1:K
            t=find(mem==j);
            G(j)=sum(Spc(t,j)); 
            Nj(j)=length(t);
        end
    end

end%main function
