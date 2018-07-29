function [K,R,t] = getcparams(C)
% decompose projection matrix into a intrinsic parameters (K) and extrinsic
% parameters (rotation R and translation t)
%
% © Copyright Phil Tresadern, University of Oxford, 2006

% RQ decomposition of projection matrix
[K,R] = rq(C(1:3,1:3));

% ensure that f and alpha*f are both positive
if (K(2,2)/K(1,1) < 0)
	K(:,2:3) = -K(:,2:3);
	R(2:3,:) = -R(2:3,:);
end

% compute corresponding translation and rescale
t	= K \ C(:,4);
K	= K / K(3,3);
