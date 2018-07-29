function out = flattenMaskOverlay(img, mask, varargin)
% FLATTENMASKOVERLAY  Create a flattened image with overlayed mask (with transparency)
%  FLATTENMASKOVERLAY(IMG, MASK) applies a MASK (defined as logical) on top
%     of the original IMG and displays the result in the current axes. The
%     mask (locations of 1's) will be displayed as a red color with 50%
%     opacity. The resulting image will be a flat image (no use of
%     AlphaData), and therefore will have better interactive performance
%     (zooming, panning, data cursors). IMG must be MxN (gray scale) or
%     MxNx3 (RGB). Supported data types are double, uint8, uint16. MASK
%     must be an MxN logical array.
%
%  FLATTENMASKOVERLAY(IMG, MASK, ALPHALEVEL, OVERLAYCOLOR) specifies the
%     opacity level and the overlay color of the mask. ALPHALEVEL must be a
%     scalar between 0 to 1. Pass in [] for default (0.5). OVERLAYCOLOR can
%     be a string indicating the color (see list below) or a 1x3 double
%     array (0 to 1) representing the RGB values. Default is red.
%            b     blue
%            g     green
%            r     red
%            c     cyan
%            m     magenta
%            y     yellow
%            k     black
%            w     white
%
%  IM = FLATTENMASKOVERLAY(IMG, MASK, ...) returns the image data without
%     displaying the image.
%
%  Example:
%     load mandrill
%     rgb = ind2rgb(X, map);
%
%     subplot(2, 2, 1);
%     image(rgb); axis image off; title('Original image');
%
%     subplot(2, 2, 2);
%     % try to segment out the nose
%     mask = rgb(:, :, 1) > 0.8 & rgb(:, :, 2) < 0.3 & rgb(:, :, 3) < 0.3;
%     image(mask); colormap(gray(2)); axis image off; title('Mask image');
%
%     subplot(2, 2, 3);
%     flattenMaskOverlay(rgb, mask, [], 'g');
%     title('Green mask with 50% opacity');
%     
%     subplot(2, 2, 4);
%     flattenMaskOverlay(rgb, mask, 1, 'g');
%     title('Green mask with 100% opacity');

% Jiro Doke
% v1.0 - Nov 2011 
% v1.1 - Nov 2011. Bug in default alphaLevel and typo in example.
%
% Copyright 2011 The MathWorks, Inc.

%%

% Default alpha level
DEFAULT_ALPHA = 0.5;

% Default overlay color
DEFAULT_COLOR = [1 0 0];

% Image size
sz = size(img);

%% Input Validation
p = inputParser();
p.addRequired('img', @isvalidImageData);
p.addRequired('mask', @(x) isvalidMaskData(x, sz));
p.addOptional('alphaLevel', DEFAULT_ALPHA, @(x) ...
    assert(isempty(x) || ...
    (isa(x, 'double') && numel(x) == 1 && x >= 0 && x <= 1), ...
    sprintf('%s:InvalidAlphaLevel', mfilename), ...
        '''alphaLevel'' must be a scalar between [0, 1]'));
p.addOptional('overlayColor', DEFAULT_COLOR, @(x) ...
    validateattributes(x, {'char', 'double'}, {'2d'}));

p.parse(img, mask, varargin{:});

img = p.Results.img;
mask = p.Results.mask;
alphaLevel = p.Results.alphaLevel;
overlayColor = p.Results.overlayColor;

if isempty(alphaLevel)
    alphaLevel = DEFAULT_ALPHA;
end

if ischar(overlayColor)
    switch lower(overlayColor)
        case {'y','yellow'}
            overlayColor = [1 1 0];
        case {'m','magenta'}
            overlayColor = [1 0 1];
        case {'c','cyan'}
            overlayColor = [0 1 1];
        case {'r','red'}
            overlayColor = [1 0 0];
        case {'g','green'}
            overlayColor = [0 1 0];
        case {'b','blue'}
            overlayColor = [0 0 1];
        case {'w','white'}
            overlayColor = [1 1 1];
        case {'k','black'}
            overlayColor = [0 0 0];
        case {''}
            overlayColor = DEFAULT_COLOR;
        otherwise
            error(sprintf('%s:UnknownOverlayColor', mfilename), ...
                'Unknown overlayColor "%s".', overlayColor);
    end
else
    if isempty(overlayColor)
        overlayColor = DEFAULT_COLOR;
    end
    assert(isequal(size(overlayColor), [1 3]) && ...
        nnz(overlayColor < 0 | overlayColor > 1) == 0, ...
        sprintf('%s:InvalidOverlayColor', mfilename), ...
        '''overlayColor'' must be a 1x3 array between [0, 1]');
end

%% Create overlay
rMask = mask * overlayColor(1);
gMask = mask * overlayColor(2);
bMask = mask * overlayColor(3);

[img_r, img_g, img_b] = getDoubleRGB(img);

% Red plane
tmp = img_r + (rMask - img_r) * alphaLevel;
img_r(mask) = tmp(mask);

% Blue plane
tmp = img_g + (gMask - img_g) * alphaLevel;
img_g(mask) = tmp(mask);

% Green plane
tmp = img_b + (bMask - img_b) * alphaLevel;
img_b(mask) = tmp(mask);

% Convert back to the original data type
if isa(img, 'double');
    finalImg = cat(3, img_r, img_g, img_b);
else
    finalImg = cast(cat(3, img_r, img_g, img_b) * ...
        double(intmax(class(img))), class(img));
end

if nargout == 0
    image(finalImg); axis image off
else
    out = finalImg;
end

end

%% Validate IMG
function tf = isvalidImageData(img)

tf = true;
validateattributes(img, {'double', 'uint8', 'uint16'}, {'nonempty'}, ...
    mfilename, 'img');

if isa(img, 'double')
    % Check that the values are between 0 and 1
    assert(nnz(img < 0 | img > 1) == 0, ...
        sprintf('%s:InvalidDoubleImageRange', mfilename), ...
        'Values in a double ''img'' must be between [0, 1].');

end

% IMG should be a 2D or an MxNx3 array
sz = size(img);
assert((numel(sz) == 2) || (numel(sz) == 3 && sz(3) == 3), ...
    sprintf('%s:InvalidImageSize', mfilename), ...
    'Size of ''img'' must be MxN or MxNx3.');

end

%% Validate MASK
function tf = isvalidMaskData(mask, sz)

tf = true;
thisSZ = size(mask);
assert(isequal(thisSZ, sz(1:2)), ...
    sprintf('%s:InvalidMaskSize', mfilename), ...
    'Size of ''mask'' must be %dx%d.', sz(1), sz(2));

end

%% Convert IMG to MxNx3 double array
function [r, g, b] = getDoubleRGB(img)

if ndims(img) == 2
    img = repmat(img, [1 1 3]);
end

if isa(img, 'double')
    newImg = img;
else
    newImg = double(img) / double(intmax(class(img)));
end
r = newImg(:, :, 1);
g = newImg(:, :, 2);
b = newImg(:, :, 3);

end