function [U,Pm,Q1,Q2,R] = tps_set_landmarks(landmarks,ctrl_pts)
%%=====================================================================
%% $RCSfile: tps_set_landmarks.m,v $
%% $Author: bjian $
%% $Date: 2008/11/24 08:59:02 $
%% $Revision: 1.1 $
%%=====================================================================
[m,d] = size(landmarks);
U = compute_TPS_kernel(landmarks, ctrl_pts);
Pm = [ones(m,1) landmarks];
[q,r]   = qr(Pm);
Q1      = q(:, 1:d+1);
Q2      = q(:, d+2:m);
R       = r(1:d+1,1:d+1);

