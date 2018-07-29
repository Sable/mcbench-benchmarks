clear all; close all; clc;
addpath('./toolbox');

% load feature trajectories
load('./data/monkey.mat');

% define some variables
dtrng			= 40:0.5:60;
arng			= 0.8:0.02:1.2;
projmodel = 'affine';
a_con			= [];						% set to a value to constrain a

% offset W1 by 50 frames
W1	= W1(51:end-50,:);

% run synchronization script
[a,dt] = sync(W1,W2,a_con,projmodel);

