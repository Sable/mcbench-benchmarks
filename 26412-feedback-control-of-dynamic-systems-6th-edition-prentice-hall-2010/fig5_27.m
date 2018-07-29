% Fig. 5.27  Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
% script for Figure 5.27, Revised Lead design for more damping

clf
np=1;
dp=[1 1 0];
nc=[1 2];
dc=[1 13];
nol=conv(np,nc);
dol=conv(dp,dc);
ncl=91*[0 0 nol];
dcl=dol+ncl;
step(ncl,dcl)
title('Figure 5.27 Step response for revised lead design')
nicegrid;