% Fig. 5.19   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
% script to produce fig 5.19
n=1;
d=conv([1 2 0],[1 2 5]);
rlocus(n,d)
axis([-5 3 -3 3])
grid on
title('Fig. 5.19 Root locus for L=1/s(s+2)(s^2+2s+5)')
z=0:.1:.9;
 wn=1:1:5;
 sgrid(z, wn)
 hold off