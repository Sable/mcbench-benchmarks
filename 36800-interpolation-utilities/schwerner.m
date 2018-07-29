function [yi, u, ypi, yppi] = schwerner(x, y, xi, p, q)

% SCHWERNER Rational interpolation using the Schneider-Werner Method
%    SCHWERNER(X,Y,XI,P,Q) interpolates to find YI, the values of the
%    underlying function Y at the points in the array XI, using
%    the Schneider Werner method and the second form (or true form)
%    of the barycentric interpolation formula.  X and Y must be
%    vectors of length N.
%
%    P and Q specify the degrees of the numerator and denominator
%    of the rational function.  P <= Q and P+Q=N-1.  If not specified,
%    values for P and Q are calculated.
%
%    [YI,U] = SCHWERNER() also returns the barycentric interpolation
%    weights U.
%
%    [YI,U,YPI,YPPI] = SCHWERNER() also returns the interpolated
%    derivative YPI and the interpolated second derivative YPPI.

% Joe Henning - Fall 2011

% Recent developments in barycentric rational interpolation
% Jean-Paul Berrut, Richard Baltensperger and Hans D. Mittelmann
% Trends and Applications in Constructive Approximation
% International Series of Numerical Mathematics Vol. 1??
% 2005 Birkhauser Verlag Basel (ISBN 3-7643-7124-2)

x = x(:).';
y = y(:).';
n = length(x);

if (nargin < 4)
   p = floor((n-1)/2.0);
   q = ceil((n-1)/2.0);
elseif (nargin < 5)
   q = (n-1) - p;
end

if (p > q)
   fprintf('??? Bad p, q input to schwerner ==> p <= q\n');
   yi = [];
   u = [];
   ypi = [];
   yppi = [];
   return
end

if ((p+q) ~= (n-1))
   fprintf('??? Bad p, q input to schwerner ==> p+q=n-1\n');
   yi = [];
   u = [];
   ypi = [];
   yppi = [];
   return
end

if (p < 0)
   fprintf('??? Bad p input to schwerner ==> p>=0\n');
   yi = [];
   u = [];
   ypi = [];
   yppi = [];
   return
end

% construct A
A = ones(1,n);
for i = 1:p-1
   A = [A; x.^i];
end
A = [A; y];
for i = 1:q-1
   A = [A; y.*x.^i];
end

% calculate the kernel of A
%u = null(A);
u = kernel(A);

% check the dimension of the kernel
if (size(u,2) > 1)
   fprintf('The kernel of A is a dimension larger than 1; recalling with p=%d-1=%d\n',p,p-1);
   [yi, u, ypi, yppi] = schwerner(x, y, xi, p-1);
   return
end
   
% remove unattainable points
[N,M] = size(u);
tol = reshape(eps*max([ones(size(u(:))) abs(u(:))],[],2),N,M);
i = find(abs(u) < tol);
if ~isempty(i)
   for k = 1:length(i)
      fprintf('(%f,%f) is an unattainable point; it will be eliminated\n',x(i(k)),y(i(k)));
   end
   k = find(abs(u) >= tol);
   [yi, u, ypi, yppi] = schwerner(x(k), y(k), xi);
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
      fprintf('??? Bad x input to schwerner ==> x values must be distinct\n');
      yi(i) = NaN;
      ypi(i) = NaN;
      yppi(i) = NaN;
      continue;
   end

   isiny = 0;
   for k = 1:n
      if (xi(i) == x(k))
         yi(i) = y(k);
         num = 0;
         for j = 1:n
            if (j ~= k)
               num = num + u(j)*(y(k)/(x(k)-x(j)) + y(j)/(x(j)-x(k)));
            end
         end
         ypi(i) = -num/u(k);
         num = 0;
         for j = 1:n
            if (j ~= k)
               num = num + u(j)*(ypi(i)-(y(k)/(x(k)-x(j)) + y(j)/(x(j)-x(k))))/(x(k)-x(j));
            end
         end
         yppi(i) = -2*num/u(k);
         isiny = 1;
         break
      end
   end

   if (isiny)
      continue
   end

   % Evaluate polynomial
   num = 0;
   den = 0;
   for k = 1:n
      num = num + y(k)*u(k)/(xi(i)-x(k));
      den = den + u(k)/(xi(i)-x(k));
   end
   yi(i) = num/den;

   num = 0;
   den = 0;
   for k = 1:n
      term = yi(i)/(xi(i)-x(k)) + y(k)/(x(k)-xi(i));
      num = num + term*u(k)/(xi(i)-x(k));
      den = den + u(k)/(xi(i)-x(k));
   end
   ypi(i) = num/den;

   num = 0;
   den = 0;
   for k = 1:n
      term = (ypi(i)-(yi(i)/(xi(i)-x(k)) + y(k)/(x(k)-xi(i))))/(xi(i)-x(k));
      num = num + term*u(k)/(xi(i)-x(k));
      den = den + u(k)/(xi(i)-x(k));
   end
   yppi(i) = 2*num/den;
end


function Y = kernel(X)
% Calculate the kernel or null space of matrix X
[m,n] = size(X);
[U,S,V] = svd(X);
s = [];
for i = 1:m
   s = [s; S(i,i)];
end
r = sum(s > eps*max([ones(size(s)) abs(s)],[],2));
Y = V(:,r+1:n);
