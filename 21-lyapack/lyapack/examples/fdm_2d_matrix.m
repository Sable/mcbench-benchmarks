function [A, name] = fdm_2d_matrix(n0,fx_str,fy_str,g_str)
%
%  Generates the stiffness matrix A for the finite difference
%  discretization (equidistant grid) of the PDE
%
%   laplace(u) - fx du/dx - fy du/dy - g u   =   r.h.s.     on Omega
%                 
%                                        u   =   0          on dOmega
% 
%  Omega = (0,1)x(0,1)   (unit square). 
%
%  This function is just used as an easy way to generate test problems
%  rather than to solve PDEs.
%
%  Calling sequence:
%   
%    [A, name] = fdm_2d_matrix( n0, fx_str, fy_str, g_str )
%
%  Input:
%   
%    n0        number of inner grid points in each dimension;
%    fx_str    string describing the function fx in the space variables
%              'x' and 'y', e.g., fx_str = 'sin(x+2*y)+3';              
%    fy_str    string describing the function fy in the space variables
%              'x' and 'y';              
%    g_str     string describing the function g in the space variables
%              'x' and 'y'. 
%
%  Output:
%
%    A         n-x-n sparse stiffness matrix, where n = n0^2;
%    name      string describing the problem.
%
%
%  LYAPACK 1.0 (Thilo Penzl, May 1999)

% Input data not completely checked!

na = nargin;

if na~=4
  error('Wrong number of input parameters.');
end

name = ['FDM-2D: fx=',fx_str,'; fy=',fy_str,'; g=',g_str];

n2 = n0*n0;

h = 1.0/(n0+1);                            

h2 = h*h;

t1 = 4.0/h2;
t2 = -1.0/h2;
t3 = 1.0/(2.0*h);

len = 5*n2-4*n0;
I = zeros(len,1);
J = zeros(len,1);
S = zeros(len,1);
ptr = 0;                                  % Pointer
i = 0;                                    % Row Number

for iy = 1:n0
  y = iy*h;
  for ix = 1:n0
    x = ix*h;
      
    i = i+1;
    fxv = eval(fx_str);
    fyv = eval(fy_str);
    gv = eval(g_str);

    if iy>1
      ptr = ptr+1;                        % A(i,i-n)
      I(ptr) = i;
      J(ptr) = i-n0;
      S(ptr) = t2-fyv*t3;
    end
      
    if ix>1
      ptr = ptr+1;                        % A(i,i-1)
      I(ptr) = i;
      J(ptr) = i-1;
      S(ptr) = t2-fxv*t3;
    end
      
    ptr = ptr+1;                          % A(i,i)
    I(ptr) = i;
    J(ptr) = i;
    S(ptr) = t1+gv;

    if ix<n0
      ptr = ptr+1;                        % A(i,i+1)
      I(ptr) = i;
      J(ptr) = i+1;
      S(ptr) = t2+fxv*t3;
    end
      
    if iy<n0
      ptr = ptr+1;                        % A(i,i+n0)
      I(ptr) = i;
      J(ptr) = i+n0;
      S(ptr) = t2+fyv*t3;
    end
      
  end  
end

A = -sparse(I,J,S,n2,n2);
