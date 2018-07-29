%  Figure 7.42      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% fig7_42.m   
clf;
f=[-10 1 0;-16 0 1;0 0 0];
g=[0 0 10]';
h=[1 0 0];
j=0;
[np,dp]=ss2tf(f,g,h,0);
np=[0 0 0 10];
num = [0 0 0 10];
nc=conv([1 .432],[1 2.1]);
r=[-2.94+8.32*i -2.94-8.32*i];
d1=poly(r);
dc=conv(d1,[1 -1.88]);
num=conv(np,nc);
den=conv(dp,dc);
rlocus(num,den)
axis([-9 3 -9 9]);
grid;
title('Fig.7.42 Root locus for DC Servo pole assignment design')
