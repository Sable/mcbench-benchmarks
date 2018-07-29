% Fig. 6.21   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

clear all;
close all;

num=1;
den=[1 2 1];
rlocus(num,den);
grid;
title('Fig. 6.21: Root locus of G(s)=1/(s+2)^2 vs K');

