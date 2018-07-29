function [s,e,f] = ieee754(x,fmt)
%IEEE754 Decompose a double precision floating point number.
% [S,E,F] = IEEE754(X) returns the sign bit, exponent, and mantissa of an
% IEEE 754 floating point value X, expressed as binary digit strings of
% length 1, 11, and 52, respectively. 
%
% S = IEEE754(X) returns one string of length 64.
%
% [S,E,F] = IEEE754(X,'dec') returns S, E, and F as floating-point numbers.
%
% X is equal to (in exact arithmetic and decimal notation)
%
%      (-1)^S * (1 + F/(2^52)) *  2^(E-1023),
%
% except for special values 0, Inf, NaN, and denormalized numbers (between
% 0 and REALMIN). 
%
% See also FORMAT, REALMAX, REALMIN, BIN2DEC.

% Copyright 2009 by Toby Driscoll (driscoll@math.udel.edu). 

if ~isreal(x) || numel(x) > 1 || ~isa(x,'double')
  error('Real, scalar, double input required.')
end
hex = sprintf('%bx',x);  % string of 16 hex digits for x
dec = hex2dec(hex');     % decimal for each digit (1 per row)
bin = dec2bin(dec,4);    % 4 binary digits per row
bitstr = reshape(bin',[1 64]);  % string of 64 bits in order

% Return options
if nargout<2
  s = bitstr;      
else
  s = bitstr(1);
  e = bitstr(2:12);
  f = bitstr(13:64);
  if nargin > 1 && isequal(lower(fmt),'dec')
    s = bin2dec(s);  e = bin2dec(e);  f = bin2dec(f);
  end
end