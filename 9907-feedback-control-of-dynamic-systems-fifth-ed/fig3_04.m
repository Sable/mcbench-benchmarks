%  Figure 3.4     Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%script to generate Fig. 3.4
%% fig3_04.m                                            
%Satellite Pulse response Example. 3.16 
clf;
numG=[0 0 0.0002];
denG=[1 0 0];
sysG=tf(numG,denG);
t=0:0.01:10;
%pulse input
u1=[zeros(1,500) 25*ones(1,10) zeros(1,491)];
[y1]=lsim(sysG,u1,t);
plot(t,u1);
grid;
xlabel('Time (sec)');
ylabel('Thrust Fc');
title('Fig. 3.4(a): Thrust input')
axis([0 10 0 26]);
pause;
% conversion to degrees
ff=180/pi;
y1=ff*y1;
plot(t,y1);
grid;
xlabel('Time (sec)');
ylabel('\theta (deg)');
title('Fig. 3.4(b): Satellite attitude')

