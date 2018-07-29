% Fig. 6.2   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

clear all;
close all;
clf
num=[1 1];
den=[.1 1];
[mag,ph,w]=bode(num,den);
figure(1)
subplot(2,1,1),loglog(w,mag),grid
title('Fig. 6.2 (a) Magnitude'),ylabel('Magnitude')
subplot(2,1,2),semilogx(w,ph),grid
title('(b) Phase'),ylabel('\phi (deg)'),xlabel('\omega (rad/sec)')
