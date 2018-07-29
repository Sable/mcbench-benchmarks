% This is an example of using this software to train a binary 
% decision tree classifier, and use this classifier to classify 
% testing data. 

% Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>, 
% Signal Analysis and Machine Perception Laboratory, 
% Department of Electrical, Computer, and Systems Engineering, 
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA
% 
% You are free to use this software for academic purposes if you cite our paper: 
% Q. Wang, Y. Ou, A.A. Julius, K.L. Boyer, M.J. Kim, 
% Tracking tetrahymena pyriformis cells using decision trees, 
% in: 2012 International Conference on Pattern Recognition, Tsukuba Science City, Japan.
% 
% For commercial use, please contact the authors. 

clear;clc;close all;

%% settings
Depth=5; % maximal depth of decision tree
Splits=100; % number of candidate thresholds at each node
MinNode=10; % minimal size of a non-leaf node

%% training
load TrainingData.mat;

tic;
T=create01Tree(X,Y,Depth,Splits,MinNode);
t1=toc;

clear X Y;

%% testing
load TestingData.mat;

tic;
y=[];
for i=1:size(X,1)
    x=X(i,:);
    y(i,1)=decide01Tree(x,T);
end
t2=toc;

%% evaluation
errorRate=sum(abs(y-Y))/max(size(Y));
fprintf('Error rate = %.4f\n',errorRate);
fprintf('Training time = %.4f seconds\n',t1);
fprintf('Testing time = %.4f seconds\n',t2);