function [errs] = compute_errors(W_gt,W,P,L_gt,L,Phi_gt,Phi)
% compute various errors given ground truth and estimated data
%
% © Copyright Phil Tresadern, University of Oxford, 2006

% reprojection error
Res				= W(:)-W_gt(:);
errs(1)		= sqrt(((Res'*Res) / length(Res)) * 2);

% joint angle error
ResMat		= Phi([19,23,27,31],:) - Phi_gt([19,23,27,31],:);
Res				= ResMat(:);
errs(2)		= sqrt((Res'*Res) / length(Res));

% limb length error
Lerr			= abs(100*(L-L_gt) ./ L_gt);
errs(3)		= mean(Lerr(2:end));

% compute camera orientation error
[errs(4),errs(5)] = compute_cam_errors(P(3:4,:));

