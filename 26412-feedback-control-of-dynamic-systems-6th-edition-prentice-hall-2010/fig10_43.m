%  Figure 10.43      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
% fig10_43.m is a script to generate Figure 10.43, the rootlocus for
% altitude control with inner-loop stabilization and altitude 
% and altitude derivative feedback

clf;
ftq = [-0.0064    0.0263         0  -32.2000         0;
   -0.0941   -0.6240  761.1400 -196.2000         0;
   -0.0002   -0.0015   -4.4120  -12.4800         0;
         0         0    1.0000         0         0;
         0   -1.0000         0  830.0000         0];

g =[0;
  -32.7000;
   -2.0800;
         0;
         0];

h=[0 0 0 0 1];
hdot=ftq(5,1:5);
hf=hdot + 0.1*h;
j=0;

rlocus(ftq,g,-hf,j)
v=[-8, 14, -8, 8];
axis(v);
grid;
title('Fig. 10.43  Root locus for h and hdot feedback with inner-loop stab.')

