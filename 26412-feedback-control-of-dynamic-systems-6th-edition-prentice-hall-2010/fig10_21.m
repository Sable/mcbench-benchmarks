%  Figure 10.21      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
%   fig10_21.m is a script to generate Fig 10.21, the     
%   frequency response of the LQR symmetric rootlocus compensator for the 
%   satellite position control, non-colocated case WITH ESTIMATOR

m=[1, 0.1]; k=[0, 0.091] ; d=[0, 0.0036]; k1=[0, 0.4];
[f,g,h,j] = twomass(m,k,d);
s=[f, g;h, 0];r=[0*g;1]; n=s\r;nx=n(1:4);nu=n(5);
[f1,g,h,j] = twomass(m,k1,d);
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
ac=f-g*K-L*h ;bc=L;cc=K;dc=0;
% [numc denc]=ss2tf(ac,bc,cc,dc)

w=logspace(-1,1);
w(26) = 1; w(25) = .94;w(25)=.9;
[mag ph]=bode(ac,bc,cc,dc,1,w);
subplot(211); loglog(w,mag); grid;
xlabel('\omega (rad/sec)');
ylabel('Magnitude, |D_4(j\omega)|');
title('Fig. 10.21: Bode plot of the optimal compensator D_4(s)');
subplot(212); semilogx(w,ph);grid;
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');

%Bode grid
bodegrid