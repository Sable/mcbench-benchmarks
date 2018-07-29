% Fig. 5.15   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
% m file for figure 5.15
npco=[1 .2 36.01];
dpco=[1 .2 6.6*6.6+.1*.1 0 0];
nc=[1 1];
dc=[1 12];
nol=conv(npco,nc);
dol=conv(dpco,dc);
rlocus(nol,dol)
title(' Fig. 5.15 Root locus for collocated system')
axis([-18, 2, -7.5, 7.5])
z=0:.1:.9;
 wn=1:2:18;
 sgrid(z, wn)
 hold off