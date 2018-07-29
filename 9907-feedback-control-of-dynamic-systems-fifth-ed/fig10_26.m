%  Figure 10.26      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
%  fig10_26.m is a script to generate Fig. 10.26,  
%  root locus of the colocated
%  design for the satellite with PD compensation

% parameter values
m=[1, .1]; k0=[0, .091] ; d0=[0, .0036]; k1=[0, .4];

% call function
[f,g,h,j]=twomass(m,k0,d0); [f1,g,h,j] = twomass(m,k1,d0);
h1=[0, 0, 1, 0];

nc1=0.25*[2, 1];
dc1=[1/40, 1];

[ac,bc,cc,dc]=tf2ss(nc1, dc1);
sysc=ss(ac, bc,cc,dc);
sysp1=ss(f,g,h1,j);
sysol= series(sysc,sysp1);
[aol,bol,col,dol]=ssdata(sysol);
[acl]=aol-bol*col;
ccl2=[0*cc h];
sysp11=ss(f1,g,h1,j);
sysol1= series(sysc,sysp11);
[aol1,bol1,col1,dol1] =ssdata(sysol1);
acl1=aol1-bol1*col1;
hold off ; clf
rlocus(aol,bol,col,dol);
v =[-3,2,-1.5,1.5];
axis(v); 
title('Fig. 10.26 Root locus for D_5(s)G_{co}(s).')
grid
