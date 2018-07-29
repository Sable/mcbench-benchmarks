%  Figure 3.7      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
% script to generate Fig. 3.7
% fig3_07.m                                          
% Satellite Double-Pulse Response Example 3.19
clf;
dI=1/5000;
numG=dI;
denG=[1 0 0];
sys=tf(numG,denG);
t=0:0.01:10;
% pulse input
u2=[zeros(1,500), 25*ones(1,10), zeros(1,100), -25*ones(1,10), zeros(1,381)];
[y2]=lsim(sys,u2,t);
figure();
plot(t,u2);
axis([0, 10, -26, 26]);
xlabel('Time (sec)');
ylabel('Thrust Fc');
title('Fig. 3.7(a): Thrust input')
% grid
nicegrid
pause;
% conversion to degrees
ff=180/pi;
y2=ff*y2;
figure();
plot(t,y2);
xlabel('Time (sec)');
ylabel('\theta (deg)');
title('Fig. 3.7(b): Satellite attitude')
% grid
nicegrid

