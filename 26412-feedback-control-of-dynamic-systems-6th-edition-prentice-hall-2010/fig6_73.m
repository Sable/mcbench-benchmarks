%  Figure 6.73      Feedback Control of Dynamic Systems, 6e
%                   Franklin, Powell, Emami
% 

clear all
%close all;
clf

num=0.9*0.05*conv([1 2],[10 1]);
num=conv(num,[1 0.005]);
den=[1 2 0 0 0];
den=den+[0 0 2*0.9*0.05*conv([10 1],[1 0.005])];
%now disturbance response
numd=0.9*[1 2 0];

% now FR of the error vs. disturbance
figure(1)
w=logspace(-3,1);
[m,p]=bode(numd,den,w);
loglog(w,m),
axis([.001 1 1 1e6])
hold on
denOL=[1 0 0];
numOL=.9;
[mo,po]=bode(numOL,denOL,w);
loglog(w,mo)
xlabel('\omega (rad/sec)')
ylabel('\theta error magnitude')
title('Fig. 6.73 Disturbance Freguency Response with PID compensator');
bodegrid;
hold off

