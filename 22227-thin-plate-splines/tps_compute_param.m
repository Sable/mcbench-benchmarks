function [param] = tps_compute_param(PP,kernel,U,Pm,Q1,Q2,R,lambda,target)
%%=====================================================================
%% $RCSfile: tps_compute_param.m,v $
%% $Author: bjian $
%% $Date: 2008/11/24 08:59:01 $
%% $Revision: 1.1 $
%%=====================================================================

TB = U*PP;
QQ = Q2*Q2';
A = inv(TB'*QQ*TB + lambda*kernel)*TB'*QQ;
tps = A*target;
affine = inv(R)*Q1'*(target-TB*tps);
param = [affine; tps];
