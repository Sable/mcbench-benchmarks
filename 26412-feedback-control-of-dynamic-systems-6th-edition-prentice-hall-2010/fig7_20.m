%  Figure 7.20      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
% script to generate fig. 7.20.
clf;
num=-1;
den=[1 0 -1];
rlocus(num,den);
title('Fig. 7.20 Symmetric root locus for a first-order system')
grid;
