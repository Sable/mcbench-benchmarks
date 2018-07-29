function B = thresholdLocally(A, blksz, varargin)
% Performs LOCAL Otsu thresholding on an image; user can specify blocksize
%
% SYNTAX: B = thresholdLocally(A,PV_Pairs)
%
% THRESHOLDLOCALLY processes an image, calling graythresh on LOCAL
% blocks in an image. This facilitates easy thresholding of images with
% uneven background illumination, for which global thresholding is
% inadequate. Uses the Image Processing Toolbox function BLOCKPROC
% (R2009b).
%
% INPUTS:
%    A:   Any image (or path/name of an image) suitable for processing
%         with im2bw()
%
%    BLKSZ: Blocksize ([M,N]) with which to process the image.
%           DEFAULT: [32 32]
%
%    (OPTIONAL):
%    PV_Pairs: Any valid parameter-value pairs accepted by blockproc.
%           DEFAULTS:
%             'BorderSize':       [6 6]
%             'PadPartialBlocks': true
%             'PadMethod':        'replicate'
%             'TrimBorder':       true
%             'Destination':      [NOT SPECIFIED] (See BLOCKPROC for usage)
%    FudgeFactor: As an additional PV_Pair, one may enter:
%             'FudgeFactor',       value (DEFAULT = 1),
%              You may provide a scalar multiplier for the local value
%              returned by graythresh.
%
% OUTPUT:
%    B:     Output image (Unless 'DESTINATION' output is specified.)
%
% USAGE NOTE: To specify any PV_Pairs, BLKSZ must be provided as the second
% input. If the default value of blksz is desired, an empty bracket ([]) may be
% provided. (See Example 3.)
%
% EXAMPLES:
%
% % NOTE: All examples use image 'rice.png', which ships with the Image
% %       Processing Toolbox.
%
% img = imread('rice.png');
%
% % EXAMPLE 1) Default usage:
% thresholded = thresholdLocally(img);
% imshow(thresholded)
%
% % EXAMPLE 2) Specifying non-default blocksize:
% thresholded = thresholdLocally(img,[16 16]);
%
% % EXAMPLE 3) Specifying non-default padmethod (using default blocksize):
% thresholded = thresholdLocally(img,[],'PadMethod','symmetric');
%
% % EXAMPLE 4) Comparing and local thresholding, and thresholding after
% %            background normalization using tophat filtering:
% figure
% subplot(2,2,1);imshow(img);title('Original Image');
% tmp = im2bw(img,graythresh(img));
% subplot(2,2,2);imshow(tmp);title('Globally Thresholded');
% tmp = imtophat(img,strel('disk',15));
% tmp = im2bw(tmp,graythresh(tmp));
% subplot(2,2,3);imshow(tmp);title('Globally Thresholded after Tophat')
% tmp = thresholdLocally(img);
% subplot(2,2,4);imshow(tmp);title('Locally Thresholded');
%
% Written by Brett Shoelson, PhD.
% 12/17/2010
% Modifications:
% * 12/20/2010   Modified significantly to accept as optional inputs all
%   parameter-value pairs accepted by BLOCKPROC, as well as an additional
%   "fudge factor" parameter that allows one to scale the local graythresh
%   value by a scalar multiple.
% * 02/08/2011   Modified default blocksize to that calculated by bestblk
%
% Copyright 2010 The MathWorks
%
% See also: blockproc, graythresh, im2bw

if ~nargin
    error('THRESHOLDLOCALLY: Requires at least one input argument.')
end

if ischar(A)
    A = imread(A);
end

% DEFAULTS
% M                = 32;
% N                = 32;
[M, N] = bestblk(size(A));
opts.BorderSize  = [6 6];
opts.PadPartialBlocks = true;
opts.PadMethod   = 'replicate';
opts.TrimBorder  = true;
opts.Destination = [];
opts.FudgeFactor = 1;

if nargin > 1 && ~isempty(blksz)
    if numel(blksz) == 1
        M = blksz; N = M;
    elseif numel(blksz) == 2
        M = blksz(1);N = blksz(2);
    else
        error('THRESHOLDLOCALLY: Improper specification of blocksize parameter');
    end
end

if nargin > 2
    opts = parsePV_Pairs(opts,varargin);
end

fun = @(block_struct) im2bw(block_struct.data,...
    min(max(opts.FudgeFactor*graythresh(block_struct.data),0),1));

if isempty(opts.Destination)
    B = blockproc(A,[M N],fun,...
        'BorderSize',opts.BorderSize,...
        'PadPartialBlocks',opts.PadPartialBlocks,...
        'PadMethod',opts.PadMethod,...
        'TrimBorder',opts.TrimBorder);
else
    B = [];
    blockproc(A,[M N],fun,...
        'BorderSize',opts.BorderSize,...
        'PadPartialBlocks',opts.PadPartialBlocks,...
        'PadMethod',opts.PadMethod,...
        'TrimBorder',opts.TrimBorder,...
        'Destination',opts.Destination);
end

end

function opts = parsePV_Pairs(opts,UserInputs)
    ind = find(strcmpi(UserInputs,'BorderSize'));
    if ~isempty(ind)
        opts.BorderSize = UserInputs{ind + 1};
    end
    ind = find(strcmpi(UserInputs,'PadPartialBlocks'));
    if ~isempty(ind)
        opts.PadPartialBlocks = UserInputs{ind + 1};
    end
    ind = find(strcmpi(UserInputs,'PadMethod'));
    if ~isempty(ind)
        opts.PadMethod = UserInputs{ind + 1};
    end
    ind = find(strcmpi(UserInputs,'TrimBorder'));
    if ~isempty(ind)
        opts.TrimBorder = UserInputs{ind + 1};
    end
    ind = find(strcmpi(UserInputs,'Destination'));
    if ~isempty(ind)
        opts.Destination = UserInputs{ind + 1};
    end
    ind = find(strcmpi(UserInputs,'FudgeFactor'));
    if ~isempty(ind)
        opts.FudgeFactor = UserInputs{ind + 1};
    end
end
