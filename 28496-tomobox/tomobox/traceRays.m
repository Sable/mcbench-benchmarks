function [voxels,vals,rows,xxyz,yxyz,zxyz] = ...
    traceRays(x0,y0,z0,abc,dims,Imod)
%TRACERAYS   Determine voxels and path lengts for parallel rays
%
% [voxels, vals, rows, xxyz, yxyz, zxyz] =
% traceRays(x0,y0,z0,abc,DIMS,Imod) is a helper function for
% buildSystemMatrix
% 
% Compute the path lengths of rays penetrating a cube of dimension dims,
% e.g. [15,15,15]. All rays have direction vector abc, the coordinates of a
% point on each ray are x0, y0, z0. Imod = 
% repmat(0:mnk3:(uvmax-1)*mnk3,mnk3,1) should be given as input for
% efficiency when calling traceRays multiple times, but is set to this if
% not given.
%
% Output voxels is a vector holding the voxel indices of the hit voxels,
% for all rays. vals and rows hold the corresponding path lengths and
% ray/row number, respectively. (xxyz,yxyz,zxyz) are the coordinates of the
% intersection points of the rays with the boundary planes between the
% voxels.

% Jakob Heide Jørgensen (jakj@imm.dtu.dk) and Per Christian Hansen
% Department of Informatics and Mathematical Modelling (IMM)
% Technical University of Denmark (DTU)
% August 2010

% This code is released under the Gnu Public License (GPL). 
% For more information, see
% http://www.gnu.org/copyleft/gpl.html


% Get the dimensions
m = dims(1);
n = dims(2);
k = dims(3);
mnk3 = m+n+k+3;

% Get the components of the direction vector
a = abc(1);
b = abc(2);
c = abc(3);

% Number of rays
uvmax = length(x0);

% Repeat the coordinate vectors to be ready to compute intersection with
% all the boundary planes
x0rep = repmat(x0,m+1,1);
y0rep = repmat(y0,n+1,1);
z0rep = repmat(z0,k+1,1);

% Coordinates to all intersections with x=(0:m) planes for all initial
% points
xx = repmat((0:m)',1,uvmax);
tx = ( xx - x0rep )/a;
yx = y0rep + b*tx;
zx = z0rep + c*tx;

% Coordinates to all intersections with y=(0:n) planes for all initial
% points
yy = repmat((0:n)',1,uvmax);
ty = ( yy - y0rep )/b;
xy = x0rep + a*ty;
zy = z0rep + c*ty;

% Coordinates to all intersections with z=(0:k) planes for all initial 
% points
zz = repmat((0:k)',1,uvmax);
tz = ( zz - z0rep )/c;
xz = x0rep + a*tz;
yz = y0rep + b*tz;

% Collect all the times, set infs to NaNs and sort the columns in ascending
% order, ie. for each ray get the times that voxel boundaries are hit in
% the right order.
txyz                  = [tx;ty;tz];
txyz(~isfinite(txyz)) = NaN;
[T,I]                 = sort(txyz);

% Collect all coordinates in sorted order. Since I from sort holds the
% local permutation indeces in each column we must add Imod for global
% indeces
if nargin < 6
    Imod = repmat(0:mnk3:(uvmax-1)*mnk3,mnk3,1);
end
xxyz = [xx;xy;xz];
yxyz = [yx;yy;yz];
zxyz = [zx;zy;zz];
XYZ  = [xxyz(:),yxyz(:),zxyz(:)];
XYZ  = XYZ(I(:) + Imod(:),:);
xxyz = reshape(XYZ(:,1),mnk3,uvmax);
yxyz = reshape(XYZ(:,2),mnk3,uvmax);
zxyz = reshape(XYZ(:,3),mnk3,uvmax);

% Discard doubles and triblets
[i,j] = find( abs(diff(T)) < 1e-12 );
idx   = sub2ind(size(T),i,j);       % Convert to single index
if ~isempty(idx)
    T(idx)    = NaN;
    [T,I2]    = sort(T);
    xxyz(idx) = NaN;
    xxyz      = xxyz(I2+Imod);
    yxyz(idx) = NaN;
    yxyz      = yxyz(I2+Imod);
    zxyz(idx) = NaN;
    zxyz      = zxyz(I2+Imod);
end
    
% Set points outside cube to NaNs
Ix          = (0 <= xxyz) & (xxyz <= m);
Iy          = (0 <= yxyz) & (yxyz <= n);
Iz          = (0 <= zxyz) & (zxyz <= k);
Ixyz        = Ix & Iy & Iz;
xxyz(~Ixyz) = NaN;
yxyz(~Ixyz) = NaN;
zxyz(~Ixyz) = NaN;
%T(~Ixyz) = NaN

% Calculate distances and midpoints
dx = diff(xxyz);
dy = diff(yxyz);
dz = diff(zxyz);
d  = sqrt(dx.^2 + dy.^2 + dz.^2);
Zm = zeros(1,uvmax);
mx = xxyz + [dx/2;Zm];
my = yxyz + [dy/2;Zm];
mz = zxyz + [dz/2;Zm];

% From floor(midpoints) determine the hit voxels, the corresponding path
% lengths and the index of the ray (=row)
voxels = floor(mz)*m*n + floor(my)*m + floor(mx) + 1;
voxels(voxels>m*n*k) = NaN;
rows   = Imod/(mnk3)+1;
vals   = [d;Zm];
isHit  = isfinite(voxels(:));
voxels = voxels(isHit);
vals   = vals(isHit);
rows   = rows(isHit);

% If asked for, also compute and return the intersection coordinates
if nargout > 3
    nonNaNs = ~isnan(xxyz);
    xxyz = xxyz(nonNaNs);
    yxyz = yxyz(nonNaNs);
    zxyz = zxyz(nonNaNs);
end