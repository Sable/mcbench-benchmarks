close all
clear all
path(path,'..\..\..\FUZZCLUST')
%the data
load motorcycle.txt
data.X = motorcycle(:,[1 2]);

[N,n]=size(data.X);

%data normalization
data = clust_normalize(data,'range');
plot(data.X(:,1),data.X(:,2),'.')
hold on
%parameters
param.c=4;
param.vis=1;
param.val=2;
%clustering
result=kmedoid(data,param);
%validation
result = validity(result,data,param);
result.validity