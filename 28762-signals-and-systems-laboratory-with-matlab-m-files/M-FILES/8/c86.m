% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Frequency Response of the discrete time systems 
% described by the impulse response:


% a)h[n]=[3,5,2,1],n=0,1,2,3

n=0:3;
h=[3 5 2 1];
syms w
H=sum(h.*exp(-j*w*n))
ezplot(abs(H),[0 2*pi])
title('|H(\omega)|,0<\omega<2\pi')

figure
ezplot(abs(H),[-5*pi 5*pi])
title('|H(\omega)|,-5\pi<\omega<5\pi')

figure
w1=0:.1:2*pi;
HH=subs(H,w,w1);
plot(w1,angle(HH));
title('\angle H(\omega), 0<\omega<2\pi')

figure
w1=-5*pi:.1:5*pi;
HH=subs(H,w,w1);
plot(w1,angle(HH));
xlim([-5*pi 5*pi])
title('\angle H(\omega),-5\pi<\omega<5\pi')


% b)h[n]=(2/3)^n u[n]

syms n w
h=(2/3)^n;
H=symsum(h*exp(-j*w*n),n,0,inf)

