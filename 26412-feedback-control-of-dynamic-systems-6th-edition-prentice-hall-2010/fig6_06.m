% Fig. 6.6   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

num=1;
den=[1 0];
w=logspace(-2,3);
[m,p]=bode(num,den,w);;
m1=ones(50,1)./m;
den=[1 0 0];
[m2,p]=bode(num,den,w);
m2=ones(50,1)./m2;
loglog(w,m,w,m1,w,m2);
xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title('Fig. 6.6 Magnitude of (j\omega)^n');
bodegrid;


