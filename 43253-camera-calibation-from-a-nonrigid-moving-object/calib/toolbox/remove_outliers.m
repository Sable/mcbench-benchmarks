function [Wout] = minimal(Win,varargin)
% function [Wout] = remove_outliers(Win,{sigma,pFail,pGood,thresh})
%
% detect and flag outliers in point measurements given estimated noise
% level, estimated proportion of outliers and desired probability of
% success. Uses RanSaC (Fischler and Bolles, Graphics and Image 
% Processing 1981).
%
% © Copyright Phil Tresadern, University of Oxford, 2006

Wout 		= Win;

sigma		= 0;
pFail		= 0.001;
pGood		= 0.9;
thresh	= 1;

if (nargin > 1), sigma = varargin{1}; end
if (nargin > 2), pFail = varargin{2}; end
if (nargin > 3), pGood = varargin{3}; end
if (nargin > 4), thresh = max(1,varargin{4}); end

nframes	= size(Win,3);
npoints	= size(Win,2);
nparams	= 8;

% estimate number of trials we need to take
nTests 	= ceil(log(pFail) / log(1 - pGood^nparams));

max_support = 0;
Wt	= Win(:,:);
for i = 1:nTests
	% select random subset of points
	r		= randperm(size(Wt,2));
	pts	= r(1:nparams);
	
	% compute fundamental matrix
	F		= getF(Wt,pts);

	% compute error for all points
	errvec = zeros(1,size(Wt,2));
	for p = 1:length(errvec)
		el 	= [Wt(1:2,p); 1]' * F;
		el	= el / norm(el(1:2));
		v2 	= [Wt(3:4,p); 1];

		errvec(p) = abs(el*v2);
	end

	% find points lying within the threshold
	support = sum(errvec<thresh) / length(errvec);
	if (support > max_support)
		max_support = support;
		best_pts = pts;
		inliers	= find(errvec < thresh);
	end
end

% recompute F for all inliers
pts = inliers;
F		= getF(Wt,pts);

% recompute error for all points with new fund. mat.
% if error is above threshold, flag it as an outlier by replacing with NaN
errvec = zeros(1,size(Wt,2));
for p = 1:length(errvec)
	el 	= [Wt(1:2,p); 1]' * F;
	el	= el / norm(el(1:2));
	v2 	= [Wt(3:4,p); 1];

	errvec(p) = abs(el*v2);

	if (errvec(p) > thresh)
		Wt(:,p) = NaN;
	end
end

Wout = reshape(Wt,4,npoints,nframes);


function F = getF(Wt,pts)
% estimate fundamental matrix between two views
% uses normalization as proposed by Hartley (TPAMI 1997)

nparams	= length(pts);

Wp	= Wt(:,pts);
t 	= mean(Wp,2);
Wn	= Wp - t(:,ones(1,nparams));

s		= 2 * sqrt(nparams / (norm(Wn(1:2,:),'fro')^2));
T1	= [eye(2)*s -t(1:2)*s; 0 0 1];
W1	= T1 * [Wp(1:2,:); ones(1,nparams)];

s		= 2 * sqrt(nparams / (norm(Wn(3:4,:),'fro')^2));
T2	= [eye(2)*s -t(3:4)*s; 0 0 1];
W2	= T2 * [Wp(3:4,:); ones(1,nparams)];

A		= [	W1(1,:).*W2(1,:); W1(1,:).*W2(2,:); W1(1,:).*W2(3,:);
				W1(2,:).*W2(1,:); W1(2,:).*W2(2,:); W1(2,:).*W2(3,:);
				W1(3,:).*W2(1,:); W1(3,:).*W2(2,:); W1(3,:).*W2(3,:)]';

[U,S,V] = svd(A);
nullvec	= V(:,end);

F = reshape(nullvec,3,3)';

[U,S,V] = svd(F);
S(3,3)	= 0;
F = T1'*U*S*V'*T2;
