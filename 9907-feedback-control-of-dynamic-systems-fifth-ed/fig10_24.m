%  Figure 10.24      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
%   fig10_24.m is a script to generate Fig. 10.24,   
%   the transient response of the LQR symmetric rootlocus compensator 
%   of the satellite position control, non-colocated case WITH ESTIMATOR

% parameter values
m=[1, 0.1]; k=[0, 0.091] ; d=[0, 0.0036]; k1=[0, 0.4];
% call function
[f,g,h,j] = twomass(m,k,d);
s=[f, g;h, 0];r=[0*g;1]; n=s\r;nx=n(1:4);nu=n(5);
% call function
[f1,g,h,j] = twomass(m,k1,d);

% form G(s)G(-s) model
a=[f, 0*f;
-h'*h, -f'];
b=[g;0*g];
d=[0];
c=[0*h, g'];
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
t=0:.25:30;
syscl=ss(acl,bcl,ccl,dcl);
step(syscl,t); 
hold on; 
grid;
gtext('nominal case')
syscl1=ss(acl1,bcl,ccl,dcl);
step(syscl1,t) ;
gtext('stiff-spring case');
title('Fig. 10.24 Closed-loop step response for the SRL design with an estimator')




