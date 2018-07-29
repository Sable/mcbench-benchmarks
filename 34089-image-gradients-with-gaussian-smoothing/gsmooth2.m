function [im, reg] = gsmooth2(im, sigmas, varargin)
%GSMOOTH2 Gaussian image smoothing
%   [SMOOTH, REGION] = GSMOOTH2(IMAGE, SIGMAS) carries out Gaussian
%   smoothing on an image.
% 
%   IMAGE must be a 2-D array of class double.
%
%   SIGMAS specifies the smoothing constants. This may be a matrix of the
%   form [SIGMAX SIGMAY] or a scalar specifying the value of both SIGMAX
%   and SIGMAY. SIGMAX and SIGMAY are the "sigma" parameters of the 1D
%   Gaussian masks used for smoothing along the rows and columns
%   respectively. (Smoothing along a row means smoothing across columns -
%   i.e. the mask is a row vector.)
%
%       The output arrays will be smaller than the input arrays in order to
%       avoid having to extrapolate beyond the boundaries of the array. The
%       result REGION reports the region of the input arrays for which the
%       output values have been estimated, in the form [MINROW, MAXROW,
%       MINCOL, MAXCOL]. The size of the output array is [MAXROW-MINROW+1,
%       MAXCOL-MINCOL+1]. The reduction in size depends on the smoothing
%       parameters, and is chosen so that the smoothing masks are a good
%       approximation to the untruncated Gaussian mask.
%
%   [SMOOTH, REGION] = GSMOOTH2(IMAGE, SIGMAS, REGION) allows a region of
%   interest to be specified. REGION may be a 4-element row vector with
%   elements [MINROW, MAXROW, MINCOL, MAXCOL] describing a rectangular
%   region. The results arrays will have size [MAXROW-MINROW+1,
%   MAXCOL-MINCOL+1] and will contain the estimated gradients for the
%   specified region of the input images. REGION is returned unchanged as
%   the second result. An empty REGION produces the default behaviour
%   described above.
%
%       It is possible to specify a region which goes right up to the
%       boundaries of the image, or even goes outside it. In these cases
%       reflection at the boundaries will be used to extrapolate the image
%       in any directions in which it does not wrap round.
% 
%   [SMOOTH, REGION] = GSMOOTH2(IMAGE, SIGMAS, 'same') specifies that the
%   output array should be the same size as the input array. Boundary
%   reflection is used to extend the input array prior to smoothing, except
%   on axes that are wrapped.
%
%   REGION = GSMOOTH2(IMAGE, SIGMAS, 'region') returns only the default
%   region, without computing the gradients.
%
%   [SMOOTH, REGION] = GSMOOTH2(IMAGE, SIGMAS, REGION, WRAP) can be used to
%   specify that the image wraps round on one or more axes. WRAP may be a
%   logical 1x2 matrix of the form [WRAPX WRAPY] or a logical scalar which
%   specifies both WRAPX and WRAPY. If WRAPX is true the rows of the images
%   wrap round; if WRAPY is true the columns wrap round. If the
%   rows/columns wrap, the number of columns/rows will not be reduced by
%   default in the output array. An empty WRAP is the same as omitting it
%   or setting it to false. REGION may have any of the values described
%   above.
%
%   Example:
%
%       img = double(imread('pout.tif'));
%       imsmooth = gsmooth2(img, 4, 'same');

% Copyright David Young 2011

[sigmas, bcons, reg, convreg, ronly] = checkinputs(im, sigmas, varargin{:});

if ronly
    im = reg;
else
    if ~isempty(convreg)
        im = exindex(im, convreg(1):convreg(2), bcons{1}, ...
            convreg(3):convreg(4), bcons{2});
    end
    im = gsmooth1(im, 1, sigmas(1));
    im = gsmooth1(im, 2, sigmas(2));
end

end

% -------------------------------------------------------------------------

function [sigmas, bcons, reg, convreg, regonly] = ...
    checkinputs(im, sigmas, reg, wraps)
% Check arguments and get defaults, plus input/output convolution regions
% and boundary conditions

error(nargchk(2, 4, nargin, 'struct'));

% image argument
validateattributes(im, {'double'}, {'2d'});

% sigmas argument
validateattributes(sigmas, {'double'}, {'nonnegative'});
if isscalar(sigmas)
    sigmas = [sigmas sigmas];
elseif isequal(size(sigmas), [1 2])
    sigmas = sigmas([2 1]);   % xy -> row col
else
    error('gsmooth:badsigmas', 'SIGMAS wrong size');
end

% wraps argument
if nargin < 4 || isempty(wraps)
    wraps = [false false];
else
    validateattributes(wraps, {'logical'}, {});
    if isscalar(wraps)
        wraps = [wraps wraps];
    elseif isequal(size(wraps), [1 2])
        wraps = wraps([2 1]); % xy -> row col for exindex
    else
        error('gsmooth:badwraps', 'WRAPS wrong size');
    end
end
boundopts = {'symmetric' 'circular'};
bcons = boundopts(wraps+1);

% region argument
if nargin < 3
    reg = [];
end
regonly = strcmp(reg, 'region');

imreg = [1 size(im,1) 1 size(im,2)];   % whole image region
mrg = gausshsize(sigmas);  % convolution margins
mrg = [1 -1 1 -1] .* mrg([1 1 2 2]);
if isempty(reg) || regonly
    % default region - small enough not to need extrapolation - shrink on
    % non-wrapped dimensions
    reg = imreg + ~wraps([1 1 2 2]) .* mrg;
elseif strcmp(reg, 'same')
    reg = imreg;
else
    validateattributes(reg, {'double'}, {'real', 'integer', 'size', [1 4]});
end
if any(reg([2 4]) < reg([1 3]))
    error('gsmooth:badreg', 'REGION or array size too small');
end
% compute input region for convolution - expand on all dimensions
convreg = reg - mrg;    % expand
if isequal(convreg, imreg)
    convreg = [];   % signal no trimming or padding
end

end

% -------------------------------------------------------------------------

function im = gsmooth1(im, dim, sigma)
% Smooth an image IM along dimension DIM with a 1D Gaussian mask of
% parameter SIGMA

hsize = gausshsize(sigma);  % reasonable truncation

msize = [1 1];
msize(dim) = 2*hsize+1;

if sigma > 0
    mask = fspecial('gauss', msize, sigma);
    im = conv2(im, mask, 'valid');
end

end

% -------------------------------------------------------------------------

function hsize = gausshsize(sigma)
% Default for the limit on a Gaussian mask of parameter sigma.
% Produces a reasonable degree of truncation without too much error.
hsize = ceil(2.6*sigma);
end

