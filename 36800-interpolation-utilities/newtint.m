function [yi, p, pval] = newtint(x, y, xi, c)

% NEWTINT Interpolation of equally-spaced points.
%    NEWTINT(X,Y,XI,C) interpolates to find YI, the value
%    of the underlying function Y at the point XI, using
%    either Newton's forward interpolation formula or
%    Newton's backward interpolation formula.
%
%    C specifies the interpolation method:
%       0 : Newton's forward or backward (default)
%       1 : Newton's forward
%       2 : Newton's backward
%       3 : Stirling's method
%       4 : Everett's method
%
%    [YI,P,PVAL] = NEWTINT() also returns P, the coefficients
%    of the calculated interpolating polynomial, and PVAL,
%    which specifies the maximum degree of the interpolating
%    polynomial.

% Joe Henning - Fall 2011

if (nargin < 4)
   c = 0;
end

pval = length(x)*(0+1) - 1;

n = length(x)-1;
D = zeros(n+1,n+1);
D(:,1) = y(:);

h = x(2)-x(1);

for i = 1:n
   for j = 1:i
      D(i+1,j+1) = D(i+1,j)-D(i,j);
   end
end

if (c == 0)
   if (xi < x(1))
      c = 2;
   elseif (xi > x(ceil((n+1)/2)) && xi <= x(n+1))
      c = 2;
   else
      c = 1;
   end
end

switch c
   case 1
      % forward difference interpolation
      p = diag(D);
      q = (xi-x(1))/h;
      yi = p(1);
      for i = 1:length(p)-1
         term = 1;
         for k = 0:(i-1)
           term = term*(q-k);
         end
         term = term/factorial(i);
         yi = yi + term*p(i+1);
      end
   case 2
      % backward difference interpolation
      p = D(n+1,:).';
      q = (xi-x(n+1))/h;
      yi = p(1);
      for i = 1:length(p)-1
         term = 1;
         for k = 0:(i-1)
           term = term*(q+k);
         end
         term = term/factorial(i);
         yi = yi + term*p(i+1);
      end
   case 3
      % Stirling's method
      xk = 0;
      ik = 0;
      for i = 1:n+1
         if (xi > x(i))
            xk = x(i);
            ik = i;
         end
      end
      yi = 0;
      q = (xi-xk)/h;
      if (q > 0.5)
         ik = ik + 1;
         xk = x(ik);
         q = (xi-xk)/h;
         for i = 1:2:n+1
            fi = floor(i/2);
            term = 0;
            %[term D(ik+i-1-floor(i/2),i)]s
            for k = fi-1:fi
               term = term + dnchoosek(q+k,i-1)/2.0;
            end
            p(i,1) = term;
            if (ik+i-1-floor(i/2) <= n+1)
               yi = yi + term*D(ik+i-1-floor(i/2),i);
            end
         end
         for i = 2:2:n+1
            fi = floor(i/2);
            term = dnchoosek(q+fi-1,i-1);
            p(i,1) = term;
            %[term D(ik+i-1-floor(i/2),i) D(ik+i-floor(i/2),i)]
            if (ik+i-floor(i/2) > n+1)
               yi = yi + term*D(ik+i-1-floor(i/2),i)/2.0;
            else
               yi = yi + term*(D(ik+i-1-floor(i/2),i)+D(ik+i-floor(i/2),i))/2.0;
            end
         end
      else
         for i = 1:2:n+1
            fi = floor(i/2);
            term = 0;
            for k = fi-1:fi
               term = term + dnchoosek(q+k,i-1)/2.0;
            end
            p(i,1) = term;
            %[term D(ik+i-1-floor(i/2),i)]
            if (ik+i-1-floor(i/2) <= n+1)
               yi = yi + term*D(ik+i-1-floor(i/2),i);
            end
         end
         for i = 2:2:n+1
            fi = floor(i/2);
            term = dnchoosek(q+fi-1,i-1);
            p(i,1) = term;
            %[term D(ik+i-1-floor(i/2),i) D(ik+i-floor(i/2),i)]
            if (ik+i-floor(i/2) > n+1)
               yi = yi + term*D(ik+i-1-floor(i/2),i)/2.0;
            else
               yi = yi + term*(D(ik+i-1-floor(i/2),i)+D(ik+i-floor(i/2),i))/2.0;
            end
         end
      end
   case 4
      % Everett's method
      xk = 0;
      ik = 0;
      for i = 1:n+1
         if (xi > x(i))
            xk = x(i);
            ik = i;
         end
      end
      p = [];
      q = (xi-xk)/h;
      r = 1-q;
      yi = 0;
      for i = 1:2:n+1
         fi = floor(i/2);
         e = dnchoosek(r+fi,i);
         f = dnchoosek(q+fi,i);
         p = [p; e f];
         %[e D(ik+i-1-floor(i/2),i) f D(ik+i-floor(i/2),i)]
         if ((ik+i-floor(i/2)) > n+1)
            yi = yi + e*D(ik+i-1-floor(i/2),i) + f*0;
         else
            yi = yi + e*D(ik+i-1-floor(i/2),i) + f*D(ik+i-floor(i/2),i);
         end
      end
end

function [d] = dnchoosek(n, k)

% DNCHOOSEK Binomial coefficient or all combinations.
%    DNCHOOSEK(N,K) where N and K are non-negative numbers
%    returns N!/K!(N-K)!.

d = gamma(n+1)/(gamma(k+1)*gamma(n-k+1));
