% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Problem 8-  Response of an ideal low pass filter to x(t)=2sin(30t)/(pi*t);


syms t w
td=.05;
B= 10;
H=exp(-j*w*td)*(heaviside(w+B)-heaviside(w-B));
w1=-50:.1:50;
H1=subs(H,w,w1);
plot(w1,abs(H1));
legend('Amplitude response')
ylim([-.1 1.1]);
xlabel('\Omega')

figure
x=2*sin(30*t)/(pi*t);
ezplot(x, [-3 3])
ylim([-5 20]);
legend('Input signal x(t)')

figure
X=fourier(x,w);
w1=-50:.1:50;
XX=subs(X,w,w1);
plot(w1,abs(XX));
legend('Input signal X(\Omega)')
ylim([-.2 2.4]);

figure
Y=X*H;
YY=subs(Y,w,w1);
plot(w1,abs(YY));
ylim([-.2  2.3]);
legend('|Y(\Omega) |')

figure
y=ifourier(Y); 
ezplot(y, [-3 3])
ylim([-1.5  8]);
title ('Output signal') 
legend('y(t) ')
