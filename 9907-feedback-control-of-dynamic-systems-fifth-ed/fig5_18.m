% Fig. 5.18   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
% script to produce fig 5.18
n=1;
d=conv([1 2 0],[1 2 5]);
pzmap(n,d)
axis([-4 4 -3 3])
title('Fig.5.18 Departure angle calculation')
z=0:.1:.9;
 wn=1:1:4;
 sgrid(z, wn)
 hold off