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
param.e=1e-3;
param.val=1;

%FCM clustering
result = FCMclust(data,param);

%validation
result = validity(result,data,param);
plot(data.X(:,1),data.X(:,2),'b.',result.cluster.v(:,1),result.cluster.v(:,2),'ro');
hold on
plot(result.cluster.v(:,1),result.cluster.v(:,2),'ro');

%evaluation
new.X=data.X;
eval = clusteval(new,result,param);
result.validity