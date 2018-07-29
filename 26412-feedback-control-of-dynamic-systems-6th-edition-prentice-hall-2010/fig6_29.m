% Fig. 6.29   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

num=[1 1];
den=conv([1 0],[0.1 -1]);
rlocus(num,den);

axis([-8 12 -10 10]);
axis equal
grid;
title('Fig. 6.29 Root locus for Example 6.10');
