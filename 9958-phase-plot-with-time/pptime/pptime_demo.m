%% Phase Plot with Colored Time Representation Demo Script
%
% This function solves damped nonlinear pendulum diff. eq. and
% calls the pptime for the colored phase plot.
%
% Date: 02.11.2006
% Author: Atakan Varol


clc         % Clear the screen
close all   % Close all figure windows

% First example
y1_in = 2;  % Set the initial conditions
y2_in = 0;
end_time = 20;  % Set the end time for the solution
options = odeset('MaxStep',1e-2);   % Set the maximum step size

% Solve numerically the diff equation defined in odefun pend1
[time,y]=ode45(@pend1,[0 end_time],[y1_in y2_in],options);  

% Plot the phase plot of the system with the colored time representation 
pptime(y,time)


% First example
y1_in = 3;  % Set the initial conditions
y2_in = 0;
end_time = 10;  % Set the end time for the solution
options = odeset('MaxStep',1e-2);   % Set the maximum step size

% Solve numerically the diff equation defined in odefun vdp1
[time,y]=ode45(@vdp1,[0 end_time],[y1_in y2_in],options);  

% Plot the phase plot of the system with the colored time representation 
pptime(y,time)

% end 