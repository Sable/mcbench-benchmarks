% Fig. 6.39   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

clear all;
close all;

num=[1 1 1];
den=[1 10 24 0 0 0];
rlocus(num,den);
grid;
title('Fig. 6.39 Root Locus of a conditionally stable system');

