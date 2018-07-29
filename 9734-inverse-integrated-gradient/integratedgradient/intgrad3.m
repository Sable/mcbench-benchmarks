function fhat = intgrad3(fx,fy,fz,dx,dy,dz,f111)
% intgrad: generates a surface, integrating gradient information.
% usage: fhat = intgrad(fx,fy,fz)
% usage: fhat = intgrad(fx,fy,fz,dx,dy,dz)
% usage: fhat = intgrad(fx,fy,fz,dx,dy,dz,f111)
%
% arguments: (input)
%  fx,fy,fz - (ny by nx by nz) arrays, as gradient would have produced.
%          fx, fy, and fz must all be the same size. Note that x is
%          assumed to be the column dimension of f, in the meshgrid
%          convention.
%
%          (nx, ny, nz) must all be at least 2.
%
%          fx, fy, fz will be assumed to contain consistent gradient
%          information. If they are inconsistent, then the generated
%          gradient will be solved for in a least squares sense.
%
%          Central differences will be used where possible.
%
%     dx - (OPTIONAL) scalar or vector - denotes the spacing in x
%          if dx is a scalar, then spacing in x (the column index
%          of fx and fy) will be assumed to be constant = dx.
%          if dx is a vector, it denotes the actual coordinates
%          of the points in x (i.e., the column dimension of fx
%          and fy.) length(dx) == nx
%
%          DEFAULT: dx = 1
%
%     dy - (OPTIONAL) scalar or vector - denotes the spacing in y
%          if dy is a scalar, then the spacing in x (the row index
%          of fx and fy) will be assumed to be constant = dy.
%          if dy is a vector, it denotes the actual coordinates
%          of the points in y (i.e., the row dimension of fx
%          and fy.) length(dy) == ny
%
%          DEFAULT: dy = 1
%
%     dz - (OPTIONAL) scalar or vector - denotes the spacing in z
%          if dz is a scalar, then the spacing in z (the plane index
%          of fz) will be assumed to be constant = dz.
%          if dz is a vector, it denotes the actual coordinates
%          of the points in z (i.e., the plane dimension of fz)
%          length(dy) == ny
%
%          DEFAULT: dz = 1
%
%    f111 - (OPTIONAL) scalar - defines the (1,1,1) eleemnt of fhat
%          after integration. This is just the constant of integration.
%
%          DEFAULT: f111 = 0
%
% arguments: (output)
%   fhat - (nx by ny by nz) array containing the integrated gradient
%
% Example usage: 10x20x30 grid
%  xp = linspace(0,1,10);
%  yp = linspace(0,1,20);
%  zp = linspace(0,1,30);
%  [x,y,z] = meshgrid(xp,yp,zp);
%  f = exp(x+y+z) + sin((x-2*y+3*z)*3);
%  [fx,fy,fz]=gradient(f,xp,yp,zp);
%  tic,fhat = intgrad3(fx,fy,fz,xp,yp,zp,1);toc
%  
%  The time required was 51 seconds

% Author; John D'Errico
% Current release: 2
% Date of release: 1/27/06

% size 
if (length(size(fx))~=3) || (length(size(fy))~=3) || (length(size(fz))~=3)
  error 'fx, fy, fz must be 3d arrays'
end
[ny,nx,nz] = size(fx);
if any([ny,nx,nz]~=size(fy)) || any([ny,nx,nz]~=size(fz))
  error 'fx, fy, fz must be the same sizes.'
end
if (nx<2) || (ny<2) || (nz<2)
  error 'fx, fy and fz must be at least 2x2x2 arrays'
end

% supply defaults if needed
if (nargin<3) || isempty(dx)
  % default x spacing is 1
  dx = 1;
end
if (nargin<4) || isempty(dy)
  % default y spacing is 1
  dy = 1;
end
if (nargin<5) || isempty(dz)
  % default z spacing is 1
  dz = 1;
end
if (nargin<6) || isempty(f111)
  % default integration constant is 0
  f111 = 0;
end

% if scalar spacings, expand them to be vectors
dx=dx(:);
if length(dx) == 1
  dx = repmat(dx,nx-1,1);
elseif length(dx)==nx
  % dx was a vector, use diff to get the spacing
  dx = diff(dx);
else
  error 'dx is not a scalar or of length == nx'
end
dy=dy(:);
if length(dy) == 1
  dy = repmat(dy,ny-1,1);
elseif length(dy)==ny
  % dy was a vector, use diff to get the spacing
  dy = diff(dy);
else
  error 'dy is not a scalar or of length == ny'
end
dz=dz(:);
if length(dz) == 1
  dz = repmat(dz,nz-1,1);
elseif length(dz)==nz
  % dz was a vector, use diff to get the spacing
  dz = diff(dz);
else
  error 'dz is not a scalar or of length == ny'
end

if (length(f111) > 1) || ~isnumeric(f111) || isnan(f111) || ~isfinite(f111)
  error 'f111 must be a finite scalar numeric variable.'
end

% build gradient design matrix, sparsely. Use a central difference
% in the body of the array, and forward/backward differences along
% the edges.

% A will be the final design matrix. it will be sparse.
% The unrolling of F will be with row index (y) running most rapidly,
% then x , then z moves most slowly
rhs = zeros(3*nx*ny*nz,1);
% but build the array elements in Af
Af = zeros(3*nx*ny*nz,6);
L = 0;

% do the leading edge in x, forward difference
indx = 1;
[indy,indz] = meshgrid(1:ny,1:nz);
indy=indy(:);
indz = indz(:);
ind = indy + (indx-1)*ny + (indz-1)*ny*nx;
m = ny*nz;
rind = repmat(L+(1:m)',1,2);
cind = [ind,ind+ny];
dfdx = repmat([-1 1]./dx(1),m,1);
Af(L+(1:m),:) = [rind,cind,dfdx];
rhs(L+(1:m)) = fx(ind);
L = L+m;

% interior partials in x, central difference
if nx>2
  [indx,indy,indz] = meshgrid(2:(nx-1),1:ny,1:nz);
  indx = indx(:);
  indy = indy(:);
  indz = indz(:);
  ind = indy + (indx-1)*ny + (indz-1)*ny*nx;
  m = (nx-2)*ny*nz;
  rind = repmat(L+(1:m)',1,2);
  cind = [ind-ny,ind+ny];
  dfdx = 1./(dx(indx-1)+dx(indx));
  dfdx = dfdx*[-1 1];
  Af(L+(1:m),:) = [rind,cind,dfdx];
  rhs(L+(1:m)) = fx(ind);
  L = L+m;
end

% do the trailing edge in x, backwards difference
indx = nx;
[indy,indz] = meshgrid(1:ny,1:nz);
indy=indy(:);
indz = indz(:);
ind = indy + (indx-1)*ny + (indz-1)*ny*nx;
m = ny*nz;
rind = repmat(L+(1:m)',1,2);
cind = [ind-ny,ind];
dfdx = repmat([-1 1]./dx(end),m,1);
Af(L+(1:m),:) = [rind,cind,dfdx];
rhs(L+(1:m)) = fx(ind);
L = L+m;

% do the leading edge in y, forward difference
indy = 1;
[indx,indz] = meshgrid(1:nx,1:nz);
indx = indx(:);
indz = indz(:);
ind = indy + (indx-1)*ny + (indz-1)*ny*nx;
m = nx*nz;
rind = repmat(L+(1:m)',1,2);
cind = [ind,ind+1];
dfdy = repmat([-1 1]./dy(1),m,1);
Af(L+(1:m),:) = [rind,cind,dfdy];
rhs(L+(1:m)) = fy(ind);
L = L+m;

% interior partials in y, central difference
if ny>2
  [indx,indy,indz] = meshgrid(1:nx,2:(ny-1),1:nz);
  indx = indx(:);
  indy = indy(:);
  indz = indz(:);
  ind = indy + (indx-1)*ny + (indz-1)*ny*nx;
  m = nx*(ny-2)*nz;
  rind = repmat(L+(1:m)',1,2);
  cind = [ind-1,ind+1];
  dfdy = 1./(dy(indy-1)+dy(indy));
  dfdy = dfdy*[-1 1];
  Af(L+(1:m),:) = [rind,cind,dfdy];
  rhs(L+(1:m)) = fy(ind);
  L = L+m;
end

% do the trailing edge in y, backwards difference
indy = ny;
[indx,indz] = meshgrid(1:nx,1:nz);
indx = indx(:);
indz = indz(:);
ind = indy + (indx-1)*ny + (indz-1)*ny*nx;
m = nx*nz;
rind = repmat(L+(1:m)',1,2);
cind = [ind-1,ind];
dfdy = repmat([-1 1]./dy(end),m,1);
Af(L+(1:m),:) = [rind,cind,dfdy];
rhs(L+(1:m)) = fy(ind);
L = L+m;

% do the leading edge in z, forward difference
indz = 1;
[indx,indy] = meshgrid(1:nx,1:ny);
indx = indx(:);
indy = indy(:);
ind = indy + (indx-1)*ny + (indz-1)*ny*nx;
m = nx*ny;
rind = repmat(L+(1:m)',1,2);
cind = [ind,ind+nx*ny];
dfdz = repmat([-1 1]./dz(1),m,1);
Af(L+(1:m),:) = [rind,cind,dfdz];
rhs(L+(1:m)) = fz(ind);
L = L+m;

% interior partials in z, central difference
if nz>2
  [indx,indy,indz] = meshgrid(1:nx,1:ny,2:(nz-1));
  indx = indx(:);
  indy = indy(:);
  indz = indz(:);
  ind = indy + (indx-1)*ny + (indz-1)*ny*nx;
  m = nx*ny*(nz-2);
  rind = repmat(L+(1:m)',1,2);
  cind = [ind-nx*ny,ind+nx*ny];
  dfdz = 1./(dz(indz-1)+dz(indz));
  dfdz = dfdz*[-1 1];
  Af(L+(1:m),:) = [rind,cind,dfdz];
  rhs(L+(1:m)) = fz(ind);
  L = L+m;
end

% do the trailing edge in z, backwards difference
indz = nz;
[indx,indy] = meshgrid(1:nx,1:ny);
indx = indx(:);
indy = indy(:);
ind = indy + (indx-1)*ny + (indz-1)*ny*nx;
m = nx*ny;
rind = repmat(L+(1:m)',1,2);
cind = [ind-nx*ny,ind];
dfdz = repmat([-1 1]./dz(end),m,1);
Af(L+(1:m),:) = [rind,cind,dfdz];
rhs(L+(1:m)) = fz(ind);

% finally, we can build the rest of A itself, in its sparse form.
A = sparse(Af(:,1:2),Af(:,3:4),Af(:,5:6),3*nx*ny*nz,nx*ny*nz);

% Finish up with f11, the constant of integration.
% eliminate the first unknown, as f11 is given.
rhs = rhs - A(:,1)*f111;

% Solve the final system of equations. They will be of
% full rank, due to the explicit integration constant.
% Just use sparse \
fhat = A(:,2:end)\rhs;
fhat = reshape([f111;fhat],ny,nx,nz);






