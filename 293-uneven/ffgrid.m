function [zzgrid, xxvec, yyvec] = ffgrid(x, y, z, dx, dy, xyz0);
% [zgrid, xvec, yvec] = ffgrid(x, y, z, dx, dy, [x0 x1 y0 y1 z0 z1 n0]);
%
%  Fast 'n' Furious data gridding.
%
%  Input:  Unevenly spaced data in vectors x, y, and z of equal length.
%          If dx and dy are omitted, the default is 75 bins in each direction.
%
%          If dx or dy is negative, then the variable is taken as the number of
%          bins rather than a grid resolution. If dx is complex, the imaginary
%          part is taken as the value with which empty grid points are padded.
%          The default padding is 10% below minimum value in grid.
%
%          The vector containing the limits can be padded with NaNs if only
%          certain limits are desired, e g if x1 and z0 are wanted:
%
%            ffgrid(x, y, z, [.5 nan nan nan 45])
%
%          The last parameter, n0, removes outliers from the data set by 
%          ignoring grid points with n0 or less observations. When n0 is 
%          negative it is treated as the percentage of the total number of 
%          data points.
%
%  Output: The gridded matrix ZGRID together with vectors XVEC and YVEC. 
%          If no output arguments are given, FFGRID will plot the gridded
%          function with the prescribed axes using PCOLOR.
%
%  Requires bin.m. Tested under MatLab 4.2, 5.0, and 5.1.
%
%  See also bin.m for further details about dx, x0, etc, and density.m.
%

% 28.7.97, Oyvind.Breivik@gfi.uib.no.
%
% Oyvind Breivik
% Department of Geophysics
% University of Bergen
% NORWAY

DX = -75; % default value

x = x(:);

y = y(:);

z = z(:);

xyz = NaN*ones(1,7);

if (nargin < 6)
 xyz0 = min(x);
end

if (nargin == 4 & length(dx) > 1)
 xyz0 = dx;
 dx = DX;
end
if (nargin < 4)
 dx = DX;
end
if (real(dx) == 0)
 dx = DX + dx;
end
pad = imag(dx);
dx = real(dx);

if (nargin == 5 & length(dy) > 1)
  xyz0 = dy;
  dy = dx;
end
if (nargin < 5)
  dy = dx;
end

nxyz = length(xyz0);
xyz(1:nxyz) = xyz0;

if (isnan(xyz(7)))
  xyz(7) = 0;
end
if (isnan(xyz(6)))
  xyz(6) = max(z);
end
if (isnan(xyz(5)))
  xyz(5) = min(z);
end
if (isnan(xyz(4)))
  xyz(4) = max(y);
end
if (isnan(xyz(3)))
  xyz(3) = min(y);
end
if (isnan(xyz(2)))
  xyz(2) = max(x);
end
if (isnan(xyz(1)))
  xyz(1) = min(x);
end
x0 = xyz(1); x1 = xyz(2); y0 = xyz(3); y1 = xyz(4); z0 = xyz(5); z1 = xyz(6);
n0 = xyz(7);
  
if (dx < 0)
 dx = (x1 - x0)/abs(dx);
end
if (dy < 0)
 dy = (y1 - y0)/abs(dy);
end

ix = bin(x, dx, x0, x1);
iy = bin(y, dy, y0, y1); % bin data in (x,y)-space

xvec = x0:dx:x1;
yvec = y0:dy:y1;

nx = length(xvec);
ny = length(yvec);

inx = (ix >= 1) & (ix <= nx);
iny = (iy >= 1) & (iy <= ny);
inz = (z >= z0) & (z <= z1);
in = (inx & iny & inz);
ix = ix(in); iy = iy(in); z = z(in);
N = length(ix); % how many datapoints are left now?

ngrid = zeros(nx, ny); % no of obs per grid cell
zgrid = ngrid; % z-coordinate

for i = 1:N
 zgrid(ix(i), iy(i)) = zgrid(ix(i), iy(i)) + z(i);
 ngrid(ix(i), iy(i)) = ngrid(ix(i), iy(i)) + 1;
end

% Remove outliers
if (n0 >= 0)
  zgrid(ngrid <= n0) = 0;
  ngrid(ngrid <= n0) = 0;
else
  n0 = -n0;
  zgrid(ngrid <= n0*N) = 0;
  ngrid(ngrid <= n0*N) = 0;
end

N = sum(sum(ngrid)); % how many datapoints are left now?

Nil = (ngrid == 0);
ngrid(Nil) = 1; % now we don't divide by zero

zgrid = zgrid./ngrid; % Make average of values for each point

if (~pad)
  zmax = max(max(zgrid(~Nil)));
  zmin = min(min(zgrid(~Nil)));
  pad = zmin - (zmax - zmin)/10; % Adjust padding value to values in grid
end

zgrid(Nil) = pad; % Empty grid points are set to default value
rho = nnz(~Nil)/length(Nil(:));

zgrid = zgrid'; % Get in shape

if (nargout == 0) % no output, then plot
 pcolor(xvec, yvec, zgrid)
 colorbar
 colormap jet
 xlabel(inputname(1))
 ylabel(inputname(2))
 zstr=inputname(3);
 dum = size(zgrid');
 if (~isempty(zstr)) % all this vital information ...
  str = sprintf('Color scale: %s, %d data points, grid: %dx%d, density: %4.2f', ...
  inputname(3), N, dum(1)-1, dum(2)-1, rho);
  title(str);
 else
   str = sprintf('%d data points, grid: %dx%d, density: %4.2f', ...
         N, dum(1)-1, dum(2)-1, rho);
   title(str);
 end
end

if (nargout > 0)
 zzgrid = zgrid;
end

if (nargout > 1)
 xxvec = xvec;
 yyvec = yvec;
end
