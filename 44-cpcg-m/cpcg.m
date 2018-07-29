function [x, error, iter, flag] = cpcg(a, b, tol, max_it, c, x0)

%CPCG -CIRCULANT PRECONDITIONED CONJUGATE GRADIENT METHOD.
%  [x, error, iter, flag] = cpcg(a, b, tol, max_it, c, x0)
%  [x, error, iter, flag] = cpcg(a, b, c)
%  [x, error, iter, flag] = cpcg(a, b)
%
% tol, max_it, c, x0 can be replaced by [] and default vaules will be used.
%
% cpcg.m solves the symmetric positive definite Toeplitz linear system Ax=b 
% using the Conjugate Gradient method with a circulant preconditioner C. 
%
% Both matrices A and C have to be SYMMETRIC POSITIVE DEFINITE.
%
% input   a        REAL FIRST COLUMN of symmetric positive definite matrix
%         b        REAL right hand side vecto
%         tol      REAL error tolerance
%         max_it   INTEGER maximum number of iteration
%         c        REAL FIRST COLUMN of CIRCULANT preconditioner matrix
%         x0       REAL initial guess vector
%
% output  x        REAL solution vector
%         error    REAL error norm
%         iter     INTEGER number of iterations performed
%         flag     INTEGER: 0 = solution found to tolerance
%                           1 = no convergence given max_it
%
% (written by L. Ling, Simon Fraser University, 1999)

  % setup inputs
  n=length(a);
  if nargin==2,
     c = zeros(n,1); c(1) = 1;
     tol = 1e-6;    
     max_it = n;   
     x0 = zeros(n,1);
  elseif nargin==3,
     c = tol;
     tol = 1e-6;    
     max_it = n;   
     x0 = zeros(n,1);   
  end
  if isempty(tol), tol=1e-6; end
  if isempty(max_it), max_it=n; end
  if isempty(c), c = zeros(n,1); c(1) = 1;; end  
  if isempty(x0), x0=zeros(n,1); end  
  
  % initialization  
  a=a(:);x=x0(:);b=b(:);c=c(:);    
  flag = 0;                                
  iter = 0;
  bnrm2 = norm( b );
  if  ( bnrm2 == 0.0 ), bnrm2 = 1.0; end  
  
  % NEW definition for the SAME varibles
     % tol is now the relative tolerance
     tol = tol * bnrm2;      
     % a (of size 2n) is now the Fourier transfrom of the first column
     % of the circulant matrix [A X;X A]
     a = fft([a;a(1,1);a(n:-1:2)]);
     % c is now the Fourier transfrom of the input c
     c = fft(c);            
  
  % Compute Toeplitz matrix-vector product by fft
  w = [x(:);zeros(n,1)];
  Aw = real( ifft( a .* fft(w) ) ); Aw = Aw(1:n);
  r = b - Aw;
  
  error = norm( r );
  if ( norm(b) == 0 ) 
     os = sprintf(['The right hand side vector is all zero so CPCG '...
           'returned an all zero solution without iterating.']);
     disp(os);
     return,end
  if ( error < tol ) 
     os = sprintf(['The initial guess is the solution with relative residual '... 
           '%0.2g so CPCG without iteration'],error/bnrm2);
     disp(os);
     return, end

  for iter = 1:max_it                       % begin iteration

     z  = real( ifft( fft(r)./c ) );
     rho = (r'*z);

     if ( iter > 1 ),                       % direction vector
        beta = rho / rho_1;
        p = z + beta*p;
     else
        p = z;
     end
     w = [p(:);zeros(n,1)];
     Aw = real( ifft( a .* fft(w) ) ); Aw=Aw(1:n);
     q = Aw;
     alpha = rho / (p'*q );
     x = x + alpha * p;                    % update approximation vector

     r = r - alpha*q;                      % compute residual
     error = norm( r );                    % check convergence
     if ( error <= tol ),
        os = sprintf(['CPCG converged at iteration %d to a solution with '...
              'relative residual %0.2g'], iter,error/bnrm2);
        disp(os);
        break, end 

     rho_1 = rho;

  end
  
  if ( error > tol ), 
     os = sprintf(['Warning: CPCG stopped after %d iteration without '... 
           'convergence and has relative residual %0.2g'],max_it,error/bnrm2); 
     flag = 1; disp(os);                   % no convergence
  end                         

% END pccg.m
