%normalization example
close all
clear all
path(path,'..\..\FUZZCLUST')
%the data
load data3.txt
data.X = data3;
%normalization
figure(2)
subplot(3,1,1),plot(data.X(:,1),data.X(:,2),'.')
data = clust_normalize(data,'range')
subplot(3,1,2),plot(data.X(:,1),data.X(:,2),'x')
data = clust_normalize(data,'var')
subplot(3,1,3),plot(data.X(:,1),data.X(:,2),'+')

