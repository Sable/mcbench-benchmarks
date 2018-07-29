function [yi, ypi] = sincint(x, y, xi, c, win)

% SINCINT 1-D piecewise sinc interpolation
%    SINCINT(X,Y,XI,C,WIN) interpolates to find YI, the values of the
%    underlying function Y at the points in the array XI, using
%    piecewise sinc interpolation.  X and Y must be vectors 
%    of length N.
%
%    C specifies the number of data points to use in the
%    interpolation.  The default is to use all points.
%
%    If WIN is nonzero, a window is applied to the sinc interpolator.
%    Possible windows are:
%        0 : Rectangular window (default)
%        1 : Lanczos window
%        2 : Hamming window
%        3 : Squared cosine window
%        4 : Kaiser window (alpha = 3)
%        5 : Blackman window
%
%    [YI,YPI] = SINCINT() also returns the interpolated derivative
%    of the underlying function Y at points XI.

% Joe Henning - Fall 2011

if (nargin < 4)
   c = 0;
   win = 0;
elseif (nargin < 5)
   win = 0;
end

n = length(x);

if (n < c)
   fprintf('??? Bad c input to sincint ==> c <= length(x)\n');
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
      fprintf('??? Bad x input to sincint ==> x values must be distinct\n');
      yi(i) = NaN;
      ypi(i) = NaN;
      continue;
   end

   % Evaluate sinc
   yi(i) = 0;
   ypi(i) = 0;
   if (c == 0)
      for k = 1:n
         if ((1/T)*abs(xi(i)-x(k)) > (n-1)/2 && win > 0)
            w = 0;
            wp = 0;
         else
            if (win == 5)
               alpha = 0.16;
               a0 = (1-alpha)/2.0;
               a1 = 1/2.0;
               a2 = alpha/2.0;
               w = a0 + a1*cos(2*pi*(1/T)*(xi(i)-x(k))/(n-1)) + a2*cos(4*pi*(1/T)*(xi(i)-x(k))/(n-1));
               wp = -a1*2*pi*(1/T)*sin(2*pi*(1/T)*(xi(i)-x(k))/(n-1))/(n-1) - a2*4*pi*(1/T)*sin(4*pi*(1/T)*(xi(i)-x(k))/(n-1))/(n-1);
            elseif (win == 4)
               alpha = 3.0;
               arg1 = pi*alpha;
               arg2 = arg1*sqrt(1 - (2*(1/T)*(xi(i)-x(k))/(n-1))*(2*(1/T)*(xi(i)-x(k))/(n-1)));
               w = besseli(0,arg2)/besseli(0,arg1);
               wp = (besseli(0,arg1)*besseli(1,arg2) - besseli(1,arg1)*besseli(0,arg2))/(besseli(0,arg1)*besseli(0,arg1));
               w = real(w);
               wp = real(wp);
            elseif (win == 3)
               w = cos(pi*(1/T)*(xi(i)-x(k))/(n-1)) * cos(pi*(1/T)*(xi(i)-x(k))/(n-1));
               wp = -2*sin(pi*(1/T)*(xi(i)-x(k))/(n-1)) * cos(pi*(1/T)*(xi(i)-x(k))/(n-1)) * pi*(1/T)/(n-1);
            elseif (win == 2)
               w = 0.54 + 0.46*cos(2*pi*(1/T)*(xi(i)-x(k))/(n-1));
               wp = -0.46*2*pi*(1/T)*sin(2*pi*(1/T)*(xi(i)-x(k))/(n-1))/(n-1);
            elseif (win == 1)
               w = sinc(2*(1/T)*(xi(i)-x(k))/(n-1));
               wp = 2*(1/T)*cosc(2*(1/T)*(xi(i)-x(k))/(n-1))/(n-1);
            else
               w = 1;
               wp = 0;
            end
         end
         yi(i) = yi(i) + y(k)*sinc((1/T)*(xi(i)-x(k)))*w;
         ypi(i) = ypi(i) + y(k)*(wp*sinc((1/T)*(xi(i)-x(k))) + w*(1/T)*cosc((1/T)*(xi(i)-x(k))));
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
            if ((1/T)*abs(xi(i)-x(k)) > (n-1)/2 && win > 0)
               w = 0;
               wp = 0;
            else
               if (win == 5)
                  alpha = 0.16;
                  a0 = (1-alpha)/2.0;
                  a1 = 1/2.0;
                  a2 = alpha/2.0;
                  w = a0 + a1*cos(2*pi*(1/T)*(xi(i)-x(k))/(n-1)) + a2*cos(4*pi*(1/T)*(xi(i)-x(k))/(n-1));
                  wp = -a1*2*pi*(1/T)*sin(2*pi*(1/T)*(xi(i)-x(k))/(n-1))/(n-1) - a2*4*pi*(1/T)*sin(4*pi*(1/T)*(xi(i)-x(k))/(n-1))/(n-1);
               elseif (win == 4)
                  alpha = 3.0;
                  arg1 = pi*alpha;
                  arg2 = arg1*sqrt(1 - (2*(1/T)*(xi(i)-x(k))/(c-1))*(2*(1/T)*(xi(i)-x(k))/(c-1)));
                  w = besseli(0,arg2)/besseli(0,arg1);
                  wp = (besseli(0,arg1)*besseli(1,arg2) - besseli(1,arg1)*besseli(0,arg2))/(besseli(0,arg1)*besseli(0,arg1));
                  w = real(w);
                  wp = real(wp);
               elseif (win == 3)
                  w = cos(pi*(1/T)*(xi(i)-x(k))/(c-1)) * cos(pi*(1/T)*(xi(i)-x(k))/(c-1));
                  wp = -2*sin(pi*(1/T)*(xi(i)-x(k))/(c-1)) * cos(pi*(1/T)*(xi(i)-x(k))/(c-1)) * pi*(1/T)/(c-1);
               elseif (win == 2)
                  w = 0.54 + 0.46*cos(2*pi*(1/T)*(xi(i)-x(k))/(c-1));
                  wp = -0.46*2*pi*(1/T)*sin(2*pi*(1/T)*(xi(i)-x(k))/(c-1))/(c-1);
               elseif (win == 1)
                  w = sinc(2*(1/T)*(xi(i)-x(k))/(c-1));
                  wp = 2*(1/T)*cosc(2*(1/T)*(xi(i)-x(k))/(c-1))/(c-1);
               else
                  w = 1;
                  wp = 0;
               end
            end
            yi(i) = yi(i) + y(k)*sinc((1/T)*(xi(i)-x(k)))*w;
            ypi(i) = ypi(i) + y(k)*(wp*sinc((1/T)*(xi(i)-x(k))) + w*(1/T)*cosc((1/T)*(xi(i)-x(k))));
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
            if ((1/T)*abs(xi(i)-x(k)) > (n-1)/2 && win > 0)
               w = 0;
               wp = 0;
            else
               if (win == 5)
                  alpha = 0.16;
                  a0 = (1-alpha)/2.0;
                  a1 = 1/2.0;
                  a2 = alpha/2.0;
                  w = a0 + a1*cos(2*pi*(1/T)*(xi(i)-x(k))/(n-1)) + a2*cos(4*pi*(1/T)*(xi(i)-x(k))/(n-1));
                  wp = -a1*2*pi*(1/T)*sin(2*pi*(1/T)*(xi(i)-x(k))/(n-1))/(n-1) - a2*4*pi*(1/T)*sin(4*pi*(1/T)*(xi(i)-x(k))/(n-1))/(n-1);
               elseif (win == 4)
                  alpha = 3.0;
                  arg1 = pi*alpha;
                  arg2 = arg1*sqrt(1 - (2*(1/T)*(xi(i)-x(k))/(c-1))*(2*(1/T)*(xi(i)-x(k))/(c-1)));
                  w = besseli(0,arg2)/besseli(0,arg1);
                  wp = (besseli(0,arg1)*besseli(1,arg2) - besseli(1,arg1)*besseli(0,arg2))/(besseli(0,arg1)*besseli(0,arg1));
                  w = real(w);
                  wp = real(wp);
               elseif (win == 3)
                  w = cos(pi*(1/T)*(xi(i)-x(k))/(c-1)) * cos(pi*(1/T)*(xi(i)-x(k))/(c-1));
                  wp = -2*sin(pi*(1/T)*(xi(i)-x(k))/(c-1)) * cos(pi*(1/T)*(xi(i)-x(k))/(c-1)) * pi*(1/T)/(c-1);
               elseif (win == 2)
                  w = 0.54 + 0.46*cos(2*pi*(1/T)*(xi(i)-x(k))/(c-1));
                  wp = -0.46*2*pi*(1/T)*sin(2*pi*(1/T)*(xi(i)-x(k))/(c-1))/(c-1);
               elseif (win == 1)
                  w = sinc(2*(1/T)*(xi(i)-x(k))/(c-1));
                  wp = 2*(1/T)*cosc(2*(1/T)*(xi(i)-x(k))/(c-1))/(c-1);
               else
                  w = 1;
                  wp = 0;
               end
            end
            yi(i) = yi(i) + y(k)*sinc((1/T)*(xi(i)-x(k)))*w;
            ypi(i) = ypi(i) + y(k)*(wp*sinc((1/T)*(xi(i)-x(k))) + w*(1/T)*cosc((1/T)*(xi(i)-x(k))));
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

function y = zonk(x)
% second derivative of normalized sinc function
i = find(x == 0);
x(i) = 1;   % Don't need this if divide-by-zero warning is off
%y = (-2*pi^4*x.*x.*cos(pi*x) - pi^5*x.^3.*sin(pi*x) + 2*pi^3*x.*sin(pi*x))./(pi^4*x.^4);
y = -2*cos(pi*x)./(x.*x) - pi*sin(pi*x)./x + 2*sin(pi*x)./(pi*x.*x.*x);
y(i) = -pi*pi/3.0;
