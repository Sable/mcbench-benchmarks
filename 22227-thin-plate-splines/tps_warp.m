function [target, bending] = tps_warp(PP,kernel,U,Pm,param)
%%=====================================================================
%% $RCSfile: tps_warp.m,v $
%% $Author: bjian $
%% $Date: 2008/11/24 08:59:04 $
%% $Revision: 1.1 $
%%=====================================================================

% param = [affine; tps]
[m,d] = size(Pm);
basis = [Pm U*PP];
target = basis*param;
tps = param(d+1:end,:);
bending = trace(tps'*kernel*tps);
