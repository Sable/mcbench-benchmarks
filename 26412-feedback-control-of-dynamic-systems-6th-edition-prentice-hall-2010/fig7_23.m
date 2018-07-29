%  Figure 7.23      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
% script to generate Fig. 7.23
% fig7_23.m
% Nyquist for LQR
clf;
f=[0 1;0 0];
g=[0;1];
h=[1 0];
j=0;
r=1;
rho=1;
q=rho*h'*h;
[k,s]=lqr(f,g,q,r);
sys=ss(f,g,k,0);
% circle of radius one
plot(-1+sin(0:.1:2*pi),cos(0:.1:2*pi),'r--');
axis equal;
text(-1,0,'x');
hold on;
w=logspace(0,2);
nyquist(sys,w);
title('Fig. 7.23: Nyquist diagram');


