function [yi, ypi] = hermint(x, y, yp, xi, c)

% HERMINT 1-D piecewise hermite interpolation
%    HERMINT(X,Y,YP,XI,C) interpolates to find YI, the values of
%    the underlying function Y at the points in the array XI,
%    using piecewise hermite interpolation.  X and Y must be
%    vectors of length N.
%
%    C specifies the number of data points to use in the
%    interpolation.  The default is to use all points.
%
%    [YI,YPI] = HERMINT() also returns the interpolated derivative
%    of the underlying function Y at points XI.

% Joe Henning - Fall 2011

if (nargin < 5)
   c = 0;
end

n = length(x);

if (n < c)
   fprintf('??? Bad c input to hermint ==> c <= length(x)\n');
   yi = [];
   ypi = [];
   return
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
      fprintf('??? Bad x input to hermint ==> x values must be distinct\n');
      yi(i) = NaN;
      ypi(i) = NaN;
      continue;
   end
   
   isiny = 0;
   for k = 1:n
      if (xi(i) == x(k))
         yi(i) = y(k);
         ypi(i) = yp(k);
         isiny = 1;
         break
      end
   end
   
   if (isiny)
      continue
   end

   % Evaluate hermite polynomial
   yi(i) = 0;
   ypi(i) = 0;
   if (c == 0)
      for k = 1:n
         f = 0;
         g = 0;
         h = 1;
         
         for m = 1:n
            if (k ~= m)
               f = f + 1/(x(k)-x(m));
               h = h*(xi(i)-x(m))/(x(k)-x(m));
            end
         end
         
         for m = 1:n
            if (k ~= m)
               g = g + h/(xi(i)-x(m));
            end
         end
         
         a = h*h;
         b = 2*h*g;
         u = xi(i) - x(k);
         
         b1 = a*u;
         b2 = b*u + a;
         a1 = a - 2*f*b1;
         a2 = b - 2*f*b2;
         
         yi(i) = yi(i) + a1*y(k) + b1*yp(k);
         ypi(i) = ypi(i) + a2*y(k) + b2*yp(k);
      end
   else
      if (mod(c,2) == 0)   % even
         c2 = c/2;
         if (klo < c2)
            klo = c2;
         end
         if (klo > n-c2)
            klo = n-c2;
         end
         khi = klo + 1;
         for k = klo-(c2-1):klo+c2
            f = 0;
            g = 0;
            h = 1;
         
            for m = klo-(c2-1):klo+c2
               if (k ~= m)
                  f = f + 1/(x(k)-x(m));
                  h = h*(xi(i)-x(m))/(x(k)-x(m));
               end
            end
         
            for m = klo-(c2-1):klo+c2
               if (k ~= m)
                  g = g + h/(xi(i)-x(m));
               end
            end
         
            a = h*h;
            b = 2*h*g;
            u = xi(i) - x(k);
         
            b1 = a*u;
            b2 = b*u + a;
            a1 = a - 2*f*b1;
            a2 = b - 2*f*b2;
         
            yi(i) = yi(i) + a1*y(k) + b1*yp(k);
            ypi(i) = ypi(i) + a2*y(k) + b2*yp(k);
         end
      else   % odd
         c2 = floor(c/2);
         if (klo < c2+1)
            klo = c2+1;
         end
         if (klo > n-c2)
            klo = n-c2;
         end
         khi = klo + 1;
         for k = klo-c2:klo+c2
            f = 0;
            g = 0;
            h = 1;
         
            for m = klo-c2:klo+c2
               if (k ~= m)
                  f = f + 1/(x(k)-x(m));
                  h = h*(xi(i)-x(m))/(x(k)-x(m));
               end
            end
         
            for m = klo-c2:klo+c2
               if (k ~= m)
                  g = g + h/(xi(i)-x(m));
               end
            end
         
            a = h*h;
            b = 2*h*g;
            u = xi(i) - x(k);
         
            b1 = a*u;
            b2 = b*u + a;
            a1 = a - 2*f*b1;
            a2 = b - 2*f*b2;
         
            yi(i) = yi(i) + a1*y(k) + b1*yp(k);
            ypi(i) = ypi(i) + a2*y(k) + b2*yp(k);
         end
      end
   end
end
