function err = chamferDistanceError(weights, varargin)
%CHAMFERDISTANCEERROR Compute relative error of chamfer distance with euclidean
%
%   ERR = chamferDistanceError(WEIGHTS)
%
%   Example
%   chamferDistanceError(2, 3)
%   ans =
%       
%
%   See also
%   imGeodesics, imChamferDistance
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% extract weights
w1 = weights(1);
w2 = weights(2);

if w2 == 0
    w2 = 2*w1;
end

w3 = 0;
if length(weights)>2
    w3 = weights(3);
end
if w3 == 0
    w3 = w1 + w2;
end

% diagonal euclidean distance
d11e = hypot(w1, w1);

% relative error of diagonal approximation
err = 100*(w2-d11e)/d11e;


if ~isempty(varargin)
    % euclidean cavalier-step distance
    d21e = hypot(2*w1, w1);
    
    % approximation of cavalier-step distance
    err(2) = 100*(w3-d21e)/d21e;
end
