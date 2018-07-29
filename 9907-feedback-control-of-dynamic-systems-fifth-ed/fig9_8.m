% Fig. 9.8  Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
 n=[1 1];
 d = [1 0 0];
 rlocus(n,d)
 axis([-6 2 -3 3])
 hold on
 r=roots([1 1 1]);
 plot(r,'*')
  z=0:.1:.9;
 wn= 1:6;
 sgrid(z, wn)
 hold off
