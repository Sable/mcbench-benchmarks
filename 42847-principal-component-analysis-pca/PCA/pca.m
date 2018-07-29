% Jason Joseph Rebello
% Carnegie Mellon University (Jan 2012 - May 2013) 
% MS in Electrical & Computer Engineering
% Principal Component Analysis

% This program uses Principal Component Analysis to reduce the number
% of features used in face recognition. This program allows you to set K
% if you know the number of Principal components needed or calculates K 
% based on how much variance you would like to preserve in the images.
% Note: K has been commented out since I am calculating K based on
% variance.

clear all;
clc;
close all;

fprintf('Principal Component Analysis used for Face Recognition\n\n');
t = cputime;

%% Initializing Variable

fprintf('Initializing Variables');
%K = 100; % Number of reduced features (principal components)
dispFaces = 12; % How many faces to display
variance = 90; % Enter a number between 1 and 99 both inclusive based on
                % how much variance to preserve.
topeig = 12; % Used to display the top 10 eigen vectors found
fprintf('...done\n\n'); 

%% Loading and Visualizing data

fprintf('Loading and Visualizing data');
load('faces.mat');
displayData(X(1:dispFaces, :)); % function taken from Machine Learning course                                
title('Original faces')         % by Prof Andrew Ng.
fprintf('...done\n\n');
pause(1);

%% Normalizing features

fprintf('Normalizing features');
[X mu stddev]  = normalizeFeatures(X);
fprintf('...done\n\n');

%% Perform PCA to get eigen vectors and eigen values

fprintf('Performing PCA & displaying top %d eigen vectors found', topeig);
[U,S] = performPCA(X);
displayData(U(:, 1:topeig)');
title('Top Eigen Vecotrs found');
fprintf('...done\n\n');
pause(2);

%% Calculate K based on variance

fprintf('Find best value of K based on Variance');
K = findK(S, variance);
fprintf('...done\n\n');

%% Get data with reduced features

fprintf('Displaying data with reduced features');
reducedData = reducedFeatures(X, U, K);
fprintf('...done\n\n');

%% Recover Original Data

fprintf('Recovering Original Data from reduced features');
XRecovered = recoverData(reducedData, U, K);
fprintf('...done\n\n');

%% Display Original and Recovered Data

fprintf('Displaying Original and Recovered Data');
show(X, XRecovered, dispFaces);
fprintf('...done\n\n');

fprintf('Program executed in %f seconds or %f minutes\n\n', cputime-t, ...
                                            (cputime-t)/60);
pause(1);