%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

clc;
close all;
%%This example shows a trajectory planning example for the 
%%antropomorphic arm

%%Link length
a2=1;
a3=1;

%%End effector initial point
%% by inverse kinematics we have the joint starting variables
[theta1s,theta2s,theta3s]=inverseAntro(1,0.5,0.3,a2,a3);

%%End effector final point
%% by inverse kinematics we have the joint ends variables
[theta1e,theta2e,theta3e]=inverseAntro(0.1,0.5,0.3,a2,a3);

%%3 joint variables: 3 trajectories
%% We want the movement be completed in 6 seconds
tstart=0;
tend=6;
time=[tstart tend];


% 
% %%Check the forward kinematics and the multiple inverse solutions
figure(1);
T01=DHmatrix(theta1s(1),0,0,45);
T12=DHmatrix(theta2s(1),0,a2,0);
T23=DHmatrix(theta3s(1),0,a3,0);
Tuh1=T01*T12*T23;
figure(1);
hold on;
plotT(Tuh1);
T01=DHmatrix(theta1s(2),0,0,45);
T12=DHmatrix(theta2s(2),0,a2,0);
T23=DHmatrix(theta3s(2),0,a3,0);
Tuh2=T01*T12*T23;
plotT(Tuh2);


%%Once we have the kinematics and paths we can plot the movements!
%%Use a spline interpolation

pp1 = spline(time,[0 theta1s(1) theta1e(1) 0]);
pp2 = spline(time,[0 theta2s(1) theta2e(1) 0]);
pp3 = spline(time,[0 theta3s(1) theta3e(1) 0]);
time=linspace(tstart,tend);
figure(2);
subplot(3,1,1);
title('Position Theta1');
plot(time,fnval(pp1,time),'b');
xlabel('Time');
ylabel('Theta1');
subplot(3,1,2);
title('Position Theta2');
plot(time,fnval(pp2,time),'b');
xlabel('Time');
ylabel('Theta2');
subplot(3,1,3);
title('Position Theta3');
plot(time,fnval(pp3,time),'b');
xlabel('Time');
ylabel('Theta3');

figure(3);
for k=1:1:length(time)
clf;
theta1=fnval(pp1,time(k));
theta2=fnval(pp2,time(k));
theta3=fnval(pp3,time(k));
T01=DHmatrix(theta1,0,0,45);
T12=DHmatrix(theta2,0,a2,0);
T23=DHmatrix(theta3,0,a3,0);
Tuh1=T01*T12*T23;
plotT(T01);
plotT2(T01,T01*T12);
plotT2(T01*T12,T01*T12*T23);
pause(0.1);
title('Arm trajectory');
end

