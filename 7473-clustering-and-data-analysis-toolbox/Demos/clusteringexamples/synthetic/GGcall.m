close all
clear all
path(path,'..\..\..\FUZZCLUST')

%loading the data set
data.X = nDexample(5,400,2,1)

%parameters
param.c=3;
param.m=2;
param.e=1e-4;
param.vis=0;
param.val=1;
%normalization
data=clust_normalize(data,'range');

result = FCMclust(data,param);
param.c=result.data.f; %initializing with the results of C-means
result = GGclust(data,param); 
result = validity(result,data,param);

plot(data.X(:,1),data.X(:,2),'b.',result.cluster.v(:,1),result.cluster.v(:,2),'ro');
hold on
%draw contour-map
new.X=data.X;
eval=clusteval(new,result,param);
result.validity