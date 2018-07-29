%  Figure 7.44      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% script for generating Fig. 7.44
clf;
f=[-10 1 0;-16 0 1;0 0 0];
g=[0 0 10]';
h=[1 0 0];
j=0;
a=[-f' -h'*h;0*f f];
b=[0*g;g];
c=[g' 0*h];
d=0;
rlocus(a,b,c,d);
axis([-12, 12, -6, 6]);
grid;
title('Fig.7.44  Symmetric root locus for a DC Servo system')
