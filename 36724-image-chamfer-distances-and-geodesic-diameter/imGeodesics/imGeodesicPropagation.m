function res = imGeodesicPropagation(img, varargin)
%IMGEODESICPROPAGATION Compute geodesic propagation for each foreground pixel
%
%   RES = imGeodesicPropagation(IMG);
%   IMG is a binary image. For each foreground pixel, the geodesic
%   progagation is defined as the maximum geodesic distance to another
%   pixel of the foreground. If the foreground is not connected this
%   distance equals infinity.
%
%   RES = imGeodesicPropagation(IMG, WEIGHTS);
%   use different weights for the computation of distances. See
%   imChamferDistance for further details.
%
%   Note:
%   As the algorithm propagates geodesic distances from each foreground
%   pixel, the computation time may be expensive.
%
%
%   Example 
%     % Compute geodesic propagation in a L-shape
%     img = zeros(20, 20);
%     img(4:16, 4:9) = 1;
%     img(11:16, 4:16) = 1;
%     prop = imGeodesicPropagation(img);
%     imagesc(prop);
%     colormap([1 1 1 ; jet]);
%
%     % Compute geodesic propagation in a set of particles
%     prop = zeros(size(img));
%     lbl = bwlabel(img);
%     for i=1:max(lbl(:))
%         prop = max(prop, imGeodesicPropagation(lbl==i));
%     end
%     imagesc(prop);
%     colormap([1 1 1 ; jet]);
%
%   See also
%   imGeodesics, imChamferDistance, imGeodesicRadius, imGeodesicExtremities
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2009-05-22,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2009 INRA - Cepia Software Platform.

img = img>0;
res = zeros(size(img));

dim = size(img);
for i=1:dim(1)
    for j=1:dim(2)
        if ~img(i,j)
            continue;
        end
        
        marker = false(size(img));
        marker(i,j) = true;
        
        dist = imChamferDistance(img, marker, varargin{:});
        res(i,j) = max(dist(img));
    end
end
