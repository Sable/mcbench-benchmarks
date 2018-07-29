clc
clear all
close all


theta0 = 10;	% Deg
thetaf = 30;
thetad0 = 0;	% Deg/Sec
thetadf = 0;
tstart = 0;		% seconds
tfinal = 1;
% find the coefficient of the 3rd order polynomial trajectory
[a3,a2,a1,a0] = createTraj3(theta0,thetaf,thetad0,thetadf,tstart,tfinal);
% make a polynomial
p = [a3,a2,a1,a0];
% Create time vector
t = linspace(tstart,tfinal,20);
% Evaluate the polynomial : Position
pos = polyval(p,t);
% calculate the first derivative : Velocity
pd = polyder(p);
% Evaluate the velocity
vel = polyval(pd,t);
% calculate the second derivative : Acceleration
pdd = polyder(pd);
% Evaluate the acceleration
acc = polyval(pdd,t);
% plot
figure;
plot(t,pos,'--+r'); hold on
plot(t,vel,'--og'); hold on
plot(t,acc,'--xb'); hold on
grid

theta0 = 10;	% Deg
thetaf = 30;
thetad0 = 0;	% Deg/Sec
thetadf = 0;
thetadd0 = 0;	% Deg/Sec
thetaddf = 0;
tstart = 0;		% seconds
tfinal = 1;

[a5,a4,a3,a2,a1,a0] = createTraj5(theta0,thetaf,thetad0,thetadf,thetadd0,thetaddf,tstart,tfinal)

% make a polynomial
p = [a5,a4,a3,a2,a1,a0];
% Create time vector
t = linspace(tstart,tfinal,20);
% Evaluate the polynomial : Position
pos = polyval(p,t);
% calculate the first derivative : Velocity
pd = polyder(p);
% Evaluate the velocity
vel = polyval(pd,t);
% calculate the second derivative : Acceleration
pdd = polyder(pd);
% Evaluate the acceleration
acc = polyval(pdd,t);
% plot
figure;
plot(t,pos,'--+r'); hold on
plot(t,vel,'--og'); hold on
plot(t,acc,'--xb'); hold on
grid




