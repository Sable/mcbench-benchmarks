%  Figure 10.23      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
%  fig10_23.m is a script to generate Fig. 10.23,    
%  the root locus of the LQR symmetric root locus compensator of the 
%  satellite position control, non-collocated case WITH ESTIMATOR

% Parameter values
m=[1, .1]; k=[0, .091] ; d=[0, .0036]; k1=[0, 0.4];

% call model
[f,g,h,j] = twomass(m,k,d);

% compute feedforward values
s=[f, g;h, 0];
r=[0*g;1]; 
n=s\r;nx=n(1:4);
nu=n(5);

% call model
[f1,g,h,j] = twomass(m,k1,d);

% form G(s)G(-s) in state-space
a=[f, 0*f;
-h'*h, -f'];
b=[g;0*g];
c=[0*h, g'];
d=[0];
hold off; clf
P=eig(a-b*c*0.1621);
pc=P(real(P<0)==1);
K=place(f,g,pc);
nbar=nu+K*nx;
% eig(f-g*K)
P=eig(a-b*c*3.056e7);
pe=P(real(P<0)==1);
L=place(f',h',pe)';
ac=f-g*K-L*h ;bc=L;cc=K;dc=0;
[Aol,Bol,Col,Dol]=series(ac,bc,cc,dc,f,g,h,j);
[acl,bcl,ccl,dcl]=feedback(f,g,h,j,ac,bc,cc,dc);
[acl1,bcl,ccl,dcl]=feedback(f1,g,h,j,ac,bc,cc,dc);
bcl= nbar*[g;g];
rlocus(Aol,Bol,Col,Dol);
grid;
v=[-2, 2, -1.5, 1.5]
axis(v);
title('Fig. 10.23 Root locus for D_4(s)G(s).')
