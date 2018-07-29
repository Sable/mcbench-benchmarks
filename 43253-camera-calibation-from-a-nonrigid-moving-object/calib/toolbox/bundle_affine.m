function [S,P,Tout,Lout,Pout,data,Wout] = bundle_affine(Sin,Pin,T,Lin,Phi,W)
% function [S,P,Tout,Lout,Pout,data,Wout] = bundle_affine(Sin,Pin,T,Lin,Phi,W)	
%
% Apply bundle adjustment under an affine projection model to the input
% parameters:
%   Sin - image scaling per frame
%		Pin - projection matrices (fixed over all frames)
%   T - translation in the image (fixed over all frames)
%   Lin - segment lengths
%   Phi - poses defining joint positions and angles
%   W - measured joint projections
% 
% to refine estimates of output variables:
%   S - image scaling per frame
%		P - projection matrices (fixed over all frames)
%   Tout - translation in the image (fixed over all frames)
%   Lout - segment lengths
%   Pout - poses defining joint positions and angles
%   data - performance measures (#iterations, time taken etc)
%   Wout - estimated joint projections
%
% © Copyright Phil Tresadern, University of Oxford, 2006

S = []; P = []; Tout = []; Lout = []; Pout = []; data = []; Wout = [];

% tolerance for lsqnonlin convergence
tol = 1e-2;

npoints	= size(W,2);
nframes	= size(W,3);

% default optimization parameters
funopts	= optimset('lsqnonlin');
opts		= optimset(	funopts,...
											'Display','none');

% remove any off-diagonal enties - generally zero but some ~eps due to
% precision error
for f	= 1:nframes
	Sin(:,:,f)	= diag(diag(Sin(:,:,f)));
end

% vector of scale factors
temp	= Sin(find(Sin));
S			= temp(1:2:end);

% generate z-axis of 2nd projection matrix and extract Euler angles
Rot		= [Pin(3:4,:); cross(Pin(3,:),Pin(4,:))];
xyz		= rot2xyz(Rot);

% parameters that affect measurements in all frames
p_com	= [	xyz';						% orientation of camera 2
					T(:);						% global image translation
					Lin(2:end)' ];	% limb lengths

% parameters that affect measurements only in a single frame
p_frm = [reshape(S,[2,nframes]); Phi];

fprintf('Performing bundle adjustment (affine)\n');

% calculate sparsity map of Jacobian
fprintf('  Calculating Jacobian sparsity...');
	JP = compute_sparsity(p_com,p_frm,W,length(Lin));

	% set specific optimization parameters
	opts	= optimset(opts,...
										'TolFun',tol,...
										'JacobPattern',JP);
	fprintf('done\n');

	% display initial reprojection error
	p0 = [p_com; p_frm(:)];
	Res	= cost(p0,W,length(Lin));
	fprintf('  RMS error (before): %g\n',sqrt( (Res'*Res)/(length(Res)/2) ));

	fprintf('  Optimizing parameters...');
	tic;
		[pmin,ResNorm,Residual,ExitFlag,Output] = ...
			lsqnonlin(@cost,p0,[],[],opts,W,length(Lin));
	t = toc;
	fprintf('done\n');

	% display final reprojection error
	Res	= cost(pmin,W,length(Lin));
	fprintf('  RMS error (after): %g\n',sqrt( (Res'*Res)/(length(Res)/2) ));

fprintf('  Optimization required %g iterations and %g seconds\n\n',Output.iterations,t);

[P,Tout,S,Lout,Pout] = unwrap(pmin,nframes,length(Lin));
[Wout] = reproject(pmin,nframes,length(Lin));

data	= [	Output.iterations,...		% how many iterations were used
					t,...										% how long it took
					sqrt( (Res'*Res)/(length(Res)/2) ),... % rms error
					0,0];
				
					
function res = cost(params,Win,nsegs)
% compute residual vector over all projected joint locations

Wnew	= reproject(params,size(Win,3),nsegs);
res		= Win(:)-Wnew(:);
	

function W = reproject(params,nframes,nsegs)
% create projected features from parameter vector

[P,T,scales,lengths,poses] = unwrap(params,nframes,nsegs);
X	= reconstruct(lengths,poses);
npoints = size(X,2);
W	= zeros(4,npoints,nframes);
for f = 1:nframes
	S					= diag(scales([1 1 2 2],f));
	W(:,:,f)	= S*P*X(:,:,f) + T(:,ones(1,npoints));
end


function [P,T,S,L,Phi] = unwrap(params,nframes,nsegs)
% "unwrap" vector of parameters

% first three define orientation of second camera
c	= cos(params(1:3)); s = sin(params(1:3));
P	= [	1 0 0; 0 1 0;
			c(3)*c(2) c(3)*s(2)*s(1)-s(3)*c(1) 	c(3)*s(2)*c(1)+s(3)*s(1);
			s(3)*c(2) s(3)*s(2)*s(1)+c(3)*c(1) 	s(3)*s(2)*c(1)-c(3)*s(1)];
params	= params(4:end);

% next four define translation in image plane
T				= params(1:4);
params	= params(5:end);

% get lengths of segments
% first length is always 1
L				= [1 params(1:nsegs-1)'];
params	= params(nsegs:end);

% remaining parameters are image scalings and skeleton pose parameters
% these apply to each frame independently rather than over all frames
S_Phi		= reshape(params,[length(params)/nframes,nframes]);	
S				= S_Phi(1:2,:);
Phi			= S_Phi(3:end,:);


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

