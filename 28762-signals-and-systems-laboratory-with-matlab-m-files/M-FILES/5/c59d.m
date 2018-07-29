% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni

% Fourier Series properties 


% Time scaling

syms t 
t0=0;
T=2*pi;
w=2*pi/T; 
x=t*cos(t) ;
k=-5:5;
a=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T);
a1=eval(a)
subplot(211);
stem(k,abs(a1));
legend('Magnitude');
title(' Coefficients of x(t)');
subplot(212);
stem(k,angle(a1));
legend('Angle');

figure
lamda=2;
T=T/ lamda ;
w=2*pi/T; 
x= lamda *t*cos(lamda *t) ;
k=-5:5;
a=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T);
a1=eval(a)
subplot(211);
stem(k,abs(a1));
legend('Magnitude');
title(' Coefficients of x(2t)');
subplot(212);
stem(k,angle(a1));
legend('Angle');


