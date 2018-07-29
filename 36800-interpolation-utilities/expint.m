function yi = expint(x, y, xi)

% EXPINT 1-D piecewise exponential interpolation
%    EXPINT(X,Y,XI) interpolates to find YI, the values of the
%    underlying function Y at the points in the array XI, using
%    piecewise exponential interpolation.  X and Y must be
%    vectors of length N.

% Joe Henning - Fall 2012

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
      fprintf('??? Bad x input to expint ==> x values must be distinct\n');
      yi(i) = NaN;
      continue;
   end
   
   % Evaluate exponential
   yi(i) = y(klo)*(y(khi)/y(klo))^((xi(i)-x(klo))/h);
end
