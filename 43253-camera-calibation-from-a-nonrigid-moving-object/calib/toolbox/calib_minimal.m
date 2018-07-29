function [Sout,Pout,Xout,T,data] = calib_minimal(Win,intra,inter)
% function [Sout,Pout,Xout,T,data] = calib_minimal(Win,intra,inter)
% 
% Compute image scaling (Sout), orthogonal projection matrices (Pout), 3D
% structure (Xout) and 2D image translation (T) using structure from motion
% followed by Tresadern and Reid's calibration method.
% 
% 'data' stores parameters of interest from an evaluation point of view
% (e.g. execution time)
%
% © Copyright Phil Tresadern, University of Oxford, 2006

Sout = []; Pout = []; Xout = []; T = []; data = [];

nframes	= size(Win,3);
npoints	= size(Win,2);

% find points that have been flagged as outliers
W			 	= Win(:,:);
goodpts	= reshape(~any(isnan(W),1),[npoints,nframes]);

%% Recover local structure
disp('Recovering local structure');

% compute 2D image translation and normalize with respect to it
T	= mean(W(:,goodpts(:)),2);
W	= W - T(:,ones(1,size(W,2)));

% initialize projection matrices and 3D structure
P	= zeros(4,3,nframes);
X	= NaN*ones(3,npoints,nframes);
	
for f = 1:nframes
	% remove image translation
	Wt 	= Win(:,goodpts(:,f),f);
	t		=	mean(Wt,2);
	Wt	= Wt - t(:,ones(1,size(Wt,2)));
		
	% factorize using svd
	[U,S,V] = svd(Wt,0);
	
	% compute affine projection matrices and 3D structure
	P(:,:,f)	= U(:,1:3) * sqrt(S(1:3,1:3));
	X(:,goodpts(:,f),f)	= sqrt(S(1:3,1:3)) * V(:,1:3)';
end

% compute metric projection and structure using T&R's method with structural
% constraints specified by 'intra' and 'inter'
[Scl,Pm,Xm,data1]	= rectify(P,X,intra,inter);

%% Recover global structure
disp('Recovering global structure');

% remove image scaling so we can treat all frames together
W	= reshape(W,4,npoints,nframes);
for f = 1:nframes
	W(:,:,f)	= Scl(:,:,f) \ W(:,:,f);
end
	
% compute any residual image translation and remove it (storing the updated
% value in T)
W = W(:,:);
t	= mean(W(:,goodpts(:)),2);
W	= W - t(:,ones(1,size(W,2)));
T	= T + t;

% factorize all frames together
Wt	= W(:,goodpts(:));
[U,S,V] = svd(Wt,0);
	
% compute projection and structure for all frames together
Ptemp	= U(:,1:3) * sqrt(S(1:3,1:3));
Xtemp	= NaN*ones(3,npoints*nframes);
	Xtemp(:,goodpts(:))	= sqrt(S(1:3,1:3)) * V(:,1:3)';

% compute intra-frame constraints for all frames together
ncons		= size(intra,1);
intra1	= zeros(ncons*nframes,4);
rows		= 1:ncons;
for f = 1:nframes
	intra1(rows,:) = intra;
	rows	= rows + ncons;
	intra	= intra + npoints;
end
		
% compute inter-frame constraints for all frames together
% since we now consider everything to be a snapshot at a single instant in 
% time, all constraints are now 'intra-frame' (so stored in 'intra2')
ncons		= size(inter,1);
intra2	= zeros(ncons*(nframes-1),4);
rows		= 1:ncons;
temp		= inter + npoints;
for f = 1:nframes-1
	intra2(rows,:) = [inter temp];
	rows	= rows + ncons;
	temp	= temp + npoints;
end

% recompute metric structure
[St,Pout,Xout,data2] = rectify(Ptemp,Xtemp,[intra1;intra2],[]);

% split structure up into separate frames
Xout	= reshape(Xout,[3,npoints,nframes]);
Sout	= zeros(size(Scl));
	
% correct to estimated scaling
for f = 1:nframes
	Sout(:,:,f) 	= St * Scl(:,:,f);
end
					
data	= [	data1.its,data1.time,...
					data2.its,data2.time,...
					(data1.ExitFlag>0)&(data2.ExitFlag>0)];


function [S,Pm,Xm,data] = rectify(P,X,intra,inter)
%% calibrate structure and motion from projection and kinematic constraints

disp('Calibrating...');

S = []; Pm = []; Xm = []; data = [];
	
nframes = size(X,3);
npoints	= size(X,2);
	
% constraints on projection matrices (weighted by importance)
CP			= get_cons_proj(P);

% constraints on structure (intra-frame and inter-frame)
CSintra	= get_cons_intra(X,intra);
CSinter = get_cons_inter(X,inter);
CS			= [CSintra; CSinter];

% subspaces defining valid U matrices and initial value of theta
Null		= zeros(6,2,nframes);
theta0	= zeros(1,nframes);
		
rows		= 1:4;
cols		= 1:6;
	
% bounds on scales (row 1) and thetas (row 2)
lbound	= zeros(2,nframes);
ubound	= Inf * ones(2,nframes);

for f = 1:nframes
	% compute subspace and limits on theta for each frame
	[l,N]				= get_limits(full(CP(rows,cols)));
	theta0(f)		= mean(l);
	Null(:,:,f) = N;

	% update bounds on theta
	lbound(2,f)	= l(1);
	ubound(2,f)	= l(2);

	% next frame
	rows	= rows + 4;
	cols	= cols + 6;
end

% define initial parameter vector (i.e. scales and thetas)
p0	= [ones(1,nframes); theta0];
p0	= p0(2:end);

% scale in frame 1 will be fixed at unity
lbound	= lbound(2:end);
ubound	= ubound(2:end);

% default parameters for optimization
funopts	= optimset('lsqnonlin');
opts		= optimset(funopts,...
										'Display','notify','MaxIter',1e4);

if (nframes == 1)
	% optimization of all frames together
	opts	= optimset(opts,...
										'MaxFunEvals',1e6);
									
	% CS is dense in this case anyway
	CS		= full(CS);
	JP		= [];
else
	% individual frames

	% determine structure of sparse Jacobian to make optimization faster
	% in this case, we can get the pattern directly from the structural
	% constraints - instead of 6 constraints per frame we have 2
	JP		= CS(:,1:3:end);
	
	% but parameter 1 is fixed so not included in the optimization
	JP		= JP(:,2:end);

	opts	= optimset(opts,...
										'JacobPattern',JP);
end

fprintf('Initial: %g\n',norm(cost(p0,Null,CSintra,CSinter)));

% find locally optimal values for calibration matrices
% note that we can easily specify parameter bounds in this case
tic;
[pmin,ResNorm,Residual,ExitFlag,Output,Lambda,Jacobian] = ...
	lsqnonlin(@cost,p0,lbound,ubound,opts,Null,CSintra,CSinter);
t			= toc;
its		= Output.iterations;
data	= struct('its',its,'time',t,'ExitFlag',ExitFlag);
	
fprintf('Final:   %g\n',norm(cost(pmin,Null,CSintra,CSinter)));
fprintf('%g iterations in %g seconds (%g sec/it)\n\n',its,t,t/its);

% get scales and thetas out of best parameter vector
pmin	= [1; pmin(:)];
scale	= pmin(1:2:end);
theta	= pmin(2:2:end);

% compute metric structure and projection matrices
S			= zeros(4,4,nframes);
Pm		= zeros(size(P));
Xm		= zeros(size(X));

for f = 1:nframes
	% compute OmegaInv, Omega and U from parameters
 	k	= scale(f) * [cos(theta(f)); sin(theta(f))]; % basic
	
	OmegaInv	= vec2sym(Null(:,:,f)*k);
	Omega			= inv(OmegaInv);
	U 				= chol(Omega);

	Pm(:,:,f) = P(:,:,f) / U;
	Xm(:,:,f) = U * X(:,:,f);
end
	
% extract image scalings from projection matrices
[S,Pm,Xm] = normalize(Pm,Xm);


function Res = cost(params,Null,sym,rig)
%% compute residual reprojection error given parameters

nframes	= size(Null,3);

% unwrap parameter vector
params	= [1; params(:)];
scale		= params(1:2:end);
theta		= params(2:2:end);

% allocate space for Omega matrices
Om 			= zeros(6,nframes);

% precompute sine and cosines
s	= sin(theta); c	= cos(theta);

% compute all Omega matrices
for f = 1:nframes
	k	= scale(f) * [c(f); s(f)];
		
	vOmegaInv = Null(:,:,f)*k;
	OmegaInv	= vOmegaInv([1,2,4;2,3,5;4,5,6]);
	Omega			= inv(OmegaInv);
	Om(:,f)		= Omega([1,4,5,7,8,9])';
end

% compute residual
Res	= [sym; rig]*Om(:);
	
	
function JacPatt = getJacobianPattern(intra,inter,nframes)
%% define sparsity structure of Jacobian
%  since this can be obtained from the structural constraints it is not
%  called in this work. I left it here for reference

nintra	= nframes * size(intra,1);
ninter	= (nframes-1) * size(inter,1);

d		= sparse(kron(eye(nframes-1),[1 1]));
		
d1	= sparse([zeros(1,2*(nframes-1)); d]);
d1	= sparse([ones(size(d1,1),1) d1]);
d1	= sparse(kron(ones(size(intra,1),1),d1));
	
d2	= sparse([ones(size(d,1),1) d]);
d2	= sparse(kron(ones(size(inter,1),1), d2));
	
JacPatt	= [d1; d2];
