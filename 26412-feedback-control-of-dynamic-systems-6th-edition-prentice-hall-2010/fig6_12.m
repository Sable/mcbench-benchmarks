% Fig. 6.12   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

num1=[10 10];
den1=[1 10];
w=logspace(-2,3,100);
[m1,p1]=bode(num1,den1,w);
num2=[10 -10];
[m2,p2]=bode(num2,den1,w);
figure(1)
loglog(w,m1,w,m2);
xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title('Fig. 6.12 Bode Plot for a NMP System (a) magnitude');
bodegrid;
%pause;
figure(2)
semilogx(w,p1,w,p2,'--');
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');
title('Fig 6.12 (b) phase');
bodegrid;