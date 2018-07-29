%  Figure 7.36      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
% script to generate Fig. 7.36   
clf;
num = [ 1 0.619];
j=sqrt(-1);
r=[-3.21+4.77*j -3.21-4.77*j];
den = poly(r);
den = [den 0 0];

rlocus(num,den)
axis([-7 2 -6 6])
title(' Fig. 7.36 Root locus for the combined control and estimator')
grid
