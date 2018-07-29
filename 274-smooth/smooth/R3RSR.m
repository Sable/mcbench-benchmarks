function y = R3RSR(x,batch)
% R3RSR will R3R a vector x follow by a repeated splitting
%    (repeated SR) of the results from R3R.
% 
% Usage: y = R3RSR(x)
%  
%   where  x is the input vector with length at least 3
%          y is the return vector of the same length as x
%

% See John Wilder Tukey, "EXPLORATORY DATA ANALYSIS".
% Addison-Wesley Publishing Co. 1977. Chpt 7A, 7D

if min(size(x)) ~= 1, error('Input must be a vector'); end
x = x(:); xlen = length(x); cont = 1; y = x;
if nargin<2, batch = 0; end
if xlen < 3, 
   if ~batch, warning('Input vector must be at least 3 elements long'); end
   cont = 0; 
end
xtemp1 = R3R(x,batch);
xtemp2 = SR(xtemp1,batch);
while any(xtemp2-xtemp1),
   xtemp1 = xtemp2;
   xtemp2 = SR(xtemp1,batch);
end

return
