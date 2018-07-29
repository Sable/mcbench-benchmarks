% Fig. 5.9   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
% Script to generate Figure 5.9

clf
n=1;
d=[1 8 32 0];
rlocus(n,d)
axis([-10 6 -6 6])
hold on
x=[ 0 -2 0 -2];
y=[0  2*sqrt(3)  0 -2*sqrt(3) ];
plot(x,y)
r=roots([1 4 16]);
plot(r,'*')
title('Fig. 5.9 Locus for L=1/[s(s+4)^2+16)]')
z=0:.1:.9;
 wn=1:1:10;
 sgrid(z, wn)
 hold off