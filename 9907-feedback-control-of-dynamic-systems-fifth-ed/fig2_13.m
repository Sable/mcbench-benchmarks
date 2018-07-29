% Fig. 2.13   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

clear all;
close all;

g=9.81;     % m/sec^2
L=1;        % m 
m=0.5;      % Kg
r2d=57.295; % radians to degrees

num = 1/(m*L^2);
den = [1 0 g/L];
t=0:.02:10;

y = step(num,den,t);  % output in radians
plot(t,r2d*y),grid
xlabel('Time (sec)')
ylabel('Pendulum angle (Deg)')
title('Fig. 2.13')
