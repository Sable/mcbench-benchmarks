%% ========================================================================
%  ARDrone Wi-Fi Control: Hovering and Position Control
%  ========================================================================
%
%  This script initializes a Simulink model that enables control of the
%  Parrot ARDrone via Wi-Fi using Simulink. The control law 
%  tracks a  desired target position. 
%
%  IMPORTANT NOTE: The position estimation given in this example is inaccurate and
%  may lead to unexpected behavior of the vehicle.  The position is estimated
%  by intergating a velocity estimation, which in turn is inaccurate.
%  The velocity is estimated by the Drone onboard flight computer. The
%  velocity estimation can be improved if there are features on the floor
%  as the Drone runs an optical flow algorithm for velocity determination.
%  
%  
%  Requirements:
%       Matlab, Simulink, Real-Time-Wndows-Target
%
%  Authors:
%       David Escobar Sanabria -> descobar@aem.umn.edu
%       Pieter J. Mosterman -> pieter.mosterman@mathworks.com
%          
%  ========================================================================


%% Cleaning the workspace

bdclose all;
clear all;
close all; 

%% Adding ARDrone library to the path
addpath ../lib/ ; 

%%
%  Sample time of Simulink model. 
sampleTime = 0.065; 

%%
ARDroneHover ; 