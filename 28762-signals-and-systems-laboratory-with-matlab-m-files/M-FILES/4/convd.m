% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
%
% problem 7 - function that computes the convolution of x[n] and h[n]


function [y,n] = convd(x,n1,h,n2)
a = n1(1)+n2(1);
b = n1(end) + n2(end);
n =a:b;
y = conv(x,h);
stem(n,y);
legend('y[n]')



