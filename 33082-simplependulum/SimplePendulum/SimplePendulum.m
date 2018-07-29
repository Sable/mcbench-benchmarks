% Simulation of Simple Pendulum
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
g = 9.81 ;           % Acceleration due to gravity
M = 10 ;              % Mass of the pendulum
L = 1 ;              % Length of the Pendulum
C = 0.7 ;             % Damping 

% Initial Boundary Conditions (Can be altered)
Phi = 0.5;            % Position
dtPhi = 1.0;        % Velocity

duration = 60;      % Duration of the Simulation 
fps = 10;           % Frames per second
%movie = true;         % true if wanted to save animation as avi file
movie = false ;         % false if only want to view animation
arrow = 'ShowArrow' ; % Shows the direction of phase plane plot
%arrow = 'NoNoArrow' ;   % Will not show the direction of phase plane plot
interval = [0, duration];               % Time span
ivp=[Phi; dtPhi; g; M; L ; C];     % Initial value's for the problem
% Simulation of Simple Pendulum
Animation(ivp, duration, fps, movie,arrow);