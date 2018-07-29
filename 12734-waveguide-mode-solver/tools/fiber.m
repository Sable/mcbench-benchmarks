function [x,y,xc,yc,nx,ny,eps] = fiber(n,r,side,dx,dy);

% This function creates an index mesh for the finite-difference
% mode solver.  The function will accommodate a generalized three
% layer rib waveguide structure.  (Note: channel waveguides can
% also be treated by selecting the parameters appropriately.) 
% 
% USAGE:
% 
% [x,y,xc,yc,nx,ny,eps] = fiber(n,r,side,dx,dy)
%
% INPUT
%
% n - indices of refraction for layers in fiber
% r - outer radius of each layer
% side - width of cladding layer to simulate
% dx - horizontal grid spacing
% dy - vertical grid spacing
% 
% OUTPUT
% 
% x,y - vectors specifying mesh coordinates
% xc,yc - vectors specifying grid-center coordinates
% nx,ny - size of index mesh
% eps - index mesh (n^2)
%
% AUTHOR:  Thomas E. Murphy (tem@umd.edu)

nx = round((sum(r)+side)/dx);
ny = round((sum(r)+side)/dy);

xc = (1:nx)'*dx - dx/2;
yc = (1:ny)*dy - dy/2;
x = (0:nx)'*dx;
y = (0:ny)*dy;

rho = sqrt(xc.^2*ones(size(yc)) + ones(size(xc))*yc.^2);

nlayers = length(n);
eps = n(nlayers).^2*ones(nx,ny);

for jj = (nlayers-1):-1:1,
  kv = find(rho < r(jj));
  eps(kv) = n(jj).^2;
end
