%  Figure 7.21      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
% script to generate fig. 7.21.
clf;
num=1;
den=[1 0 0 0 0];
rlocus(num,den);
title('Fig. 7.21 Symmetric root locus for satellite system')
grid;
