function outputImage = fcnFirstOrderStatisticsFilter(inputImage,mask)

% fcnFirstOrderStatisticsFilter performs noise filtering on an image based
%   on using First Order Local Statistics around a prespecified pixel
%   neighborhood.
%
%   OUTPUTIMAGE = fcnFirstOrderStatisticsFilter(INPUTIMAGE) performs
%   filtering of an image using the First Order Local statistics of the
%   gray-vales around each pixel. It uses a square neighborhood of 5x5
%   pixels to estimate the gray-level statistics in default settings.
%   Supported data type for INPUTIMAGE are uint8, uint16, uint32, uint64,
%   int8, int16, int32, int64, single, double. OUTPUTIMAGE has the same
%   image type as INPUTIMAGE.
%
%   OUTPUTIMAGE = fcnFirstOrderStatisticsFilter(INPUTIMAGE,MASK) performs
%   the filtering with local statistics computed based on the neighbors as
%   specified in the locical valued matrix MASK.
% 
%   Details of the method are avilable in
% 
%   J. S. Lee, "Digital image smoothing and sigma filter," Computer Vision,
%   Graphics and Image Processing, vol. 24, no. 2, pp. 255–269, 1983. 
%   [http://dx.doi.org/10.1016/0734-189X(83)90047-6]
%
%   This implementation is based on information available in
%
%   D. Sheet, S. Pal, A. Chakraborty, J. Chatterjee, A.K. Ray, 
%   "Image quality assessment for performance evaluation of despeckle 
%   filters in Optical Coherence Tomography of human skin," 
%   2010 IEEE EMBS Conf. Biomedical Engineering and Sciences (IECBES), 
%   pp.499-504, Nov. 30 2010 - Dec. 2 2010
%   [http://dx.doi.org/10.1109/IECBES.2010.5742289] 
%
%   D. Sheet, S. Pal, A. Chakraborty, J. Chatterjee, A.K. Ray,
%   "Visual importance pooling for image quality assessment of despeckle 
%   filters in Optical Coherence Tomography," 2010 Intl. Conf. Systems in 
%   Medicine and Biology (ICSMB), pp.102-107, 16-18 Dec. 2010
%   [http://dx.doi.org/10.1109/ICSMB.2010.5735353] 
%
%   2010 (c) Debdoot Sheet, Indian Institute of Technology Kharagpur, India
%       Ver 1.0     20 October 2010
%       Ver 2.0     13 October 2011
%           Rev 1.0 15 December 2011
%
% Example
% -------
% inputImage = imnoise(imread('cameraman.tif'),'speckle',0.01);
% outputImage1 = fcnFirstOrderStatisticsFilter(inputImage);
% outputImage2 = ...
% fcnFirstOrderStatisticsFilter(inputImage,getnhood(strel('disk',3,0)));
% figure, subplot 131, imshow(inputImage), subplot 132,
% imshow(outputImage1), subplot 133, imshow(outputImage2)
%

% 2010 (c) Debdoot Sheet, Indian Institute of Technology Kharagpur, India
% All rights reserved.
% 
% Permission is hereby granted, without written agreement and without 
% license or royalty fees, to use, copy, modify, and distribute this code 
% (the source files) and its documentation for any purpose, provided that 
% the copyright notice in its entirety appear in all copies of this code, 
% and the original source of this code. Further Indian Institute of 
% Technology Kharagpur (IIT Kharagpur / IITKGP)  is acknowledged in any
% publication that reports research or any usage using this code. The 
% implementation of the work is to be cited using the bibliography as
% 
%   D. Sheet, S. Pal, A. Chakraborty, J. Chatterjee, A.K. Ray, 
%   "Image quality assessment for performance evaluation of despeckle 
%   filters in Optical Coherence Tomography of human skin," 
%   2010 IEEE EMBS Conf. Biomedical Engineering and Sciences (IECBES), 
%   pp.499-504, Nov. 30 2010 - Dec. 2 2010
%   [http://dx.doi.org/10.1109/IECBES.2010.5742289] 
%
%   D. Sheet, S. Pal, A. Chakraborty, J. Chatterjee, A.K. Ray,
%   "Visual importance pooling for image quality assessment of despeckle 
%   filters in Optical Coherence Tomography," 2010 Intl. Conf. Systems in 
%   Medicine and Biology (ICSMB), pp.102-107, 16-18 Dec. 2010
%   [http://dx.doi.org/10.1109/ICSMB.2010.5735353]
% 
% In no circumstantial cases or events the Indian Institute of Technology
% Kharagpur or the author(s) of this particular disclosure be liable to any
% party for direct, indirectm special, incidental, or consequential 
% damages if any arising out of due usage. Indian Institute of Technology 
% Kharagpur and the author(s) disclaim any warranty, including but not 
% limited to the implied warranties of merchantability and fitness for a 
% particular purpose. The disclosure is provided hereunder "as in" 
% voluntarily for community development and the contributing parties have 
% no obligation to provide maintenance, support, updates, enhancements, 
% or modification.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Input argument check
iptcheckinput(inputImage,{'uint8','uint16','uint32','uint64','int8','int16','int32','int64','single','double'}, {'nonsparse','2d'}, mfilename,'I',1);

if nargin == 1
    mask = getnhood(strel('square',5));
elseif nargin == 2
    if ~islogical(mask)
        error('Mask of neighborhood specified must be a logical valued matrix');
    end
else
    error('Unsupported calling of fcnFirstOrderStatisticsFilter');
end

imageType = class(inputImage);

windowSize = size(mask);

inputImage = padarray(inputImage,[floor(windowSize(1)/2) floor(windowSize(2)/2)],'symmetric','both');

inputImage = double((inputImage));

[nRows,nCols] = size(inputImage);

localMean = zeros([nRows nCols]);
localVar = zeros([nRows nCols]);
k = zeros(nRows,nCols);

for i=ceil(windowSize(1)/2):nRows-floor(windowSize(1)/2)
    for j=ceil(windowSize(2)/2):nCols-floor(windowSize(2)/2)
        localNeighborhood = inputImage(i-floor(windowSize(1)/2):i+floor(windowSize(1)/2),j-floor(windowSize(2)/2):j+floor(windowSize(2)/2));
        localNeighborhood = localNeighborhood(mask);
        localMean(i,j) = mean(localNeighborhood(:));
        localVar(i,j) = var(localNeighborhood(:));
    end
end

localNoiseVar = localVar(ceil(windowSize(1)/2):nRows-floor(windowSize(1)/2),ceil(windowSize(2)/2):nCols-floor(windowSize(2)/2))./(localMean(ceil(windowSize(1)/2):nRows-floor(windowSize(1)/2),ceil(windowSize(2)/2):nCols-floor(windowSize(2)/2))+eps);
globalNoiseVar = sum(localNoiseVar(:));

k(ceil(windowSize(1)/2):nRows-floor(windowSize(1)/2),ceil(windowSize(2)/2):nCols-floor(windowSize(2)/2)) = (1-((localMean(ceil(windowSize(1)/2):nRows-floor(windowSize(1)/2),ceil(windowSize(2)/2):nCols-floor(windowSize(2)/2)).^2).*(localVar(ceil(windowSize(1)/2):nRows-floor(windowSize(1)/2),ceil(windowSize(2)/2):nCols-floor(windowSize(2)/2))))./(localVar(ceil(windowSize(1)/2):nRows-floor(windowSize(1)/2),ceil(windowSize(2)/2):nCols-floor(windowSize(2)/2))*(1+globalNoiseVar)));

outputImage = (localMean(ceil(windowSize(1)/2):nRows-floor(windowSize(1)/2),ceil(windowSize(2)/2):nCols-floor(windowSize(2)/2))+(k(ceil(windowSize(1)/2):nRows-floor(windowSize(1)/2),ceil(windowSize(2)/2):nCols-floor(windowSize(2)/2)).*(inputImage(ceil(windowSize(1)/2):nRows-floor(windowSize(1)/2),ceil(windowSize(2)/2):nCols-floor(windowSize(2)/2))-localMean(ceil(windowSize(1)/2):nRows-floor(windowSize(1)/2),ceil(windowSize(2)/2):nCols-floor(windowSize(2)/2)))));

outputImage = cast(outputImage,imageType);