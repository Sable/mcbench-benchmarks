% Fig. 5.2   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
clf
hold off
n2=1;
d2=[1 1 0];
rlocus(n2,d2)
axis([-2 2 -1.5 1.5])
title('Fig.5.2 Root locus of 1/s(s+1)')
grid on
  z=0:.1:.9;
 wn=.5:.5:2;
 sgrid(z, wn)
