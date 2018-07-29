% Author: Housam Binous

% Dynamic and control of a tank using the genetic algorithm toolbox

% National Institute of Applied Sciences and Technology, Tunis, TUNISIA

% Email: binoushousam@yahoo.com

close all
close all hidden
clear
clc

global t1 h sys X par2

%obtaining step response and transfer function of the tank

[t1 h]=ode45(@tank,[0:1:500],0);

par=fminsearch(@obj,[3,0.4]);

figure(1)

plot(t1,h,'r')

hold on

num=[1];
den=[par(1),par(2)];

disp('transfer function of tank')

sys=tf(num,den)

[y t2]=step(sys,0:1:500);

plot(t2,y,'b')

% using genetic algorithm to obtain the real PID controller
% parameters (gain, integral and derivative time constants)

binousga2;

disp('PID controller parameters:')

par2=X

% tranfer function of PID controller

num=[par2(2) 1];
den=[par2(2) 0];

pid1=tf(num,den);

num=[par2(3) 1];
den=[0.1*par2(3) 1];

pid2=tf(num,den);

disp('transfer function of PID controller')

pid=par2(1)*pid1*pid2

% plotting results of feedback loop 
% tank's height set point is equal to 2

sys_series=series(pid,sys);

sys_controlled=feedback(sys_series,1);

u=2*ones(501,1);

[y1 t3]=lsim(sys_controlled,u,0:0.01:5);

figure(2)
plot(t3,y1,'g')

% running simulink to check result

sim('binous')
hold on
plot(t4,y4,'r')
