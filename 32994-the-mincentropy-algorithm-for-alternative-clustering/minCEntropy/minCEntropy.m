% minCEntropy clustering: partitional clustering using the minimum conditional Entropy objective
%(C) Nguyen Xuan Vinh, 2010. Contact:  vinh.nguyenx@gmail.com, vinh.nguyen@monash.edu
%Input:
%   a: data, rows for objects, cols for features
%   K: number of desired clusters
%   sigma_factor: default kernel with sigma_0, specify sigma_factor to obtain
%               a new kernel width,  sigma=sigma_0/sigma_factor
%   n_run: optional, number of runs, default: 1
%   init_mem: optional, initial clustering
%Output:
%   max_mem: best clustering over n_run runs
%   max_obj: max objective value
%   S: kernel similarity matrix
%Reference:
%   [1] N. X. Vinh, Epps, J., "minCEntropy: a Novel Information Theoretic Approach for the Generation of
%       Alternative Clusterings,"  in IEEE Int. Conf. on Data Mining (ICDM) 2010.
%Example:
%
% X = [randn(100,2)+5;randn(100,2)+[5*ones(100,1) -5*ones(100,1)];  randn(100,2)-5;randn(100,2)+[-5*ones(100,1) 5*ones(100,1)]];
% [mem]=minCEntropy(X,2,1,10);  %% run minCEntropy+ 10 times,
%                               %% with K=2, sigma=sigma_0
% figure;scatter(X(:,1),X(:,2),30,mem);title('minCEntropy clustering');

function [max_mem,max_obj,all_mem,S]=minCEntropy(a,K,sigma_factor,n_run,SS,init_mem)

if nargin<3 sigma_factor=1;end;
if nargin<4 n_run   = 1;end;
if nargin<6 hasC=-1;end;
    
[n dim]=size(a);

if nargin<5
    SE=sqdistance(a');
    sigma0=sum(sum(sqrt(SE)))/n^2/2; %1/2 average pairwise distance
    sigma0=real(sigma0);
    sigma=sigma0/sigma_factor;
    sig2=4*sigma^2;
    S=exp(-SE/sig2);
else
    S=SS; %preprovided kernel matrix
end
Spc=zeros(n,K);            %point->cluster similarity
G=zeros(1,K);              %cluster quality
Nj=zeros(1,K);             %cluster size
 
max_obj=-inf;%best objective
max_mem=[];
all_mem=zeros(n_run,n);


for run=1:n_run
    change_count=0;
    
    if hasC==-1
        %initialization with Kmeans, using only 1 iteration
        mem=kmeans(a,K,'Maxiter',0,'EmptyAction','singleton');
        %random initialization
        %mem=round(rand(1,n)*(K-1))+1;
    else
        n_run=1;
        mem=init_mem;
    end;

    setup();

    obj=sum(G./Nj);
    isContinue=1;
while isContinue
isContinue=0;
for i=1:n

   cur_clus=mem(i);   
   %check point->cluster similarity
   max_inc=-inf; % maximum objective increase
   for new_clus=1:K
      if new_clus==cur_clus continue;end;     
      cond2=G(cur_clus)/(Nj(cur_clus)-1)/Nj(cur_clus)-G(new_clus)/(Nj(new_clus)+1)/Nj(new_clus)-2*Spc(i,cur_clus)/(Nj(cur_clus)-1)+2*Spc(i,new_clus)/(Nj(new_clus)+1);
      if cond2>max_inc
        max_inc=cond2;
        max_clus=new_clus;
      end
   end
      
    if(max_inc>0) %make change 
         new_clus=max_clus;
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
         
         change_count=change_count+1;
     
    end %make change
    
end%for i=1:n  one round through the data set
end%while point can still move

obj=sum(G./Nj);
fprintf('Sigma factor: %d, changes: %d, quality: %f\n',sigma_factor,change_count,obj);
if max_obj<obj
   max_obj=obj;
   max_mem=mem;
end
all_mem(run,:)=mem;
end%for run

fprintf('>>>>>>>>Finished clustering. best quality: %f\n',max_obj);
mem=max_mem;

%----------end main function------------------
    function setup()        
        for i=1:n
           for j=1:K
                Spc(i,j)=sum(S(i,mem==j));  % point -> cluster similarity
           end
        end

        for j=1:K
            G(j)=sum(Spc(mem==j,j)); 
            Nj(j)=sum(mem==j);
        end
    end

end%main function