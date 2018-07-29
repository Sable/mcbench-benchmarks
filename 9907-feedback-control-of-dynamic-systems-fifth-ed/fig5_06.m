% Fig. 5.6   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
hold off
clf
n6=1;
d6=[1 8 32 0];
pzmap(n6,d6)
x=[-2.67 2 -2.67 2];
y=[0 4.67*sqrt(3) 0 -4.67*sqrt(3)];
title('Fig.5.6  The asymptotes... ')
axis([-14 2 -6 6])
hold on
plot(x,y)
 z=0:.1:.9;
 wn= 1:6;
 sgrid(z, wn)
 hold off
