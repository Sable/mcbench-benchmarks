function Y = imag(X)
% IMAG: Imaginary part of the coefficients of a sympoly array
% usage: Y = imag(X)
% 
% Arguments:
%  X - any sympoly scalar or array
%
%  Y - Imaginary part of the coefficients of X.
%
% See also REAL, CONJ, @sympoly/CONJ, @sympoly/REAL
%
% Author: John D'Errico
% e-mail: woodchips@rochester.rr.com
% Release: 1.3
% Release date: 10/18/06

N = numel(X);

Y = X;
if N>1
  % its a sympoly array
  for i = 1:N
    Y(i) = imag(X(i));
  end
elseif N == 1
  % A scalar. Just take the real parts of the coefficients.
  Y.Coefficient = imag(Y.Coefficient);
end

