% Fig. 6.7    Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

num=1;
den=[10 1];
w=logspace(-3,3);
[m,p]=bode(num,den,w);;
m1=ones(50,1)./m;
loglog(w,m1);
axis([.001 10 .1 100])
xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title('Fig. 6.7 Magnitude plot for j\omega \tau + 1; \tau = 10');
bodegrid;

