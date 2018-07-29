% Fig. 5.5   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami

n5=1;
d5=[1 8 32 0];
pzmap(n5,d5)
title('Fig. 5.5 The Real axis...')
axis([-10 2 -4.5 4.5])
  z=0:.1:.9;
 wn= 1:5;
 sgrid(z, wn)
