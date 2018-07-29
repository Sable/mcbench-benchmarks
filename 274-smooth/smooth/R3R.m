function y = R3R(x,batch)
% R3R is a repeated running medians of 3.
% 
% Usage: y = R3R(x)
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
if cont,
   % running median
   for ii = 2:xlen-1,
      y(ii) = median(x(ii-1:ii+1));
   end
   % compute the low-end point
   delta = abs( y(3)-y(2) );
   slope = sign( y(3)-y(2) );
   switch slope
   case 1
      if y(2)-y(1)<=0 | y(2)-y(1)>=2*delta, y(1) = y(2) - 2*delta; end
   case -1
      if y(1)-y(2)<=0 | y(1)-y(2)>=2*delta, y(1) = y(2) + 2*delta; end
   case 0
      y(1) = y(2);
   end
   % compute the high-end point
   delta = abs( y(xlen-1)-y(xlen-2) );
   slope = sign( y(xlen-1)-y(xlen-2) );
   switch slope
   case 1
      if y(xlen)-y(xlen-1)<=0 | y(xlen)-y(xlen-1)>=2*delta,y(xlen)=y(xlen-1)+2*delta;end
   case -1
      if y(xlen-1)-y(xlen)<=0 | y(xlen-1)-y(xlen)>=2*delta,y(xlen)=y(xlen-1)-2*delta;end
   case 0
      y(xlen) = y(xlen-1);
   end
end
% 3-ing to death?
if ~isequal(y(2:xlen-1),x(2:xlen-1)) & xlen > 3, y = R3R(y); end

return
