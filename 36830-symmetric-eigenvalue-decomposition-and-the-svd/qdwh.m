function [U,H,it] = qdwh(A,alpha,L,piv)
%QDWH   QR-based dynamically weighted Halley iteration for polar decomposition.
%   [U,H,it,res] = qdwh(A,alpha,L,PIV) computes the
%   polar decomposition A = U*H of a full rank M-by-N matrix A with 
%   M >=  N.   Optional arguments: ALPHA: an estimate for norm(A,2),
%   L: a lower bound for the smallest singular value of A, and 
%   PIV = 'rc' : column pivoting and row sorting,
%   PIV = 'c'           : column pivoting only,
%   PIV = ''    (default): no pivoting.
%   The third output argument IT is the number of iterations.

[m,n] = size(A);

tol1 = 10*eps/2; tol2 = 10*tol1; tol3 = tol1^(1/3);
if m == n && norm(A-A','fro')/norm(A,'fro') < tol2;
   symm = 1;
else
   symm = 0;
end

it = 0; 

if m < n, error('m >= n is required.'), end

if nargin < 2 || isempty(alpha) % Estimate for largest singular value of A.
   alpha = normest(A,0.1);
end

% Scale original matrix to form X0.
U = A/alpha; Uprev = U;

if nargin < 3 || isempty(L) % Estimate for smallest singular value of U.
   Y = U; if m > n, [Q,Y] = qr(U,0); end
   smin_est =  norm(Y,1)/condest(Y);  % Actually an upper bound for smin.
   L = smin_est/sqrt(n);   
end

if nargin < 4, piv = ''; end

col_piv = strfind(piv,'c');
row_sort = strfind(piv,'r');

if row_sort
   row_norms = sum(abs(U),2);
   [ignore,rind] = sort(row_norms,1,'descend');
   U = U(rind,:);
end

while norm(U-Uprev,'fro') > tol3 || it == 0 || abs(1-L) > tol1

      it = it + 1;
      Uprev = U;

      % Compute parameters L,a,b,c (second, equivalent way).
      L2 = L^2;
      dd = ( 4*(1-L2)/L2^2 )^(1/3);
      sqd = sqrt(1+dd);
      a = sqd + sqrt(8 - 4*dd + 8*(2-L2)/(L2*sqd))/2;
      a = real(a);
      b = (a-1)^2/4;
      c = a+b-1;
      % Update L.
      L = L*(a+b*L2)/(1+c*L2);

      if c > 100 % Use QR.
         B = [sqrt(c)*U; eye(n)];

          if col_piv
             [Q,R,E] = qr(B,0,'vector');
          else
             [Q,R] = qr(B,0); %E = 1:n;
          end

          Q1 = Q(1:m,:); Q2 = Q(m+1:end,:);
          U = b/c*U + (a-b/c)/sqrt(c)*Q1*Q2';

      else % Use Cholesky when U is well conditioned; faster.
          C = chol(c*(U'*U)+eye(n));
          % Utemp = (b/c)*U + (a-b/c)*(U/C)/C';
          % Next three lines are slightly faster.
          opts1.UT = true; opts1.TRANSA = true;
          opts2.UT = true; opts2.TRANSA = false;
          U = (b/c)*U + (a-b/c)*(linsolve(C,linsolve(C,U',opts1),opts2))';
    end
    if symm
       U = (U+U')/2;
    end
end
if row_sort
   U(rind,:) = U;
end

if nargout > 1
    H = U'*A; H = (H'+H)/2;
end
