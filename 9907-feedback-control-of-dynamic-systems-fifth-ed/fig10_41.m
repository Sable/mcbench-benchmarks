%  Figure 10.41      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% fig10_41.m is a script to create Figure 10.41, the step response of the
% attitude inner loop to a 2 degree step in pitch angle.
clf;
% the total inner loop system matrix is

ftq =[-0.0064    0.0263         0  -32.2000         0;
   -0.0941   -0.6240  761.1400 -196.2000         0;
   -0.0002   -0.0015   -4.4120  -12.4800         0;
         0         0    1.0000         0         0;
         0   -1.0000         0  830.0000         0];

g =[0;
  -32.7000;
   -2.0800;
         0;
         0];
h = [0     0    -1     0     0];
j =0;
% now remove the altitude to get the inner loop pitch angle
ft=ftq(1:4,1:4)
gt=g(1:4);
ht=[0 0 0 1];
% compute the dc gain
dcgain= -ht*inv(ft)*gt
% compute the reference input in radians from 2 degrees

r=2*pi/180
t=0:.1:8;
y=step(ft,r*gt/dcgain,ht,0,1,t);
plot(t,y);
xlabel('Time (sec)');
ylabel('\theta (t) (rad)');
grid;
title(' Fig. 10.41 step response of the pitch angle inner loop ')

