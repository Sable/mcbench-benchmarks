function [yi, ypi, yppi] = shermite(x, y, yp, ypp, yppp, xi)

% SHERMITE 1-D piecewise septic Hermite spline
%    SHERMITE(X,Y,YP,YPP,YPPP,XI) interpolates to find YI, the values of
%    the underlying function Y at the points in the array XI, using
%    piecewise septic Hermite splines.  X and Y must be vectors
%    of length N.
%
%    First, second, and third differences are calculated in a finite
%    difference fashion when YP, YPP, and YPPP are not specified.
%
%    [YI,YPI,YPPI] = SHERMITE() also returns the interpolated
%    septic derivative and quintic second derivative of the underlying
%    function Y at points XI.

% Joe Henning - Fall 2012

if (isempty(yp) && isempty(ypp) & isempty(yppp))
   yp = lfindiff (x, y);
   ypp = lfindiff (x, yp);
   yppp = lfindiff (x, ypp);
elseif (isempty(yp) && isempty(ypp))
   yp = lfindiff (x, y);
   ypp = lfindiff (x, yp);
elseif (isempty(yp) && isempty(yppp))
   yp = lfindiff (x, y);
   yppp = lfindiff (x, ypp);
elseif (isempty(yp))
   yp = lfindiff (x, y);
elseif (isempty(ypp) && isempty(yppp))
   ypp = lfindiff (x, yp);
   yppp = lfindiff (x, ypp);
elseif (isempty(ypp))
   ypp = lfindiff (x, yp);
elseif (isempty(yppp))
   yppp = lfindiff (x, ypp);
else
   m = -1;
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
      fprintf('??? Bad x input to shermite ==> x values must be distinct\n');
      yi(i) = NaN;
      ypi(i) = NaN;
      yppi(i) = NaN;
      continue;
   end
   
   a = yp(klo);
   b = yp(khi);
   c = ypp(klo);
   d = ypp(khi);
   e = yppp(klo);
   f = yppp(khi);

   % Evaluate septic Hermite polynomial
   t = (xi(i) - x(klo))/h;
   t2 = t*t;
   t3 = t2*t;
   t4 = t3*t;
   t5 = t4*t;
   t6 = t5*t;
   t7 = t6*t;
   h2 = h*h;
   h3 = h2*h;
   z0 = 20*t7 - 70*t6 + 84*t5 - 35*t4 + 1;
   z1 = 10*t7 - 36*t6 + 45*t5 - 20*t4 + t;
   z2 = 2*t7 - 7.5*t6 + 10*t5 - 5*t4 + 1/2*t2;
   z3 = 1/6*t7 - 2/3*t6 + t5 - 2/3*t4 + 1/6*t3;
   z4 = 1 - z0;
   z5 = 10*t7 - 34*t6 + 39*t5 - 15*t4;
   z6 = -2*t7 + 6.5*t6 - 7*t5 + 2.5*t4;
   z7 = 1/6*t7 - 1/2*t6 + 1/2*t5 - 1/6*t4;

   yi(i) = z0*y(klo) + z1*h*a + z2*h2*c + z3*h3*e + z4*y(khi) + z5*h*b + z6*h2*d + z7*h3*f;

   % Differentiate to find the sixth-order interpolant
   z0 = 140*t6 - 420*t5 + 420*t4 - 140*t3;
   z1 = 70*t6 - 216*t5 + 225*t4 - 80*t3 + 1;
   z2 = 14*t6 - 45*t5 + 50*t4 - 20*t3 + t;
   z3 = 7/6*t6 - 4*t5 + 5*t4 - 8/3*t3 + 1/2*t2;
   z4 = -z0;
   z5 = 70*t6 - 204*t5 + 195*t4 - 60*t3;
   z6 = -14*t6 + 39*t5 - 35*t4 + 10*t3;
   z7 = 7/6*t6 - 3*t5 + 5/2*t4 - 2/3*t3;

   ypi(i) = z0*y(klo)/h + z1*a + z2*h*c + z3*h2*e + z4*y(khi)/h + z5*b + z6*h*d + z7*h2*f;

   % Differentiate to find the fifth-order interpolant
   z0 = 840*t5 - 2100*t4 + 1680*t3 - 420*t2;
   z1 = 420*t5 - 1080*t4 + 900*t3 - 240*t2;
   z2 = 84*t5 - 225*t4 + 200*t3 - 60*t2 + 1;
   z3 = 7*t5 - 20*t4 + 20*t3 - 8*t2 + t;
   z4 = -z0;
   z5 = 420*t5 - 1020*t4 + 780*t3 - 180*t2;
   z6 = -84*t5 + 195*t4 - 140*t3 + 30*t2;
   z7 = 7*t5 - 15*t4 + 10*t3 - 2*t2;

   yppi(i) = z0*y(klo)/h2 + z1*a/h + z2*c + z3*h*e + z4*y(khi)/h2 + z5*b/h + z6*d + z7*h*f;
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
