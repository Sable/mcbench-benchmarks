%  Figure 6.67      Feedback Control of Dynamic Systems, 6e
%                   Franklin, Powell, Emami
% 

clear all
%close all;
clf

k=10;
num=k;
den=[1 1 0];
w=logspace(-3,1,100);
[m,p]=bode(num,den,w);
num=conv(num,[10 1]);
den=conv(den,[100 1]);
[mc,pc]=bode(num,den,w);
subplot(2,1,1)
w2=[.001 10];
m2=[1 1];
loglog(w,m,w,mc,'--',w2,m2,'r');
grid;
%xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title('Fig. 6.67 Frequency response of lag-compensation design: magnitude.');
subplot(2,1,2)
semilogx(w,p,w,pc,'--');
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');
title('Fig. 6.67 Frequency response of lag compensation design: phase.');
bodegrid;
%return;
%numcl=[1 0.1];
%dencl=[1 1.01 1.01 0.1];
%t=0:.01:20;
%y=step(numcl,dencl,t);
%plot(t,y);
%grid;
%xlabel('sec');
%ylabel('y');
