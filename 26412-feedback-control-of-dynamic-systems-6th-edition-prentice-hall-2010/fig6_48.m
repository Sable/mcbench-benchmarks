% Fig. 6.48   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

num=[20 1];
den=[1 0 0];
w=logspace(-3,1,100);
[m,p]=bode(num,den,w);
loglog(w,m);
xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title('Fig. 6.48 Compensated open-loop transfer function.');
bodegrid;
