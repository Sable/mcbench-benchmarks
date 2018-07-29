% gravity_demo.m

% Copyright 2003-2010 The MathWorks, Inc.

clear, close all, clc
get_video_data, disp('press any key to select region'), pause
select_region, disp('press any key to remove background'), pause
remove_background, disp('press any key to segment balls'), pause
segment_by_threshold, disp('press any key to suppress noise'), pause
suppress_noise, disp('press any key to locate ball positions'), pause
locate_ball_positions, disp('press any key to fit circle'), pause
fit_circle, disp('press any key to transform XY points to polar'), pause
%transform_to_polar, disp('press any key to fit damped sinusoid'), pause
%fit_damped_sinusoid, disp('press any key to calibrate pixel size'), pause
transform_to_polar, disp('press any key to model system'), pause
edit model_system
model_system, disp('press any key to calibrate pixel size'), pause
calibrate_resolution, disp('press any key to calculate gravity'), pause
edit calculate_gravity
calculate_gravity