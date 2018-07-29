function varargout = vec2grid(varargin)
%VEC2GRID Grid 2D or 3D data without interpolation
%
% [xg, yg, vg] = vec2grid(x,y,v);
% [xg, yg, zg, vg] = vec2grid(x,y,z,v);
%
% This function reformats a list of 2-d or 3-d datpoints to a grid, similar
% to the results of the griddata function but without any interpolation.
% It reshapes the data using all unique x, y, and if applicable, z
% coordinates as rows, columns, and pages of the final data grid.
%
% Input variables:
%
%   x:  x coordinates of data points, vector
%
%   y:  y coordinates of data points, vector
%
%   z:  z coordinates of data points (optional, for 3D datasets only),
%       vector
%
%   v:  data value at each 2D or 3D location
%
% Output variables:
%
%   xg: unique x values in dataset, correspoding to columns of vg
%
%   yg: unique y values in dataset, corresponding to rows of vg
%
%   zg: unique z values in dataset, corresponding to pages (dim  3) of vg
%
%   vg: gridded dataset.  NaNs are used for missing values.
%
% Example:data
%
% [x,y] = meshgrid(1:5,0:2:6);
% x = x(:); y = y(:);
% holes = rand(size(x)) < .2;
% x(holes) = []; y(holes) = [];
% v = 1:length(x);
% [xg,yg,vg] = vec2grid(x,y,v)
% xg =
%      1
%      2
%      3
%      4
%      5
% yg =
%      0
%      2
%      4
%      6
% vg =
%      1   NaN   NaN   NaN    13
%      2     5     8    11    14
%      3     6     9   NaN    15
%      4     7    10    12    16

% Copyright 2008 Kelly Kearney

%-------------------------
% Check input
%-------------------------

error(nargchk(3, 4, nargin));

if ~all(cellfun(@isvector, varargin)) || any(diff(cellfun(@length, varargin)))
    error('Inputs must be vectors of the same length');
end

%-------------------------
% Check input
%-------------------------

if nargin == 3
    
    x = varargin{1};
    y = varargin{2};
    z = varargin{3};

    [xunique, blah, xidx] = unique(x);
    [yunique, blah, yidx] = unique(y);

    znew = nan(max(yidx),max(xidx));
    znew(sub2ind(size(znew), yidx, xidx)) = z;
    
    varargout = {xunique, yunique, znew};
    
elseif nargin == 4
    
    x = varargin{1};
    y = varargin{2};
    z = varargin{3};
    v = varargin{4};
    
    [xunique, blah, xidx] = unique(x);
    [yunique, blah, yidx] = unique(y);
    [zunique, blah, zidx] = unique(z);
    
    vnew = nan(max(zidx), max(yidx), max(xidx));
    vnew(sub2ind(size(vnew), zidx, yidx, xidx)) = v;
    
    varargout = {xunique, yunique, zunique, vnew};
    
end
    
    