function cp = cp_ml_logo
% CP Trajectory (MATLAB Logo)

% CP trajectory
load ml_logo.mat
center = [0.07; 0.05];
gain = 0.14;
ml_logo = repmat(center, 1, length(ml_logo_x)) + gain * [ml_logo_x; ml_logo_y];
cp = {ml_logo};
