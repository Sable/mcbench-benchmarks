function Y = conj(X)
% CONJ: Complex conjugate of the coefficients of a sympoly array
% usage: Y = conj(X)
% 
% Arguments:
%  X - any sympoly scalar or array
%
%  Y - Complex conjugate of X.
%
%      Y = real(X) - i*imag(X)
%
% See also CTRANSPOSE, @sympoly/CTRANSPOSE
%
% Author: John D'Errico
% e-mail: woodchips@rochester.rr.com
% Release: 1.3
% Release date: 10/18/06

Y = real(X) - i*imag(X);
