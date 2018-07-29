%  Figure 9.07     Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
% fig10_07.m is a script to generate Fig. 10.7       
% the satellite with low-gain PD compensation
clf;
np =[0.0360,    0.9100];

dp =[1.0000,    0.0396,    1.0010,    0.0000,    0.0000];

nc2=0.001*[30, 1];

nol2=conv(nc2,np);
dol2=dp;

hold off ; clf
% define frequency range
w=logspace(-2,.2);
w(46)=1;
% subplot(221); 

rlocus(nol2,dol2);
axis([-0.5, 0.5, -1.2, 1.2]); 
grid;
title('Fig. 10.7 Root locus for the low-gain PD satellite design')
