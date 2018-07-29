% Fig. 5.26  Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%script for Figure 5.26
n=[1 5.4];
d1=conv([1 1 0],[1 7 49]);
d=conv(d1,[1 20]);
pzmap(n,d)
axis([-20 0 -7.5 7.5])
hold on
r=roots([1 7 49]);
plot(r,'*')
title('Fig.5.26 Construction for placing a specific point')
z=0:.1:.9;
 wn=2:2:19;
 sgrid(z, wn)
 hold off