% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
% problem 4 - Computation of circular convolution


x1=[1 2 3 4 5];
x2=[ 5 4 3 2 1];
y=circonv(x1,x2)


X1=fft(x1);
X2=fft(x2);
y=ifft(X1.*X2)
