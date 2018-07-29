clear all
close all
path(path,'..\..\FUZZCLUST')

%loading the data
%load data2.txt
%data.X = data2;

load onedimtry.mat -ascii
data.X = onedimtry;

%normalization and plotting
data = clust_normalize(data, 'range');
%plot(data.X(:,1),data.X(:,2),'.')
hold on
%plot(0.5,0.5,'ro')
hold on
%parameters
param.m = 2; param.c = 3; param.e = 1e-3;
%GK clustering
result = GKclust(data,param);
%plot(result.cluster.v(:,1),result.cluster.v(:,2),'m*')
new.X = data.X;
%new.X = [0.5 0.5];
eval = clusteval(new,result,param);
