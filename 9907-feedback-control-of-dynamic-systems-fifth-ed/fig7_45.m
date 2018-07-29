%  Figure 7.45      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
%script for Fig. 7.45   
clf;
f=[-10 1 0;-16 0 1;0 0 0];
g=[0 0 10]';
h=[1 0 0];
j=0;
[np,dp]=ss2tf(f,g,h,0);
np=[0 0 0 10];
nc=conv([1 7.98],[1 2.52]);
r=[-4.28+6.42*i -4.28-6.42*i];
d1=poly(r);
dc=conv(d1,[1 10.6]);
num=conv(np,nc);
den=conv(dp,dc);
rlocus(num,den);
axis([-12 2 -7 7]);
grid;
title('Fig.7.45 Root locus for SRL design of DC Servo system')
