close all
clear all
path(path,'..\..\..\FUZZCLUST')
%the data
data.X = nDexample(5,400,2,1)
[N,n]=size(data.X);

%data normalization
data = clust_normalize(data,'range');
plot(data.X(:,1),data.X(:,2),'.')
hold on
%parameters given
%param.c = [0.6    0.5
%           0.6    0.5
%           0.6    0.5]
param.c=3;
param.vis=1;
param.val=2;

result=kmedoid(data,param);
hold on
plot(result.cluster.v(:,1),result.cluster.v(:,2),'ro')

result = validity(result,data,param);
result.validity