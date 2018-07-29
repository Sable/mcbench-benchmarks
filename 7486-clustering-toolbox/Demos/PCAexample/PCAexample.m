% generate PCA example
clear all
close all
path(path,'..\..\FUZZCLUST')

data.X = nDexample(2,50,3,1);

figure(1)
plot3(data.X(:,1),data.X(:,2),data.X(:,3),'.')
grid on

%FCM clustering
param.c = 2;
param.m = 2;
result = FCMclust(data,param)

%PCA projection
param.q = 2;
result = PCA(data,param,result);
figure(2)
plot(result.proj.P(:,1),result.proj.P(:,2),'.')
hold on
plot(result.proj.vp(:,1),result.proj.vp(:,2),'r*')
perf = projeval(result,param);

perf