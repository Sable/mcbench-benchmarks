function pint = defint(sp,intvar,interval)
% sympoly/int: definite integral of a sympoly
% usage: pint = defint(sp,intvar,interval);
% 
% arguments: (input)
%  sp       - scalar sympoly object
%
%  intvar   - character - name of variable to integrate over
%
%  interval - numeric vector - length 2 - limits of integration
%
% arguments: (output)
%  pint - scalar sympoly object - definite integral of the polynomial

% intervals needs to be supplied, and it must
% be of length 2
if (nargin~=3) || length(interval)~=2
  error 'interval needs to be a vector of length 2'
end

% indefinite integral
pint = int(sp,intvar);

% substitute at the end points of the interval, then subtract
pint = subs(pint,intvar,interval(2)) - ...
       subs(pint,intvar,interval(1));



