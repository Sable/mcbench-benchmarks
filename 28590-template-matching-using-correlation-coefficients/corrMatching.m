function [corrScore, boundingBox] = corrMatching(frameImg, templateImg, threshC)
% -------------------------------------------------------------------------
% Function corrMatching: Template Matching using Correlation Coefficients
% Inputs: 
%           frameImg = gray or color frame image
%           templateImg = gray or color template image
%           threshC = threshold of rejecting detected region (default = .75)
%                     e.g. if the detected region has a corrCoef>threshC
%                     then the algorithm accepts it as a detection,
%                     otherwise rejects it as a false alarm.
% Output: 
%           corrScore = 2D matrix of correlation coefficients
%           boundingBox = [upperLeftPixel.y upperLeftPixel.x height width]
%
% -------------------------------------------------------------------------
% By Yue Wu (Rex)
% Department of Electrical and Computer Engineering
% Tufts University
% Medford, MA
% 08/30/2010
% -------------------------------------------------------------------------

%% 1. initialization
if size(frameImg,3) ~=1
    frameGray = rgb2gray(frameImg);
else
    frameGray = frameImg;
end
frameGray = double(frameGray);

if size(templateImg,3) ~=1
    templateGray = rgb2gray(templateImg);
else
    templateGray = templateImg;
end
templateGray = double(templateGray);
[templateHeight,templateWidth] = size(templateGray);


%% 2. correlation calculation
frameMean = conv2(frameGray,ones(size(templateGray))./numel(templateGray),'same');
templateMean = mean(templateGray(:));
corrPartI = conv2(frameGray,fliplr(flipud(templateGray-templateMean)),'same')./numel(templateGray);
corrPartII = frameMean.*sum(templateGray(:)-templateMean);
stdFrame = sqrt(conv2(frameGray.^2,ones(size(templateGray))./numel(templateGray),'same')-frameMean.^2);
stdTemplate = std(templateGray(:));
corrScore = (corrPartI-corrPartII)./(stdFrame.*stdTemplate);

%% 3. finding most likely region
[maxVal,maxIdx] = max(corrScore(:));
[maxR, maxC] = ind2sub([size(corrScore,1),size(corrScore,2)],maxIdx);

%% 4. hypothesis test
if ~exist('threshC','var')
    threshC = .75;
end
if maxVal>=threshC
    boundingBox(1,:) = [max(1,maxR-round(templateHeight/2)), max(1,maxC-round(templateWidth/2)), templateHeight, templateWidth];
else
    boundingBox(1,:) = [];
end
