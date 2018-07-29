% Fig. 5.12   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami

clf
np=[1 1];
dp=[1 4 0 0];
rlocus(np,dp)
axis([-6 2 -3 3])
grid on
title('Root locus for Figure 5.12')
z=0:.1:.9;
 wn= .5:.5:6;
 sgrid(z, wn)
 hold off