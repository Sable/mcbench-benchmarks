function path = imMaxGeodesicPath(img, varargin)
%IMMAXGEODESICPATH Find a path in a region with maximal geodesic length
%
%   PATH = imMaxGeodesicPath(IMG)
%   PATH = imMaxGeodesicPath(IMG, WEIGHTS)
%   IMG is a binary image, and WEIGHTS is the optional ponderation array
%   for orthogonal and diagonal pixels.
%   The result PATH is a N-by-2 array containing coordinates of the path
%   vertices. The set of vertices corresponds to a geodesic path within the
%   binary particle such that its length is maximal (using the metric
%   specificied by the weights).
%
%   Example
%   % Show maximal geodesic path on a complex particle
%     img = imread('circles.png');
%     imshow(img); hold on;
%     path = imMaxGeodesicPath(img);
%     plot(path(:,1), path(:,2), 'color', 'm', 'linewidth', 2);
%
%   % Compute the maximal geodesic path on several small particles
%     img = imread('rice.png');
%     img2 = img - imopen(img, ones(30, 30));
%     lbl = bwlabel(img2 > 50);
%     imshow(img); hold on;
%     for i=1:max(lbl(:))
%         path = imMaxGeodesicPath(lbl == i);
%         plot(path(:,1), path(:,2), 'color', 'g', 'linewidth', 2);
%     end
%
%   See also
%   imGeodesics, imGeodesicPath, imChamferDistance, imGeodesicDiameter
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-02-22,    using Matlab 7.9.0.529 (R2009b)
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


%% Initialization: find a point far enough from border

% extract coordinates of image pixels
[y x] = find(img);

% compute distance map from particle boundary
dist    = imChamferDistance(img, ws);

% index of "central" pixel, i.e. the furthest pixel from boundary
[maxVal ind] = max(dist(img)); %#ok<ASGLU>
ind = ind(1);


%% Step 1: find one of the geodesic extremities

% initialize marker image
markers = false(size(img));
markers(y(ind), x(ind)) = true;

% compute distance map from marker
dist = imChamferDistance(img, markers, ws, 'verbose', verbose);

% find index of furthest point
[maxVal ind] = max(dist(img)); %#ok<ASGLU>
ind = ind(1);


%% Step 2: find one of the opposite geodesic extremities

% initialize marker image
markers = false(size(img));
markers(y(ind), x(ind)) = true;

% compute distance map from marker
dist = imChamferDistance(img, markers, ws, 'verbose', verbose);

% find index of furthest point
[maxVal ind] = max(dist(img)); %#ok<ASGLU>
ind = ind(1);


%% Build path by iterating from geodesic extremity to minimum

% add a 1-pixel wide border around image, initialized with very high value
tmp = dist;
dist = zeros(size(dist)+2, class(dist));
dist(:) = max(tmp(:)) + 2;
dist(2:end-1, 2:end-1) = tmp;

% keep coordinates of geodesic extremity
x = x(ind) + 1;
y = y(ind) + 1;

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
