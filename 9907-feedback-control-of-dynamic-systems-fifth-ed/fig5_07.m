% Fig. 5.7   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami

n6=1;
d6=[1 8 32 0];
pzmap(n6,d6)
title('Fig.5.7 The departure angle')
axis([-10 6 -6 6])
hold on
x=[-4 -3.5];
y=[4 3.5];
plot(x,y)
z=0:.1:.9;
 wn= 1:6;
 sgrid(z, wn)
 hold off
