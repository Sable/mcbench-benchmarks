function cmap = cold(m)
%COLD    Black-Blue-Cyan-White Color Map
%   COLD(M) returns an M-by-3 matrix containing a "cold" colormap
%   COLD, by itself, is the same length as the current figure's
%   colormap. If no figure exists, MATLAB creates one.
%
%   Example:
%       imagesc(peaks(500))
%       colormap(cold); colorbar
%
%   Example:
%       load topo
%       imagesc(0:360,-90:90,topo), axis xy
%       colormap(cold); colorbar
%
% See also: hot, cool, jet, hsv, gray, copper, bone, vivid
%
% Author: Joseph Kirk
% Email: jdkirk630@gmail.com
% Release: 1.0
% Date: 04/21/09

if nargin < 1
    m = size(get(gcf,'colormap'),1);
end
n = fix(3/8*m);

r = [zeros(2*n,1); (1:m-2*n)'/(m-2*n)];
g = [zeros(n,1); (1:n)'/n; ones(m-2*n,1)];
b = [(1:n)'/n; ones(m-n,1)];

cmap = [r g b];



