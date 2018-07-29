function dist = imChamferDistance(img, varargin)
%IMCHAMFERDISTANCE  Compute chamfer distance using scanning algorithm
%
%   RES = imChamferDistance(IMG, MARKERS);
%   where IMG and MARKERS are binary images, computes for each foreground
%   pixel the minimum distance to the marker, using a path that is
%   contained in the foreground. If the markers can not be reached from a
%   foreground pixel, the corresponding result is Inf.
%   The function propagates distances to orthogonal and diagonal pixels,
%   using weights equal to 1 for orthogonal pixels, and sqrt(2) for
%   diagonal markers. The result RES is given in a double array the same
%   size as IMG.
%
%   The function uses scanning algorithm. Each iteration consists in a
%   sequence of a forward and a backward scan. Iteration stops when
%   stability is reached.
%
%   RES = imChamferDistance(IMG);
%   Assumes the marker image is given by the complement of the image IMG.
%   In this case, the behaviour is similar to the functin bwdist.
%
%   RES = imChamferDistance(..., WEIGHTS);
%   Specifies different weights for computing distance between 2 pixels.
%   WEIGHTS is a 2 elements array, with WEIGHTS(1) corresponding to the
%   distance between two orthonal pixels, and WEIGHTS(2) corresponding to
%   the distance between two diagonal pixels.
%   Possible choices
%   WEIGHTS = [1 sqrt(2)]   -> quasi-euclidean distance (default)
%   WEIGHTS = [1 Inf]       -> "Manhattan" or "cityblock" distance
%   WEIGHTS = [1 1]         -> "Chessboard" distance
%   WEIGHTS = [3 4]         -> Borgerfors' weights
%   WEIGHTS = [5 7]         -> close approximation of sqrt(2)
%
%   Note: when specifying weights, the result has the same class/data type
%   than the array of weights. It is possible to balance between speed and
%   memory usage:
%   - if weights are double (the default), the memory usage is high, but
%       the result can be given in pixel units 
%   - if weights are integer (for Borgefors weights, for example), the
%       memory usage is reduced, but representation limit of datatype can
%       be easily reached. One needs to divide by the first weight to get
%       result comparabale with natural distances.
%       For uint8, using [3 4] weigths, the maximal computable distance is
%       around 255/3 = 85 pixels. Using 'int16'  seems to be a good
%       tradeoff, the maximal distance with [3 4] weights is around 11000
%       pixels.
%
%   RES = imChamferDistance(..., 'verbose', true);
%   Displays info on iterations.
%
%   Example
%   % computes distance function inside a complex particle
%     img = imread('circles.png');
%     marker = false(size(img));
%     marker(80, 80) = 1;
%     % compute using quasi-enclidean weights
%     dist = imChamferDistance(img, marker);
%     figure; imshow(dist, []);
%     colormap(jet); title('Quasi-euclidean distance');
%     % compute using integer weights, giving integer results
%     dist34 = imChamferDistance(img, marker, int16([3 4]));
%     figure; imshow(double(dist34)/3, [0 max(dist34(img))/3]);
%     colormap(jet); title('Borgefors 3-4 weights');
%
%
%   % uses the examples from bwdist with different distances
%     img = ones(255, 255);
%     img(126, 126) = 0;
%     res1 = imChamferDistance(img);
%     res2 = imChamferDistance(img, [1 inf]);
%     res3 = imChamferDistance(img, [1 1]);
%     res4 = imChamferDistance(img, [1 1.5]);
%     figure;
%     subplot(221); subimage(mat2gray(res1));
%     hold on; imcontour(res1); title('quasi-euclidean');
%     subplot(222); subimage(mat2gray(res2));
%     hold on; imcontour(res2); title('city-block');
%     subplot(223); subimage(mat2gray(res3));
%     hold on; imcontour(res3); title('chessboard');
%     subplot(224); subimage(mat2gray(res4));
%     hold on; imcontour(res4); title('approx euclidean');
%
%   
%   See also
%   imGeodesics, bwdist, imGeodesicDistance
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2009-05-19,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2009 INRA - Cepia Software Platform.

%   HISTORY
%   2010.08.25 fix memory allocation for large images, add vebosity option


%% Process input arguments


% extract markers if they are given as parameter
markers = [];
if ~isempty(varargin)
    var = varargin{1};
    if sum(size(var)~=size(img))==0
        % use binarised markers
        markers = var>0;
        varargin(1) = [];
    end
end

% if the markers are not given, assumes they correspond to the complement
% of the image
if isempty(markers)
    markers = img==0;
end


% default weights for orthogonal or diagonal
w1 = 1;
w2 = sqrt(2);

% extract user-specified weights
if ~isempty(varargin)
    var = varargin{1};
    varargin(1) = [];
    w1 = var(1);
    w2 = var(2);
    % small check up to avoid degenerate cases
    if w2 == 0
        w2 = 2*w1;
    end
end


% extract verbosity option
verbose = false;
if length(varargin)>1
    varName = varargin{1};
    if ~ischar(varName)
        error('unknown option');
    end
    if strcmpi(varName, 'verbose')
        verbose = varargin{2};
    else
        error(['unknown option: ' varName]);
    end
end


%% Initialisations

% determines type of output from type of weights
outputType = class(w1);

% shifts in directions i and j for (1) forward and (2) backward iterations
di1 = [-1 -1 -1 0];
dj1 = [-1 0 1 -1];
di2 = [+1 +1 +1 0];
dj2 = [-1 0 1 +1];
ws =  [w2 w1 w2 w1];

% binarisation of mask image
mask = img>0;

% allocate memory for result
dist = ones(size(mask), outputType);

% init result: either max value, or 0 for marker pixels
if isinteger(w1)
    dist(:) = intmax(outputType);
else
    dist(:) = inf;
end
dist(markers) = 0;

% size of image
[D1 D2] = size(img);


%% Iterations until no more changes

% apply forward and backward iteration until no more changes are made
modif = true;
nIter = 1;
while modif
    modif = false;
    
    %% Forward iteration
    
    if verbose
        disp(sprintf('Forward iteration %d', nIter)); %#ok<DSPS>
    end
    
    % Process first line
    for j=2:D2
        if mask(1, j)
            newVal = dist(1,j);
            newVal = min(newVal, dist(1, j-1)+w1);     % left pixel
            if newVal~=dist(1,j)
                modif = true;
                dist(1,j) = newVal;
            end
        end
    end
    
    % iteration on lines
    for i=2:D1
        % special processing for first pixel of the line
        if mask(i, 1)
            newVal = dist(i, 1);
            newVal = min(newVal, dist(i-1, 1)+w1);     % top pixel
            newVal = min(newVal, dist(i-1, 2)+w2);     % top-left diag
            if newVal~=dist(i,1)
                modif = true;
                dist(i,1) = newVal;
            end
        end

        % process all pixels inside the current line
        for j=2:D2-1            
            % computes only for pixel inside structure
            if ~mask(i, j)
                continue;
            end
            
            % compute minimal propagated distance
            newVal = dist(i, j);
            for k=1:4
                newVal = min(newVal, dist(i+di1(k), j+dj1(k))+ws(k));
            end
            
            % if distance was changed, update result, and toggle flag
            if newVal~=dist(i,j)
                modif = true;
                dist(i,j) = newVal;
            end
        end
        
        % special processing for last pixel of the line
        if mask(i, D2)
            newVal = dist(i, D2);
            newVal = min(newVal, dist(i,   D2-1) + w1);  % left pixel
            newVal = min(newVal, dist(i-1, D2-1) + w2);  % top-left pixel
            newVal = min(newVal, dist(i-1, D2)   + w1);  % top pixel
            if newVal~=dist(i,D2)
                modif = true;
                dist(i,D2) = newVal;
            end
        end
        
    end % iteration on lines

    % check end of iteration
    if modif==false && nIter ~= 1;
        break;
    end
    
    %% Backward iteration
    modif = false;
    
    if verbose
        disp(sprintf('Backward iteration %d', nIter)); %#ok<DSPS>
    end
    
    % Process last image line
    for j=D2-1:-1:1
        if mask(D1, j)
            newVal = dist(D1,j);
            newVal = min(newVal, dist(D1, j+1)+w1);     % left pixel
            if newVal~=dist(D1,j)
                modif = true;
                dist(D1,j) = newVal;
            end
        end
    end
    
    for i=D1-1:-1:1
        % special processing for last pixel of the line
        if mask(i, D2)
            newVal = dist(i, D2);
            newVal = min(newVal, dist(i+1,   D2) + w1); % bottom pixel
            newVal = min(newVal, dist(i+1, D2-1) + w2); % bottom-left diag
            if newVal~=dist(i,D2)
                modif = true;
                dist(i,D2) = newVal;
            end
        end

        % process all pixels inside the current line
        for j=D2-1:-1:2
            % computes only for pixel inside structure
            if ~mask(i, j)
                continue;
            end
            
            % compute minimal propagated distance
            newVal = dist(i, j);
            for k=1:4
                newVal = min(newVal, dist(i+di2(k), j+dj2(k))+ws(k));
            end
            
            % if distance was changed, update result, and toggle flag
            if newVal~=dist(i,j)
                modif = true;
                dist(i,j) = newVal;
            end
        end
        
        % process last image line
        if mask(i, 1)
            newVal = dist(i, 1);
            newVal = min(newVal, dist(i,   2) + w1);  % right pixel
            newVal = min(newVal, dist(i+1, 2) + w2);  % bottom-right pixel
            newVal = min(newVal, dist(i+1, 1) + w1);  % bottom pixel
            if newVal~=dist(i,1)
                modif = true;
                dist(i,1) = newVal;
            end
        end
        
    end % line iteration
    
    nIter = nIter+1;
end % until no more modif
