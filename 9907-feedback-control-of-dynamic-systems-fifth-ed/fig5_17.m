% Fig. 5.17   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
% m file for figure 5 17
 np=1;
dp=[1 .2 6.6*6.6+.1*.1 0 0];
nc=[1 1];
dc=[1 12];
nol=conv(np,nc);
dol=conv(dp,dc);
rlocus(nol,dol)
title(' Fig. 5.17 Root locus for noncollocated system')
axis([-15, 5, -7.5, 7.5])
z=0:.1:.9;
 wn=2:2:14;
 sgrid(z, wn)
 hold off