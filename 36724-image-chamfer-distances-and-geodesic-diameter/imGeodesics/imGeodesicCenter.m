function center = imGeodesicCenter(img, varargin)
%IMGEODESICCENTER Compute geodesic center of a binary particle
%
%   RES = imGeodesicCenter(IMG);
%   IMG is a binary image representing a connected particle. The result RES
%   is a binary image with foreground pixels corresponding to the geodesic
%   center of the particle. The geodesic center is the set of pixels in the
%   particle whose geodesic propagation equal the particle geodesic radius.
%
%   RES = imGeodesicCenter(IMG, WEIGHTS);
%   use different weights for the computation of distances. See
%   imChamferDistance for further details.
%
%   Note:
%   As the algorithm propagates geodesic distances from each foreground
%   pixel, the computation time may be expensive.
%
%
%   See also
%   imGeodesics, imChamferDistance, imGeodesicRadius, imGeodesicPropagation
%   imGeodesicDiameter, imGeodesicExtremities
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2009-05-22,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2009 INRA - Cepia Software Platform.

propag = imGeodesicPropagation(img, varargin{:});
minVal = min(propag(img));
center = propag == minVal;