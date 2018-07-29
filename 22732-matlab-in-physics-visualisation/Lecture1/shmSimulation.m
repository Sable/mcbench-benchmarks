function res = shmSimulation(x0,k,m)
% Simulation of SHM with spring constant k and mass m
% Inputs : starting position x0, spring constant k and mass m
% Outputs: res struct with fields x, t, xdot, freqSpectrum

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 35 $  $Date: 2009-05-29 15:27:34 +0100 (Fri, 29 May 2009) $

% Natural frequency of oscillation in angular units.
omega0 = sqrt(k/m);
% Convert the oscillation frequency to Hz.
f0 = omega0/(2*pi);

% Equations of motion for [x'; x''] in terms of the state vector [x; x'].  
% These are derived from:
% m*a = F, where F = -k*x and a = d^2(x)/dt^2
eqsOfMotion = @(t,x) [0 1; -omega0.^2 0]*x;

% Define the sampling frequency
Fs = 20*f0;

% Simulation time is 10 oscillations
Tmax = 10/f0;

% Define the initial conditions: start at rest
% State vector is [position, velocity]
initialConditions = [x0; 0];

%% Solve the equations of motion

% Uncomment second options line for increased accuracy, the default
% relative tolerance is 1 part in 1000.
options = odeset;
%options = odeset('RelTol',1e-5);
[t, x] = ode45(eqsOfMotion,0:1/Fs:Tmax,initialConditions,options);

% Store the output results
res.Time = t;
res.Position = x(:,1);
res.Velocity = x(:,2);
res.Energy = 0.5*k*res.Position.^2 + 0.5*m*res.Velocity.^2;
