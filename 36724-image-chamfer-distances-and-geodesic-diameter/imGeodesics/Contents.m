% IMGEODESICS Geodesic distances in images
% Version 1.1 04-Apr-2011 .
%
%   Some functions for computing distance function in images, and computing
%   geodesic parameters.
%
%   The base function is 'imChamferDistance'. It propagates distances from
%   a set of markers, using a mask to constrain the propagation. Chamfer
%   distances are used as approximation of euclidean distances.
%
%   Using Chamfer distance propagation, it is possible to compute geodesic
%   distances and geodesic path between two markers in a particle.
%
%   It is also possible to compute morphological parameters, such as the
%   geodesic length or the geodesic radius. For some parameters, an
%   exhaustive search is performed, making the computation time rather
%   high.
%
%
% Distance propagation
%   imChamferDistance     - Compute chamfer distance using scanning algorithm
%   imGeodesicPath        - Compute a geodesic path between two markers in an image
%   imMaxGeodesicPath     - Find a path in a region with maximal geodesic length
%   imGeodesicDistance    - Compute geodesic distance between 2 markers
%
% Geodesic parameters
%   imGeodesicDiameter    - Compute geodesic diameter of particles
%   imGeodesicCenter      - Compute geodesic center of a binary particle
%   imGeodesicExtremities - Compute geodesic extremities of a binary particle
%   imGeodesicRadius      - Compute the geodesic radius of a binary particle
%   imGeodesicPropagation - Compute geodesic propagation for each foreground pixel
%
% Validation
%   chamferDistanceError  - Compute relative error of chamfer distance with euclidean
%
%
% ----
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% created:  2011-04-01.
% Copyright INRA - Cepia Software Platform.
% http://www.pfl-cepia.inra.fr/index.php?page=imGeodesics

% deprecated
%   geodesicLength        - Compute geodesic length of particles
