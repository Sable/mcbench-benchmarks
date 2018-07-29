% Fig. 6.15   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

clear all;
close all;

w=logspace(-2,2,100);
k=10;
num=k;
den=conv([1 0],[1 2 1]);
[m10,p10]=bode(num,den,w);
k=2;
num=k;
den=conv([1 0],[1 2 1]);
[m2,p2]=bode(num,den,w);
k=0.1;
num=k;
den=conv([1 0],[1 2 1]);
[mp1,pp1]=bode(num,den,w);
figure(1)
loglog(w,m10,w,m2,w,mp1,w,ones(size(w)));
grid;
xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title('Fig. 6.15 Frequency Response (a) magnitude');
pause;
figure(2)
semilogx(w,p10,w,p2,w,pp1,w,-180*ones(size(w)),'-');
grid;
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)')
title('Fig. 6.15 (b) phase');
