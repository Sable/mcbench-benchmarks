function varargout = imHistogram(img, varargin)
%IMHISTOGRAM  Histogram of 2D/3D grayscale or color images
%
%   Usage 
%   H = imHistogram(IMG);
%   imHistogram(IMG);
%
%   Description
%   H = imHistogram(IMG);
%   Compute the histogram of the image IMG. IMG can be a 2D or 3D image.
%   The number of bins is computed automatically depending on image type
%   for integer images, and on image min/max values for floating-point
%   images.
%   If IMG is a color image, the result is a N-by-3 array, containing
%   histograms for the red, green and blue bands in each column.
%
%   H = imHistogram(..., N);
%   Specifies the number of histogram bins. N must be a scalar>0.
%
%   H = imHistogram(..., [GMIN GMAX]);
%   Specifies the gray level extents. This can e especially useful for
%   images stored in float, or for images with more than 256 gray levels.
%
%   H = imHistogram(..., []);
%   Forces the function to compute the histogram limits from values of
%   image gray levels.
%
%   H = imHistogram(..., BINS);
%   Specifies the bin centers.
%
%   H = imHistogram(..., ROI);
%   where ROI is a binary image the same size as IMG, computes the
%   histogram only for pixels/voxels located inside of the specified region
%   of interest.
%
%   [H X] = imHistogram(...);
%   Returns the center of bins used for histogram computation.
%
%   imHistogram(IMG);
%   When called with no output argument, displays the histogram on the 
%   current axis.
%
%
%   Examples
%   % Histogram of a grayscale image (similar to imhist)
%     img = imread('cameraman.tif');
%     imHistogram(img);
%
%   % RGB Histogram of a color image
%     img = imread('peppers.png');
%     imHistogram(img);
%
%   % Compute histogram of a 3D image, only for pixel with non null values
%   % (requires image processing toolbox)
%     info = analyze75info('brainMRI.hdr');
%     X = analyze75read(info);
%     imHistogram(X, X>0, 0:88)
%
%   See also
%   imhist, hist
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-01-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% HISTORY
% 2010-09-10 code cleanup, update doc


%% Initialise default parameters

% check if image is color
colorImage = size(img, 3)==3;

% compute intensity bounds, based either on type or on image data
if isinteger(img)
    type = class(img);
    minimg = intmin(type);
    maximg = intmax(type);
else
    minimg = min(img(:));
    maximg = max(img(:));
end

% default number of histogram bins
N = 256;

% default roi is empty
roi = [];


%% Process inputs 

% process each argument
while ~isempty(varargin)
    var = varargin{1};
    
    if isempty(var)
        % if an empty variable is given, assumes gray level bounds must be
        % recomputed from image values
        minimg = min(img(:));
        maximg = max(img(:));
    elseif isnumeric(var) && length(var)==1
        % argument is number of bins
        N = var;
    elseif isnumeric(var) && length(var)==2
        % argument is min and max of values to compute
        minimg = var(1);
        maximg = var(2);
    elseif islogical(var)
        % argument is a ROI
        roi = var;
    elseif isnumeric(var)
        % argument is value for histo bins
        x = var;
        minimg = var(1);
        maximg = var(end);
        N = length(x);
    end
    
    % remove processed argument from the list
    varargin(1) = [];
end

% compute bin centers if they were not specified
if ~exist('x', 'var')
    x = linspace(double(minimg), double(maximg), N);
end


%% Main processing 

% compute image histogram
if ~colorImage
    % process 2D or 3D grayscale image
    h = calcHistogram(img, x, roi);
else
    % process color image: compute histogram of each channel
    h = zeros(length(x), 3);
    if ndims(img)==3
        % process 2D color image
        for i=1:3
            h(:, i) = calcHistogram(img(:,:,i), x, roi);
        end        
    else
        % process 3D color image
        for i=1:3
            h(:, i) = calcHistogram(img(:,:,i,:), x, roi);
        end
    end
end


%% Process output arguments

% In case of no output argument, display the histogram
if nargout==0
    % display histogram in current axis
    if ~colorImage
        % Display grayscale histogram
        bar(gca, x, h, 'hist');
        % use jet color to avoid gray display
        colormap jet;
    else
        % display each color histogram as stairs, to see the 3 curves
        hh = stairs(gca, x, h);
        
        % setup curve colors
        set(hh(1), 'color', [1 0 0]); % red
        set(hh(2), 'color', [0 1 0]); % green
        set(hh(3), 'color', [0 0 1]); % blue
    end
    
    % setup histogram bounds
    xlim([minimg maximg]);
    
elseif nargout==1
    % return histogram
    varargout = {h};
elseif nargout==2
    % return histogram and x placement
    varargout = {h, x};
elseif nargout==3
    % return red, green and blue histograms as separate outputs
    varargout = {h(:,1), h(:,2), h(:,3)};
elseif nargout==4
    % return red, green and blue histograms as separate outputs as well as
    % the bin centers
    varargout = {h(:,1), h(:,2), h(:,3), x};
end


%% Utilitary functions

function h = calcHistogram(img, x, roi)
% Compute image histogram using specified bins, and eventually a region of
% interest
if isempty(roi)
    % histogram of whole image
    h = hist(double(img(:)), x);
else
    % histogram constrained to ROI
    h = hist(double(img(roi)), x);
end    


