function [yi, ypi] = sincdint(x, y, xi, c)

% SINCDINT 1-D piecewise discrete sinc interpolation
%    SINCDINT(X,Y,XI,C) interpolates to find YI, the values of the
%    underlying function Y at the points in the array XI, using
%    piecewise discrete sinc interpolation.  X and Y must be vectors 
%    of length N.
%
%    C specifies the amount of signal mirroring.  It can be:
%       0 : No mirroring (default)
%       1 : Forward mirroring
%       2 : Backward and forward mirroring
%
%    [YI,YPI] = SINCDINT() also returns the interpolated derivative
%    of the underlying function Y at points XI.
%
%    See also interpft.

% 
% Joe Henning - Fall 2011

if (nargin < 4)
   c = 0;
end

n = length(x);

% Find the period of the undersampled signal
T = x(2) - x(1);

if (c == 1)
   temp_x = x;
   for k = 1:n-1
      temp_x = [temp_x x(n)+T*k];
   end
   temp_y = [y fliplr(y(1:length(y)-1))];
   x = temp_x;
   y = temp_y;
   n = length(x);
elseif (c == 2)
   temp_x = [];
   for k = 1:n-1
      temp_x = [temp_x x(1)-T*(n-k)];
   end
   temp_x = [temp_x x];
   for k = 1:n-1
      temp_x = [temp_x x(n)+T*k];
   end
   temp_y = [fliplr(y(2:length(y))) y fliplr(y(1:length(y)-1))];
   x = temp_x;
   y = temp_y;
   n = length(x);
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
      fprintf('??? Bad x input to sincdint ==> x values must be distinct\n');
      yi(i) = NaN;
      ypi(i) = NaN;
      continue;
   end

   % Evaluate discrete sinc
   yi(i) = 0;
   ypi(i) = 0;
   for k = 1:n
      yi(i) = yi(i) + y(k)*sincd((1/T)*(xi(i)-x(k)),n);
      ypi(i) = ypi(i) + y(k)*(sincd((1/T)*(xi(i)-x(k)),n) + (1/T)*coscd((1/T)*(xi(i)-x(k)),n));
   end
end

function y = sincd(x,n)
% normalized discrete sinc function
i = find(x == 0);
x(i) = 1;   % Don't need this if divide-by-zero warning is off
if (rem(n,2) == 0)
   y = (sin(pi*(n+1)*x/n)./(n*sin(pi*x/n)) + sin(pi*(n-1)*x/n)./(n*sin(pi*x/n)))/2.0;
else
   y = sin(pi*x)./(n*sin(pi*x/n));
end
y(i) = 1;

function y = coscd(x,n)
% derivative of normalized discrete sinc function
i = find(x == 0);
x(i) = 1;   % Don't need this if divide-by-zero warning is off
if (rem(n,2) == 0)
   y = (sin(pi*x/n).*(cos(pi*(n+1)*x/n)*pi*(n+1) + cos(pi*(n-1)*x/n)*pi*(n-1)) - cos(pi*x/n)*pi*(sin(pi*(n+1)*x/n) + sin(pi*(n-1)*x/n)))./(2*n*n*sin(pi*x/n).*sin(pi*x/n));
else
   y = (pi*n*cos(pi*x).*sin(pi*x/n) - pi*sin(pi*x).*cos(pi*x/n))./(n*n*sin(pi*x/n).*sin(pi*x/n));
end
y(i) = 0;
