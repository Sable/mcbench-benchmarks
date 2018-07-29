function [c,mv] = normAm(A,m)
%NORMAM   Estimate of 1-norm of power of matrix.
%   NORMAM(A,m) estimates norm(A^m,1).
%   If A has nonnegative elements the estimate is exact.
%   [C,MV] = NORMAM(A,m) returns the estimate C and the number MV of
%   matrix-vector products computed involving A or A^*.

%   Reference: A. H. Al-Mohy and N. J. Higham, A New Scaling and Squaring
%   Algorithm for the Matrix Exponential, SIAM J. Matrix Anal. Appl. 31(3):
%   970-989, 2009.

%   Awad H. Al-Mohy and Nicholas J. Higham, April 19, 2010.

n = length(A);
if isequal(A,abs(A))
    e = ones(n,1);
    for j=1:m         % for positive matrices only
        e = A'*e;
    end
    c = norm(e,inf);
    mv = m;
else
    [c,v,w,it] = normest1(@afun_power);
    mv = it(2)*2*m; % Since t = 2.
end

  function Z = afun_power(flag,X)
       %AFUN_POWER  Function to evaluate matrix products needed by NORMEST1.

       if isequal(flag,'dim')
          Z = n;
       elseif isequal(flag,'real')
          Z = isreal(A);
       else

          [p,q] = size(X);
          if p ~= n, error('Dimension mismatch'), end

          if isequal(flag,'notransp')
             for i = 1:m, X = A*X; end
          elseif isequal(flag,'transp')
             for i = 1:m, X = A'*X; end
          end

          Z = X;

       end

  end
end
