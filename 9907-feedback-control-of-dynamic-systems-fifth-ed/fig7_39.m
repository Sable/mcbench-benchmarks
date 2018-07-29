%  Figure 7.39      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% script to generate Fig. 7.39
clf;
np=1;
dp=[1 0 0];
nc=[1 0.619];
dc=[1 6.41];
num=conv(np,nc);
den=conv(dp,dc);
rlocus(num,den);
axis([-10 2 -4.5 4.5]);
grid;
title('Fig.7.39  Root locus for reduced-order controller for 1/s^2');
