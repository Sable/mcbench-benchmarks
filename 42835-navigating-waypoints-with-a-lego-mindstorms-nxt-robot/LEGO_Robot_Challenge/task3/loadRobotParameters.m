%% Copyright (c) 2013, The MathWorks, Inc.
%% loadRobotParameters.m
% This MATLAB script populates the workspace with parameters related to the
% simulation of the LEGO robot. It specifies plant model parameters to
% characterise the motors and motion of the LEGO robot.

%% Robot Geometry
AxleLength = 0.115; %Distance between centre-line of driving wheels is 115mm
WheelRadius = 0.028; %Driving wheel diameter is 56mm

%% Initial Conditions for Robot Position
theta0 = 0; %Initial Robot Angle relative to positive x-axis
x0 = 0.5;   %Initial Robot x-position
y0 = 0.5;   %Initial Robot y-position

%% Plant Model Motor Parameters:
motorBiasRight = -72;   %Bias for right motor to convert from demand to deg/s
motorBiasLeft  = -68;   %Bias for left motor to convert from demand to deg/s
motorGainRight = 8.1;   %Scaling for right motor to convert from demand to deg/s
motorGainLeft = 8.4;    %Scaling for left motor to convert from demand to deg/s
motorDeadZoneFwd = 20;  %Demand in forward direction below which motor doesn't turn
motorDeadZoneRev = -20; %Demand in reverse direction below which motor doesn't turn
EncR_init = 0;          %Right encoder initialisation value
EncL_init = 0;          %Left encoder initialisation value

%% Simulation Parameters
deltaT = 0.01; %Step size for plant model
dT = 0.1; %Step size for sensors and algorithm

