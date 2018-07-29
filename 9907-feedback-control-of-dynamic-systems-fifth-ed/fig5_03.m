% Fig. 5.3   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
n3=[1 0];
d3=[1 0 1];
rlocus(n3,d3)
axis([-2  2 -1.5 1.5])
title('Fig.5.3 Root locus of 1/s(s+c)')
  z=0:.1:.9;
 wn=.5:.5:2;
 sgrid(z, wn)

