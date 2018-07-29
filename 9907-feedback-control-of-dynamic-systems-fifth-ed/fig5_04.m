% Fig. 5.4   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
clf
hold off
n4=[1 1];
d4=conv([1 5 0],[1 4 8]);
pzmap(n4,d4)
axis([-6 2 -3 3])
title('Fig.5.4 Measuring the phase of Eq.5.15')
 z=0:.1:.9;
 wn=1:.5:3;
 sgrid(z, wn)
