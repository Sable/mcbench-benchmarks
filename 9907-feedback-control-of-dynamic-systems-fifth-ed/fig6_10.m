% Fig. 6.10   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

clear all;
close all;

num=10;
den=conv([1 0],[1 0.4 4]);
w=logspace(-1,2,100);
[m,p]=bode(num,den,w);

figure(1)
loglog(w,m);
grid;
xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title('Fig. 6.10 Bode plot for a TF with a complex pole :(a) magnitude');
pause;
figure(2)
semilogx(w,p);
grid;
xlabel('\omega (rad/sec)');
ylabel('Phase');
title('Fig. 6.10 (b) phase');