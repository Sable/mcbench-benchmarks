function [y,r]=smooth(x,twice)
% SMOOTH will compute the non-linear running medians of
%     the input vector.  First it smooths the data, compute
%     the residuals, smooth the residuals, and add this back
%     to the first smooth.
%
% Usage: y = smooth(x, OPTIONAL twice?)
%  where x         is the input vector of minimum length 3
%        twice?    whether to do this twice (default = 1)
%        y         is the smoothed vector
%
% [y,r] = smooth(x, OPTIONAL twice?)
%     r  is the final residuals where x = y + r
%
% See also: R3R, SR, R3RSR, H

%
% Huy Le,  Massachusetts Institute of Technology.   1997
%
% See John Wilder Tukey, "EXPLORATORY DATA ANALYSIS".
% Addison-Wesley Publishing Co. 1977. Chpt 7, 16.

format long e;
xlen = length(x); x = x(:); y = x; r = x - y; batch = 1;  
if nargin<2, twice = 1; end
if nargout<2, res = 0; end
if ~all(isfinite(x)), error('Input must have finite values.'); end
if xlen<3, error('Input vector must be at least 3 elements long.'); end
% first, run the 3RSR of vector x
xtemp1 = R3RSR(x,batch);
% first hanning
xtemp2 = H(xtemp1,batch);
% second hanning
xtemp1 = H(xtemp2,batch);
if twice,
   % compute first residuals
   rtemp = x - xtemp1;
   % run 3RSR on first residuals
   rtemp1 = R3RSR(rtemp,batch);
   % hanning of first residuals
   rtemp2 = H(rtemp1,batch);
   % sum of smooths
   xtemp = xtemp1 + rtemp2;
else
   xtemp = xtemp1;
end

for ii = 1:xlen,
   y(ii) = xtemp(ii);
   r(ii) = x(ii) - y(ii);
end

return

