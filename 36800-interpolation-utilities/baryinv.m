function [yi, u] = baryinv(x, y, xi, c)

% BARYINV 1-D barycentric interpolation with inverse distance weighting
%    BARYINV(X,Y,XI,C) interpolates to find YI, the values of the
%    underlying function Y at the points in the array XI, using
%    the second form (or true form) of the barycentric interpolation
%    formula and inverse distance weighting.  X and Y must be vectors
%    of length N.
%
%    C specifies the order of the inverse distance weighting.  It
%    defaults to 1 (Shepard's interpolant).
%
%    [YI,U] = BARYINV() also returns the barycentric interpolation
%    weights U.

% Joe Henning - Fall 2011

if (nargin < 4)
   c = 1;
end

n = length(x);

for i = 1:length(xi)
   % Find the right place in the table by means of a bisection.
   klo = 1;
   khi = n;
   while (khi-klo > 1)
      k = fix((khi+klo)/2.0);
      if (x(k) > xi(i))
         khi = k;
      else
         klo = k;
      end
   end
   
   h = x(khi) - x(klo);
   if (h == 0.0)
      fprintf('??? Bad x input to baryinv ==> x values must be distinct\n');
      yi(i) = NaN;
      continue;
   end

   isiny = 0;
   for k = 1:n
      if (xi(i) == x(k))
         yi(i) = y(k);
         isiny = 1;
         break
      end
   end

   if (isiny)
      continue
   end

   % Evaluate weighted polynomial
   num = 0;
   den = 0;
   for k = 1:n
      u(k,1) = (1/(xi(i)-x(k)))^c;
      num = num + u(k)*y(k)/(xi(i)-x(k));
      den = den + u(k)/(xi(i)-x(k));
   end
   yi(i) = num/den;
end
