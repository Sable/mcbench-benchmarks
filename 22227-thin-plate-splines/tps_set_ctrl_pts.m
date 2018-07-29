function [PP,kernel] = tps_set_ctrl_pts(ctrl_pts)
%%=====================================================================
%% $RCSfile: tps_set_ctrl_pts.m,v $
%% $Author: bjian $
%% $Date: 2008/11/24 08:59:01 $
%% $Revision: 1.1 $
%%=====================================================================

[n,d] = size(ctrl_pts);
K = tps_compute_kernel(ctrl_pts, ctrl_pts);
Pn = [ones(n,1) ctrl_pts];
PP = null(Pn');  % or use qr(Pn)
kernel = PP'*K*PP;

