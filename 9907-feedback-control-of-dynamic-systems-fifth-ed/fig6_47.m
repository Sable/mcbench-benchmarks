% Fig. 6.47   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

clear all;
close all;

num=[20 1];
den=[1 0 0];
w=logspace(-3,1,100);
[m,p]=bode(num,den,w);
loglog(w,m);
grid;
xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title('Fig. 6.47 Compensated open-loop transfer function.');
