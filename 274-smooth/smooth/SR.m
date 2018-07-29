function y = SR(x,batch)
% SR is a process of splitting the peaks and valleys.
%    This function require the R3R function. 
%
% Usage: y = SR(x)
%
%  where  x   is the input vector of at least length 5
%         y   is the return matrix whose columns are
%             the sub-seqs of x
%

% See John Wilder Tukey, "Exploratory Data Analysis"
% Addison-Wesley Publishing Co. 1977 Chpt 7F.

if min(size(x)) ~= 1, error('Input must be a vector'); end
x = x(:); xlen = length(x); cont = 0; y = x; 
zero = NaN; neg = NaN; pos = NaN; start = 1; stop = xlen;
if nargin<2, batch = 0; end
xtemp = diff(x); nonce = 2;

for ii = 1:xlen-1,
   % detecting 2-wide peaks and valleys
   if xtemp(ii)<0, neg = ii; end
   if xtemp(ii)>0, pos = ii; end
   if xtemp(ii)==0, zero = ii; end
   if zero == (neg+pos)/2,
      stop(nonce) = stop(nonce-1);
      stop(nonce-1) = zero;
      start(nonce)= zero+1;
      nonce = nonce + 1;
      cont = 1;
   end
end

if cont,
   % splitting and running 3R to end-value smooth
   xtemp = inf * ones(xlen,xlen);
   for ii = 1:length(stop),
      xtemp(1:stop(ii)-start(ii)+1,ii) = R3R(x(start(ii):stop(ii)),batch);
      % handling 2-long sub-sequences
      if stop(ii)-start(ii)==1 & start(ii)~=1 & stop(ii)~=xlen,
         xtemp(3,ii) = xtemp(2,ii);
         xtemp(2,ii) = xtemp(1,ii);
         xtemp(1,ii) = xtemp(3,ii);
      end
   end
   % putting it back
   for ii = 1:length(stop),
      y(start(ii):stop(ii)) = xtemp(1:stop(ii)-start(ii)+1,ii);
   end
   % 3R smooth the joins
   xtemp = inf * ones(xlen,1);
   xtemp = R3R(y);
   y = xtemp;
end

return
