%  Figure 3.6     Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
% script to generate Fig. 3.6
%% fig3_06.m                                            
% Satellite Pulse response Example. 3.19 
clf;
numG=[0 0 0.0002];
denG=[1 0 0];
sysG=tf(numG,denG);
t=0:0.01:10;
%pulse input
u1=[zeros(1,500) 25*ones(1,10) zeros(1,491)];
[y1]=lsim(sysG,u1,t);
figure();
plot(t,u1);
xlabel('Time (sec)');
ylabel('Thrust Fc');
title('Fig. 3.6(a): Thrust input')
axis([0 10 0 26]);
% grid
nicegrid
pause;
% conversion to degrees
ff=180/pi;
y1=ff*y1;
figure();
plot(t,y1);
xlabel('Time (sec)');
ylabel('\theta (deg)');
title('Fig. 3.6(b): Satellite attitude')
% grid
nicegrid

