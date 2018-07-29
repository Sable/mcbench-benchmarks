%book : Signals and Systems Laboratory with MATLAB  
%by Alex Palamides & Anastasia Veloni

% Fourier Series properties 


%linearity 

t0=0;
T=2*pi;
w=2*pi/T;
syms t
z1=3+2i; z2=2;
x=cos(t); y=sin(2*t);
f=z1*x+z2*y;
k=-5:5;
left=(1/T)*int(f*exp(-j*k*w*t),t,t0,t0+T);
left=eval(left);
subplot(211);
stem(k,abs(left));
legend('Magnitude');
title('Coefficients of the left part');
subplot(212);
stem(k,angle(left));
legend('Angle');

figure
a=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T);
b=(1/T)*int(y*exp(-j*k*w*t),t,t0,t0+T);
right=z1*a+z2*b;
subplot(211);
right=eval(right);
stem(k,abs(right));
legend('Magnitude');
title('Coefficients of the right part');
subplot(212);
stem(k,angle(right));
legend('Angle');




