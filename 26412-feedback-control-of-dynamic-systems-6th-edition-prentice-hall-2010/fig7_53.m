%  Figure 7.53      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% script to generate Fig. 7.53
% 
clf;
dp=[1 1 0];
np=[1];
nc=conv([1 1.001],[8.32 0.8]);
dc=conv([1 4.08],[1 0.0196]);
num=conv(np,nc);
den=conv(dp,dc);
dcl=[0 0 num]+den; % closed-loop denominator
t=0:.1:5;
y=step(num,dcl,t);
plot(t,y);
xlabel('Time (sec)');
ylabel('y(t)');
nicegrid;
title('Fig.7.53: Step response for lag compensation design')
