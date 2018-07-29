function [yi, ypi] = trigint(x, y, xi, c)

% hRIGINT 1-D piecewise trigonometric interpolation
%    TRIGINT(X,Y,XI,C) interpolates to find YI, the values of the
%    underlying function Y at the points in the array XI, using
%    piecewise trigonometric interpolation.  X and Y must be vectors 
%    of length N.
%
%    C specifies the number of data points to use in the
%    interpolation.  The default is to use all points.
%
%    [YI,YPI] = TRIGINT() also returns the interpolated derivative
%    of the underlying function Y at points XI.

% Joe Henning - Fall 2012

% On the Interpolation Trigonometric Polynomial with an Arbitrary Even Number of Nodes
% Ernest Scheiber
% 2011 13th International Symposium on Symbolic and Numeric Algorithms for Scientific Computing
% 978-0-7695-4630-8/11 2011 IEEE
% DOI 10.1109/SYNASC.2011.13

if (nargin < 4)
   c = 0;
end

n = length(x);

if (n < c)
   fprintf('??? Bad c input to trigint ==> c <= length(x)\n');
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
      fprintf('??? Bad x input to trigint ==> x values must be distinct\n');
      yi(i) = NaN;
      ypi(i) = NaN;
      continue;
   end

   % Evaluate lagrange polynomial
   yi(i) = 0;
   ypi(i) = 0;
   if (c == 0)
      if (mod(n,2) == 0)   % even
         for k = 1:n
            sumx = 0;
            for m = 1:n
               sumx = sumx + x(m);
            end
            term = y(k)*(cos(0.5*(xi(i)-x(k))) + sin(0.5*(xi(i)-x(k)))*cot(0.5*sumx));
            termp = 0;
            termp2 = y(k)*0.5*(-sin(0.5*(xi(i)-x(k))) + cos(0.5*(xi(i)-x(k)))*cot(0.5*sumx));
            for m = 1:n
               if (k ~= m)
                  term = term*sin(0.5*(xi(i)-x(m)))/sin(0.5*(x(k)-x(m)));
                  prod = 0.5*cos(0.5*(xi(i)-x(m)));
                  for j = 1:n
                     if ((k ~= j) && (m ~= j))
                        prod = prod*sin(0.5*(xi(i)-x(j)))/sin(0.5*(x(k)-x(j)));
                     end
                  end
                  termp = termp + y(k)*(cos(0.5*(xi(i)-x(k))) + sin(0.5*(xi(i)-x(k)))*cot(0.5*sumx))*prod/sin(0.5*(x(k)-x(m)));
                  termp2 = termp2*sin(0.5*(xi(i)-x(m)))/sin(0.5*(x(k)-x(m)));
               end
            end
            yi(i) = yi(i) + term;
            ypi(i) = ypi(i) + termp + termp2;
         end
      else   % odd
         for k = 1:n
            term = y(k);
            termp = 0;
            for m = 1:n
               if (k ~= m)
                  term = term*sin(0.5*(xi(i)-x(m)))/sin(0.5*(x(k)-x(m)));
                  prod = 0.5*cos(0.5*(xi(i)-x(m)));
                  for j = 1:n
                     if ((k ~= j) && (m ~= j))
                        prod = prod*sin(0.5*(xi(i)-x(j)))/sin(0.5*(x(k)-x(j)));
                     end
                  end
                  termp = termp + y(k)*prod/sin(0.5*(x(k)-x(m)));
               end
            end
            yi(i) = yi(i) + term;
            ypi(i) = ypi(i) + termp;
         end
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
            sumx = 0;
            for m = klo-(c2-1):klo+c2
               sumx = sumx + x(m);
            end
            term = y(k)*(cos(0.5*(xi(i)-x(k))) + sin(0.5*(xi(i)-x(k)))*cot(0.5*sumx));
            termp = 0;
            termp2 = y(k)*0.5*(-sin(0.5*(xi(i)-x(k))) + cos(0.5*(xi(i)-x(k)))*cot(0.5*sumx));
            for m = klo-(c2-1):klo+c2
               if (k ~= m)
                  term = term*sin(0.5*(xi(i)-x(m)))/sin(0.5*(x(k)-x(m)));
                  prod = 0.5*cos(0.5*(xi(i)-x(m)));
                  for j = 1:n
                     if ((k ~= j) && (m ~= j))
                        prod = prod*sin(0.5*(xi(i)-x(j)))/sin(0.5*(x(k)-x(j)));
                     end
                  end
                  termp = termp + y(k)*(cos(0.5*(xi(i)-x(k))) + sin(0.5*(xi(i)-x(k)))*cot(0.5*sumx))*prod/sin(0.5*(x(k)-x(m)));
                  termp2 = termp2*sin(0.5*(xi(i)-x(m)))/sin(0.5*(x(k)-x(m)));
               end
            end
            yi(i) = yi(i) + term;
            ypi(i) = ypi(i) + termp + termp2;
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
            term = y(k);
            termp = 0;
            for m = klo-c2:klo+c2
               if (k ~= m)
                  term = term*sin(0.5*(xi(i)-x(m)))/sin(0.5*(x(k)-x(m)));
                  prod = 0.5*cos(0.5*(xi(i)-x(m)));
                  for j = 1:n
                     if ((k ~= j) && (m ~= j))
                        prod = prod*sin(0.5*(xi(i)-x(j)))/sin(0.5*(x(k)-x(j)));
                     end
                  end
                  termp = termp + y(k)*prod/sin(0.5*(x(k)-x(m)));
               end
            end
            yi(i) = yi(i) + term;
            ypi(i) = ypi(i) + termp;
         end
      end
   end
end
