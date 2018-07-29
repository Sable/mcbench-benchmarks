% this experiment adds outliers (in addition to gaussian noise) to the
% measurements and tests how well the calibration methods perform with and
% without outlier rejection techniques. The results correspond to Table 2
% of Tresadern and Reid, IVC 2008
%
% © Copyright Phil Tresadern, University of Oxford, 2006

clear all; close all; clc;
addpath('./toolbox');

% where to load/save data and figures
datapath	= './data/';
figpath		= './figs/synth_gorilla/';
	
% load gorilla dataset
load([datapath,'synth_gorilla.mat']);

nframes	= size(W1,1);
npoints	= size(W1,2)/2;

% use every 10th frame to be quick
rng = 1:10:nframes;
nframes	= length(rng);

% convert left/right matrices into a single measurement matrix
W1	= W1(rng,:);
W2	= W2(rng,:);
Wgt	= lr2W(W1,W2,0);
W		= Wgt;

% number of times to repeat
nTests 	= 10; % for debugging
% nTests 	= 100; % for IVC paper

vals		= zeros(4,4,nTests);

% list of limbs that we want to compare
newinter = [inter; 1 8; 1 11];
if (exist('Xgt'))
	Xrng	= Xgt(:,:,rng);
	Lgt		= median(get_lengths(Xrng,newinter));
	Lgt		= Lgt / Lgt(1);
end

for t = 1:nTests
	% generate noise with s.d. 2 pixels and 40 pixels
	n2	=  2*randn(size(Wgt(:,:)));
	n40	= 40*randn(size(Wgt(:,:)));
	
	% select, at random, which points to corrupt (approx. 10% 
	% of *correspondences* i.e. ~5% in each view)
	outs = rand(2,size(Wgt,2)*size(Wgt,3)) > 0.95;
	outs = outs([1,1,2,2],:);

	% Recover structure and motion
	sigma = 2;
	for n = 1:4
		switch (n)
			case 1,
				% no outliers, just noise
				noise = n2;
				W = Wgt + reshape(noise,size(Wgt));
				
			case 2,
				% both noise and gross outliers
				noise = (outs.*n40) + (~outs.*n2);
				W = Wgt + reshape(noise,size(Wgt));
				
				% replace known outliers with NaN
				W(:,any(outs)) = NaN;
				
			case 3,
				% both noise and gross outliers
				noise = (outs.*n40) + (~outs.*n2);	
				W = Wgt + reshape(noise,size(Wgt));
				
				% estimate outliers and replace NaN
				W = remove_outliers(W,sigma,0.001,0.8,10*sigma);
				
			case 4,
				% both noise and gross outliers
				noise = (outs.*n40) + (~outs.*n2);
				W = Wgt + reshape(noise,size(Wgt));
				
				% do nothing about outliers
		end
		
		% compute metric structure without bundle adjustment
		[S,P,X,T,perf] = calib_minimal(W,intra,inter);
		vals(n,1,t) = perf(5);
		
		% don't bother to compute errors for trials that did not converge
		if (perf(5)==0)
			continue;
		end
		
		% reproject estimated structure
		Wnew	= zeros(4,npoints,nframes);
		Tmat	= T(:,ones(1,npoints));
		for f = 1:nframes
			Wnew(:,:,f) = (S(:,:,f)*P*X(:,:,f)) + Tmat;
		end
		
		% compute reprojection error over points that are not thought to be
		% outliers
		goodpts	= ~isnan(W);
		Res	= W(goodpts) - Wnew(goodpts);
		RMS	= sqrt( (Res'*Res)/(length(Res)/2) );
		fprintf('RMS error : %g\n\n',RMS);
		vals(n,2,t) = RMS;
		
		% compute median lengths of all limbs that we could estimate
		D = get_lengths(X,newinter);
		L	= zeros(1,size(newinter,1));
		for l = 1:size(newinter,1)
			lengths = D(:,l);
			lengths = lengths(~isnan(lengths));
			L(l)	= median(lengths);
		end
		
		% normalize with respect to first limb
		L 		= L / L(1);
		err 	= abs(100*(L-Lgt)./Lgt);

		vals(n,3,t) = mean(err(2:end));
		vals(n,4,t) = max(err(2:end));
	end
end

% display summary of convergence, rms error and limb length errors
% (Table 2, Tresadern and Reid, IVC 2008)
% compute means over trials that did converge
converged = sum(vals(:,1,:),3);
errors = [converged sum(vals(:,2:4,:),3)./converged(:,[1,1,1])]
