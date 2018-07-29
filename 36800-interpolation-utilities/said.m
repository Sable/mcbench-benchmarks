function [yi, ypi] = said(x, y, xi, chi, eta, c)

% SAID 1-D piecewise Said interpolation
%    SAID(X,Y,XI,CHI,ETA,C) interpolates to find YI, the values of the
%    underlying function Y at the points in the array XI, using
%    piecewise Said interpolation.  X and Y must be vectors 
%    of length N.
%
%    C specifies the number of data points to use in the
%    interpolation.  The default is to use all points.
%
%    CHI and ETA specify functional parameters.  Parameters to finely
%    approximate popular interpolation kernels are:
%        Kernel                         chi      eta
%        ------                         -----    ----
%        Sinc                           -        0
%        Lanczos, M=2                   0.414    0.61
%        Lanczos, M=3                   0.284    0.64
%        Lanczos, M=4                   0.212    0.65
%        Lanczos, M=5                   0.170    0.65
%        Blackman-Harris, N=6           0.411    0.23
%        Cubic B-Spline                 0.310    0
%        Mitchell-Netravali, B=C=1/3    0.550    0.32

% Joe Henning - Fall 2012

% New Filters for Image Interpolation and Resizing
% Amir Said
% Media Technologies Laboratory
% HP Laboratories Palo Alto
% HPL-2007-179
% November 2, 2007

if (nargin < 6)
   c = 0;
end

n = length(x);

if (n < c)
   fprintf('??? Bad c input to said ==> c <= length(x)\n');
   yi = [];
   ypi = [];
   return
end

% Find the period of the undersampled signal
T = x(2) - x(1);

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
      fprintf('??? Bad x input to said ==> x values must be distinct\n');
      yi(i) = NaN;
      ypi(i) = NaN;
      continue;
   end

   % Evaluate Said function
   yi(i) = 0;
   ypi(i) = 0;
   if (c == 0)
      for k = 1:n
         t = xi(i)-x(k);
         a = sqrt(2*eta)*pi*chi/T/(2-eta);
         b = pi*chi/T/(2-eta);
         yi(i) = yi(i) + y(k)*sinc(t/T)*cosh(a*t)*exp(-b*t*b*t);
         ypi(i) = ypi(i) + y(k)*(cosc(t/T)/T*cosh(a*t)*exp(-b*t*b*t) + ...
                  sinc(t/T)*(sinh(a*t)*a*exp(-b*t*b*t) - 2*b*t*b*cosh(a*t)*exp(-b*t*b*t)));
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
            t = xi(i)-x(k);
            a = sqrt(2*eta)*pi*chi/T/(2-eta);
            b = pi*chi/T/(2-eta);
            yi(i) = yi(i) + y(k)*sinc(t/T)*cosh(a*t)*exp(-b*t*b*t);
            ypi(i) = ypi(i) + y(k)*(cosc(t/T)/T*cosh(a*t)*exp(-b*t*b*t) + ...
                     sinc(t/T)*(sinh(a*t)*a*exp(-b*t*b*t) - 2*b*t*b*cosh(a*t)*exp(-b*t*b*t)));
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
            t = xi(i)-x(k);
            a = sqrt(2*eta)*pi*chi/T/(2-eta);
            b = pi*chi/T/(2-eta);
            yi(i) = yi(i) + y(k)*sinc(t/T)*cosh(a*t)*exp(-b*t*b*t);
            ypi(i) = ypi(i) + y(k)*(cosc(t/T)/T*cosh(a*t)*exp(-b*t*b*t) + ...
                     sinc(t/T)*(sinh(a*t)*a*exp(-b*t*b*t) - 2*b*t*b*cosh(a*t)*exp(-b*t*b*t)));
         end
      end
   end
end

function y = sinc(x)
% normalized sinc function
i = find(x == 0);
x(i) = 1;   % Don't need this if divide-by-zero warning is off
y = sin(pi*x)./(pi*x);
y(i) = 1;

function y = cosc(x)
% derivative of normalized sinc function
i = find(x == 0);
x(i) = 1;   % Don't need this if divide-by-zero warning is off
%y = (pi*pi*x.*cos(pi*x) - pi*sin(pi*x))./(pi*x*pi.*x);
y = cos(pi*x)./x - sin(pi*x)./(pi*x.*x);
y(i) = 0;
