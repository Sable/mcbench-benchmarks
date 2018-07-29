% Fig. 6.56   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

numG=1;
denG=[1 1 0];
numD=[0.5 1];
denD=[0.1 1];
num=conv(numG,numD);
den=conv(denG,denD);
axis('square');

rlocus(num,den);
axis([-16 0 -8 8]);
title('Fig. 6.56 Root Locus for Lead Compensation Design');
axis('normal');
