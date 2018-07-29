function [phi,neff] = svmodes (lambda, guess, nmodes, dx, dy, ...
                               eps, boundary, field); 

% This function calculates the modes of a dielectric waveguide
% using the semivectorial finite difference method.
% 
% USAGE:
% 
% [phi,neff] = svmodes (lambda, guess, nmodes, dx, dy, eps, ...
%                       boundary, field);
% 
% INPUT:
% 
% lambda - optical wavelength
% guess - scalar shift to apply when calculating the eigenvalues.
%     This routine will return the eigenpairs which have an
%     effective index closest to this guess
% nmodes - the number of modes to calculate
% dx - horizontal grid spacing
% dy - vertical grid spacing
% eps - index mesh (= n^2(x,y))
% boundary - 4 letter string specifying boundary conditions to be
% applied at the edges of the computation window.  
%   boundary(1) = North boundary condition
%   boundary(2) = South boundary condition
%   boundary(3) = East boundary condition
%   boundary(4) = West boundary condition
% The following boundary conditions are supported: 
%   'A' - field is antisymmetric
%   'S' - field is symmetric
%   '0' - field is zero immediately outside of the
%         boundary. 
% field - must be 'EX', 'EY', or 'scalar'
% 
% OUTPUT:
% 
% phi - three-dimensional vector containing the requested
%       field component for each computed mode
% neff - vector of modal effective indices
%
% AUTHOR:  Thomas E. Murphy (tem@umd.edu)

boundary = upper(boundary);

[nx,ny] = size(eps);

% now we pad eps on all sides by one grid point
eps = [eps(:,1),eps,eps(:,ny)];
eps = [eps(1,:); eps ; eps(nx,:)];

% compute free-space wavevector
k = 2*pi/lambda;

if isscalar(dx)
  dx = dx*ones(nx+2,1);             % uniform grid
else
  dx = dx(:);                       % convert to column vector
  dx = [dx(1);dx;dx(length(dx))];   % pad dx on top and bottom
end

if isscalar(dy)
  dy = dy*ones(1,ny+2);             % uniform grid
else
  dy = dy(:);                       % convert to column vector
  dy = [dy(1);dy;dy(length(dy))].'; % pad dy on top and bottom
end

n = ones(1,nx*ny);   n(:) = ones(nx,1)*(dy(3:ny+2)+dy(2:ny+1))/2;
s = ones(1,nx*ny);   s(:) = ones(nx,1)*(dy(1:ny)+dy(2:ny+1))/2;
e = ones(1,nx*ny);   e(:) = (dx(3:nx+2)+dx(2:nx+1))/2*ones(1,ny);
w = ones(1,nx*ny);   w(:) = (dx(1:nx)+dx(2:nx+1))/2*ones(1,ny);
p = ones(1,nx*ny);   p(:) = dx(2:nx+1)*ones(1,ny);
q = ones(1,nx*ny);   q(:) = ones(nx,1)*dy(2:ny+1);

en = ones(1,nx*ny);  en(:) = eps(2:nx+1 ,3:ny+2);
es = ones(1,nx*ny);  es(:) = eps(2:nx+1 ,1:ny);
ee = ones(1,nx*ny);  ee(:) = eps(3:nx+2 ,2:ny+1);
ew = ones(1,nx*ny);  ew(:) = eps(1:nx   ,2:ny+1);
ep = ones(1,nx*ny);  ep(:) = eps(2:nx+1 ,2:ny+1);

switch lower(field)
 case 'ex'
  an = 2./n./(n+s);
  as = 2./s./(n+s);
  ae = 8*(p.*(ep-ew)+2.*w.*ew).*ee./...
       ((p.*(ep-ee)+2.*e.*ee).*(p.^2.*(ep-ew)+4.*w.^2.*ew) + ...
        (p.*(ep-ew)+2.*w.*ew).*(p.^2.*(ep-ee)+4.*e.^2.*ee));
  aw = 8*(p.*(ep-ee)+2.*e.*ee).*ew./...
       ((p.*(ep-ee)+2.*e.*ee).*(p.^2.*(ep-ew)+4.*w.^2.*ew) + ...
        (p.*(ep-ew)+2.*w.*ew).*(p.^2.*(ep-ee)+4.*e.^2.*ee));
  ap = ep.*k^2 - an - as - ae.*ep./ee - aw.*ep./ew;
  
 case 'ey'
  an = 8*(q.*(ep-es)+2.*s.*es).*en./...
       ((q.*(ep-en)+2.*n.*en).*(q.^2.*(ep-es)+4.*s.^2.*es) + ...
        (q.*(ep-es)+2.*s.*es).*(q.^2.*(ep-en)+4.*n.^2.*en));
  as = 8*(q.*(ep-en)+2.*n.*en).*es./...
       ((q.*(ep-en)+2.*n.*en).*(q.^2.*(ep-es)+4.*s.^2.*es) + ...
        (q.*(ep-es)+2.*s.*es).*(q.^2.*(ep-en)+4.*n.^2.*en));
  ae = 2./e./(e+w);
  aw = 2./w./(e+w);
  ap = ep.*k^2 - an.*ep./en - as.*ep./es - ae - aw;

 case 'scalar'
  an = 2./n./(n+s);
  as = 2./s./(n+s);
  ae = 2./e./(e+w);
  aw = 2./w./(e+w);
  ap = ep.*k^2 - an - as - ae - aw;
end

ii = zeros(nx,ny);
ii(:) = (1:nx*ny);

% Modify matrix elements to account for boundary conditions

% north boundary
ib = zeros(1,nx);
ib(:) = ii(1:nx,ny);
if (boundary(1) == 'S')
  ap(ib) = ap(ib) + an(ib);
elseif (boundary(1) == 'A')
  ap(ib) = ap(ib) - an(ib);
end

% south boundary
ib = zeros(1,nx);
ib(:) = ii(1:nx,1);
if (boundary(2) == 'S')
  ap(ib) = ap(ib) + as(ib);
elseif (boundary(2) == 'A')
  ap(ib) = ap(ib) - as(ib);
end

% east boundary
ib = zeros(1,ny);
ib(:) = ii(nx,1:ny);
if (boundary(3) == 'S')
  ap(ib) = ap(ib) + ae(ib);
elseif (boundary(3) == 'A')
  ap(ib) = ap(ib) - ae(ib);
end

% west boundary
ib = zeros(1,ny);
ib(:) = ii(1,1:ny);
if (boundary(4) == 'S')
  ap(ib) = ap(ib) + aw(ib);
elseif (boundary(4) == 'A')
  ap(ib) = ap(ib) - aw(ib);
end

iall = zeros(1,nx*ny);    iall(:) = ii;
in = zeros(1,nx*(ny-1));  in(:) = ii(1:nx,2:ny);
is = zeros(1,nx*(ny-1));  is(:) = ii(1:nx,1:(ny-1));
ie = zeros(1,(nx-1)*ny);  ie(:) = ii(2:nx,1:ny);
iw = zeros(1,(nx-1)*ny);  iw(:) = ii(1:(nx-1),1:ny);

A = sparse ([iall,iw,ie,is,in], ...
	[iall,ie,iw,in,is], ...
	[ap(iall),ae(iw),aw(ie),an(is),as(in)]);

shift = (2*pi*guess/lambda)^2;
options.tol = 1e-8;
options.disp = 0;						% suppress output
options.isreal = isreal(A);

clear an as ae aw ap in is ie iw iall ii en es ee ew ep ...
    n s e w p q;

[v,d] = eigs(A,speye(size(A)),nmodes,shift,options);
neff = lambda*sqrt(diag(d))/(2*pi);

phi = zeros(nx,ny,nmodes);
temp = zeros(nx,ny);

for k = 1:nmodes;
  temp(:) = v(:,k)/max(abs(v(:,k)));
  phi(:,:,k) = temp;
end;
