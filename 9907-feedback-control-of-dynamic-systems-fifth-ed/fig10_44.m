%  Figure 10.44      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% fig10_44.m is a script to generate the SRL for the aircraft with  
% the inner loop stabilization in place.
clf;
ftq =[-0.0064    0.0263         0  -32.2000      0;
   -0.0941   -0.6240  761.1400 -196.2000         0;
   -0.0002   -0.0015   -4.4120  -12.4800         0;
         0         0    1.0000         0         0;
         0   -1.0000         0  830.0000         0];
g=[0; -32.7; -2.08; 0; 0];
h=[0 0 0 0 1];
j=0;
% form the matrices of the SRL
a=[-ftq', -h'*h;0*ftq, ftq];
b=[0*g;g];
c=[g', 0*g'];
d=0;

rlocus(a,b,c,d);
v=[-8, 8, -8, 8];
axis(v);

grid;
title(' Fig. 10.44  SRL for the altitude autopilot')
