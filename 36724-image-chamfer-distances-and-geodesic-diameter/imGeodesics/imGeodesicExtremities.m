function center = imGeodesicExtremities(img, varargin)
%IMGEODESICEXTREMITIES Compute geodesic extremities of a binary particle
%
%   RES = imGeodesicExtremities(IMG);
%   IMG is a binary image representing a connected particle. The result RES
%   is a binary image with foreground pixels corresponding to the geodesic
%   extremities of the particle. The geodesic extremities are the pixels
%   belonging to the particle whose geodesic propagation equal the geodesic
%   length of the particle.
%
%   RES = imGeodesicExtremities(IMG, WEIGHTS);
%   use different weights for the computation of distances. See
%   imChamferDistance for further details.
%
%   Example
%   imGeodesicExtremities
%
%   Note:
%   As the algorithm propagates geodesic distances from each foreground
%   pixel, the computation time may be expensive.
%
%   See also
%   imGeodesics, imChamferDistance, imGeodesicPropagation
%   imGeodesicRadius, imGeodesicCenter, imGeodesicDiameter
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2009-05-22,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2009 INRA - Cepia Software Platform.

propag = imGeodesicPropagation(img, varargin{:});
maxVal = max(propag(img));
center = propag==maxVal;