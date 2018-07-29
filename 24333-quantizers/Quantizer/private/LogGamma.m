function Alg = LogGamma (x)
% Calculate the log-gamma function
% This routines returns the natural logarithm of the gamma function. For
% argument values less than 10^(-9), the function is set to Inf. The
% approximation is based on an asymptotic expansion.
% Reference:
%   M. Abramowitz and I.A. Stegun, "Handbook of Mathematical Functions",
%   equation 6.1.40.

% Parameters
C0 = 0.91893853320467274178e0;   % 0.5 * log(2*pi)
% Cm is B(2m)/(2m(2m-1))
% where B(2m) for 1,...,4 = [1/6, -1/30, 1/42, -1/30]
C1 = 8.3333333333333333333e-2;   % 1/12
C2 =-2.7777777777777777778e-3;   % -1/360
C3 = 7.9365079365079365079e-4;   % 1/1260
C4 =-5.9523809523809523810e-4;   % -1/1680
xmax = 1e10;
xmin = 1e-9;
zmin = 18;

z = x;
if (x > xmax)

% For large arguments use an abreviated series
  Alg = z * (log(z) - 1);

elseif (x > xmin)

% Use the gamma function recursion to telescope the argument
  zfact = 1;
  while (z <= zmin)
    zfact = zfact * z;
    z = z + 1;
  end

% Euler-McLaurin series expansion (z larger than zmin)
% The approximation error (for z > 18) is at most 5e-15
  rz = 1 / z;
  rz2 = rz * rz;
  Alg = (z - 1/2) * log(z) - z + C0 - log(zfact) ...
        + rz * (C1 + (rz2 * (C2 + (rz2 * (C3 + rz2 * C4)))));

elseif (x >= 0)

% Small argument
  Alg = Inf;

else
   error('LogGamma: argument must be non-negative');
 
end

return