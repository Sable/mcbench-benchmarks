% Copyright (C) 2010 Quan Wang <wangq10@rpi.edu>
% Signal Analysis and Machine Perception Laboratory
% Department of Electrical, Computer, and Systems Engineering
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA

%% A demo showing how to use this package for binary classification
%    f: (n0+n1)*2 feature matrix, each row being a data point
%    l0: (n0+n1)*1 ground truth of binary label vector, each element being 0 or 1
%    l: (n0+n1)*1 resulting binary label vector, each element being 0 or 1
clear;clc;close all;

n0=100;
n1=100;

l0=[zeros(n0,1);ones(n1,1)];
f=[l0+randn(n0+n1,1),l0+randn(n0+n1,1)];

[w,t,fp]=fisher_training(f,l0);
[l,precision,recall,accuracy,F1]=fisher_testing(f,w,t,l0);

%% visualization
figure;
plot(f(1:n0,1),f(1:n0,2),'bo','MarkerSize',10);
hold on;
plot(f(n0+1:end,1),f(n0+1:end,2),'rs','MarkerSize',10);
grid on;

xx=-2:0.1:3;
yy=-w(1)/w(2)*xx+t/w(2);
plot(xx,yy,'-.k','LineWidth',2);
title('data points and classification border');
legend('label 0','label 1','class border');
