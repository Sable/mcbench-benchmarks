% Fig. 5.24  Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
% script for Figure 5.24, Lead design.

clf;
np=1;
dp=[1 1 0];
nc=[1 2];
dc=[1 10];
nol=conv(np,nc);
dol=conv(dp,dc);
rlocus(nol,dol)
axis([-19 1 -7.5 7.5])
title('Figure 5.24  Root locus for lead design')
hold on
r=roots([1 11 80 140]);
plot(r,'*')
z=0:.1:.9;
 wn=2:2:19;
 sgrid(z, wn)
 hold off