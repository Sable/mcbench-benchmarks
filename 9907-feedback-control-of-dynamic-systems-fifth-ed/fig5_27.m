% Fig. 5.27  Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
% script for Figure 5.27
n=[1 5.4];
d=conv([1 20],[1 1 0]); 
rlocus(n,d)
hold on
r=roots([1 7 49]);
plot(r,'*')
axis([-20 4 -9 9])
title('Figure 5.27 Root locus for (s+5.4)/s(s+1)(s+20)')
z=0:.1:.9;
 wn=2:2:19;
 sgrid(z, wn)
 hold off