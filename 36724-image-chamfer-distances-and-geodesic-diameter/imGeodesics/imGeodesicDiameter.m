function gl = imGeodesicDiameter(img, varargin)
%IMGEODESICDIAMETER Compute geodesic diameter of particles
%
%   GL = imGeodesicDiameter(IMG)
%   where IMG is a labeled image, returns the geodesic diameter of each
%   particle.
%   If IMG is a binary image, a labelling is performed first.
%   GL is a column vector containing the geodesic diameter of each particle.
%
%   A definition for the geodesic length can be found in the book from
%   Coster & Chermant: "Precis d'analyse d'images", Ed. CNRS 1989.
%
%   
%   GL = imGeodesicDiameter(IMG, WS)
%   Specifies the weights associated to neighbor pixels. WS(1) is the
%   distance to orthogonal pixels, and WS(2) is the distance to diagonal
%   pixels. Default is [3 4], recommended by Borgefors. The final length is
%   normalized by weight for orthogonal pixels.
%   
%   GL = imGeodesicDiameter(..., 'verbose', true);
%   Display some informations about the computation procedure, that may
%   take some time for large and/or complicated images.
%
%   These algorithm uses 3 steps:
%   * first propagate distance from particles boundary to find a pixel
%       approximately in the center of the particle(s)
%   * propagate distances from the center, and keep the furthest pixel,
%       which is assumed to be a geodesic extremity
%   * propagate distances from the geodesic extremity, and keep the maximal
%       distance.
%   This algorithm is less time-consuming than the direct approach that
%   consists in computing geodesic propagation and keeping the max value.
%   However, for some cases in can happen that the two methods give
%   different results.
%
%
%   Notes: 
%   * only planar images are currently supported.
%   * the particles are assumed to be 8 connected. If two or more particles
%       touch by a corner, the result will not be valid.
%   
%   Example
%   % segment and labelize image of grains, and compute their lengths
%     img = imread('rice.png');
%     img2 = img - imopen(img, ones(30, 30));
%     bin = imopen(img2 > 50, ones(3, 3));
%     lbl = bwlabel(bin);
%     lg = imGeodesicDiameter(lbl);
%     plot(lg, '+');
%
%
%   See Also
%   imGeodesics, imChamferDistance, imGeodesicExtremities
%   imGeodesicRadius, imGeodesicCenter, imMaxGeodesicPath
%
%
%   ---------
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 06/07/2005.
%

%   HISTORY 
%   10/08/2006 add support for 3D images
%   19/04/2007 update doc, allocate memory for result
%   20/05/2009 rewrite using chamfer distance (work now only for 2D)
%   24/08/2010 add comments, add verbosity option
%   15/09/2010 add a pass to detect center


%% Default values 

% weights for computing geodesic lengths
ws = [1 sqrt(2)];

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
        error(['Unkown option in imGeodesicDiameter: ' paramName]);
    end
    varargin(1:2) = [];
end

% make input image a label image if this is not the case
if islogical(img)
    if verbose
        disp('Labelling particles');
    end
    img = bwlabeln(img);
end

% number of structures in image
n = max(img(:));


%% Detection of center point (furthest point from boundary)

if verbose
    disp(sprintf('Computing geodesic length of %d particle(s).', n)); %#ok<*DSPS>
end

% create markers image
markers = ~img;

if verbose
    disp('Computing empirical centers.'); 
end

% computation of geodesic length from empirical markers
dist = imChamferDistance(img, markers, ws, 'verbose', verbose);



%% Second pass: find a geodesic extremity

% compute new seed point in each label, and use it as new marker
markers = false(size(img));
for i=1:n
    % find the pixel with greatest distance in current label
    [y x] = find(img==i);
    [maxVal ind] = max(dist(img==i)); %#ok<ASGLU>
    markers(y(ind), x(ind)) = true;
end

if verbose
    disp('Second step markers computations done.'); 
end

% recomputes geodesic distance from new markers
dist = imChamferDistance(img, markers, ws, 'verbose', verbose);


%% third pass: find second geodesic extremity

% compute new seed point in each label, and use it as new marker
markers = false(size(img));
for i=1:n
    % find the pixel with greatest distance in current label
    [y x] = find(img==i);
    [maxVal ind] = max(dist(img==i)); %#ok<ASGLU>
    markers(y(ind), x(ind)) = true;
end

if verbose
    disp('Third step markers computations done.'); 
end

% recomputes geodesic distance from new markers
dist = imChamferDistance(img, markers, ws, 'verbose', verbose);


%% Final computation of geodesic distances

% keep max geodesic distance inside each label
gl = zeros(n, 1);
for i=1:n
    % find the pixel with greatest distance in current label
    gl(i) = max(dist(img==i));
end

% format to have metric in pixels, and not a multiple of the weights
gl = double(gl)/double(ws(1));
