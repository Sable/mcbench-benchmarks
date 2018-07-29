function Ent = QuantEntropy (Xq, Farea)
% Calculate the entropy for a quantizer
%
% This routine calculates the entropy for a quantizer specified by
% a table of decision levels. The quantizer assigns an output level
% to a range of input values in accordance with the following table,
%       interval            input range
%          1             -Inf < x =< Xq(1)
%          2            Xq(1) < x =< Xq(2)
%         ...                  ...
%        Nlev-1    Xq(Nlev-1) < x =< Xq(Nlev-1)
%        Nlev        Xq(Nlev) < x =< Inf
%
% The entropy is calculated as
%           Nlev
%   Ent = - Sum  p(i) Log2(p(i)) ,
%           i=1
%              Xq(i)
% where p(i) =  INT  p(x) dx ,
%              Xq(i-1)
% where Xq(0)=-Inf and Xq(Nlev)=Inf.
%
% Xq - Nlev-1 quantizer decision levels (in ascending order)
% Farea - Pointer to a function to calculate the integral of a
%   probability density function in an interval.
%                 b
%   Farea(a,b) = Int p(x) dx,
%                 a
%   where (a,b) is the interval and p(x) is the probability density
%   function.

% Sum the entropy, interval by interval
Nlev = length(Xq) + 1;
Enat = 0;
XU = -Inf;
for (i = 1:Nlev)

% Calculate the probability of the interval (XQL,XQU)
  XL = XU;
  if (i < Nlev)
    XU = Xq(i);
  else
    XU = Inf;
  end
  Pr = feval(Farea, XL, XU);

% Calculate the contribution to the entropy
  if (Pr > 0)
    Enat = Enat - Pr * log(Pr);
  elseif (Pr < 0)
    error('QuantEntropy: Negative interval probability');
  end
end

% Return the entropy in bits
Ent= Enat / log(2);

return
