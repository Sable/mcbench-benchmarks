function comparePendulumToSHM(x0,k,m)
% comparePendulumToSHM : compare the motion of a simple harmonic oscillator
% with the motion of a pendulum having 'equivalent' parameters.

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 35 $  $Date: 2009-05-29 15:27:34 +0100 (Fri, 29 May 2009) $

% The motion of a simple harmonic oscillator is determined by the spring
% constant (k), the mass of the pendulum (m)and the initial position of the
% pendulum (x0).  The natural frequency of the motion is (in angular units)
% omega0 = sqrt(k/m).

% The motion of a pendulum consisting of a massless arm and a bob of mass m
% is determined by the acceleration due to gravity (g), the length of the
% pendulum (L) and the initial angle of the pendulum from the vertical
% (x0).  For small angles the natural frequency of the motion is (in
% angular units) omega0 = sqrt(g/L) (NB: does not depend on mass of
% pendulum).

% We want to plot the motion of a simple harmonic oscillator and the
% equivalent pendulum, where 'equivalent' means the intial angular
% displacement is equal (in radians) to the intial position displacement
% (in metres) of the simple harmonic oscillator, and the pendulum length is
% chosen to give the same natural frequency as the simple harmonic
% oscillator.

% Define acceleration due to gravity
g = 9.81; % m/s^2

% Natural frequency of simple harmonic oscillator
omega0 = sqrt(k/m);

% Pendulum length giving same oscillation frequncy
L = g/omega0^2;

% Plot the time series representation of simple harmonic motion

% res struct has fields Position, Time
resSHM = shmSimulation(x0,k,m);
resPendulum = pendulumSimulation(x0,g,L);

plot(resPendulum.Time, resPendulum.Position, 'b-',...
    resSHM.Time, resSHM.Position, 'r--')
axis([0 max(resSHM.Time) -1.1*x0 1.1*x0])
xlabel('Time (s)','FontSize',14);
ylabel('Position','FontSize',14);
legend('SHO','Pendulum')
title(['Comparison of Simple Harmonic Oscillator and Pendulum.  x0 = ',...
    num2str(x0)]);
