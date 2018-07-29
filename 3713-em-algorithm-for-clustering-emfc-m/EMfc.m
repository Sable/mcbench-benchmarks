function EMfc
%This is an implementation of the EM algorithm for Clustering via Gaussian
%mixture models, using graphical on-line representation.

%Panagiotis Braimakis (s6990029)

%load simulated gaussian data.
clear;clc
%for p=1:1000
load data
%load M5    %uncomment only if you want to take results from k-means
            %algorithm

%if i load the M5 matrix then i get as starting values tha ones given via
%the kmeans algorithm, which as he saw detects only spherical clusters
%(which does not always hold)
%So lets give initial random id's to the observations.

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%OPTIONAL SUB-SAMPLING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%%%%%%
 %sample from X
 t=10000;
%  Y=randperm(t);
%  X=X(Y,:);
 
cidx=unidrnd(5,t,1);
%in order to give a SEED for the Z matrix ,which classifies 
%each row of data to it's cluster, we use the results of another clustering method  
tic;
Z=zeros(t,5);   %Setting up the storing matrix.
for i=1:t
for j=1:5
if (cidx(i)==j)     %cidx was the (t*1) id-matrix of each record (from 1 to 5)
Z(i,j)=1;           %The new (t*5) Z matrix has only ones, where needed
end %if
end %for
end %for

%Since we have the seed we can now implement the M-step of the algorithm &
%get the loop started between the "Maximization" & "Expectation" steps.

    w=0;    %for the graphs.
    c=2;    %starting counter.
    ll(1)=-88888888;  %starting values just to set the first difference between the log-likelihood's
                %in the first step (remember l(-1) & l(0) does not exist!!!)
    ll(2)=-77777777;
while ll(c)-ll(c-1) > 10^(-10);
     
    c=c+1;  
    g=c-2   %iteration number.
    %all these are the estimates for the parameters of mixture models with
    %normal components.(Geoffrey J. Mclachlan &Kaye E. Basford)
    
    %nk row matrix is an estimate of the number of "points" on each
    %cluster.
    nk=sum(Z,1);
    
    %just for the plots
    
    for i=1:t
max(i)=Z(i,1);
k=1;
for j=2:5
if  (Z(i,j)>max(i))
max(i)=Z(i,j);
P(i,k)=0;
k=j;
else
P(i,j)=0;
end
end
P(i,k)=1;
end
    
    n=sum(P,1);
        
        %Now the tk row-matrix estimates each time the probabilities of belonging
    %to the jth cluster (j=1:5)
    tk=nk./t;
    %%Now comes the mean's matrix if we suppose that i element of X belongs to the k-th
    %%cluster (that is done via the Z matrix each time).
    sumclusterX=X'*Z;
    diagnk=diag(nk);
    diag1nk=inv(diagnk);                
    mean=sumclusterX*diag1nk;
    
    %Next one is the estimated intra-cluster VAriance-COvariance MAtrix of
    %the data.
    
 covma=cell(5,1);
 
    for j=1:5
     
    Q1=X-ones(t,1)*mean(:,j)';  %x's-means
    Q2=Q1';                         
A=cell(t,1);
    for i=1:t
        A(i)={Q1(i,:)};
    end
B=cell(t,1);
    for i=1:t
        B(i)={Q2(:,i)};
    end
        T=[Z(:,j) Z(:,j)];

C=cell(1,1);
    for e=1:t
       C{e}=(T(e,:)'.*B{e})*A{e};
    end
    
    nom=[0 0;0 0];
    for k = 1:length(C)
    nom=C{k}+nom;
    end %for
    
    covma{j}=nom./nk(j);
    end %for
          
  %PLOTS the 95% confidence ellipses & the (X,Y) pairs of each cluster in each iteration.
  
%   w=w+1;
%   subplot(2,2,w);
%   hold on,
%   
%   
  plot(X(:,1),X(:,2),'m.');
  confreg(mean(:,1),covma{1},n(1),0.05);  
  confreg(mean(:,2),covma{2},n(2),0.05);
  confreg(mean(:,3),covma{3},n(3),0.05);
  confreg(mean(:,4),covma{4},n(4),0.05);
  confreg(mean(:,5),covma{5},n(5),0.05);
  axis equal;
  zoom out;
  xlabel(g);
  title('Progress Graph');
  ylabel('Data vs Clusters');
  grid on;
  hold off
pause(0.1);
  
  
  if w==4    %tests' whether your initial graph counter is 4 in order to reset him and subplot to 
    w=0;    %the correct position.
  else
    w=w;
  end %if
  


   %f(xi|theta-hat) matrix (n*k) -which is for every xi and every
    %mean,var-cov matrix.
    
 for k=1:5
     for i=1:t
 Q11=X(i,:)-mean(:,k)';  %xi-mean
 Q22=Q11';
   f(i,k)=(((2*pi)^-1)*(det(covma{k}))^(-1/2))*exp(-(1/2)*(Q11*(covma{k}^-1))*Q22);
 %The l(i,k) matrix is only computed in these two for's in order to avoid extra aggravation 
 %of our program.
 
 l(i,k)=tk(k)*f(i,k);        
 
    end %for
 end %for
 
 
%the log-likelihood of our data given the iteration c is equal to:
ll(c)=sum(log(sum(l,2)));
        
     
%  E-step (posterior expected value)

for i=1:t
    for k=1:5

        Z(i,k)=(tk(k)*f(i,k))/sum(tk'.*f(i,:)');
    end
end
save sampleresults1 Z mean covma n P ll ;

 end %while
 
 
% disp('Time to Find Clusters: ');
% Q(p)=toc
% LL{p}=ll;
% MEANS{p}=mean;
% COVS{p}=covma;
% save MEANS&COVS100 MEANS COVS Q LL;
% p
%end %for p
disp('Have a nice morning')