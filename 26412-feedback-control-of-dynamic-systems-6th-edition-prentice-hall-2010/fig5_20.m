% Fig. 5.20   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
% 
clf
n=1;
d=conv([1 2 0],[1 2 5]);
rlocus(n,d)
axis([-5 3 -3 3])
grid on
title('Fig. 5.20 Root locus for L=1/s(s+2)(s^2+2s+5)')
z=0:.1:.9;
 wn=1:1:5;
 sgrid(z, wn)
 hold off