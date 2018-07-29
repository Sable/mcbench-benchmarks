function radius = imGeodesicRadius(img, varargin)
%IMGEODESICRADIUS Compute the geodesic radius of a binary particle
%
%   RES = imGeodesicRadius(IMG);
%   IMG is a binary image. The geodesic radius is defined as the minimum of
%   the geodesic propagation for the pixels belonging to the particle.
%
%   RES = imGeodesicRadius(IMG, WEIGHTS);
%   use different weights for the computation of distances. See
%   imChamferDistance for further details.
%   
%   Note:
%   As the algorithm propagates geodesic distances from each foreground
%   pixel, the computation time may be expensive.
%
%   Example
%     img = false(10, 30);
%     img(2:9, 2:9) = 1;
%     img(3:8, 12:28) = 1;
%     res = imGeodesicRadius(img)
%     res = 
%         5.6569
%         9.2426
%
%   See also
%   imGeodesics, imChamferDistance, imGeodesicPropagation
%   imGeodesicExtremities, imGeodesicCenter, imGeodesicDiameter
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2009-05-22,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2009 INRA - Cepia Software Platform.


%   HISTORY
%   2009/09/01 allow computation for several particles

% switch between image types
if islogical(img)
    img = bwlabeln(img);
end

% number of structures in image
n = max(img(:));

% allocate memory
radius = zeros(n, 1);

% iterate on particle labels
for i = 1:n
    % create image for current particle
    im = img==i;
    if sum(im(:)) == 0
        continue;
    end
    
    % compute geodesic propagation
    propag = imGeodesicPropagation(im, varargin{:});
    
    % compute geodesic radius
    radius(i) = min(propag(im));
end
