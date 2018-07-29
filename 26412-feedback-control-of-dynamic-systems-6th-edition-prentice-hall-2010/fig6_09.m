% Fig. 6.9   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

num=2000*[1 0.5];
den=conv([1 10 0],[1 50]);
w=logspace(-2,3);
[m,p]=bode(num,den,w);

figure(1)
loglog(w,m);
xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title('Fig. 6.9 Composite plots (a) magnitude');
bodegrid;
%pause;
figure(2)
semilogx(w,p);
xlabel('\omega (rad/sec)');
ylabel('Phase');
title('Fig. 6.9 (b) phase');
bodegrid