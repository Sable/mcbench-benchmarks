% Fig. 5.15   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
% 

clf
np=[1 .2 36.01];
dp=[1 .2 6.6*6.6+.1*.1 0 0];
nc=[1 1];
dc=[1 12];
nol=conv(np,nc);
dol=conv(dp,dc);
pzmap(nol,dol)
title('Pole-Zero map for Figure 5.15')
axis([-18, 2, -7.5, 7.5])
z=0:.1:.9;
 wn=1:2:18;
 sgrid(z, wn)
 hold off