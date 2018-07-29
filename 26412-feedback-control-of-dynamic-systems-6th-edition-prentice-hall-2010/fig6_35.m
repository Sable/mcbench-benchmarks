% Fig. 6.35   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

num=1;
den=conv([1 0],[1 2 1]);
w=logspace(-1,2,100);
[m,p]=bode(num,den,w);
subplot(2,1,1)
loglog(w,m,w, ones(size(w)));
axis([.1 100 .0001 10])
ylabel('Magnitude');
title('Fig. 6.35 GM and PM from Bode Plot (a) magnitude');
nicegrid;
subplot(2,1,2)
semilogx(w,p,w,-180*ones(size(w)));
xlabel('\omega (rad/sec)');
ylabel('Phase(deg)');
title('(b) phase');
nicegrid;
