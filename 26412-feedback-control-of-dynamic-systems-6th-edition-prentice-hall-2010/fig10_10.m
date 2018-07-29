%  Figure 10.10      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
%  fig10_10.m is a script to generate Fig 10.10    
%  the poles and zeros pattern of the notch  network
clf;
nnotch=[1/.81 0  1] ;
dnotch=[1/625 2/25  1];
pzmap(nnotch,dnotch);
title('Fig. 10.10 Poles and zeros of the notch network')
sgrid;
