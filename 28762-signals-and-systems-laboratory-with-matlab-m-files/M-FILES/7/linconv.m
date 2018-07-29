% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
% problem 11 - This function computes the linear convolution of two
% sequences with use of theis DFTs and IDFTs

function y=linconv(x,h);
 
N1=length(x);
N2=length(h);
N= N1 + N2-1 ;
 
X=fft(x,N);
H=fft(h,N);
y=ifft(X.*H);

