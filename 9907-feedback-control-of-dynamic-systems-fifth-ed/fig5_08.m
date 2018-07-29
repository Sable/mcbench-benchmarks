% Fig. 5.8   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami

n6=1;
d6=[1 8 32 0];
pzmap(n6,d6)
title('Fig.5.8 The locus crosses the j\omega axis at *')
axis([-10 6 -6 6] )
hold on
r=roots([1 0 32]);
 plot(r,'*')
z=0:.1:.9;
 wn= 1:6;
 sgrid(z, wn)
 hold off
