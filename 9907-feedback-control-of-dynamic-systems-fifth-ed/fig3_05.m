%  Figure 3.5      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%script to generate Fig. 3.5
% fig3_05.m                                          
% Satellite Double-Pulse response Example 3.18
clf;
dI=1/5000;
F=[0, 1;0, 0];
G=[0;dI];
H=[1, 0];
J=[0];
sys=ss(F,G,H,J);
t=0:0.01:10;
%pulse input
u2=[zeros(1,500), 25*ones(1,10), zeros(1,100), -25*ones(1,10), zeros(1,381)];
[y2]=lsim(sys,u2,t);
plot(t,u2);
axis([0, 10, -26, 26]);
grid;
xlabel('Time (sec)');
ylabel('Thrust Fc');
title('Fig. 3.5(a): Thrust input')
pause;
% conversion to degrees
ff=180/pi;
y2=ff*y2;
plot(t,y2);
grid;
xlabel('Time (sec)');
ylabel('\theta (deg)');
title('Fig. 3.5(b): Satellite attitude')

