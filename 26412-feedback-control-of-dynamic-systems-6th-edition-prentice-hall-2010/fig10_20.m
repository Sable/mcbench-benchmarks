%  Figure 10.20      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
%  fig10_20.m is a script to generate                       
%  Fig. 10.20,  frequency response of the LQR symmetric rootlocus 
%  compensator of the satellite position control, non-colocated case

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
rlocus(a,b,c,d);
v=[-2, 2, -1.5, 1.5];axis(v);
title('Symmetric rootlocus for the satellite') 
disp('select poles at -.5+j0.36')
pause
[K, P]=rlocfind(a,b,c,d)
pc=P(real(P<0)==1);
K=place(f,g,pc);
nbar=nu+K*nx;
hold off;
w=logspace(-1,1);
w(26) = 1;
[mag, ph]=bode(f,g,K,j,1,w);
subplot(211); loglog(w,mag); grid;
xlabel('\omega (rad/sec)');
ylabel('Magnitude, |KX(j\omega)/U(j\omega)|');
title('Fig. 10.20 Frequency response of the SRL design from u to Kx')
subplot(212);
ph1=[ph, -180*ones(size(ph))];
semilogx(w,ph1);
grid;
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');
%Bode grid
bodegrid

[Gm,Pm,Wcg,Wcp] = margin(mag,ph,w)