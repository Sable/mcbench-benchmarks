%  Figure 3.3      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%script to generate Fig. 3.3
%% fig3_03.m
% Example 3.16 : DC Motor Angular velocity 
clf;
numb=[0 0 100];
denb=[1 10.1 101];
sysb=tf(numb,denb);;
t=0:0.01:5;
y=step(sysb,t);
plot(t,y);
grid;
title('Fig. 3.3: Step response');
xlabel('Time (sec)');
ylabel('\omega (rad/sec)');
