%book : Signals and Systems Laboratory with MATLAB  
%by Alex Palamides & Anastasia Veloni

% Fourier Series properties 


%time shifting 

t0=0;
T=10;
w=2*pi/T;
syms t
x=t*exp(-5*t) 
k=-5:5;
a=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T);
a1=eval(a);
subplot(211);
stem(k,abs(a1));
title(' Coefficients of x(t)=te^-^5^t');
legend('Magnitude');
subplot(212);
stem(k,angle(a1));
legend('Angle');

figure
t1=3;
right= exp(-j*k*w*t1).*a;
right =eval(right);
subplot(211);
stem(k,abs(right));
legend('Magnitude');
title('Right part');
subplot(212);
stem(k,angle(right));
legend('Angle');

figure
x=(t-t1).*exp(-5*(t-t1));
a=(1/T)*int(x*exp(-j*k*w*t),t,t0+t1,t0+T+t1);
coe=eval(a);
subplot(211);
stem(k,abs(coe));
legend('Magnitude');
title(' Coefficient of (t-3)exp(-5(t-3)) ');
subplot(212);
stem(k,angle(coe));
legend('Angle');
