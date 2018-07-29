function v = fdm_2d_vector(n0,f_str)
%
%  Generates a vector v which contains the values of a function f(x,y) 
%  on an equidistant grid in the interior of the unit square. The grid
%  points are numbered consistently with those used in the function
%  'fdm_2d_matrix'.
%
%  This function is just used as an easy way to generate test problems
%  rather than to solve PDEs.
%
%  Calling sequence:
%   
%    v = fdm_2d_vector( n0, f_str)
%
%  Input:
%   
%    n0        number of inner grid points in each dimension;
%    f_str     string describing the function f in the space variables 'x'
%              and 'y', e.g., f_str = 'sin(x+2*y)+3'. 
%
%  Output:
%
%    v         vector of order n = n0^2 containing the values of f(x,y).
%
%
%  LYAPACK 1.0 (Thilo Penzl, May 1999)

% Input data not completely checked!

na = nargin;

if na~=2
  error('Wrong number of input parameters.');
end

h = 1.0/(n0+1);                             

n2 = n0*n0;

v = zeros(n2,1);

i = 0;

for iy = 1:n0
  y = iy*h;
  for ix = 1:n0
    x = ix*h;
    i = i+1;
    v(i) = eval(f_str);
  end
end  



