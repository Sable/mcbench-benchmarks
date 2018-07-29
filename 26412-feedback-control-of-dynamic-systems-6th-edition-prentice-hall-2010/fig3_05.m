%  Figure 3.5      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
% script to generate Fig. 3.5
%% fig3_05.m
% Example 3.17 : DC Motor Angular velocity 
clf;
numb=[0 0 100];
denb=[1 10.1 101];
sysb=tf(numb,denb);;
t=0:0.01:5;
y=step(sysb,t);
plot(t,y);
title('Fig. 3.5: Step response');
xlabel('Time (sec)');
ylabel('\omega (rad/sec)');
% grid
nicegrid
