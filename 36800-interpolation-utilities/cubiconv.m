function [yi, ypi, yppi] = cubiconv(x, y, xi)

% CUBICONV Cubic convolution interpolation
%    CUBICONV(X,Y,XI) interpolates to find YI, the value of
%    the underlying function Y at the points in the uniform array
%    XI, using cubic convolution interpolation.  X and Y must be
%    vectors of length N.
%
%    [YI,YPI,YPPI] = CUBICONV() also returns the interpolated
%    quartic derivative and cubic second derivative of the underlying
%    function Y at points XI.

% Joe Henning - Fall 2011

% Cubic Convolution Interpolation for Digital Image Processing
% Robert G. Keys
% IEEE Transactions on Acoustics, Speech, and Signal Processing, Vol. ASSP-29, No. 6
% December, 1981

n = length(x);
%h = (x(n) - x(1))/n;

for i = 1:length(xi)
   if (xi(i) < x(1) || xi(i) > x(n))
      fprintf('??? Bad x input to cubiconv ==> x(1) <= x <= x(n)\n');
      yi(i) = NaN;
      continue;
   end

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
      fprintf('??? Bad x input to cubiconv ==> x values must be distinct\n');
      yi(i) = NaN;
      ypi(i) = NaN;
      yppi(i) = NaN;
      continue;
   end

   km1 = klo - 1;
   kp1 = khi + 1;
   if (km1 < 1)
      a = 3*y(klo) - 3*y(khi) + y(khi+1);
   else
      a = y(km1);
   end
   if (kp1 > n)
      d = 3*y(khi) - 3*y(klo) + y(klo-1);
   else
      d = y(kp1);
   end
   b = y(klo);
   c = y(khi);

   % Evaluate cubic polynomial
   t = (xi(i) - x(klo))/h;
   t2 = t*t;
   t3 = t2*t;
   h2 = h*h;
   c00 = (-t3 + 2*t2 - t)/2.0;
   c10 = (3*t3 - 5*t2 + 2)/2.0;
   c20 = (-3*t3 + 4*t2 + t)/2.0;
   c30 = (t3 - t2)/2.0;

   yi(i) = a*c00 + b*c10 + c*c20 + d*c30;

   % Differentiate to find the second-order interpolant
   c00 = (-3*t2 + 4*t - 1)/2.0;
   c10 = (9*t2 - 10*t)/2.0;
   c20 = (-9*t2 + 8*t + 1)/2.0;
   c30 = (3*t2 - 2*t)/2.0;

   ypi(i) = a*c00/h + b*c10/h + c*c20/h + d*c30/h;

   % Differentiate to find the first-order interpolant
   c00 = (-6*t + 4)/2.0;
   c10 = (18*t - 10)/2.0;
   c20 = (-18*t + 8)/2.0;
   c30 = (6*t - 2)/2.0;

   yppi(i) = a*c00/h2 + b*c10/h2 + c*c20/h2 + d*c30/h2;
end
