function smoothedImg=smoothImg(img,segma)
% Convolving an image with a Gaussian kernel.

% The degree of smoothing is determined by the Gaussian's standard
% deviation 'segma'. The Gaussian outputs a 'weighted average' of each
% pixel's neighborhood, with the average weighted more towards the value of
% the central pixels. The larger the standard deviation, the less weight
% towards the central pixels and more weight towards the pixels away, hence
% heavier blurring effect and less details in the output image.
%
% Author: Mohd Kharbat at Cranfield Defence and Security
% mkharbat(at)ieee(dot)org , http://mohd.kharbat.com
% Published under a Creative Commons Attribution-Non-Commercial-Share Alike
% 3.0 Unported Licence http://creativecommons.org/licenses/by-nc-sa/3.0/
%
% October 2008

if nargin<2
    segma=1;
end

G=gaussFilter(segma);
smoothedImg=conv2(img,G,'same');
smoothedImg=conv2(smoothedImg,G','same');