% Fig. 5.8   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami

clf
n9=1;
d9=[1 8 32 0];
rlocus(n9,d9)
title('Fig.5.08 The root locus for L(s)=1/s(s^2+8s+32)')
axis([-14 2 -6 6])
z=0:.1:.9;
 wn= 1:6;
 sgrid(z, wn) 
hold on
x=[-2.67 2 -2.67 2];
y=[0 4.67*sqrt(3) 0 -4.67*sqrt(3)];
plot(x,y)
r=roots([1 0 32]);
 plot(r,'*')
 hold off