function x = conjgrad(A,b,tol)
% CONJGRAD  Conjugate Gradient Method.
%   X = CONJGRAD(A,B) attemps to solve the system of linear equations A*X=B
%   for X. The N-by-N coefficient matrix A must be symmetric and the right
%   hand side column vector B must have length N.
%
%   X = CONJGRAD(A,B,TOL) specifies the tolerance of the method. The
%   default is 1e-10.
%
% Example:
%{
  n = 6000;
  m = 8000;
  A = randn(n,m);
  A = A * A';
  b = randn(n,1);
  tic, x = conjgrad(A,b); toc
  norm(A*x-b)
%}
% By Yi Cao at Cranfield University, 18 December 2008.
%
    if nargin<3
        tol=1e-10;
    end
    r = b + A*b;
    y = -r;
    z = A*y;
    s = y'*z;
    t = (r'*y)/s;
    x = -b + t*y;
  
    for k = 1:numel(b);
       r = r - t*z;
       if( norm(r) < tol )
            return;
       end
       B = (r'*z)/s;
       y = -r + B*y;
       z = A*y;
       s = y'*z;
       t = (r'*y)/s;
       x = x + t*y;
    end
 end
