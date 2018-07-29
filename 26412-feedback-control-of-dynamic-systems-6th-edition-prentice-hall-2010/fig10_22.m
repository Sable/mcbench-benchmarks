%  Figure 10.22      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
%   fig10_22.m is a script to generate Fig 10.22,      
%   frequency response of the LQR symmetric rootlocus compensator of the 
%   satellite position control, non-colocated case WITH ESTIMATOR

m=[1, 0.1]; k=[0, 0.091] ; d=[0, 0.0036]; k1=[0, 0.4];
[f,g,h,j] = twomass(m,k,d);
s=[f, g;h 0];r=[0*g;1]; n=s\r;nx=n(1:4);nu=n(5);
[f1,g,h,j] = twomass(m,k1,d);
% form the 2nx2n matrix of the lqr SRL system
a=[f, 0*f;
-h'*h, -f'];
b=[g;0*g];
c=[0*h, g'];
d=[0];
hold off; clf
P=eig(a-b*c*0.1621);
% the optimal poles are those of the SRL in the left-half plane
pc=P(real(P<0)==1);
K=place(f,g,pc);
nbar=nu+K*nx;
% eig(f-g*K)
P=eig(a-b*c*3.056e7);
pe=P(real(P<0)==1);
L=place(f',h',pe)';
ac=f-g*K-L*h ;bc=L;cc=K;dc=0;
[Aol,Bol,Col,Dol]=series(ac,bc,cc,dc,f,g,h,j);
w=logspace(-1,1);
w(26) = 1; w(25) = .94;
[mag, ph]=bode(Aol,Bol,Col,Dol,1,w);
subplot(211);
mag1=[mag, ones(size(mag))];
loglog(w,mag1); grid;
xlabel('\omega (rad/sec)');
ylabel('Magnitude, |D_4(s)G(s)|');
title('Fig. 10.22 Frequency response for D_4(s)G(s)')
subplot(212); 
ph1=[ph, -180*ones(size(ph))];
semilogx(w,ph1);grid;
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');
%Bode grid
bodegrid
