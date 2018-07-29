function [imgOut, hist] = matchHistograms(img1,img2,varargin)
% Match the histogram of image1 to that of image 2.
%
% [imOut, hist] = matchHistograms(img1,img2,nbins)
% 
% INPUTS:
%     img1:   the image to modify
%     img2:   the image whose histogram is to be matched
%     nbins:  number of histogram bins (Default: 255 for grayscale, 2 for
%             binary.)
% 
% OUTPUTS: 
%     imgOut: the histogram-matched image
%     hist:   the histogram of the output image. For color images, if the
%             second argument is requested, it will be returned in a
%             cell array. 
%
% USAGE: this function works on two grayscale, two binary, or two color
% images. For color images, the number of color planes must match (i.e.,
% size(img1,3) must match size(img2,3).
%
% EXAMPLES:
%%% 1)
%  img1 = imread('cameraman.tif');
%  img2 = imread('liftingbody.png');
%  [imOut,hist] = matchHistograms(img1,img2);
%  figure
%  subplot(2,3,1);imshow(img1); title('Original');
%  subplot(2,3,2);imshow(img2); title('Target');
%  subplot(2,3,3);imshow(imOut);title('Histogram-matched')
%  subplot(2,3,4);imhist(img1)
%  subplot(2,3,5);imhist(img2)
%  subplot(2,3,6);imhist(imOut)
%  
%%% 2) 
%  imOut = matchHistograms('gantrycrane.png','peppers.png');
%  figure
%  subplot(1,3,1);imshow('gantrycrane.png'); title('Original');
%  subplot(1,3,2);imshow('peppers.png'); title('Target');
%  subplot(1,3,3);imshow(imOut);title('Histogram-matched')
%
% Written by Brett Shoelson, PhD
% brett.shoelson@mathworks.com
% 4/28/10
% Copyright MathWorks, 2010.
%
% SEE ALSO: imhist, histeq

% Validate inputs
iptchecknargin(2,3,nargin,mfilename);
iptcheckinput(img1,{'numeric','logical','char'},{''}, mfilename,'img1',1);
iptcheckinput(img2,{'numeric','logical','char'},{''}, mfilename,'img2',2);
if ischar(img1)
    img1 = imread(img1);
end
if ischar(img2)
    img2 = imread(img2);
end

if (~strcmp(class(img1),class(img2))) || (size(img1,3)~=size(img2,3))
    error('matchHistograms: Image classes and sizes must match!')
end

if islogical(img1), nbins = 2; else nbins = 256; end
if nargin == 3
    nbins = varargin{1};
end

imgOut = zeros(size(img1),class(img1));
for ii = 1:size(img1,3)
    % Calculate the histogram of the second image
    hist = imhist(img2(:,:,ii),nbins);
    % Apply histogram to first image
    imgOut(:,:,ii) = histeq(img1(:,:,ii),hist);
end

if nargout > 1
    if size(img1,3) ~= 1
        hist = cell(size(img1,3),1);
        for ii = 1:size(img1,3)
            hist{ii} = imhist(imgOut(:,:,ii),nbins);
        end
    else
        hist = imhist(imgOut,nbins);
    end
else
    clear hist
end