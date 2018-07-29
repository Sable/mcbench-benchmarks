function [Sout,Pout,Xout,T,data] = lieb(Win,intra,inter,varargin)
% function [Sout,Pout,Xout,T,data] = lieb(Win,intra,inter,varargin)
% 
% Compute image scaling (Sout), orthogonal projection matrices (Pout), 3D
% structure (Xout) and 2D image translation (T) using structure from motion
% followed by Liebowitz and Carlsson's calibration method.
% 
% 'data' stores parameters of interest from an evaluation point of view
% (e.g. execution time)
%
% © Copyright Phil Tresadern, University of Oxford, 2006

Sout = []; Pout = []; Xout = []; T = []; data = [];

error(nargchk(3,4,nargin));

% weighting of projection constraints versus structure constraints
wcam = 1;
if length(varargin)>0, wcam	= varargin{1}; end

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

% compute metric projection and structure using L&C's method with structural
% constraints specified by 'intra' and 'inter'
[Scl,Pm,Xm,data1]	= rectify(P,X,intra,inter,wcam);

	
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
[St,Pout,Xout,data2] = rectify(Ptemp,Xtemp,[intra1;intra2],[],wcam);

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


function [S,Pm,Xm,data] = rectify(P,X,intra,inter,wcam)
%% calibrate structure and motion from projection and kinematic constraints

disp('Calibrating...');

S = []; Pm = []; Xm = [];

nframes = size(X,3);
npoints	= size(X,2);

% constraints on projection matrices (weighted by importance)
CP			= wcam * get_cons_proj(P);

% constraints on structure (intra-frame and inter-frame)
CSintra	= get_cons_intra(X,intra);
CSinter = get_cons_inter(X,inter);
CS			= [CSintra; CSinter];

% parameters of U for each frame
U0			= zeros(6,nframes);
rows		= 1:4;
cols		= 1:6;

for f = 1:nframes
	% each Omega has six parameters but four constraints on the projection 
	%	matrices, leaving two degrees of freedom - s.cos(t) and s.sin(t). Since
	%	the scaling s does not affect the sign of the eigenvalues (only their
	%	absolute value) we can compute the limits (l) of t for which Omega is
	%	positive definite as required
	% N defines the 2D subspace that gives valid solutions for Omega
	[l,N] 	= get_limits(full(CP(rows,cols)));

	% start from the midpoint of the valid interval
	theta0	= mean(l);
	k				= [cos(theta0); sin(theta0)];
	
	% compute Omega for the initial parameters
	omega		= inv(vec2sym(N*k));

	% extract parameters of U corresponding to Omega
	U0(:,f)	= triu2vec(chol(omega));

	% next frame
	rows		= rows + 4;
	cols		= cols + 6;
end

% remove degree of freedom in global scaling to avoid singularity
G				= logical([0,0,0,0,0,1]);
scales	= U0(G,:);
U0 			= U0 ./ scales(ones(6,1),:);
scales	= scales / scales(1);
U0			= [scales; U0(~G,:)];
U0			= U0(2:end);

% define non-linear optimizer parameters
funopts	= optimset('lsqnonlin');
opts		= optimset(funopts,...
										'Display','notify');

if (nframes == 1)
	% optimization of all frames together
	opts	= optimset(opts,...
										'MaxFunEvals',1e6,...
										'MaxIter',1e4);
									
	% CS is dense in this case anyway
	CS		= full(CS);
else
	% individual frames
	
	% determine structure of sparse Jacobian to make optimization faster
	JP		= getJacobianPattern(intra,inter,nframes);
	opts	= optimset(opts,...
										'JacobPattern',JP);
end

fprintf('Initial: %g\n',norm(cost(U0,CP,CS,G)));

% find locally optimal values for calibration matrices
tic;
[Umin,ResNorm,Residual,ExitFlag,Output] = ...
	lsqnonlin(@cost,U0,[],[],opts,CP,CS,G);
t			= toc;
its		= Output.iterations;
data	= struct('its',its,'time',t,'ExitFlag',ExitFlag);

fprintf('Final:   %g\n',norm(cost(Umin,CP,CS,G)));
fprintf('%g iterations in %g seconds (%g sec/it)\n\n',its,t,t/its);

% recompute individual U matrices
Umat				= reshape([1; Umin(:)],[6,nframes]);
scales			= Umat(1,:);
Umat(~G,:)	= Umat(2:6,:);
Umat(G,:)		= ones(1,nframes);
Umat				= Umat .* scales(ones(6,1),:);

% compute metric structure and projection matrices
Pm	= zeros(size(P));
Xm	= zeros(size(X));

for f = 1:nframes
	U = vec2triu(Umat(:,f));

	Pm(:,:,f) = P(:,:,f) / U;
	Xm(:,:,f) = U * X(:,:,f);
end

% extract image scalings from projection matrices
[S,Pm,Xm] = normalize(Pm,Xm);


function Res = cost(Uvec,CP,CS,G)
%% compute residual for Uvec, given constraints defined in CP (projection) and 
% CS (structure)
Uvec		= [1; Uvec(:)];
nframes	= length(Uvec) / 6;
Umat		= reshape(Uvec,[6,nframes]);

% reconstruct the U matrices
scales			= Umat(1,:);
Umat(~G,:)	= Umat(2:6,:);
Umat(G,:)		= ones(1,nframes);
Umat				= Umat .* scales(ones(6,1),:);

Om 		= zeros(6,nframes);
OmInv	= zeros(6,nframes);

% compute Omega and Omega^-1 for every frame
for f = 1:nframes
	U			= [	Umat(1,f) Umat(2,f) Umat(4,f);
						0					Umat(3,f) Umat(5,f);
						0					0					Umat(6,f)];
	Uinv	= inv(U);

	Omega			= U'*U;
	OmegaInv	= Uinv*Uinv';

	Om(:,f)			= Omega([1,4,5,7,8,9])';
	OmInv(:,f)	= OmegaInv([1,4,5,7,8,9])';
end

% compute structure and projection residuals given elements of Omega
Rstruc	= CS*Om(:);
Rproj		= CP*OmInv(:);
Res			= [Rstruc; Rproj];


function JacPatt = getJacobianPattern(intra,inter,nframes)
%% define sparsity structure of Jacobian

d1	= sparse(kron(eye(nframes),ones(1,6)));
d1(:,1:6) = ones(size(d1,1),6);
d1	= sparse(kron(ones(size(intra,1),1),d1));

d2	= sparse(kron(eye(nframes-1),ones(1,6)));
d2	= sparse([ones(nframes-1,6) d2]);
d2	= sparse(kron(ones(size(inter,1),1), d2));

d3	= sparse(kron(eye(nframes),ones(4,6)));

JacPatt	= [d1; d2; d3];
JacPatt	= JacPatt(:,2:size(JacPatt,2));
