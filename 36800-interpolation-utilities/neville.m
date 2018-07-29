function [yi, ypi, P, D] = neville(x, y, xi)

% NEVILLE Interpolation using Neville's Method
%    NEVILLE(X,Y,XI) interpolates to find YI, the value of
%    the underlying function Y at the point XI, using Neville's
%    Method.  X and Y must be vectors of length N.
%
%    [YI,YPI] = NEVILLE() also returns the interpolated derivative
%    YPI.
%
%    [YI,YPI,P,D] = NEVILLE() also returns the polynomial table
%    P and derivative polynomial table D calculated for the last XI.

% Joe Henning - Fall 2011

% An Iterative Method of Numerical Differentiation
% D. B. Hunter

n = length(x);

for k = 1:length(xi)
   xd = [];
   for i = 1:n
      xd(i) = abs(x(i) - xi(k));
   end

   [xds,i] = sort(xd);

   x = x(i);
   y = y(i);

   P = zeros(n,n);
   P(:,1) = y(:);

   for i = 1:n-1
      for j = 1:(n-i)
         P(j,i+1) = ((xi(k)-x(j))*P(j+1,i) + (x(j+i)-xi(k))*P(j,i))/(x(j+i)-x(j));
      end
   end

   yi(k) = P(1,n);

   D = zeros(n,n);
   D(:,1) = y(:);

   for i = 1:n-1
      D(i,2) = (D(i+1,1)-D(i,1))/(x(i+1)-x(i));
   end

   for i = 2:n-1
      for j = 1:(n-i)
         D(j,i+1) = (P(j+1,i) + (xi(k)-x(j))*D(j+1,i) - P(j,i) + (x(j+i)-xi(k))*D(j,i))/(x(j+i)-x(j));
      end
   end

   ypi(k) = D(1,n);
end
