clear all; close all; clc;
addpath('./toolbox');

% load feature trajectories
load('./data/homog.mat');

% define some variables
dtrng			= 5:0.5:25;
arng			= 0.45:0.02:0.85;
projmodel = 'homography';
a_con			= [];						% set to a value to constrain a

% run synchronization script
[a,dt] = sync(W1,W2,a_con,projmodel);

