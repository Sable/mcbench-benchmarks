function [P1,P2,Lout,Pout,data,Wout] = bundle_persp(K1,K2,R2,t2,Lin,Pin,W,inter)
% function [P1,P2,Lout,Pout,data,Wout] = bundle_persp(K1,K2,R2,t2,Lin,Pin,W,inter)
%
% Apply bundle adjustment under a perspective projection model to the input
% parameters:
%   K1 - internal calibration of camera 1 (assumed to be aligned with world
%   origin)
%		K2 - internal calibration of camera 2
%   R2 - orientation of camera 2
%   t2 - position of camera 2
%   Lin - segment lengths
%   Pin - poses defining joint positions and angles
%   W - measured joint projections
%   inter - list of segments with fixed length over time
% 
% to refine estimates of output variables:
%   P1 - projection matrix of camera 1 (= K1*[I 0])
%   P2 - projection matrix of camera 2 (= K2*[R2 t2])
%   Lout - segment lengths
%   Pout - poses defining joint positions and angles
%   data - performance measures (#iterations, time taken etc)
%   Wout - estimated joint projections
%
% © Copyright Phil Tresadern, University of Oxford, 2006

P1 = []; P2 = []; Lout = []; Pout = []; data = []; Wout = [];

% tolerance for lsqnonlin convergence
tol = 1e-5;

npoints	= size(W,2);
nframes	= size(W,3);

funopts	= optimset('lsqnonlin');
opts		= optimset(	funopts,...
											'Display','none');

% Get camera parameters and optimize
f			= K1(1,1);
cam1	= [f];

f			= K2(1,1);
xyz		= rot2xyz(R2);
cam2	= [f; t2; xyz'];

p0	= [	cam1;					% camera 1 parameters
				cam2;					% camera 2 parameters
				zeros(6,1) ]; % position and orientation of joints in the world
			
% fix joint locations for time being
X		= reconstruct(Lin,Pin);

fprintf('Performing bundle adjustment (perspective)\n');

% calculate sparsity map of Jacobian
% very lazy: just perturb each variable in turn and record those that
% change - this is fine for this case since there are so few variables
fprintf('  Calculating Jacobian sparsity...');
	res = cost(p0,W,length(Lin),X);
	JP	= sparse(length(res),length(p0));
	for p = 1:length(p0)
		ptemp			= p0;
		ptemp(p) 	= ptemp(p) + 1;
		delta			= res-cost(ptemp,W,length(Lin),X);
		JP(:,p)		= abs(delta)>1e-6;
	end
	opts	= optimset(opts,...
 										'TolFun',tol,...
										'JacobPattern',JP);
	fprintf('done\n');

	Res	= cost(p0,W,length(Lin),X);
	fprintf('  RMS error (before): %g\n',sqrt( (Res'*Res)/(length(Res)/2) ));

	% optimize camera parameters only, plus a small correction of the world
	% co-ordinate frame with respect to camera 1 (that is fixed)
	fprintf('  Optimizing camera parameters...');
	tic;
		[pmin,ResNorm,Residual,ExitFlag,Output1] = ...
			lsqnonlin(@cost,p0,[],[],opts,W,length(Lin),X);
	t1 = toc;
	fprintf('done\n');

	Res	= cost(pmin,W,length(Lin),X);
	fprintf('  RMS error (after): %g\n',sqrt( (Res'*Res)/(length(Res)/2) ));

	fprintf('  Camera optimization required %g iterations in %g seconds\n',Output1.iterations,t1);

	
% apply correction to previously estimated joint locations
params = pmin(9:end);
c	= cos(params(1:3)); s = sin(params(1:3));
R	= [	c(3)*c(2) c(3)*s(2)*s(1)-s(3)*c(1) 	c(3)*s(2)*c(1)+s(3)*s(1);
			s(3)*c(2) s(3)*s(2)*s(1)+c(3)*c(1) 	s(3)*s(2)*c(1)-c(3)*s(1);
			-s(2)			c(2)*s(1)									c(2)*c(1)];
t	= params(4:6);

X(:,:)	= R*X(:,:) + t(:,ones(size(X(1,:))));

% recompute joint positions and angles
Pin			= compute_poses(X,inter);

% parameters that affect measurements in all frames
p_com	= [	pmin(1:8);			% parameters of cameras 1 and 2
					Lin(2:end)' ];	% limb lengths

% parameters that affect measurements only in a single frame
p_frm = Pin;							% joint angles

fprintf('  Calculating Jacobian sparsity...');
	JP = compute_sparsity(p_com,p_frm,W,length(Lin));
	
	opts	= optimset(opts,...
										'TolFun',tol,...
										'MaxIter',1e4,...
										'MaxFunEvals',1e6,...
										'JacobPattern',JP);
	fprintf('done\n');

	% optimize over camera and structure parameters
	fprintf('  Optimizing all parameters...');
	p0 = [p_com; p_frm(:)];
	tic;
		[pmin,ResNorm,Residual,ExitFlag,Output2] = ...
			lsqnonlin(@cost,p0,[],[],opts,W,length(Lin));
	t2 = toc;
	fprintf('done\n');

	Res = cost(pmin,W,length(Lin));
	fprintf('  RMS error : %g\n',sqrt( (Res'*Res)/(length(Res)/2) ));

	fprintf('  Full optimization required %g iterations in %g seconds\n',Output2.iterations,t2);

% get individual variables from parameter vector
[P1,P2,Lout,Pout] = unwrap(pmin,nframes,length(Lin));
Wout  = reproject(pmin,nframes,length(Lin));

data	= [	Output1.iterations+Output2.iterations,... % total #iterations
					t1+t2,... % total time taken
					sqrt((Res'*Res) / (length(Res)/2) ),... % rms error
					0,0];


function res = cost(params,Win,nsegs,varargin)
% compute residual vector over all projected joint locations

Wnew	= reproject(params,size(Win,3),nsegs,varargin{:});
res		= Win(:)-Wnew(:);


function W = reproject(params,nframes,nsegs,varargin)
% create projected features from parameter vector

% we hope that this will not happen (but it probably has in the past)
if (sum(abs(imag(params))) > 0)
	% this may occur due to numerical stability - if imaginary parts are tiny
	% then we could just ignore them and take the real parts
	disp('imaginary params');	pause;
end

if (nargin == 4)
	% unwrap camera parameters only and use specified structure (X)
	[C1,C2,R,t] = unwrap2(params);
	X						= varargin{1};
	Xnew				= zeros(size(X));
	Xnew(:,:)		= R*X(:,:) + t(:,ones(size(X(1,:))));
else
	% unwrap both camera and structure parameters, and reconstruct X
	[C1,C2,lengths,poses] = unwrap(params,nframes,nsegs);
	Xnew	= reconstruct(lengths,poses);
end

% reproject under perspective model
npoints = size(Xnew,2);
Xnew		= [Xnew(:,:); ones(1,npoints*nframes)];
W1			= C1*Xnew;
	W1			= W1(1:2,:) ./ W1([3,3],:);
W2			= C2*Xnew;
	W2			= W2(1:2,:) ./ W2([3,3],:);
W				= [W1; W2];


function [C1,C2,lengths,poses] = unwrap(params,nframes,nsegs)
% unwrap parameter vector into separate variables

params	= params(:);

% get camera parameters
[C1,C2,params] = unwrap_cameras(params);

% remaining parameters define limb lengths and joint angles
% first length is always 1
lengths	= [1 params(1:nsegs-1)'];
poses		= params(nsegs:end);
poses		= reshape(poses,[length(poses)/nframes,nframes]);


function [C1,C2,R,t] = unwrap2(params)
% unwrap parameter vector into separate variables

params	= params(:);

% get camera parameters
[C1,C2,params] = unwrap_cameras(params);

% next six parameters define a small adjustment to the position and
% orientation of the joint locations in the world
c	= cos(params(1:3)); s = sin(params(1:3));
R	= [	c(3)*c(2) c(3)*s(2)*s(1)-s(3)*c(1) 	c(3)*s(2)*c(1)+s(3)*s(1);
			s(3)*c(2) s(3)*s(2)*s(1)+c(3)*c(1) 	s(3)*s(2)*c(1)-c(3)*s(1);
			-s(2)			c(2)*s(1)									c(2)*c(1)];
t	= params(4:6);


function [C1,C2,params] = unwrap_cameras(params)
% unwrap camera parameter vector into separate variables

params	= params(:);

% this assumes that both cameras are 640x480 with a principal point at the
% centre. This is not the case for the juggling sequence which will
% introduce some small errors but they are unlikely to be significant. We
% could always fix this by including the image sizes as additional
% constants

% first parameter defines camera 1
cam			= params(1);
	K			= [cam(1) 0 320; 0 cam(1) 240; 0 0 1];
	C1		= K*[eye(3) zeros(3,1)];
params	= params(2:end);

% next seven parameters define camera 2
cam			= params(1:7);
	K			= [cam(1) 0 320; 0 cam(1) 240; 0 0 1];
	c			= cos(cam(5:7)); s = sin(cam(5:7));
	R			= [	c(3)*c(2) c(3)*s(2)*s(1)-s(3)*c(1) 	c(3)*s(2)*c(1)+s(3)*s(1);
						s(3)*c(2) s(3)*s(2)*s(1)+c(3)*c(1) 	s(3)*s(2)*c(1)-c(3)*s(1);
						-s(2)			c(2)*s(1)									c(2)*c(1)];
	t			= cam(2:4);
	C2		= K*[R t];
params	= params(8:end);


function JP = compute_sparsity(p_com,p_frm,W,n_segs)
% compute sparse matrix that indicates which elements of the Jacobian
% (dr/dp) are non-zero. Makes optimization considerably more efficient.

% get number of frames
nframes = size(W,3);

% initial parameter vector
p0 = [p_com(:); p_frm(:)];

% get size of Jacobian
res = cost(p0,W,n_segs);
JP	= sparse(length(res),length(p0));

% define initial parameters for a single frame and corresponding residual
p0	= [p_com(:); p_frm(:,1)];
res = cost(p0,W(:,:,1),n_segs);

% compute effect of common parameters
subblock = sparse(length(res),length(p_com));
for p = 1:length(p_com)
	ptemp			= p0;
	ptemp(p) 	= ptemp(p) + 1;
	delta			= res - cost(ptemp,W(:,:,1),n_segs);
	subblock(:,p) = abs(delta)>1e-6;
end

% copy to Jacobian pattern matrix
rows = 1:length(res);
cols = 1:length(p_com);
for f = 1:nframes
	JP(rows,cols) = subblock;
	rows = rows+length(res);
end

% compute effect of frame-dependent parameters
subblock = sparse(length(res),length(p_frm(:,1)));
for p = length(p_com)+[1:length(p_frm(:,1))]
	ptemp			= p0;
	ptemp(p) 	= ptemp(p) + 1;
	delta			= res - cost(ptemp,W(:,:,1),n_segs);
	subblock(:,p-length(p_com)) = abs(delta)>1e-6;
end

% copy to Jacobian pattern matrix
rows = 1:length(res);
cols = length(p_com)+[1:length(p_frm(:,1))];
for f = 1:nframes
	JP(rows,cols) = subblock;
	rows = rows+length(res);
	cols = cols+length(p_frm(:,1));
end

