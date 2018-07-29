% Fig. 6.22   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

num=1;
den=[1 2 1];
w=logspace(-2,3,100);
[m,p]=bode(num,den,w);
figure(1)
loglog(w,m);
xlabel('\omega rad/sec');
ylabel('Magnitude');
title('Fig. 6.22 Open loop Bode plot for G=1/(s+1)^2 (a) magnitude');
bodegrid
%pause;
figure(2)
semilogx(w,p);
xlabel('\omega rad/sec');
ylabel('Phase');
title('Fig. 6.22 (b) phase');
bodegrid;

