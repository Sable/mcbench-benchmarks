% Fig. 6.47   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

num=1;
den=[1 0 0];
w=logspace(-2,2,100);
[m,p]=bode(num,den,w);
loglog(w,m);
xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title('Fig. 6.47 Spacecraft frequency-response magnitude');
bodegrid;

