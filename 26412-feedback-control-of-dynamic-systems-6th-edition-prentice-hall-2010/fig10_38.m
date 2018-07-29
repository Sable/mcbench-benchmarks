%  Figure 10.38      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
% fig10_38.m is a script to create the symmetric        
% root locus for the yaw damper control design
clf;
fpw =[-10.0000         0         0         0         0         0;
    0.0730   -0.0558   -0.9968    0.0802    0.0415         0     ;
   -4.7500    0.5980   -0.1150   -0.0318         0         0;
    1.5300   -3.0500    0.3880   -0.4650         0         0;
         0         0    0.0805    1.0000         0         0;
         0         0    1.0000         0         0   -0.3333];
 gpw =[10;
     0;
     0;
     0;
     0;
     0];
hpw = [0         0    1.0000         0         0   -0.3333];
jpw = 0;
% state space matrices for the symmetric root locus
a=[fpw, 0*fpw;
   -hpw'*hpw,  -fpw'];
b=[gpw;0*gpw];
c=[0*gpw' gpw'];
rlocus(a,b,c,0)
v=[-10 10 -1.5 1.5];
axis(v);
grid;
title('Fig. 10.38 Symmetric root locus of lateral dynamics')
