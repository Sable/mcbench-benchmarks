function Y = transpose(X)
% ctranspose: conjugate transpose (X') of a sympoly array
% usage: Y = cranspose(X)
% usage: Y = X'
%
% Arguments:
%  X - any sympoly array.
%
%  Y - the conjugate transpose of X
% 
%      Y = conj(X.')
%
%   See also CTRANSPOSE, TRANSPOSE
%
% Author: John D'Errico
% e-mail: woodchips@rochester.rr.com
% Release: 1.3
% Release date: 10/18/06

Y = conj(X.');
