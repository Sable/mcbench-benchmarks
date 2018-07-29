%%=====================================================================
%% $RCSfile: tps_test_script.m,v $
%% $Author: bjian $
%% $Date: 2008/11/24 08:59:03 $
%% $Revision: 1.1 $
%%=====================================================================

% preparation: set ctrl pts
ctrl_pts = rand(25,2);
[PP,kernel] = tps_set_ctrl_pts(ctrl_pts);
lambda = 0;

m = 10;
n = 10;
err = ones(m,n);
for i=1:m
    % step1: set landmarks;
    landmarks = rand(100,2);
    [U,Pm,Q1,Q2,R] = tps_set_landmarks(landmarks,ctrl_pts);

    for j=1:n
        % step2: set parameters;
        param0 = rand(25,2);
        [target, bending] = tps_warp(PP,kernel,U,Pm,param0);
        param1 = tps_compute_param(PP,kernel,U,Pm,Q1,Q2,R,lambda,target);
        err(i,j) = norm(param1-param0);
    end
end
max(err(:))
