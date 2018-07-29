function A = circ(r, dim, centerCoord)
% Matlab function to return a generalized circular/elliptical mask for a 
%   desired radius (or radii for an ellipse), array size, an center 
%   location.
%
% By:   Christopher C. Wilcox, PhD
%       Naval Research Laboratory
%       Feb 3, 2012
%
% Usage:	A = circ(r, [dim], [centerCoord]);
%	Input:    
%		- r is the radius of circle in the mask (can be 2 element 
%			vector to give ellipse
%       - dim (Optional) is a 2 element vector of the desired returned 
%			array (Default = [128 128])
%       - centerCoord (Optional) is a 2 element vector of the desired 
%			center location of the circle (Default is center of the mask)
%	Output:
%		- A is the binary circular mask
%
% Examples:
%       A = circ(35) will return a circle mask array with a circle of
%           radius 35. Default array size is 128x128 with a central 
%           location at the middle of the array
%
%       A = circ([35 90], [800 600], [300 250]) will return an ellipse mask 
%           array of 800x600 with a radii of 35 and 90 with a center 
%           location of (300, 250)

if nargin == 0
    error('Not enough input arguments.');
elseif nargin == 1
    if ~isscalar(r) || length(r) ~= 2
        error('Radius input argument must be a scalar for a circle or a 2 element array for an ellipse.'); 
    end
    dim = [128 128];
    centerCoord = dim/2;
elseif nargin == 2
    if length(dim) ~= 2
        error('Dimension input argument must be a 2 element array.');
    end
    centerCoord = dim/2;
elseif nargin == 3
    if length(centerCoord) ~= 2
        error('Dimension input argument must be a 2 element array.');
    end
elseif nargin > 3
    error('Too many input arguments.');
end

if isscalar(r)
    a = r;
    b = r;
else 
    a = r(2);
    b = r(1);
end

xSize = dim(2);
ySize = dim(1);
x1 = centerCoord(2);
y1 = centerCoord(1);

[x, y] = meshgrid(-(x1 - 1):(xSize - x1), -(y1 - 1):(ySize - y1));
A = (((x/a).^2 + (y/b).^2) <= 1);