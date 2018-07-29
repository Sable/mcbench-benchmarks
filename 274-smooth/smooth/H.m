function y = H(x,batch)
% H is the process of hanning the vector x.
% 
% Usage: y = H(x)
%  
%   where  x is the input vector with length at least 3
%          y is the return vector of the same length as x
%

% See John Wilder Tukey, "EXPLORATORY DATA ANALYSIS".
% Addison-Wesley Publishing Co. 1977. Chpt 7G.

if min(size(x)) ~= 1, error('Input must be a vector'); end
x = x(:); xlen = length(x); cont = 1; y = x;
xtemp1 = inf * ones(xlen-1,1); xtemp2 = inf * ones(xlen-2,1); 
if nargin<2, batch = 0; end
if xlen < 3, 
   if ~batch, warning('Input vector must be at least 3 elements long'); end
   cont = 0; 
end
if cont,
   % Mean of adjacent
   for ii = 1:xlen-1,
      xtemp1(ii) = mean(x(ii:ii+1));
   end
   % Mean of adjacent (again)
   for ii = 1:xlen-2,
      xtemp2(ii) = mean(xtemp1(ii:ii+1));
   end
   y(2:xlen-1) = xtemp2;
end
   
return
