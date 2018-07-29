function P = Gamma1aCCDF (x, a)
% Calculate the integral of a one-sided generalized gamma probability
% density function with parameter a.
%
% This routine calculates the integral of the tail of a one-sided gamma
% density function. This is one minus the incomplete gamma function and is
% closely related to the chi-square distribution function.
%                   inf
%   G(x,a) = 1/G(a) Int exp(-t) t^(a-1) dt,  for x >= 0 and a >= 0.
%                    x
% where G(a) is the complete gamma function. For x < 0, the value returned
% is unity. This density is not unit-variance - the density function in
% the integral has a second moment equal to a*(a+1).
%
% For x less than a and for x in the interval [a,1], a series expansion is
% used to calculate the integral. In other parts of the range a continued
% fraction expansion is used.
% Reference:
%   M. Abramowitz and I. A. Stegun, "Handbook of Mathematical Functions",
%   equations 26.4.6 and 26.4.10.

% Parameters
eps = 1e-8;
Amax = 1e12;

if (x <= 0)
  P = 1;

elseif (isinf(x))
  P = 0;
 
elseif (x > 1 && x >= a)

% Continued-fraction expansion
%                    e^(-x) x^a     1  1-a   1  2-a   2  3-a
%   GammaCCDF(x,p) = ----------  ( --  ---  --  ---  --  --- ... )
%                       G(a)       x+   1+  x+   1+  x+   1+
%
% The generic continued fraction expansion to i terms is
%          A(i)           a(1)   a(2)      a(i)
%   f(i) = ---- = b(0) +  -----  ----- ... ----- .
%          B(i)           b(1)+  b(2)+      b(i)
%
% The numerator and denominator terms can be calculated recursively
%   A(i) = b(i)A(i-1) + a(i)A(i-2),  B(i) = b(i)B(i-1) + a(i)B(i-2).
% In the present case, we do two steps of the recursion at once,
%   b(i) A(i+2) = [b(i)b(i+1)b(i+2) + b(i)a(i+2) + b(i+2)a(i+1)] A(i)
%                 - b(i+2)a(i)a(i+1) A(i-2)
% Let i=2n+1
%   a(i)=n, a(i+1)=n+1-a, a(i+2)=n+1, b(i)=x, b(i+1)=1, b(i+2)=x
%   A(i+2) = [x+2(n+1)-a] A(i) - n(n+1-a) A(i-2)
% Initialization, An1=A(1),An2=A(3), Ad1=B(1),Ad2=B(3)
  Bn = x + 2 - a;
  An = 0;
  An1 = 1;
  An2 = x + 1;
  Ad1 = x;
  Ad2 = x * Bn;
  Sp = An2 / Ad2;

% Calculate an extended expansion by recursion
  while (true)
    An = An + 1;
    Bn = Bn + 2;
    Cn = An * (An + 1 - a);
    Anum = An2*Bn - An1*Cn;
    Aden = Ad2*Bn - Ad1*Cn;

% Check for convergence
    if (Aden ~= 0)
      S = Anum / Aden;
      if (abs(Sp - S) <= eps && abs(Sp - S) <= S*eps)
        break
      end
      Sp = S;
    end

% Prepare for the next interation
    An1 = An2;
    An2 = Anum;
    Ad1 = Ad2;
    Ad2 = Aden;

% Scale the terms to prevent overflows
    if (abs(Anum) >= Amax || abs(Aden) >= Amax)
      An1 = An1 / Amax;
      An2 = An2 / Amax;
      Ad1 = Ad1 / Amax;
      Ad2 = Ad2 / Amax;
    end
  end

% Set the value of the function
  Ax = exp(a * log(x) - (x + LogGamma(a)));
  P = Ax * S;

else

% Series approximation
%                     e^(-x) x^a)  inf           x^n
%   GammaCCDF(x,a) = ------------  Sum -----------------------
%                        G(a)      n=0 a * (a+1) * ... * (a+n)
  Cn = 1;
  S = 1;
  Bn = a;

  while (Cn > eps)
    Bn = Bn + 1;
    Cn = Cn * x / Bn;
    S = S + Cn;
  end

  Ax = exp(a * log(x) - (x + LogGamma(a)));
  P = 1 - Ax * S / a;

end

return
