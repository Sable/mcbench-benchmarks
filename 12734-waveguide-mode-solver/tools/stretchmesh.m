function [x,y,xc,yc,dx,dy] = stretchmesh(x,y,nlayers,factor,method)

% This function can be used to continuously stretch the grid
% spacing at the edges of the computation window for
% finite-difference calculations.  This is useful when you would
% like to increase the size of the computation window without
% increasing the total number of points in the computational
% domain.  The program implements four different expansion
% methods: uniform, linear, parabolic (the default) and
% geometric.  The first three methods also allow for complex
% coordinate stretching, which is useful for creating
% perfectly-matched non-reflective boundaries.
%
% USAGE:
% 
% [x,y] = stretchmesh(x,y,nlayers,factor);
% [x,y] = stretchmesh(x,y,nlayers,factor,method);
% [x,y,xc,yc] = stretchmesh(x,y,nlayers,factor);
% [x,y,xc,yc] = stretchmesh(x,y,nlayers,factor,method);
% [x,y,xc,yc,dx,dy] = stretchmesh(x,y,nlayers,factor);
% [x,y,xc,yc,dx,dy] = stretchmesh(x,y,nlayers,factor,method);
% 
% INPUT:
% 
% x,y - vectors that specify the vertices of the original
%   grid, which are usually linearly spaced.
% nlayers - vector that specifies how many layers of the grid
%   you would like to expand:
%   nlayers(1) = # of layers on the north boundary to stretch
%   nlayers(2) = # of layers on the south boundary to stretch
%   nlayers(3) = # of layers on the east boundary to stretch
%   nlayers(4) = # of layers on the west boundary to stretch
% factor - cumulative factor by which the layers are to be
%   expanded.  As with nlayers, this can be a 4-vector.
% method - 4-letter string specifying the method of
%   stretching for each of the four boundaries.  Four different
%   methods are supported: uniform, linear, parabolic (default)
%   and geometric.  For example, method = 'LLLG' will use linear
%   expansion for the north, south and east boundaries and
%   geometric expansion for the west boundary.
% 
% OUTPUT:
% 
% x,y - the vertices of the new stretched grid
% xc,yc (optional) - the center cell coordinates of the
%   stretched grid 
% dx,dy (optional) - the grid spacing (dx = diff(x))
%
% AUTHOR:  Thomas E. Murphy (tem@umd.edu)

if (nargin < 5)
  method = 'PPPP';
end 

if isscalar(factor)
  factor = factor*ones(1,4);
end

% Stretch out north boundary
n = nlayers(1);
f = factor(1);
if ((n > 0) & (f ~= 1));
  kv = (length(y)-n:length(y));
  q1 = y(length(y)-n);
  q2 = y(length(y));
  
  switch upper(method(1))
   case 'U'    % Uniform expansion
    c = polyfit([q1,q2],[q1,q1 + f*(q2-q1)],1);
    y(kv) = polyval(c,y(kv));
   case 'L'    % Linear expansion
    c = (f-1)/(q2-q1);
    b = 1 - 2*c*q1;
    a = q1 - b*q1 - c*q1^2;
    y(kv) = a + b*y(kv) + c*y(kv).^2;
   case 'P'    % Parabolic expansion
    y(kv) = y(kv) + (f-1)*(y(kv)-q1).^3/(q2-q1).^2;
   case 'G'    % Geometric expansion
    b = fzero(@(z) exp(z)-1-real(f)*z,real(f));
    a = (q2-q1)/b;
    y(kv) = q1 + a*(exp((y(kv)-q1)/a) - 1);  
  end
end

% Stretch out south boundary
n = nlayers(2);
f = factor(2);
if ((n > 0) & (f ~= 1));
  kv = (1:1+n);
  q1 = y(1+n);
  q2 = y(1);

  switch upper(method(2))
   case 'U'    % Uniform expansion
    c = polyfit([q1,q2],[q1,q1 + f*(q2-q1)],1);
    y(kv) = polyval(c,y(kv));
   case 'L'    % Linear expansion
    c = (f-1)/(q2-q1);
    b = 1 - 2*c*q1;
    a = q1 - b*q1 - c*q1^2;
    y(kv) = a + b*y(kv) + c*y(kv).^2;
   case 'P'    % Parabolic expansion
    y(kv) = y(kv) + (f-1)*(y(kv)-q1).^3/(q2-q1).^2;
   case 'G'    % Geometric expansion
    b = fzero(@(z) exp(z)-1-f*z,f);
    a = (q2-q1)/b;
    y(kv) = q1 + a*(exp((y(kv)-q1)/a) - 1);  
  end
end

% Stretch out east boundary
n = nlayers(3);
f = factor(3);
if ((n > 0) & (f ~= 1));
  kv = (length(x)-n:length(x));
  q1 = x(length(x)-n);
  q2 = x(length(x));

  switch upper(method(3))
   case 'U'    % Uniform expansion
    c = polyfit([q1,q2],[q1,q1 + f*(q2-q1)],1);
    x(kv) = polyval(c,x(kv));
   case 'L'    % Linear expansion
    c = (f-1)/(q2-q1);
    b = 1 - 2*c*q1;
    a = q1 - b*q1 - c*q1^2;
    x(kv) = a + b*x(kv) + c*x(kv).^2;
   case 'P'    % Parabolic expansion
    x(kv) = x(kv) + (f-1)*(x(kv)-q1).^3/(q2-q1).^2;
   case 'G'    % Geometric expansion
    b = fzero(@(z) exp(z)-1-f*z,f);
    a = (q2-q1)/b;
    x(kv) = q1 + a*(exp((x(kv)-q1)/a) - 1);  
  end
end

% Stretch out west boundary
n = nlayers(4);
f = factor(4);
if ((n > 0) & (f ~= 1));
  kv = (1:1+n);
  q1 = x(1+n);
  q2 = x(1);

  switch upper(method(4))
   case 'U'    % Uniform expansion
    c = polyfit([q1,q2],[q1,q1 + f*(q2-q1)],1);
    x(kv) = polyval(c,x(kv));
   case 'L'    % Linear expansion
    c = (f-1)/(q2-q1);
    b = 1 - 2*c*q1;
    a = q1 - b*q1 - c*q1^2;
    x(kv) = a + b*x(kv) + c*x(kv).^2;
   case 'P'    % Parabolic expansion
    x(kv) = x(kv) + (f-1)*(x(kv)-q1).^3/(q2-q1).^2;
   case 'G'    % Geometric expansion
    b = fzero(@(z) exp(z)-1-f*z,f);
    a = (q2-q1)/b;
    x(kv) = q1 + a*(exp((x(kv)-q1)/a) - 1);  
  end
end

if (nargout > 2)
  kv = 1:length(x)-1;
  xc = (x(kv) + x(kv+1))/2;
  
  kv = 1:length(y)-1;
  yc = (y(kv) + y(kv+1))/2;
end

if (nargout > 4)
  dx = diff(x);
  dy = diff(y);
end