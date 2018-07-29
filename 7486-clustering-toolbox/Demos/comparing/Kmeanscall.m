clear all
close all
path(path,'..\..\FUZZCLUST')
colors={'r.' 'gx' 'b+' 'ys' 'md' 'cv' 'k.' 'r*' 'g*' 'b*' 'y*' 'm*' 'c*' 'k*' };

%the data
data.X=nDexample(5,250,2,1);
%normalization
data=clust_normalize(data,'range');

%parameters
param.c=3;
param.m=2;
param.val=1;
param.vis=1;
%Kmeans clustering
result=kmeans(data,param);

%validation
result = validity(result,data,param);
%
result.validity

