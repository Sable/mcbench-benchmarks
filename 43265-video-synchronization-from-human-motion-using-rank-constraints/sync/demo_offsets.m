clear all; close all; clc;
addpath('./toolbox');

% load feature trajectories
load('./data/running.mat');

% define some variables
dtrng			= 20:0.5:40;
arng			= 0.8:0.02:1.2;
projmodel = 'affine';
a_con			= [1];						% set to a value to constrain a

% define offset parameters
noffs	= 10;
a			= zeros(1,noffs+1);
dt		= zeros(1,noffs+1);

% offset W1 by 30 frames
W1		= W1(31:end-30,:);
W2		= W2(1:noffs:end,:);
t			= (30:30+noffs) / noffs;

for i = 0:noffs
	W1off	= W1(i+1:noffs:end,:);
	
	% run synchronization script
	[a(i+1),dt(i+1)] = sync(W1off,W2,a_con,projmodel);
end

figure; hold on;
	plot(t,t,'r--',t,dt,'b-');
	axis([t(1),t(end),t(1),t(end)]);
	xlabel('True offset (frames)'); ylabel('Recovered offset (frames)');

