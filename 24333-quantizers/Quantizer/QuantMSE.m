function MSE = QuantMSE (Yq, Xq, FPDF)
% Calculate the mean-square quantization error
%
% This routine calculates the mean square error for a quantizer specified
% by a table of decision levels and output levels. The quantizer assigns an
% output level to a range of input values in accordance with the following
% table,
%       interval           input range          output level
%          1            -Inf < x =< Xq(1)          Yq(1)
%          2           Xq(1) < x =< Xq(2)          Yq(2)
%         ...                 ...                   ...
%        Nlev-1   Xq(Nlev-1) < x =< Xq(Nlev-1)     Yq(Nlev-1)
%        Nlev       Xq(Nlev) < x =< Inf            Yq(Nlev)
%
% Yq - Nlev quantizer output levels (in ascending order)
% Xq - Nlev-1 quantizer decision levels (in ascending order)
% FPDF - Cell array of function handles {Farea, Fmean, Fvar}
% Farea - Pointer to a function to calculate the integral of a probability
%   density function in an interval.
%                 b
%   Farea(a,b) = Int p(x) dx,
%                 a
%   where (a,b) is the interval and p(x) is the probability density
%   function.
% Fmean - Pointer to a function to calculate the mean of a probability
%   density function in an interval.
%                 b
%   Fmean(a,b) = Int x p(x) dx,
%                 a
%   where (a,b) is the interval and p(x) is the probability density
%   function.
% Fvar - Pointer to a function to calculate the second moment of a
%   probability density function in an interval.
%                b
%   Fvar(a,b) = Int x^2 p(x) dx,
%                a
%   where (a,b) is the interval and p(x) is the probability density
%   function.
%
% The mean square error is calculated as
%         Nlev Xq(i)
%   MSE = Sum   Int  (x-Yq(i))^2 p(x) dx
%         i=1  Xq(i-1)
%
%                     Nlev          Xq(i)
%       = var[p(x)] - Sum  [2 Yq(i)  Int x p(x) dx
%                     i=1           Xq(i-1)
%
%                                     Xq(i)
%                           - Yq(i)^2  Int p(x) dx ],
%                                     Xq(i-1)
% with Xq(0)=-Inf and Xq(Nlev+1)=Inf.

Farea = FPDF{1};
Fmean = FPDF{2};
Fvar = FPDF{3};

% Sum the mean square error terms, interval by interval
Nlev = length(Yq);
if (Nlev ~= length(Xq)+1)
  error('QuantMSE - Invalid length for Yq and/or Xq');
end

dMSE = 0;
XU = -Inf;
for (i = 1:Nlev)
  XL = XU;
  if (i < Nlev)
    XU = Xq(i);
  else
    XU = Inf;
  end
  dMSE = dMSE + Yq(i)*(2*feval(Fmean, XL, XU) - Yq(i)*feval(Farea, XL, XU));
end

MSE = feval(Fvar, -Inf, Inf) - dMSE;

return
