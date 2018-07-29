function [yi, ypi, yppi] = chermite(x, y, yp, xi, c)

% CHERMITE 1-D piecewise cubic Hermite spline
%    CHERMITE(X,Y,YP,XI,C) interpolates to find YI, the values of the
%    underlying function Y at the points in the array XI, using
%    piecewise cubic Hermite splines.  X and Y must be vectors
%    of length N.
%
%    C specifies how tangents are calculated when YP is not specified.
%    C can be:
%       0 : Finite difference (default)
%       1 : Catmull-Rom spline
%       2 : Monotone interpolation
%       3 : Monotone with Lam harmonic mean
%
%    [YI,YPI,YPPI] = CHERMITE() also returns the interpolated
%    quadratic derivative and linear second derivative of the
%    underlying function Y at points XI.

% Joe Henning - Fall 2011

if (nargin < 5)
   c = 0;
end

if (~isempty(yp))
   c = -1;
end

n = length(x);

if (c == 0)
   % precompute finite difference derivative
   yp = lfindiff (x, y);
elseif (c == 3)
   % precompute harmonic mean
   yp = zeros(1,n);
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
      fprintf('??? Bad x input to chermite ==> x values must be distinct\n');
      yi(i) = NaN;
      ypi(i) = NaN;
      yppi(i) = NaN;
      continue;
   end

   if (c == -1)
      a = yp(klo);
      b = yp(khi);
   elseif (c == 0)
      % Finite difference
      a = yp(klo);
      b = yp(khi);
   elseif (c == 1)
      % Catmull-Rom spline
      if (klo == 1)
         a = (y(khi) - y(klo))/h;
         b = (y(khi+1) - y(klo))/(x(khi+1) - x(klo));
      elseif (khi == n)
         a = (y(khi) - y(klo-1))/(x(khi) - x(klo-1));
         b = (y(khi) - y(klo))/h;
      else
         a = (y(khi) - y(klo-1))/(x(khi) - x(klo-1));
         b = (y(khi+1) - y(klo))/(x(khi+1) - x(klo));
      end
   else
      % Monotone interpolation
      if (c == 2)
         if (klo == 1)
            a = (y(khi) - y(klo))/h;
            b = ( (y(khi) - y(klo))/h + (y(khi+1) - y(khi))/(x(khi+1) - x(khi)) )/2;
         elseif (khi == n)
            a = ( (y(klo) - y(klo-1))/(x(klo) - x(klo-1)) + (y(khi) - y(klo))/h )/2;
            b = (y(khi) - y(klo))/h;
         else
            a = ( (y(klo) - y(klo-1))/(x(klo) - x(klo-1)) + (y(khi) - y(klo))/h )/2;
            b = ( (y(khi) - y(klo))/h + (y(khi+1) - y(khi))/(x(khi+1) - x(khi)) )/2;
         end
      else
         % Harmonic mean
         a = yp(klo);
         b = yp(khi);
      end

      if ( y(khi) == y(klo) )
         a = 0;
         b = 0;
      else
         alpha = a/( (y(khi) - y(klo))/h );
         beta = b/( (y(khi) - y(klo))/h );
         if (alpha < 0 || beta < 0)
            a = 0;
            b = 0;
         else
            if ( (alpha*alpha + beta*beta) > 9 )
               tau = 3/sqrt(alpha*alpha + beta*beta);
               a = tau*alpha*(y(khi) - y(klo))/h;
               b = tau*beta*(y(khi) - y(klo))/h;
            end
         end
      end
   end

   % Evaluate cubic Hermite polynomial
   t = (xi(i) - x(klo))/h;
   t2 = t*t;
   t3 = t2*t;
   h2 = h*h;
   h00 = 2*t3 - 3*t2 + 1;
   h10 = t3 - 2*t2 + t;
   h01 = -2*t3 + 3*t2;
   h11 = t3 - t2;

   yi(i) = h00*y(klo) + h10*h*a + h01*y(khi) + h11*h*b;
   
   % Differentiate to find the second-order interpolant
   h00 = 6*t2 - 6*t;
   h10 = 3*t2 - 4*t + 1;
   h01 = -h00;
   h11 = 3*t2 - 2*t;
   
   ypi(i) = h00*y(klo)/h + h10*a + h01*y(khi)/h + h11*b;
   
   % Differentiate to find the first-order interpolant
   h00 = 12*t - 6;
   h10 = 6*t - 4;
   h01 = -h00;
   h11 = 6*t - 2;
   
   yppi(i) = h00*y(klo)/h2 + h10*a/h + h01*y(khi)/h2 + h11*b/h;
end


% 3-pt finite difference
function [yp] = lfindiff(x, y)
% Finite Difference Formulae for Unequal Sub-Intervals Using Lagrange's Interpolation Formula
% Singh, Ashok K. and B. S. Bhadauria
% Int. Journal of Math. Analysis, Vol. 3, 2009, no. 17, 815-827

n = length(x);

if (n ~= length(y))
   fprintf('Error, len(x) != len(y), returning\n');
   yp = NaN;
   return;
end

for k = 1:n
   if (k == 1)
      h1 = x(k+1) - x(k);
      h2 = x(k+2) - x(k+1);
      yp(k) = -(2*h1+h2)/(h1*(h1+h2))*y(k) + (h1+h2)/(h1*h2)*y(k+1) - h1/(h2*(h1+h2))*y(k+2);
   elseif (k == n)
      h1 = x(k-1) - x(k-2);
      h2 = x(k) - x(k-1);
      yp(k) = h2/(h1*(h1+h2))*y(k-2) - (h1+h2)/(h1*h2)*y(k-1) + (h1+2*h2)/(h2*(h1+h2))*y(k);
   else
      h1 = x(k) - x(k-1);
      h2 = x(k+1) - x(k);
      yp(k) = -h2/(h1*(h1+h2))*y(k-1) - (h1-h2)/(h1*h2)*y(k) + h1/(h2*(h1+h2))*y(k+1);
   end
end
