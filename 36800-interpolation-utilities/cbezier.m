function [yi, ypi, yppi, c1x, c1y, c2x, c2y] = cbezier(x, y, xi)

% CBEZIER 1-D piecewise cubic Bezier spline interpolation
%    CBEZIER(X,Y,XI) interpolates to find YI, the values of
%    the underlying function Y at the points in the array XI, using
%    piecewise subic Bezier spline interpolation.  X and Y must
%    be vectors of length N.
%
%    [YI,YPI,YPPI] = CBEZIER() also returns the interpolated
%    quadratic derivative and linear second derivative of the
%    underlying function Y at points XI.
%
%    [YI,YPI,YPPI,C1X,C1Y,C2X,C2Y] = CBEZIER() also returns the
%    X and Y coordinates of the first and second Bezier control
%    points.

% Joe Henning - Fall 2011

n = length(x);
u = zeros(1,n-1);
v = zeros(1,n-1);

if (n == 2)
   % Bezier curve should be a straight line
   c1x(1) = (2*x(1) + x(2))/3.0;
   c1y(1) = (2*y(1) + y(2))/3.0;
   
   c2x(1) = 2*c1x - x(1);
   c2y(1) = 2*c1y - y(1);
else
   % Calculate first Bezier control points
   for i = 2:n-2
      u(i) = 4*x(i) + 2*x(i+1);
      v(i) = 4*y(i) + 2*y(i+1);
   end
   u(1) = x(1) + 2*x(2);
   u(n-1) = (8*x(n-1) + x(n))/2.0;
   v(1) = y(1) + 2*y(2);
   v(n-1) = (8*y(n-1) + y(n))/2.0;

   % Decomposition, forward substitution, and backsubstitution
   tmp = zeros(1,n-1);
   b = 2.0;
   c1x(1) = u(1)/b;

   for i = 2:n-1
      tmp(i) = 1/b;
      if (i < n-1)
         b = 4.0 - tmp(i);
      else
         b = 3.5 - tmp(i);
      end
      c1x(i) = (u(i) - c1x(i-1))/b;
   end

   for i = 2:n-1
      c1x(n-i) = c1x(n-i) - tmp(n-i+1)*c1x(n-i+1);
   end
   
   tmp = zeros(1,n-1);
   b = 2.0;
   c1y(1) = v(1)/b;

   for i = 2:n-1
      tmp(i) = 1/b;
      if (i < n-1)
         b = 4.0 - tmp(i); 
      else
         b = 3.5 - tmp(i);
      end
      c1y(i) = (v(i) - c1y(i-1))/b;
   end

   for i = 2:n-1
      c1y(n-i) = c1y(n-i) - tmp(n-i+1)*c1y(n-i+1);
   end
   
   % Calculate second Bezier control points
   for i = 1:n-1
      if (i < n-1)
         c2x(i) = 2*x(i+1) - c1x(i+1);
         c2y(i) = 2*y(i+1) - c1y(i+1);
      else
         c2x(i) = (x(n) + c1x(n-1))/2.0;
         c2y(i) = (y(n) + c1y(n-1))/2.0;
      end
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
      fprintf('??? Bad x input to cbezier ==> x values must be distinct\n');
      yi(i) = NaN;
      ypi(i) = NaN;
      yppi(i) = NaN;
      continue;
   end
   
   % Evaluate cubic Bezier polynomial
   t = (xi(i) - x(klo))/h;
   t2 = t*t;
   t3 = t2*t;
   h2 = h*h;
   b00 = -t3 + 3*t2 - 3*t + 1;
   b10 = 3*t3 - 6*t2 + 3*t;
   b20 = -3*t3 + 3*t2;
   b30 = t3;
   
   yi(i) = b00*y(klo) + b10*c1y(klo) + b20*c2y(klo) + b30*y(khi);
   
   % Differentiate to find the second-order interpolant
   b00 = -3*t2 + 6*t - 3;
   b10 = 9*t2 - 12*t + 3;
   b20 = -9*t2 + 6*t;
   b30 = 3*t2;
   
   ypi(i) = b00*y(klo)/h + b10*c1y(klo)/h + b20*c2y(klo)/h + b30*y(khi)/h;
   
   % Differentiate to find the first-order interpolant
   b00 = -6*t + 6;
   b10 = 18*t - 12;
   b20 = -18*t + 6;
   b30 = 6*t;
   
   yppi(i) = b00*y(klo)/h2 + b10*c1y(klo)/h2 + b20*c2y(klo)/h2 + b30*y(khi)/h2;
end
