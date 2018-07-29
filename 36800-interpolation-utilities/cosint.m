function yi = cosint(x, y, xi)

% COSINT 1-D piecewise cosine interpolation
%    COSINT(X,Y,XI) interpolates to find YI, the values of the
%    underlying function Y at the points in the array XI, using
%    piecewise cosine interpolation.  X and Y must be vectors 
%    of length N.

% Joe Henning - Fall 2011

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
      fprintf('??? Bad x input to cosint ==> x values must be distinct\n');
      yi(i) = NaN;
      continue;
   end
   
   % Evaluate cosine function
   cfact = (1 - cos(pi*(xi(i)-x(klo))/h))/2.0;
   yi(i) = y(klo) + cfact*(y(khi)-y(klo));
end
