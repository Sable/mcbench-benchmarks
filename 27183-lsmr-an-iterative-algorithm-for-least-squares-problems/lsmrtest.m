function x = lsmrtest( m,n,lambda,localSize )

% LSMRTEST   Test program for LSMR.
%        x = lsmrtest( m,n,lambda,localSize );
%        x = lsmrtest(  50,50,0.0 );
%        x = lsmrtest( 100,50,0.0 );
%        x = lsmrtest( 100,50,0.1 );
%        x = lsmrtest( 100,50,0.0,20 );
%        x = lsmrtest( 100,50,0.0,Inf );
%
% If LAMBDA = 0, this sets up a system Ax = b
% and calls LSMR to solve it.  Otherwise, the usual
% least-squares or damped least-squares problem is solved.
% If LOCALSIZE = 0, this runs LSMR without reorthogonalization.
% If LOCALSIZE > 0, this runs LSMR with reorthogonalization 
% against the previous LOCALSIZE v_k's.

% 08 Dec 2009: First version for distribution with LSMR.
% 14 Apr 2010: Updated documentation.
% 09 Jun 2010: Local reorthogonalization now tested.
%
% David Chin-lung Fong            clfong@stanford.edu
% Institute for Computational and Mathematical Engineering
% Stanford University
%
% Michael Saunders                saunders@stanford.edu
% Systems Optimization Laboratory
% Dept of MS&E, Stanford University.
%-----------------------------------------------------------------------

  if nargin < 4 || isempty(localSize), localSize = 0; end

  A         = @(v,mode) Aprodxxx( v,mode,m,n );  % Private function

  xtrue     = (n : -1: 1)';
  b         = A(xtrue,1);

  atol      = 1.0e-7;
  btol      = 1.0e-7;
  conlim    = 1.0e+10;
  itnlim    = 10*n;
  show      = 1;

  [ x, istop, itn, normr, normar, norma, conda, normx ] ...
      = lsmr( A, b, lambda, atol, btol, conlim, itnlim, localSize, show );

  j1 = min(n,5);   j2 = max(n-4,1);
  fprintf('\nFirst elements of x:\n')
  fprintf(' %10.4f', x(1:j1)')
  fprintf('\nLast  elements of x:\n')
  fprintf(' %10.4f', x(j2:n)')

  r    = b - A(x,1);
  r2   = norm([r; (-lambda*x)]);
  fprintf('\n\nnormr (est.)  %17.10e', normr );
  fprintf(  '\nnormr (true)  %17.10e\n', r2  );

% end function lsmrtest

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Subfunctions (only 1 here).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
function y = Aprodxxx( x,mode,m,n )

% if mode = 1, computes y = A*x
% if mode = 2, computes y = A'*x
% for some matrix  A.
%
% This is a simple example for testing LSMR.
% It uses the leading m*n submatrix from
% A = [ 1
%       1 2
%         2 3
%           3 4
%             ...
%               n ]
% suitably padded by zeros.
%
% 08 Dec 2009: First version for distribution with lsmr.m.

  if mode == 1
    d  = (1:n)';  % Column vector
    y1 = [d.*x; 0] + [0;d.*x];
    if m <= n+1
      y = y1(1:m);
    else         
      y = [     y1; 
	zeros(m-n-1,1)];
    end
  else
    d  = (1:m)';  % Column vector
    y1 = [d.*x] + [d(1:m-1).*x(2:m); 0];
    if m >= n
      y = y1(1:n);
    else
      y = [y1;
	zeros(n-m,1)];
    end
  end

% end subfunction Aprodxxx
