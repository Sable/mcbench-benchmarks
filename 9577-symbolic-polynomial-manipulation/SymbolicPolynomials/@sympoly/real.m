function Y = real(X)
% REAL: Real part of the coefficients of a sympoly array
% usage: Y = real(X)
% 
% Arguments:
%  X - any sympoly scalar or array
%
%  Y - Real part of the coefficients of X.
%
% See also IMAG, CONJ, @sympoly/CONJ, @sympoly/IMAG
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
    Y(i) = real(X(i));
  end
elseif N == 1
  % A scalar. Just take the real parts of the coefficients.
  Y.Coefficient = real(Y.Coefficient);
end

