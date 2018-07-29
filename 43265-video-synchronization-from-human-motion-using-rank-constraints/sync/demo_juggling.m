clear all; close all; clc;
addpath('./toolbox');

% load feature trajectories
load('./data/juggling.mat');

% define some variables
dtrng			= 110:0.25:120;
arng			= 0.75:0.02:0.95;
projmodel = 'affine';
a_con			= [];						% set to a value to constrain a

% run synchronization script
[a,dt] = sync(W1,W2,a_con,projmodel);

