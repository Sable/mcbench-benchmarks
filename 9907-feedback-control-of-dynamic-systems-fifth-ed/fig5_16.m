% Fig. 5.16   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
% m file for figure 5.16
 np=[.2 36.01];
dp=[1 .2 6.6*6.6+.1*.1 0 0];
nc=[1 1];
dc=[1 12];
nol=conv(np,nc);
dol=conv(dp,dc);
pzmap(nol,dol)
axis([-18 2 -7.5 7.5])
title('Fig.5.16  Departure angle for noncollocated system')
z=0:.1:.9;
 wn=1:2:18;
 sgrid(z, wn)
 hold off