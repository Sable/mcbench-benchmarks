%  Figure 10.13      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
%  fig10_13.m is a script to generate fig 10.13        
%  the rootlocus of the PD plus notch compensator of the 
%  satellite position control, non-colocated case


% satellite system matrices
f =[0    1.0000         0         0;
   -0.9100   -0.0360    0.9100    0.0360;
         0         0         0    1.0000 ;
    0.0910    0.0036   -0.0910   -0.0036];
g =[0;
     0;
     0;
     1];

h =[1     0     0     0];

j =[0];
% controller transfer function
no3=conv(.25*[2 1],[1/.81 0 1]);
do3=conv([1/20 1],[1/625 2/25 1]);
% convert to state-space
[Ac3,Bc3,Cc3,Dc3]=tf2ss(no3,do3);
% series combination of controller and plant
[Aol,Bol,Col,Dol]=series( Ac3,Bc3,Cc3,Dc3,f,g,h,j );
Acl=Aol-Bol*Col;
hold off; clf
% rootlocus
rlocus(Aol,Bol,Col,Dol)
v=[-2 2 -1.5 1.5];axis(v); 
title('Rootlocus for KD_3(s)G(s)')
grid;
