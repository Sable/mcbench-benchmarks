function [yi, ypi] = mqspline(x, y, yp, xi, c)

% MQSPLINE 1-D piecewise monotone quadratic spline interpolation
%    MQSPLINE(X,Y,C0,XI) interpolates to find YI, the values of
%    the underlying function Y at the points in the array XI, using
%    piecewise monotone quadratic spline interpolation.  X and Y
%    must be vectors of length N.
%
%    C specifies how tangents are calculated when YP is not specified.
%    C can be:
%       0 : Lam harmonic mean (default)
%       1 : Schumaker estimation
%
%    [YI,YPI] = MQSPLINE() also returns the interpolated linear
%    derivative of the underlying function Y at points XI.

% Joe Henning - Fall 2012

% On Shape-Preserving Quadratic Spline Interpolation
% Schumaker, Larry L.
% SIAM Journal of Numerical Analysis 20
% No. 4, August 1983, 854-864

% Monotone and Convex Quadratic Spline Interpolation
% Maria H. Lam
% Virginia Journal of Science
% Volume 41, Number 1, Spring 1990

if (nargin < 5)
   c = 0;
end

n = length(x);

% compute slopes if necessary
if (isempty(yp))
   yp = zeros(1,n);

   if (c == 0)
      d = zeros(1,n-1);
      for i = 1:n-1
         h = x(i+1) - x(i);
         dy = y(i+1) - y(i);
         d(i) = dy/h;
      end

      for i = 2:n-1
         if (d(i-1)*d(i) > 0)
            yp(i) = 2*d(i-1)*d(i)/(d(i-1) + d(i));
         else
            yp(i) = 0;
         end
      end

      if (d(1)*(2*d(1)-yp(2)) > 0)
         yp(1) = 2*d(1) - yp(2);
      else
         yp(1) = 0;
      end

      if (d(n-1)*(2*d(n-1)-yp(n-1)) > 0)
         yp(n) = 2*d(n-1) - yp(n-1);
      else
         yp(n) = 0;
      end
   else
      L = zeros(1,n-1);
      d = zeros(1,n-1);
      for i = 1:n-1
         h = x(i+1) - x(i);
         dy = y(i+1) - y(i);
         L(i) = sqrt(h*h + dy*dy);
         d(i) = dy/h;
      end

      for i = 2:n-1
         if (d(i-1)*d(i) > 0)
            yp(i) = (L(i-1)*d(i-1) + L(i)*d(i))/(L(i-1) + L(i));
         else
            yp(i) = 0;
         end
      end

      yp(1) = -(3*d(1) - yp(2))/2;
      yp(n) = (3*d(n-1) - yp(n-1))/2;
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
      fprintf('??? Bad x input to mqspline ==> x values must be distinct\n');
      yi(i) = NaN;
      ypi(i) = NaN;
      continue;
   end

   a = yp(klo);
   b = yp(khi);

   % Schumaker's method
   del = (y(khi)-y(klo))/h;

   % check for a case where a quadratic polynomial works
   if ((a+b)/2 == del)
      eps = x(khi);
   else
      % check for curvature
      if ((a-del)*(b-del) >= 0)
         % inflection point, neither concave nor convex
         eps = 0.5*(x(klo)+x(khi));
      elseif (abs(b-del) < abs(a-del))
         % convex
         eps = x(klo) + 2*h*(b-del)/(b-a);
      else   % (abs(b-del) >= abs(a-del))
         % concave
         eps = x(khi) + 2*h*(a-del)/(b-a);
      end
   end

   alpha = eps - x(klo);
   beta = x(khi) - eps;
   shat = (2*(y(khi)-y(klo)) - alpha*a - beta*b)/h;

   A1 = y(klo);
   B1 = a;
   C1 = (shat-a)/(2*alpha);
   if (xi(i) <= eps)
      yi(i) = A1 + B1*(xi(i)-x(klo)) + C1*(xi(i)-x(klo))*(xi(i)-x(klo));
      ypi(i) = B1 + 2*C1*(xi(i)-x(klo));
   else
      A2 = A1 + alpha*B1 + alpha*alpha*C1;
      B2 = shat;
      C2 = (b-shat)/(2*beta);
      yi(i) = A2 + B2*(xi(i)-eps) + C2*(xi(i)-eps)*(xi(i)-eps);
      ypi(i) = B2 + 2*C2*(xi(i)-eps);
   end
end
