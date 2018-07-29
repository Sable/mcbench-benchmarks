% Fig. 6.14b   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

num=1;
den=conv([1 0],[1 2 1]);
rlocus(num,den);
title('Fig. 6.14(b)');
grid;