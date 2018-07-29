function [D, p, pval] = divdiff(x, y, yp, ypp)

% DIVDIFF Divided differences.
%    DIVDIFF(X,Y,YP,YPP) calculates divided differences.  The method
%    can be used to calculate coefficients of the Newton form of the
%    interpolation polynomial.  YP can be used to specify the first
%    derivative of Y, and YPP can be used to specify the second
%    derivative.
%
%    [YI,D,P,PVAL] = DIVDIFF() also returns D, the divided difference
%    table, P, the coefficients of the interpolation polynomial, and
%    PVAL, which specifies the maximum degree of the interpolating
%    polynomial.
%
%    See also: HERMITEDIV

% Joe Henning - Fall 2011

if (nargin < 3)
   order = 1;
   yp = [];
   ypp = [];
   pval = length(x)*(0+1) - 1;
elseif (nargin < 4)
   order = 2;
   ypp = [];
   pval = length(x)*(1+1) - 1;
else
   order = 3;
   pval = length(x)*(2+1) - 1;
end

x = reshape(repmat(x,order,1),1,length(x)*order);
y = reshape(repmat(y,order,1),1,length(y)*order);
yp = reshape(repmat(yp,order,1),1,length(yp)*order);
ypp = reshape(repmat(ypp,order,1),1,length(ypp)*order);

n = length(x)-1;
D = zeros(n+1,n+1);
D(:,1) = y(:);

tol = eps;
   
if (order == 1)
   for i = 1:n
      for j = 1:i
         D(i+1,j+1) = (D(i+1,j)-D(i,j))/(x(i+1)-x(i-j+1));
      end
   end
elseif (order == 2)
   for i = 1:n
      for j = 1:i
         h = (x(i+1)-x(i-j+1));
         if (j == 1 && h < tol*max([1 abs(x(i+1)) abs(x(i-j+1))]))
            D(i+1,j+1) = yp(i)/1;
         else
            D(i+1,j+1) = (D(i+1,j)-D(i,j))/h;
         end
      end
   end
else
   for i = 1:n
      for j = 1:i
         h = (x(i+1)-x(i-j+1));
         if (j == 1 && h < tol*max([1 abs(x(i+1)) abs(x(i-j+1))]))
            D(i+1,j+1) = yp(i)/1.0;
         elseif (j == 2 && h < tol*max([1 abs(x(i+1)) abs(x(i-j+1))]))
            D(i+1,j+1) = ypp(i)/2.0;
         else
            D(i+1,j+1) = (D(i+1,j)-D(i,j))/h;
         end
      end
   end
end

p = diag(D);
