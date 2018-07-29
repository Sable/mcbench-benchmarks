function res = pendulumSimulation(x0,g,len)
% pendulumSimulation : Simulation of pendulum
% Inputs : starting angle x0 (in radians), gravity g and length len
% Outputs: res struct with fields Time, Position, Velocity, Energy
% (here the Position and Velocity are angular position (pendulum angle) and
% angular velocity).

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 35 $  $Date: 2009-05-29 15:27:34 +0100 (Fri, 29 May 2009) $

% Estimate the natural frequency of oscillation (in angular units).  This
% will only be accurate for small angles, but we can use it to set the
% simulation time.
omega0 = sqrt(g/len);

% Convert the angular units to Hz.
f0 = omega0/(2*pi);

% Equations of motion for [d(theta)/dt, d(omega)/dt] where theta is the angular 
% position and omega = d(theta)/dt is the angular velocity, in terms of the
% state vector x = [theta, omega].
% These are derived from the equations:
% T = dL/dt, where T is the applied Torque and L is the angular momentum.
% The applied Torque due to gravity is:
%  T = -m*g*len*sin(x(1))
% and the change in angular momentum is given by
% dL/dt = d(m*len^2*(dx(1)/dt))/dt = m*len^2*(d2x(1)/dt2) 
eqsOfMotion = @(t,x) [x(2); -g/len*sin(x(1))];

% Define the sampling frequency
Fs = 20*f0;

% Simulation time is 10 oscillations
Tmax = 10/f0;

% Define the initial conditions: start at rest.
% State vector is [angle, angular velocity]
initialConditions = [x0; 0];

% Solve the equations of motion using the 4th/5th order Runge-Kuta method.
% By default the solution is accurate to 1 part in 1000, this can be
% improved by altering the options of the ode solver.
options = odeset;
% Uncomment the line below to improve the simulation accuracy.
% options = odeset('RelTol',1e-5);
[t, x] = ode45(eqsOfMotion,0:1/Fs:Tmax,initialConditions,options);

% Store the output results
res.Time = t;
res.Position = x(:,1); % Angular position
res.Velocity = x(:,2); % Angular velocity
% Calculate the Energy (per unit of pendulum bob mass, so this is actually E/m)
res.Energy = g*len*(1-cos(res.Position)) ... % Gravitational energy
    + 0.5*len^2*res.Velocity.^2;  % Kinetic energy 
% Note that for small angles, cos(res.Position) is approximately 
% 1 - 0.5*res.Position.^2, so the energy would be
% E/m = 0.5*g*len*(theta).^2 + 0.5*len^2*(omega).^2;
