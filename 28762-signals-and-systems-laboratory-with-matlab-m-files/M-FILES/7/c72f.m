% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% DTFT properties

% time difference 

syms w
n=0:4;
x=[1,1,1,1,0];
x1=[0,1,1,1,1];
L=x-x1;
Left=sum(L.*exp(-j*w*n));
subplot(211);
ezplot(abs(Left));
title('| DTFT of x[n]-x[n-1] |')
w1=-2*pi:.1:2*pi;
Left=subs(Left,w,w1);
subplot(212);
plot(w1,angle(Left));
title('Phase of DTFT of x[n]-x[n-1]')
xlim([-2*pi  2*pi])


figure
X= sum(x.*exp(-j*w*n));
Right=(1-exp(-j*w))*X;
subplot(211);
ezplot(abs(Right));
title('| (1-exp(jw))*X(w) |')
subplot(212);
Right=subs(Right,w,w1);
plot(w1,angle(Right));
title('\angle (1-exp(jw))*X(w)')
xlim([-2*pi 2*pi])

