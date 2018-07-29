%==========================================================================
% [Saliency_Map, Feature_Maps, ICA_Maps, img, SUN] = Run_SUN(img, SUN)
% returns the SUN Saliency Map of img as well as other useful quantities.
%
% Input:    img is a color (preferably) or black and white image.
%           SUN (optional) is a structure containing SUN's parameters.
%
% Output:   Saliency_Map is a saliency map created out of ICA responses
%               using the SUN framework.
%           Feature_Maps contains ICA filter responses nonlinearly
%               weighted by their statistical frequency.
%           ICA_Maps contains the ICA filter responses with the sign
%               discarded.
%           img is the image after being preprocessed.
%           SUN is a structure that contains SUN's parameters.
%
% Note:     If you are making subsequent calls to this function, pass
%           an empty array to SUN and then use the returned version. This
%           will substantially speed up the function.
%
% Example:  img = imread('wpeppers.jpg');figure;
%           subplot(1, 4, 1);imagesc(img);title('Original Image');axis off;
%           [Saliency_Map, Feature_Maps, ICA_Maps, img] = ...
%               Run_SUN(img, []);
%           subplot(1, 4, 2);imagesc(img);title('Preprocessed Image');
%           axis off;
%           subplot(1, 4, 3);imagesc(Saliency_Map);title('Saliency Map');
%           axis off;subplot(1, 4, 4);imagesc(mean(Feature_Maps, 3));axis off;
%           title('Mean Feature Map');
%
%
% Author:   Christopher Kanan (chriskanan@gmail.com)
%
% Cite as:  Kanan, C. & Cottrell, G. W. (2010). Robust classification of
%             objects, faces, and flowers using natural image Statistics.
%             In Proceedings of the IEEE Conference on Computer Vision
%             and Pattern Recognition (CVPR), 2010.
%==========================================================================
function [Saliency_Map, Feature_Maps, ICA_Maps, img, SUN] = Run_SUN(img, SUN, max_filters, img_size, skip_preprocessing)

%set up default parameters
if ~exist('img_size', 'var')
    img_size = 128; %default canonical image size
end

pad_image = false;
use_probit = false; %keep false in general for more discriminability
approx_gammainc = true; %makes the algorithm much faster

if nargin == 0
    img = imread('wpeppers.jpg');
    orig = img;
    img_size = 192;
end


if ~exist('img', 'var')
    error('No image was passed to SUN_RICA.');
end

if ~exist('SUN', 'var') || isempty(SUN)
    SUN = load('SUN.mat');
    if isfield(SUN, 'SUN')
        SUN = SUN.SUN;
    end
end

if ~exist('max_filters', 'var')
    max_filters = inf;
end
Num_Filters = min(SUN.Num_Filters, max_filters);

if approx_gammainc && isempty(SUN.Filters(1).Inc_Gamma_List_X)
    %this takes a few seconds, but only needs to be repeated once as long
    %as you use the returned SUN structure on subsequent function calls
    for f = 1:Num_Filters
        x_max = SUN.Filters(f).x_max;
        x_inc = SUN.Filters(f).x_inc;
        SUN.Filters(f).Inc_Gamma_List_X = single(0:x_inc:x_max)';
        SUN.Filters(f).Inc_Gamma_List_Y = single(gammainc(SUN.Filters(f).Inc_Gamma_List_X, 1 ./ SUN.Theta(f), 'lower'));
    end
end

%preprocess the image to make it into the "canonical" size
if ~exist('skip_preprocessing', 'var') || ~skip_preprocessing
    img = Preprocess_Image(img, img_size);
end

Filters = SUN.Filters;

Filt_Size = size(Filters(1).R, 1);
half_filt = Filt_Size / 2;
if pad_image
    img = padarray(img, [half_filt, half_filt], 'both', 'replicate');
end

[SY, SX, SZ] = size(img);
prec = 'single';

%subtract chanel means
R = img(:, :, 1) - SUN.Channel_Mean(1);
G = img(:, :, 2) - SUN.Channel_Mean(2);
B = img(:, :, 3) - SUN.Channel_Mean(3);


%prepare image for FFT
FFT_R = fftn(R);
FFT_G = fftn(G);
FFT_B = fftn(B);

%prepare filters for FFT
for f = 1:Num_Filters
    if isempty(Filters(f).FFT_R) || size(Filters(f).FFT_R, 1) ~= SY || size(Filters(f).FFT_R, 2) ~= SX
        Filt_Size = size(Filters(f).R, 1);
        Filters(f).FFT_R = zeros(size(img, 1), size(img, 2), prec);
        Filters(f).FFT_G = zeros(size(img, 1), size(img, 2), prec);
        Filters(f).FFT_B = zeros(size(img, 1), size(img, 2), prec);
        
        Filters(f).FFT_R(1:Filt_Size, 1:Filt_Size) = fliplr(flipud(Filters(f).R));
        Filters(f).FFT_G(1:Filt_Size, 1:Filt_Size) = fliplr(flipud(Filters(f).G));
        Filters(f).FFT_B(1:Filt_Size, 1:Filt_Size) = fliplr(flipud(Filters(f).B));
        
        Filters(f).FFT_R = fftn(Filters(f).FFT_R);
        Filters(f).FFT_G = fftn(Filters(f).FFT_G);
        Filters(f).FFT_B = fftn(Filters(f).FFT_B);
    end
end

Filt_Size = size(Filters(1).R, 1);
shape_flag = 'valid';

if strcmpi(shape_flag, 'valid')
    deduct = Filt_Size;
else
    deduct = 0;
end

%pre-allocate memory for speed
ICA_Maps = zeros(SY - deduct, SX - deduct, Num_Filters, prec);
Feature_Maps = zeros(SY - deduct, SX  - deduct, Num_Filters, prec);
SUN_Maps = zeros(SY  - deduct, SX  - deduct, Num_Filters, prec);

[SY, SX, SZ] = size(Feature_Maps);

%get the filter responses
inv_theta = 1 ./ SUN.Theta(f);
for f = 1:Num_Filters
    theta = SUN.Theta(f);
    sigma = SUN.Sigma(f);
    
    %do FFT filtering
    filt_resp = (ifftn(Filters(f).FFT_R .* FFT_R + Filters(f).FFT_G .* FFT_G + Filters(f).FFT_B .* FFT_B, 'symmetric'));
    filt_resp = filt_resp(Filt_Size+1:end, Filt_Size+1:end);
    filt_resp = abs(single(filt_resp));
    if deduct == 0
        filt_resp = imresize(filt_resp, [SY, SX], 'nearest');
    end
    
    filt_resp = filt_resp / max(filt_resp(:));    
    ICA_Maps(:, :, f) = filt_resp;   
    filt_resp = (filt_resp ./  sigma) .^ theta;
    SUN_Maps(:, :, f) = filt_resp;
    
    if ~approx_gammainc
        R_Map = gammainc(filt_resp, inv_theta(f), 'lower');
    else
        Yi = qinterp1c(Filters(f).Inc_Gamma_List_X, Filters(f).Inc_Gamma_List_Y, filt_resp);
        R_Map = reshape(Yi, [SY, SX]);
    end
    
    %R_Map = R_Map ./ max(abs(R_Map(:)));    
    Feature_Maps(:, :, f) = R_Map;
end

if use_probit
    Feature_Maps = norminv(Feature_Maps);
end

Feature_Maps(~isfinite(Feature_Maps)) = 0;

Saliency_Map = sum(SUN_Maps, 3);

Saliency_Map = double(Saliency_Map);

%this actually alters the saliency map, but I do it here for numerical purposes
Saliency_Map = Saliency_Map - min(Saliency_Map(:));
Saliency_Map = Saliency_Map ./ max(Saliency_Map(:));

%some filtering to smooth the saliency map
sz = 9;
h = fspecial('gaussian', sz, sz / 2);
Saliency_Map = imfilter(Saliency_Map, h, 'conv');
Saliency_Map = exp(Saliency_Map - log(sum(exp(Saliency_Map(:)))));

SUN.Filters = Filters;

if nargin == 0
    figure;
    subplot(1, 2, 1)
    imagesc(orig);
    title('Input Image');
    axis off
    subplot(1, 2, 2);
    imagesc(Saliency_Map);
    axis off;
    title('Saliency Map');    
    img = [];
    Saliency_Map = [];
    Feature_Maps = [];
    ICA_Maps = [];
    SUN = [];
end


return;

%==========================================================================
% This function converts to LMS space and applies the log nonlinearity to
% to the image.
%
% Author:   Christopher Kanan (chriskanan@gmail.com)
%==========================================================================
function img = Preprocess_Image(img, img_size)

do_smoothing = true;

img = single(img);
if max(img(:) > 1)
    img = img ./ 255;
end

if do_smoothing
    %this helps with our noisy JPEG images, and is similar to some
    %computations done in the retina
    sz_per = 0.03;
    sz = max(floor(sz_per*min(size(img, 1), size(img, 2))), 3);
    sz = sz + (mod(sz, 2) == 0);h = fspecial('gaussian', sz, 1);
    img = imfilter(img, h, 'same');
end


if ndims(img) == 2 %handle grayscale images by making them color
    img = repmat(img, [1, 1, 3]);
end

img = SRGB2LMS(img); %convert from sRGB to LMS color space

[sy, sx, sz] = size(img);
rescale_factor = img_size / min(sy, sx);
img = imresize(img, round([sy, sx]*rescale_factor));

img = min(max(img, 0), 1); %bicubic interpolation can make some values greater than 1 or less than 0

%normalize image
img = img - min(img(:));
img = img ./ max(img(:));
%img = min(max(img, 0), 1); %should do nothing

%now log nonlinearity
C = 0.005; %arbitrary choice
%img_log = (log((img + C) ./ C)) ./ (log((1 + C) ./ C)); %output is in [0,1]
img_log = (log(img + C) - log(C)) ./ (log(1 + C) - log(C));
img_log = max(img_log, 0); %in case of numerical issues

img = img_log;

img(isnan(img)) = 0; %This should never be needed


%==================================================================
% This function converts from the default standard RGB color space
% to LMS color space, which approximates the response of
% human cone photoreceptors
%
% Input: A color image in SRGB color space, the default using
% imread(.), either as an NxMx3 matrix or as a (N*M)x3 matrix where
% each column represent a color channel
%
% Output: The image in LMS color space
%
% Example:  This will do nothing, since the functions are inverses,
%           peppers = imread('wpeppers.jpg');
%           figure;
%           subplot(1, 3, 1);imshow(peppers);
%           title('Original (SRGB)');
%           subplot(1, 3, 2);imshow(SRGB2LMS(peppers));
%           title('LMS Space');
%           subplot(1, 3, 3);imshow(LMS2SRGB(SRGB2LMS(peppers)));
%           title('Invert back to SRGB space')
%
% Author: Christopher Kanan (chriskanan@gmail.com)
%==================================================================
function LMS_Feat = SRGB2LMS(RGB_Feat)

XYZ_RGB = [0.4124, .3576, .1805; 0.2126, 0.7152, 0.0722; 0.0193, 0.1192, 0.9505];
XYZ_RGB = XYZ_RGB ./ repmat(sum(XYZ_RGB, 2), [1, 3]);
LMS_XYZ = [0.7328, 0.4296, -0.1624; -0.7036, 1.6975, 0.0061; 0.0030, 0.0136, 0.9834];
LMS_RGB = LMS_XYZ * XYZ_RGB; %CIECAM02


%see if we need to reshape the values
if size(RGB_Feat, 3) == 3 || size(RGB_Feat, 2) ~= 3
    is_image = true;
    [sy, sx, sz] = size(RGB_Feat);
    R = RGB_Feat(:, :, 1);
    G = RGB_Feat(:, :, 2);
    B = RGB_Feat(:, :, 3);
    RGB_Feat = [R(:), G(:), B(:)];
else
    is_image = false;
end
RGB_Feat = single(RGB_Feat);

% normalize:
if any(RGB_Feat(:) > 1)
    RGB_Feat = RGB_Feat ./ 255;
end

% remove sRGB gamma nonlinearity:
mask = RGB_Feat <= 0.04045;
RGB_Feat(mask) = RGB_Feat(mask) ./ 12.92;
RGB_Feat(~mask) = ((RGB_Feat(~mask) + 0.055) ./ 1.055) .^ 2.4;

%now do the conversion
LMS_Feat = (LMS_RGB * RGB_Feat')';

LMS_Feat = max(LMS_Feat, 0);
LMS_Feat = min(LMS_Feat, 1);

%turn back into an image if necessary
if is_image
    L = reshape(LMS_Feat(:, 1), [sy, sx]);
    M = reshape(LMS_Feat(:, 2), [sy, sx]);
    S = reshape(LMS_Feat(:, 3), [sy, sx]);
    LMS_Feat = zeros(sy, sx, 3, 'single');
    LMS_Feat(:, :, 1) = L;
    LMS_Feat(:, :, 2) = M;
    LMS_Feat(:, :, 3) = S;
end

%This is used for nearest neighbor interpolation
function Yi = qinterp1c(x,Y,xi)

% Forces vectors to be columns
x = x(:); xi = xi(:);
sx = size(x); sY = size(Y);
if sx(1)~=sY(1)
    if sx(1)==sY(2)
        Y = Y';
    else
        error('x and Y must have the same number of rows');
    end
end

% Gets the x spacing
warning('off');
ndx = 1/(x(2)-x(1)); % one over to perform divide only once
warning('on');
if x(1) ~= 0
    xi = xi - x(1);      % subtract minimum of x
end

rxi = round(xi*ndx)+1;        % indices of nearest-neighbors
len = length(x);
rxi(rxi < 1) = 1;
rxi(rxi > len) = len;
Yi = Y(rxi, :);
