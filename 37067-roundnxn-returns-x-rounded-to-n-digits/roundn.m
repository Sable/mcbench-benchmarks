% ------------------------------------------------------------- roundn(x,d)
% ROUNDN(x,d) returns x rounded to d digits.
%
%    If d is not given, then d = 1 is assumed.
%
% See also:
%   ROUND
% -------------------------------------------------------------------------

function y = roundn(x,d)

if nargin == 1
    y = round(x);
else
   
    y = round(10^d*x)/10^d;
      
end