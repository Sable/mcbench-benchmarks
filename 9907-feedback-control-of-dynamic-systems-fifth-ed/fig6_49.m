% Fig. 6.49   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

clear all;
close all;

num=0.01*[20 1];
den=[1 0 0];
dencl=den+[0 num];
t=0:1:100;
y=step(num,dencl,t);
plot(t,y);
xlabel('Time (sec)');
ylabel('\theta');
grid;
title('Fig. 6.49 Step response for PD compensator');
