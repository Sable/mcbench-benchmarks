function [S,P,X,L,Phi] = fix_lengths(S,P,X,inter)
% given scales, projection matrices and structure, compute the
% corresponding scales and structure with segment lengths fixed over time
%
% © Copyright Phil Tresadern, University of Oxford, 2006

% small hack to fix affine ambiguity - shouldn't make a huge difference in
% most cases
P(:,3)	= -P(:,3);
X(3,:)	= -X(3,:);

% compute segment lengths
L	= median(get_lengths(X,inter));

% rescale with respect to reference length (eg, hip separation)
S		= S * L(1);
X		= X / L(1);
L		= L / L(1);

% recompute poses from rescaled structure
Phi	= compute_poses(X,inter);

% apply poses to fixed length skeleton
X		= reconstruct(L,Phi);
