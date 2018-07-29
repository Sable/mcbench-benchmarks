function [xg, yg, tg, region] = gradients_xyt(image1, image2, varargin)
%GRADIENTS_XYT Estimate spatial and temporal grey-level gradients
%   [XG, YG, TG, REGION] = GRADIENTS_XYT(IMAGE1, IMAGE2, SIGMAS) carries
%   out Gaussian smoothing and differencing to estimate the spatial and
%   temporal grey-level gradients for a pair of images.
%
%   IMAGE1 and IMAGE2 are 2D arraysof class double. They must be the same
%   size as each other, representing successive images in a sequence.
%
%   SIGMAS specifies the spatial smoothing. This may be a matrix of the
%   form [SIGMAX SIGMAY] or a scalar specifying the values of both SIGMAX
%   and SIGMAY. SIGMAX and SIGMAY are the "sigma" parameters of the 1D
%   Gaussian masks used for smoothing along the rows and columns
%   respectively. (Smoothing along a row means smoothing across columns -
%   i.e. the mask is a row vector.) A value of 0 indicates no smoothing is
%   required.
%
%   XG and YG are estimates of the spatial gradients, computed by smoothing
%   the average of the two input images and finding symmetric local
%   differences. TG is the smoothed difference between the two images.
%
%       The output arrays will be smaller than the input arrays in order to
%       avoid having to make unreliable assumptions near the boundaries of
%       the array. The result REGION reports the region of the input arrays
%       for which the gradients have been estimated, in the form [MINROW,
%       MAXROW, MINCOL, MAXCOL]. The size of the output arrays is
%       [MAXROW-MINROW+1, MAXCOL-MINCOL+1]. The reduction in size depends
%       on the smoothing parameters.
%
%   [XG, YG, TG, REGION] = GRADIENTS_XYT(IM1, IM2, SIGMAS, REGION) allows a
%   region of interest to be specified. REGION may be a 4-element row
%   vector with elements [MINROW, MAXROW, MINCOL, MAXCOL] describing a
%   rectangular region. The results arrays will have size [MAXROW-MINROW+1,
%   MAXCOL-MINCOL+1] and will contain the estimated gradients for the
%   specified region of the input images. The REGION argument is returned
%   unchanged. An empty REGION specifies the default described above.
%
%       It is possible to specify a region which goes right up to
%       the boundaries of the image, or even goes outside it. In these
%       cases reflection at the boundaries will be used to extrapolate the
%       image in any directions in which it does not wrap round.
%
%   [XG, YG, TG, REGION] = GRADIENTS_XYT(IM1, IM2, SIGMAS, 'same')
%   specifies that the output arrays should be the same size as the input
%   array. Boundary reflection is used to extend the input arrays prior to
%   smoothing, except on axes that are wrapped.
%
%   REGION = GRADIENTS_XYT(IM1, IM2, SIGMAS, 'region') returns only the
%   default region, without computing the gradients.
%
%   [XG, YG, TG, REGION] = GRADIENTS_XYT(IM1, IM2, SIGMAS, REGION, WRAP)
%   can be used to specify that the image wraps round on one or more axes.
%   WRAP may be a logical 1x2 matrix of the form [WRAPX WRAPY] or a logical
%   scalar which specifies both WRAPX and WRAPY. If WRAPX is true the rows
%   of the images wrap round; if WRAPY is true the columns wrap round. If
%   the rows/columns wrap, the number of columns/rows will not be reduced
%   by default in the output arrays. An empty WRAP is the same as omitting
%   it or setting it to false. REGION may have any of the values described
%   above.
% 
%     Example:
%     
%         im1 = double(rgb2gray(imread('office_1.jpg')))/256;
%         im2 = double(rgb2gray(imread('office_2.jpg')))/256;
%         [xg, yg, tg] = gradients_xyt(im1, im2, 4, 'same');

% Copyright David Young 2011

% check arguments and get defaults
[sigmas, wraps, region, regonly] = checkinputs(image1, image2, varargin{:});

% can stop now if only the region to be returned
if regonly
    xg = region;
    return;
end
    
% expand the region to allow for subsequent differencing operation
regdiff = region + [-1 1 -1 1];

% region selection and spatial smoothing (do this before sum and difference
% to reduce processing if region is small)
imsmth1 = gsmooth2(image1, sigmas, regdiff, wraps);
imsmth2 = gsmooth2(image2, sigmas, regdiff, wraps);

% Hor and vert differencing masks - use [1 0 -1]/2 to get the average
% gradient over 2 pixels, and divide by 2 again to replace sum by average.
imsum = imsmth1 + imsmth2;
dmask = [1 0 -1]/4;
xg = conv2(imsum, dmask, 'valid');
xg = xg(2:end-1, :);
yg = conv2(imsum, dmask.', 'valid');
yg = yg(:, 2:end-1);

% temporal differencing
tg = imsmth2 - imsmth1;
tg = tg(2:end-1, 2:end-1);

end

% -------------------------------------------------------------------------

function [sigmas, wraps, region, regonly] = checkinputs( ...
    image1, image2, sigmas, region, wraps)
% Check arguments and get defaults

error(nargchk(3, 5, nargin, 'struct'));

% most attributes checked in gsmooth, so do not check here
if ~isequal(size(image1), size(image2))
    error('gradients_xyt:badsize', 'Size of image2 does not match image1');
end

if nargin < 5 || isempty(wraps)
    wraps = false(1,2);
elseif isscalar(wraps)
    wraps = [wraps wraps];
end

if nargin < 4
    region = [];
end
regonly = strcmp(region, 'region');
if isempty(region) || regonly
    % default region - small enough not to need extrapolation
    region = gsmooth2(image1, sigmas, 'region', wraps);
    region = region + ~wraps([2 2 1 1]) .* [1 -1 1 -1];
elseif strcmp(region, 'same')
    region = [1 size(image1,1) 1 size(image1,2)];
end
if any(region([2 4]) < region([1 3]))
    error('gradients_xyt:badreg', 'REGION or array size too small');
end

end

