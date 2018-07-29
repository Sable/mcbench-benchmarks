% 
% Author:  Stilian Stoev (C), sstoev@math.bu.edu
%
% This function computes the discrete convolution of the vectors
% a and b, efficiently, by using the FFT algorithm.
%
% input:
%  a <- a vector
%  b <- a vector with the same dimensions as a
%  force <- if force == 1, then the FFT's are "forced" to be
%           of dyadic complexity.
%
% output:
%  c <- the discrete convolution of a and b, that is,
%       (a(1)*b(1), a(1)*b(2)+a(2)*b(1), ...)
% 
% usage:
%   c = fftconv(a,b,force);
%
% Written by sstoev@math.bu.edu
%
function c = fftconv(a,b,force);

na = length(a);
nb = length(b);

if force,
 n = 2^(fix(log2(na+nb))+1);
else
 n=na+nb;
end;
A = fft(a,n);
B = fft(b,n);

c = ifft(A.*B,n);
c = real(c(1:na+nb-1));
