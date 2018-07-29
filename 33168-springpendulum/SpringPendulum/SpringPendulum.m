% Simulation of Spring Pendulum
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Warning : On running this the workspace memory will be deleted. Save if
% any data present before running the code !!
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%-------------------------------------------------------------------------
% Code written by : Siva Srinivas Kolukula                                |
%                   Senior Research Fellow                                |
%                   Structural Mechanics Laboratory                       |
%                   Indira Gandhi Center for Atomic Research              |
%                   India                                                 |
% E-mail : allwayzitzme@gmail.com                                         |
%          http://sites.google.com/site/kolukulasivasrinivas/             |
%-------------------------------------------------------------------------
clear ;clc ;
% Properties of Pendulum (Can be altered)
g = 9.81 ;                  % Acceleration due to gravity
M = 2 ;                     % Mass of the pendulum
L = 1 ;                     % Length of the Pendulum
K = 5 ;                     % Spring Constant
% Initial Boundary Conditions (Can be altered)
r = 3 ;                     % Extension Length
rdot = 1. ; 
Phi = 0.1 ;                 % Position
Phidot = 0.1;               % Velocity

duration = 60;              % Duration of the Simulation 
fps = 10;                   % Frames per second
%movie = true;              % true if wanted to save animation as avi file
movie = false ;             % false if only want to view animation
arrow = true ;              % Shows the direction of phase plane plot
%arrow = false ;            % Will not show the direction of phase plane plot
interval = [0, duration];                  % Time span
ivp=[r ;rdot ;Phi ;Phidot ;g ;M ;L ; K];   % Initial value's for the problem
% Simulation of Simple Pendulum
Animation(ivp,duration,fps,movie,arrow);