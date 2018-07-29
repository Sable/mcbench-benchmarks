%  Figure 6.66      Feedback Control of Dynamic Systems, 5e
%                   Franklin, Powell, Emami
% 

clear all
close all;

k=10;
num=k;
den=[1 1 0];
num=conv(num,[10 1]);
den=conv(den,[100 1]);
numcl=[1 0.1];
dencl=[1 1.01 1.01 0.1];
t=0:.2:50;
y=step(numcl,dencl,t);
subplot(2,1,1)
plot(t,y);
grid;
xlabel('Time (sec)');
ylabel('y');
title('Fig. 6.66 Step response of lag-compensation design.');
