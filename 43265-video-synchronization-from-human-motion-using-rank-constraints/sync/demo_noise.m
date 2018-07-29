clear all; close all; clc;
addpath('./toolbox');

% load feature trajectories
load('./data/running.mat');

% define some variables
dtrng			= 20:0.5:40;
arng			= 0.8:0.02:1.2;
projmodel = 'affine';
a_con			= [];						% set to a value to constrain a

% define noise parameters
nnoise		= 21;
nits			= 20;
noisevec	= linspace(0,5,nnoise);
dts				= zeros(nits,nnoise);

% offset W1 by 30 frames
W1		= W1(31:end-30,:);

for n = 1:nnoise
	for it = 1:nits
		W1n = W1 + noisevec(n)*randn(size(W1));
		W2n	= W2 + noisevec(n)*randn(size(W2));
		
		% run synchronization script
		[a,dt] = sync(W1n,W2n,a_con,projmodel);
	
		dts(it,n)	= dt;
	end
end

% this took a while so save to a temporary file just in case
save('temp.mat','dts');

mn	= mean(dts,1);
sd	= 3*std(dts,[],1);

figure;
	plot([0,5],[30,30],'r--',...
				noisevec,dts,'b.');
	axis('equal',[minmax(noisevec),28,32]);
	xlabel('\sigma_n (pixels)'); ylabel('Recovered offset (frames)');
	
