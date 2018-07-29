% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni

% Fourier Series properties 


% Time reversal

t0=0;
T=2*pi;
w=2*pi/T;
syms t
x=t*cos(t) ;
k=-5:5;
a=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T);
a1=eval(a);
subplot(211);
stem(k,real(a1));
legend('Re[a_k]');
title('Coefficients of x(t)');
subplot(212);
stem(k,imag (a1));
legend('Im[a_k]');

figure
x_=-t*cos(-t) ;
b=(1/T)*int(x_*exp(-j*k*w*t),t,t0-T,t0);
b1=eval(b)
subplot(211);
stem(k,real(b1));
legend('Re[b_k]');
title(' Coefficients of x(-t)');
subplot(212);
stem(k,imag (b1));
legend('Im[b_k]');
