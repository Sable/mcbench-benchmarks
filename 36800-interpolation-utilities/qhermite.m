function [yi, ypi, yppi] = qhermite(x, y, yp, ypp, xi, v)

% QHERMITE 1-D piecewise quintic Hermite spline
%    QHERMITE(X,Y,YP,YPP,XI,M) interpolates to find YI, the values of
%    the underlying function Y at the points in the array XI, using
%    piecewise quintic Hermite splines.  X and Y must be vectors
%    of length N.
%
%    V specifies how tangents are calculated when derivatives are not
%    specified.  V can be:
%       0 : Finite difference (default)
%       1 : Catmull-Rom spline
%
%    [YI,YPI,YPPI] = QHERMITE() also returns the interpolated
%    quartic derivative and cubic second derivative of the underlying
%    function Y at points XI.

% Joe Henning - Fall 2011

if (nargin < 6)
   v = 0;
end

if (v == 0)
   % precompute finite difference derivatives
   if (isempty(yp) && isempty(ypp))
      m = 0;
      yp = lfindiff (x, y);
      ypp = lfindiff (x, yp);
   elseif (isempty(yp))
      m = 1;
      yp = lfindiff (x, y);
   elseif (isempty(ypp))
      m = 2;
      ypp = lfindiff (x, yp);
   else
      m = -1;
   end
else
   if (isempty(yp) && isempty(ypp))
      m = 0;
   elseif (isempty(yp))
      m = 1;
   elseif (isempty(ypp))
      m = 2;
   else
      m = -1;
   end
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
      fprintf('??? Bad x input to qhermite ==> x values must be distinct\n');
      yi(i) = NaN;
      ypi(i) = NaN;
      yppi(i) = NaN;
      continue;
   end

   if (m == -1)
      a = yp(klo);
      b = yp(khi);
      c = ypp(klo);
      d = ypp(khi);
   elseif (v == 0)
      % Finite difference
      a = yp(klo);
      b = yp(khi);
      c = ypp(klo);
      d = ypp(khi);
   elseif (m == 0)
      if (klo == 1)
         a = (y(khi) - y(klo))/h;
         b = (y(khi+1) - y(klo))/(x(khi+1) - x(klo));
         c = ((y(khi+1) - y(khi))/(x(khi+1) - x(khi)) - (y(khi) - y(klo))/h)/...
             (x(khi+1) - x(klo));
         d = 2*(y(khi+1) - 2*y(khi) + y(klo) - (x(khi+1) - 2*x(khi) + x(klo))*b)/...
             ((x(khi+1) - x(khi))*(x(khi+1) - x(khi)) + h*h);
      elseif (khi == n)
         a = (y(khi) - y(klo-1))/(x(khi) - x(klo-1));
         b = (y(khi) - y(klo))/h;
         c = 2*(y(khi) - 2*y(klo) + y(klo-1) - (x(khi) - 2*x(klo) + x(klo-1))*a)/...
             (h*h + (x(klo) - x(klo-1))*(x(klo) - x(klo-1)));
         d = ((y(khi) - y(klo))/h - (y(klo) - y(klo-1))/(x(klo) - x(klo-1)))/...
             (x(khi) - x(klo-1));
      else
         a = (y(khi) - y(klo-1))/(x(khi) - x(klo-1));
         b = (y(khi+1) - y(klo))/(x(khi+1) - x(klo));
         c = 2*(y(khi) - 2*y(klo) + y(klo-1) - (x(khi) - 2*x(klo) + x(klo-1))*a)/...
             (h*h + (x(klo) - x(klo-1))*(x(klo) - x(klo-1)));
         d = 2*(y(khi+1) - 2*y(khi) + y(klo) - (x(khi+1) - 2*x(khi) + x(klo))*b)/...
             ((x(khi+1) - x(khi))*(x(khi+1) - x(khi)) + h*h);
      end
   elseif (m == 1)
      c = ypp(klo);
      d = ypp(khi);
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
      a = yp(klo);
      b = yp(khi);
      if (klo == 1)
         c = ((y(khi+1) - y(khi))/(x(khi+1) - x(khi)) - (y(khi) - y(klo))/h)/...
             (x(khi+1) - x(klo));
         d = 2*(y(khi+1) - 2*y(khi) + y(klo) - (x(khi+1) - 2*x(khi) + x(klo))*b)/...
             ((x(khi+1) - x(khi))*(x(khi+1) - x(khi)) + h*h);
      elseif (khi == n)
         c = 2*(y(khi) - 2*y(klo) + y(klo-1) - (x(khi) - 2*x(klo) + x(klo-1))*a)/...
             (h*h + (x(klo) - x(klo-1))*(x(klo) - x(klo-1)));
         d = ((y(khi) - y(klo))/h - (y(klo) - y(klo-1))/(x(klo) - x(klo-1)))/...
             (x(khi) - x(klo-1));
      else
         c = 2*(y(khi) - 2*y(klo) + y(klo-1) - (x(khi) - 2*x(klo) + x(klo-1))*a)/...
             (h*h + (x(klo) - x(klo-1))*(x(klo) - x(klo-1)));
         d = 2*(y(khi+1) - 2*y(khi) + y(klo) - (x(khi+1) - 2*x(khi) + x(klo))*b)/...
             ((x(khi+1) - x(khi))*(x(khi+1) - x(khi)) + h*h);
      end
   end

   % Evaluate quintic Hermite polynomial
   t = (xi(i) - x(klo))/h;
   t2 = t*t;
   t3 = t2*t;
   t4 = t3*t;
   t5 = t4*t;
   h2 = h*h;
   z0 = -6*t5 + 15*t4 - 10*t3 + 1;
   z1 = -3*t5 + 8*t4 - 6*t3 + t;
   z2 = 0.5*(-t5 + 3*t4 - 3*t3 + t2);
   z3 = 1 - z0;
   z4 = -3*t5 + 7*t4 - 4*t3;
   z5 = 0.5*(t5 - 2*t4 + t3);

   yi(i) = z0*y(klo) + z1*h*a + z2*h2*c + z3*y(khi) + z4*h*b + z5*h2*d;
   
   % Differentiate to find the fourth-order interpolant
   z0 = -30*t4 + 60*t3 - 30*t2;
   z1 = -15*t4 + 32*t3 - 18*t2 + 1;
   z2 = 0.5*(-5*t4 + 12*t3 - 9*t2 + 2*t);
   z3 = -z0;
   z4 = -15*t4 + 28*t3 - 12*t2;
   z5 = 0.5*(5*t4 - 8*t3 + 3*t2);
   
   ypi(i) = z0*y(klo)/h + z1*a + z2*h*c + z3*y(khi)/h + z4*b + z5*h*d;
   
   % Differentiate to find the third-order interpolant
   z0 = -120*t3 + 180*t2 - 60*t;
   z1 = -60*t3 + 96*t2 - 36*t;
   z2 = 0.5*(-20*t3 + 36*t2 - 18*t + 2);
   z3 = -z0;
   z4 = -60*t3 + 84*t2 - 24*t;
   z5 = 0.5*(20*t3 - 24*t2 + 6*t);
   
   yppi(i) = z0*y(klo)/h2 + z1*a/h + z2*c + z3*y(khi)/h2 + z4*b/h + z5*d;
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
