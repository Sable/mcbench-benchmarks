% Fig. 6.82   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clf
clear all;
%close all;

numS=[1 11 10 0];
denS=[1 11 60 100];
w=logspace(-1,2,100);
sysS=tf(numS,denS);
[m,p]=bode(sysS,w);
loglog(w,squeeze(m));
axis([.1 100 .01 10])

hold on
% add line at mag = 1
w2=[.1 100];
mcl=[1 1];
loglog(w2,mcl,'r')

xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title('Fig. 6.82 Sensitivity Function for Example 6.24');
bodegrid;
hold off
