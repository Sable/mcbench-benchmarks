%  Figure 10.51      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
%  fig10_51.m is a script to generate Fig. 10.51, the rootlocus  
%  for the fuel/air ratio with a linear sensor.  A (3,3)
%  Pade approximant is used  to approximate the delay.
clf;
% construct the F/A dynamics with the sensor time-constant too
f =[-50 ,    0,     0;
     0 ,   -1 ,    0;
    10 ,   10 ,  -10];

g =[25.0000;
    0.5000;
         0];
h =[0,     0,     1];
j=0;
[n3,d3]=pade(0.2,3); %  the delay Pade model

[np,dp]=ss2tf(f,g,h,j); % convert to polynomial form

np=[np(3:4)];  % remove the extraneous leading zeros

np=conv(np,n3);  % the plant numerator
dp =conv(dp,d3);  % the plant denominator
nc=[1, .3];
dc=[1, 0]; % the PI controller in polynomial form
% form the open-loop system
nol=conv(np,nc);
dol=conv(dp,dc);

rlocus(nol,dol);
v=[-30 2 -12 12];  % set the axes
axis(v);
grid;
title('Fig. 10.51  Rootlocus for the F/A control')



