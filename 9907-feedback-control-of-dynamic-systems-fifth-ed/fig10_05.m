%  Figure 10.05      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% fig10_05.m is a script to generate Fig. 10.5   
% root locus, for the PD design for the satellite 
clf;
% parameters of two-mass spring model
m=[1, 0.1]; k0=[0, 0.091] ; d0=[0, 0.0036]; k1=[0, 0.4];

% call two mass-spring model function
[f,g,h,j] = twomass(m,k0,d0);
nc1=0.25*[2, 1];
dc1=[1/40, 1];

% convert controller to state-space
[ac,bc,cc,dc]=tf2ss(nc1, dc1);

% series of controller and plant
[aol,bol,col,dol]= series(ac, bc,cc,dc,f,g,h,j);
[acl]=aol-bol*col;

hold off ; clf

rlocus(aol,bol,col,dol)
grid;
v =[-2.0000,    2.0000,   -1.5000,    1.5000];
axis(v); 
title('Fig. 10.5 Root locus for the PD design of the satellite')
% 
