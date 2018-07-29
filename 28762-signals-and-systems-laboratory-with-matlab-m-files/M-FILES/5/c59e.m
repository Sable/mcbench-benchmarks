% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni

% Fourier Series properties 


% Signal multiplication 

syms t 
t0=0;
T=2*pi; 
w=2*pi/T; 
x=cos(t) ;
k=-5:5;
a=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T);
a1=eval(a);
y=sin(t);
b=(1/T)*int(y*exp(-j*k*w*t),t,t0,t0+T);
b1=eval(b);
left=conv(a1,b1);
subplot(211);
stem(-10:10,abs(left));
legend('Magnitude');
title(' a_k*b_k');
subplot(212);
stem(-10:10,angle(left));
legend('Angle');

figure
z=x*y; 
k=-10:10;
c=(1/T)*int(z*exp(-j*k*w*t),t,t0,t0+T);
c1=eval(c)
subplot(211);
stem(k,abs(c1));
legend('Magnitude');
title(' Coefficients of x(t)y(t)');
subplot(212);
stem(k,angle(c1));
legend('Angle');

