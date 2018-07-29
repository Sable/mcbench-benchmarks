function path = imGeodesicPath(img, source, target, varargin)
%IMGEODESICPATH Compute a geodesic path between two markers in an image
%
%   PATH = imGeodesicPath(MASK, SOURCE, TARGET)
%   Computea minimal geodesic-distance path between the two markers SOURCE
%   and TARGET. Both SOURCE and TARGET can be either a binary image the
%   same size as MASK, or a N-by-2 array containing a list of coordinates
%   (x first, y second).
%   The result PATH is a P-by-2 array containing coordinates of a polyline
%   with minimal geodesic length starting from one of the points specified
%   by SOURCE, and terminating at one of the points specified by TARGET.
%   Note that the result is not uniquely defined, and the returned solution
%   is one of the possible solutions. 
%
%   PATH = imGeodesicPath(..., WEIGHTS)
%   Specify the weights to use for propagating chamfer distance. Default is
%   [3 4], as suggested by Borgefors.
%
%   PATH = imGeodesicPath(..., 'verbose', V)
%   Specify the verbosity. V can be either TRUE or FALSE.
%
%   
%   Example
%     % read circle image, and create 2 markers 
%     img = imread('circles.png');
%     imshow(img); hold on;
%     p1 = [130 130]; % (x1,y1)
%     p2 = [170 170]; % (x2,y2)
%     plot(p1(1), p1(2), 'bo');
%     plot(p2(1), p2(2), 'ro');
%     % Compute and display the path as a polyline
%     path = imGeodesicPath(img, p1, p2);
%     plot(path(:,1), path(:,2), 'color', 'm', 'linewidth', 2);
%
%   See also
%   imGeodesics, imChamferDistance, imMaxGeodesicPath
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-04-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Default values 

% weights for computing geodesic lengths
ws = [3 4];

% no verbosity by default
verbose = 0;


%% process input arguments

% extract weights if present
if ~isempty(varargin)
    if isnumeric(varargin{1})
        ws = varargin{1};
        varargin(1) = [];
    end
end

% Extract options
while ~isempty(varargin)
    paramName = varargin{1};
    if strcmpi(paramName, 'verbose')
        verbose = varargin{2};
    else
        error(['Unkown option in imGeodesicLength: ' paramName]);
    end
    varargin(1:2) = [];
end

% forces input image to binary
img = img > 0;


%% Propagate distance from destination markers

% initialize marker image
if sum(size(target) == size(img)) == 2
    % initialize from binary mask
    markers = target > 0;
    
else
    % initialize from set of points
    markers = false(size(img));
    for i = 1:size(target, 1)
        markers(target(i,2), target(i,1)) = true;
    end
end

% compute distance map from marker
dist = imChamferDistance(img, markers, ws, 'verbose', verbose);


%% Find position of first source point 

% find position of closest point belonging to the source
if sum(size(source) == size(img)) == 2
    % compute in a binary mask
    [minDist ind] = min(dist(source));
    [ys xs] = ind2sub(size(source), ind);
    
else
    % initialize from set of points
    minDist = inf;
    for i = 1:size(source, 1)
        value = dist(source(i,2), source(i,1));
        if value < minDist
            xs = source(i,1);
            ys = source(i,2);
            minDist = value;
        end
    end
end

% check existence of path
if isempty(minDist)
    warning([mfilename ':NoPathFound'], ...
        'No path could be found between the two markers');
    path = [];
    return;
end


%% Create the path by returning to destination marker

% add a 1-pixel wide border around image, initialized with very high value
tmp = dist;
dist = zeros(size(dist)+2, class(dist));
dist(:) = max(tmp(:)) + 2;
dist(2:end-1, 2:end-1) = tmp;

% keep coordinates of geodesic extremity
x = xs + 1;
y = ys + 1;

% initialize path
path = [x y];

while true
    % check around current point
    neigh = dist(y-1:y+1, x-1:x+1);
    
    % look for the minimum
    [mini ind] = min(neigh(:));
    
    % if minimum is the same as current value, minima is found
    if mini == dist(y, x)
        break;
    end
    
    % convert index to sub
    [iy ix] = ind2sub([3 3], ind(1));
    
    % update coord
    x = x + ix - 2;
    y = y + iy - 2;
    
    % stores result
    path = [path; x y]; %#ok<AGROW>
end

% subtract 1, because of border
path = path - 1;
