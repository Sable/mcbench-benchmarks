% Fig. 6.25   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

clear all;
close all;

num=1;
den=conv([1 0],[1 2 1]);
w=logspace(-2,3,100);
[m,p]=bode(num,den,w);
subplot(2,1,1)
loglog(w,m);
axis([.01 100 .0001 100])
hold on;
ii=[11 21 47 61];
loglog(w([ii]),m([ii]),'*');
loglog(1,.5,'*')
grid;
ylabel('Magnitude');
title('Fig. 6.25 Bode Plot for G=1/(s+1)^2 (a) magnitude');
hold off;
subplot(2,1,2)
semilogx(w,p);
axis([.01 100 -270 -90])
hold on;
w180=[.01 100];
p180=[-180 -180];
semilogx(w([11 21 47 61]),p([11 21 47 61]),'*');
semilogx(1,-180,'*')
semilogx(w180,p180)
grid;
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');
title('(b) phase ');
hold off;
