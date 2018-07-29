clear all; close all; clc;
addpath('./toolbox');

% load feature trajectories
load('./data/depth.mat');

% define some variables
dtrng			= 20:0.5:40;
arng			= 0.8:0.02:1.2;
projmodel = 'perspective';
a_con			= [];						% set to a value to constrain a

% offset W1 by 30 frames
W1	= W1(31:end-30,:);

% run synchronization script
[a,dt] = sync(W1,W2,a_con,projmodel);

