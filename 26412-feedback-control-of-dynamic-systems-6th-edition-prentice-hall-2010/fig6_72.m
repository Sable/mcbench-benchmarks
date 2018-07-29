%  Figure 6.72      Feedback Control of Dynamic Systems, 6e
%                   Franklin, Powell, Emami
% 

clear all
%close all;
clf

num=0.9*0.05*conv([1 2],[10 1]);
num=conv(num,[1 0.005]);
den=[1 2 0 0 0];
den=den+[0 0 2*0.9*0.05*conv([10 1],[1 0.005])];
t=0:.5:40;
y=step(num,den,t);
subplot(2,1,1)
plot(t,y);
xlabel('Time (sec)');
ylabel('\theta');
title('Fig. 6.72 (a) Step Response with PID compensator');
nicegrid
subplot(2,1,2)
%now disturbance response
numd=0.9*[1 2 0];
t=0:5:1000;
yd=step(numd,den,t);
plot(t,0.1*yd);
xlabel('Time (sec)');
ylabel('\theta');
title('Fig. 6.72 (b) Step Disturbance Response with PID compensator');
nicegrid;

% now FR of the error vs. disturbance
figure(2)
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
hold off
bodegrid;
