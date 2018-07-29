close all
clear all
path(path,'..\..\..\FUZZCLUST')
%the data
load motorcycle.txt
data.X = motorcycle(:,[1 2]);



%parameters
param.c=4;
param.m=2;
param.e=1e-4;
normalas = 1;
param.val=1;
%normalization
data=clust_normalize(data,'range');
%clustering
result = FCMclust(data,param);
param.c=result.data.f;
result = GGclust(data,param);
plot(data.X(:,1),data.X(:,2),'b.',result.cluster.v(:,1),result.cluster.v(:,2),'ro');
hold on
%draw contour-map
new.X=data.X;
eval=clusteval(new,result,param);
%validation
result = validity(result,data,param);
result.validity