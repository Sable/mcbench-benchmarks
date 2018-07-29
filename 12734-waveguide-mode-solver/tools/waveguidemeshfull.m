function [x,y,xc,yc,nx,ny,eps,varargout] = waveguidemeshfull(n,h,rh,rw,side,dx,dy);

% This function creates an index mesh for the finite-difference
% mode solver.  The function will accommodate a generalized three
% layer rib waveguide structure.  (Note: channel waveguides can
% also be treated by selecting the parameters appropriately.) 
% 
% USAGE:
% 
% [x,y,xc,yc,nx,ny,eps] = waveguidemeshfull(n,h,rh,rw,side,dx,dy)
% [x,y,xc,yc,nx,ny,edges] = waveguidemeshfull(n,h,rh,rw,side,dx,dy)
%
% INPUT
%
% n - indices of refraction for layers in waveguide
% h - height of each layer in waveguide
% rh - height of waveguide feature
% rw - half-width of waveguide
% side - excess space to the right of waveguide
% dx - horizontal grid spacing
% dy - vertical grid spacing
% 
% OUTPUT
% 
% x,y - vectors specifying mesh coordinates
% xc,yc - vectors specifying grid-center coordinates
% nx,ny - size of index mesh
% eps - index mesh (n^2)
% edges - (optional) list of edge coordinates, to be used later
%   with the line() command to plot the waveguide edges
%
% AUTHOR:  Thomas E. Murphy (tem@umd.edu)

if isscalar(side)
  side1 = side;
  side2 = side;
else
  side1 = side(1);
  side2 = side(2);
end

ih = round(h/dy);
irh = round (rh/dy);
irw = round (2*rw/dx);
iside1 = round (side1/dx);
iside2 = round (side2/dx);
nlayers = length(h);

nx = irw+iside1+iside2+1;
ny = sum(ih)+1;

x = dx*(-(irw/2+iside1):1:(irw/2+iside2))';
xc = (x(1:nx-1) + x(2:nx))/2;

y = (0:(ny-1))*dy;
yc = (1:(ny-1))*dy - dy/2;

eps = zeros(nx-1,ny-1);

iy = 1;

for jj = 1:nlayers,
  for i = 1:ih(jj),
	eps(:,iy) = n(jj)^2*ones(nx-1,1);
	iy = iy+1;
  end
end

iy = sum(ih)-ih(nlayers);
for i = 1:irh,
  eps(1:iside1,iy) = n(nlayers)^2*ones(iside1,1);
  eps(irw+iside1+1:irw+iside1+iside2,iy) = n(nlayers)^2*ones(iside2,1);
  iy = iy-1;
end

nx = length(xc);
ny = length(yc);

if (nargout == 8)
  iyp = cumsum(ih);
  for jj = 1:nlayers-2,
    if (iyp(jj) >= (iyp(nlayers-1)-irh))
      edges{1,jj} = dx*[-irw/2,irw/2];
    else
      edges{1,jj} = dx*[-(irw/2+iside1),(irw/2+iside2)];
    end
    edges{2,jj} = dy*[1,1]*iyp(jj);
  end
  jj = nlayers-1;
  edges{1,jj} = dx*[-(irw/2+iside1),-irw/2,-irw/2,+irw/2, ...
                    +irw/2,(irw/2+iside2)]; 
  edges{2,jj} = dy*[iyp(jj)-irh,iyp(jj)-irh,iyp(jj),iyp(jj), ...
                    iyp(jj)-irh,iyp(jj)-irh]; 
  varargout(1) = {edges};
end