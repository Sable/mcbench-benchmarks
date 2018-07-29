function [yi, ypi, yppi] = cakima(x, y, xi)

% CAKIMA 1-D piecewise cubic Akima interpolation
%    CAKIMA(X,Y,XI) interpolates to find YI, the values of
%    the underlying function Y at the points in the array XI, using
%    piecewise cubic Akima interpolation.  X and Y must be vectors
%    of length N.
%
%    [YI,YPI,YPPI] = CAKIMA() also returns the interpolated
%    quadratic derivative and linear second derivative of the
%    underlying function Y at points XI.

% Joe Henning - Fall 2011

n = length(x);
u = zeros(1,n+3);
yp = zeros(1,n);

% Calculate Akima coefficients and derivatives
for i = 1:n-1
   % Shift i to i+2
   u(i+2) = (y(i+1)-y(i))/(x(i+1)-x(i));
end

u(n+2) = 2.0*u(n+1) - u(n);
u(n+3) = 2.0*u(n+2) - u(n+1);
u(2) = 2.0*u(3) - u(4);
u(1) = 2.0*u(2) - u(3);

for i = 1:n
   a = abs(u(i+3) - u(i+2));
   b = abs(u(i+1) - u(i));
   if ((a+b) ~= 0)
      yp(i) = (a*u(i+1) + b*u(i+2))/(a+b);
   else
      yp(i) = (u(i+2) + u(i+1))/2.0;
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

   b = x(khi) - x(klo);
   if (b == 0.0)
      fprintf('??? Bad x input to cakima ==> x values must be distinct\n');
      yi(i) = NaN;
      ypi(i) = NaN;
      yppi(i) = NaN;
      continue;
   end

   % Evaluate Akima polynomial
   a = xi(i) - x(klo);
   yi(i) = y(klo) + yp(klo)*a + (3.0*u(klo+2) - 2.0*yp(klo) - yp(klo+1))*a*a/b + (yp(klo) + yp(klo+1) - 2.0*u(klo+2))*a*a*a/(b*b);

   % Differentiate to find the second-order interpolant
   ypi(i) = yp(klo) + (3.0*u(klo+2) - 2.0*yp(klo) - yp(klo+1))*2*a/b + (yp(klo) + yp(klo+1) - 2.0*u(klo+2))*3*a*a/(b*b);

   % Differentiate to find the first-order interpolant
   yppi(i) = (3.0*u(klo+2) - 2.0*yp(klo) - yp(klo+1))*2/b + (yp(klo) + yp(klo+1) - 2.0*u(klo+2))*6*a/(b*b);
end
