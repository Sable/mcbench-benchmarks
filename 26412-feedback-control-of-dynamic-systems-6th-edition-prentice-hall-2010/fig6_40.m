% Fig. 6.40   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

num=[1 1 1];
den=[1 10 24 0 0 0];
rlocus(num,den);
axis([-10 2 -6 6])
title('Fig. 6.40 Root Locus of a conditionally stable system');
grid;