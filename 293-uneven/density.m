function [rrho, xxvec, yyvec] = density(x, y, dx, dy, xy0);
% [rho, xvec, yvec] = density(x, y, dx, dy, [x0 x1 y0 y1]);  
% 
%  2-D probability density plot.
%
%  Input:  Vectors x and y of equal length. If dx and/or dy are omitted, the
%          default is 75 bins in each direction.
%      
%          If dx or dy is negative, then the variable is taken as the number of
%          bins rather than a grid resolution.
%
%          The vector containing the limits can be padded with NaNs if only
%          certain limits are desired, e g if x0 and y1 are wanted:
%
%            density(x, y, [.5 nan nan 45])
%
%  Output: The density matrix RHO together with vectors XVEC and YVEC. 
%          If no output arguments are specified, DENSITY will plot the density
%          function with the prescribed axes using PCOLOR. 
%
%  Requires bin.m. Tested under MatLab 4.2, 5.0, and 5.1.
%
%  See also bin.m for further details about dx, x0, etc, and ffgrid.m.
%

% 1.9.97 Oyvind.Breivik@gfi.uib.no.
%
% Oyvind Breivik
% Department of Geophysics
% University of Bergen
% NORWAY

DX = -75;  % Default grid size

x = x(:);

if nargin < 2
 y = x;
end

y = y(:);

xy = NaN*ones(1,4);

if (nargin < 4)
 xy0 = min(x);
end

if (nargin == 3 & length(dx) > 1)
 xy0 = dx;
 dx = DX;
end

if nargin < 3
 dx = DX;
end

if (nargin == 4 & length(dy) > 1)
 xy0 = dy;
 dy = dx;
end
if nargin < 4
 dy = dx;
end

nxy = length(xy0);
xy(1:nxy) = xy0;

if (isnan(xy(4)))
 xy(4) = max(y);
end
if (isnan(xy(3)))
 xy(3) = min(y);
end
if (isnan(xy(2)))
 xy(2) = max(x);
end
if (isnan(xy(1)))
 xy(1) = min(x);
end
x0 = xy(1); x1 = xy(2); y0 = xy(3); y1 = xy(4);

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
in = (inx & iny);
ix = ix(in); iy = iy(in);
N = length(ix); % how many datapoints are left now?

rho = zeros(length(xvec), length(yvec)) + eps;

for i = 1:N
 rho(ix(i), iy(i)) = rho(ix(i), iy(i)) + 1;
end

rho = rho/(N*dx*dy); % Density is n per dx per dy

rho = rho'; % Get in shape

if nargout == 0
 pcolor(xvec, yvec, rho)
 colorbar
 colormap jet
 xlabel(inputname(1))
 ylabel(inputname(2))
 dum = size(rho');
 str = sprintf('%d data points, grid: %dx%d', N, dum(1)-1, dum(2)-1);
 title(str);
end

if nargout > 0
 rrho = rho;
end

if nargout > 1
 xxvec = xvec;
 yyvec = yvec;
end
