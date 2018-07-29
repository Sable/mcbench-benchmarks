%  Figure 4.6      Feedback Control of Dynamic Systems, 6e
%                   Franklin, Powell, Emami
%
numG=2;
den=[1 1 2];
% add integrator
denG=conv(den,[1 0]);
t=0:.03:10;
y=step(numG,denG,t);
axis('square');
plot(t,t,t,y);
title('Fig. 4.6 Relationship between ramp response and Kv');
xlabel('Time (sec)');
ylabel('r, y');
axis('normal')
gtext('r')
gtext('y')
gtext('e_{ss}=1/K_v')
nicegrid;