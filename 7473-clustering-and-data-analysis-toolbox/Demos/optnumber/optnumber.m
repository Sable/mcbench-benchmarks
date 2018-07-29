%calling function to search the optimal number of clusters
close all
clear all
path(path,'..\..\FUZZCLUST')


%the data
load motorcycle.txt
data.X=motorcycle(:,[1 2]);
[N,n]=size(data.X);
%data normalizaiton
data = clust_normalize(data,'range');

%parameters
ncmax=14; %maximal number of cluster
param.m=2;
param.e=1e-3;
%
ment=[];
figure(1)
for cln=2:ncmax
param.c=cln;
    param.ro = ones(1,param.c);
    result=GKclust(data,param);
    clf
    plot(data.X(:,1),data.X(:,2),'b.',result.cluster.v(:,1),result.cluster.v(:,2),'r*');
    hold on
    new.X=data.X;
    clusteval(new,result,param)
    %validation
    result=modvalidity(result,data,param);
    ment{cln}=result.validity;

end


PC=[];CE=[];SC=[];S=[];XB=[];DI=[];ADI=[];

    for i=2:ncmax
       PC=[PC ment{i}.PC];
       CE=[CE ment{i}.CE];
       SC=[SC ment{i}.SC];
       S=[S ment{i}.S];
       XB=[XB ment{i}.XB];
       DI=[DI ment{i}.DI];
       ADI=[ADI ment{i}.ADI];
   end
    figure(2)
    clf
    subplot(2,1,1), plot([2:ncmax],PC)
    title('Partition Coefficient (PC)')
    subplot(2,1,2), plot([2:ncmax],CE,'r')  
    title('Classification Entropy (CE)')
    figure(3)
    subplot(3,1,1), plot([2:ncmax],SC,'g')
    title('Partition Index (SC)')
    subplot(3,1,2), plot([2:ncmax],S,'m')
    title('Separation Index (S)')
    subplot(3,1,3), plot([2:ncmax],XB)
    title('Xie and Beni Index (XB)')
    figure(4)
    subplot(2,1,1), plot([2:ncmax],DI)
    title('Dunn Index (DI)')
    subplot(2,1,2), plot([2:ncmax],ADI)
    title('Alternative Dunn Index (ADI)')
