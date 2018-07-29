function [yi, u, ypi, yppi] = floaterhormann(x, y, xi, c)

% FLOATERHORMANN Rational interpolation using the Floater-Hormann Method
%    FLOATERHORMANN(X,Y,XI,C) interpolates to find YI, the values of the
%    underlying function Y at the points in the array XI, using
%    Floater-Hormann rational interpolation.  X and Y must be
%    vectors of length N.
%
%    C specifies the order of the interpolating polynomial
%    (0 <= C <= N).  The default is C = 0 (Berrut rational interpolation).
%
%    [YI,U] = FLOATERHORMANN() also returns the barycentric interpolation
%    weights U.
%
%    [YI,U,YPI,YPPI] = FLOATERHORMANN() also returns the interpolated
%    derivative YPI and the interpolated second derivative YPPI.

% Joe Henning - Fall 2011

% Barycentric Rational Interpolation with no Poles and High Rates of Approximation
% Michael S. Floater and Kai Hormann
% Ifl Technical Report Series, Ifl-06-06

if (nargin < 4)
   c = 0;
end

n = length(x);

if (n-1 < c)
   fprintf('??? Bad c input to floaterhormann ==> c <= length(x)-1\n');
   yi = [];
   u = [];
   ypi = [];
   yppi = [];
   return
end

% calculate Floater-Hormann coefficients
u = [];
for k = 1:n
   u(k,1) = 0;
   for m = k-c:k
      prod = 1;
      if (m < 1 || m > n-c)
         continue
      end
      for j = m:m+c
         if (j ~= k)
            prod = prod/(x(k)-x(j));
         end
      end
      u(k,1) = u(k,1) + (-1)^m*prod;
   end
end

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
      fprintf('??? Bad x input to floaterhormann ==> x values must be distinct\n');
      yi(i) = NaN;
      ypi(i) = NaN;
      yppi(i) = NaN;
      continue;
   end

   isiny = 0;
   for k = 1:n
      if (xi(i) == x(k))
         yi(i) = y(k);
         num = 0;
         for j = 1:n
            if (j ~= k)
               num = num + u(j)*(y(k)/(x(k)-x(j)) + y(j)/(x(j)-x(k)));
            end
         end
         ypi(i) = -num/u(k);
         num = 0;
         for j = 1:n
            if (j ~= k)
               num = num + u(j)*(ypi(i)-(y(k)/(x(k)-x(j)) + y(j)/(x(j)-x(k))))/(x(k)-x(j));
            end
         end
         yppi(i) = -2*num/u(k);
         isiny = 1;
         break
      end
   end

   if (isiny)
      continue
   end

   % Evaluate polynomial
   num = 0;
   den = 0;
   for k = 1:n
      num = num + y(k)*u(k)/(xi(i)-x(k));
      den = den + u(k)/(xi(i)-x(k));
   end
   yi(i) = num/den;

   num = 0;
   den = 0;
   for k = 1:n
      term = yi(i)/(xi(i)-x(k)) + y(k)/(x(k)-xi(i));
      num = num + term*u(k)/(xi(i)-x(k));
      den = den + u(k)/(xi(i)-x(k));
   end
   ypi(i) = num/den;

   num = 0;
   den = 0;
   for k = 1:n
      term = (ypi(i)-(yi(i)/(xi(i)-x(k)) + y(k)/(x(k)-xi(i))))/(xi(i)-x(k));
      num = num + term*u(k)/(xi(i)-x(k));
      den = den + u(k)/(xi(i)-x(k));
   end
   yppi(i) = 2*num/den;
end
