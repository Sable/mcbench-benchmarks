% Simulation of Bead on a rotating hoop
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
clear all;clc ;
% Properties of Pendulum (Can be altered)
g = 9.81 ;           % Acceleration due to gravity
M = 10 ;             % Mass of the bead
R = 2 ;              % Radius of the rotating hoop
V = 0.5 ;            % Friction on the wire
w0 = 20 ;            % Angular Velocity of the rotating hoop

% Initial Boundary Conditions (Can be altered)
thita = pi;          % Position
dthita = 0. ;
%
duration = 20;       % Duration of the Simulation 
fps = 50;            % Frames per second
%movie = true;       % true if wanted to save animation as avi file
movie = false ;      % false if only want to view animation
interval = [0, duration];   % Time span
ivp=[thita;dthita ; g; M; R; V ;w0 ];     % Initial value's for the problem
% Simulation of Bead on Rotating Hoop
Animation(ivp, duration, fps, movie);