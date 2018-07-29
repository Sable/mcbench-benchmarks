%  Figure 6.70      Feedback Control of Dynamic Systems, 5e
%                   Franklin, Powell, Emami
% 

clear all
close all;

num=0.9*0.05*conv([1 2],[10 1]);
num=conv(num,[1 0.005]);
den=[1 2 0 0 0];
den=den+[0 0 2*0.9*0.05*conv([10 1],[1 0.005])];
t=0:.5:40;
y=step(num,den,t);
subplot(2,1,1)
plot(t,y);
grid;
xlabel('Time (sec)');
ylabel('\theta');
title('Fig. 6.70 (a) Step Response with PID compensator');
subplot(2,1,2)
%now disturbance response
numd=0.9*[1 2 0];
t=0:5:1000;
yd=step(numd,den,t);
plot(t,0.1*yd);
grid;
xlabel('Time (sec)');
ylabel('\theta');
title('Fig. 6.70 (b) Step Disturbance Response with PID compensator');

