% Fig. 5.28  Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%script for Figure 5.28
n=[1 5.4]; 
d=conv([1 1 0],[1 20]);
nol=[0 0 n];
ncl=127*nol;
dcl=d+ncl;
step(ncl,dcl); 
title('Fig.5.28 Step response for lead design')
grid on