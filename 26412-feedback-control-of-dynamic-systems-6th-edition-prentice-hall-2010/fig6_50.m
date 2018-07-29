% Fig. 6.50   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

num=0.01*[20 1];
den=[1 0 0];
dencl=den+[0 num];
t=0:1:100;
y=step(num,dencl,t);
plot(t,y);
xlabel('Time (sec)');
ylabel('\theta');
title('Fig. 6.50 Step response for PD compensator');
nicegrid;

