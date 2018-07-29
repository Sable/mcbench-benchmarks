% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
% problem 8 - This function computes the circular convolution of two sequences
% that may not have the same number of samples

function y=circonv3(x,h);
 
N1=length(x);
N2=length(h);
N=max(N1,N2);
 
X=fft(x,N);
H=fft(h,N);
y=ifft(X.*H);
