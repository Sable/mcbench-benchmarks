%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL
close all
clc

%%NOTICE: accelaration is not continuous because we can't impose it with
%% 3th order polynomials: see other script
%%Define the matrix with time, joint points and velocities
trajectory=[0,2,4,6;0,6,0.8,2.4;0,4,-4,1];

[TJ]=trajectory3Velconstraint(trajectory);

%%Plot position, velocity and acceleration
figure(1)
hold on;
grid on;
plot(trajectory(1,:),trajectory(2,:),'r');
%%the interpoled values

plotPolTraj(trajectory(1,:),TJ);
legend('planned traj','interpoled traj','velocities','acceleration');
title('Planned and interpoled trajectory');
xlabel('Time');
ylabel('pos,vel,acc');

%%In this case we used a computed velocity approach:
%%as we can see in the intermediate points we have 0 velocities!
%%Note: accelerations are still discontinuous
figure(2);
hold on;
grid on;
plot(trajectory(1,:),trajectory(2,:),'r');
[TJ]=trajectory3VelComputed(trajectory);
plotPolTraj(trajectory(1,:),TJ);
legend('planned traj','interpoled traj','velocities','acceleration');
title('Planned and interpoled trajectory');
xlabel('Time');
ylabel('pos,vel,acc');

%%If we want a continous acceleration  we must use a cubic spline
%% Initial and final velocities are zeros!
%% As we can see the acceleration is now piecewise linear
pp = spline(trajectory(1,:),[0 trajectory(2,:) 0]);
figure(3);
hold on;
grid on;
plot(trajectory(1,:),trajectory(2,:),'r');
xx=linspace(trajectory(1,1),trajectory(1,end));
plot(xx,fnval(pp,xx),'b');
fprime = fnder(pp);
plot(xx,fnval(fprime,xx),'g');
fsecond = fnder(fprime);
plot(xx,fnval(fsecond,xx),'k');
title('Planned and interpoled trajectory');
legend('planned traj','interpoled traj','velocities','acceleration');
xlabel('Time');
ylabel('pos,vel,acc');


