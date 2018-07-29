function plotLayers(im)
%PLOTLAYERS Show the layers of 3D array in subplots
%
% plotLayers(im) makes size(im,3) subplots where the k'th subplot is the
% layer im(:,:,k) displayed as an image

% Jakob Heide Jørgensen (jakj@imm.dtu.dk)
% Department of Informatics and Mathematical Modelling (IMM)
% Technical University of Denmark (DTU)
% August 2009

% This code is released under the Gnu Public License (GPL). 
% For more information, see
% http://www.gnu.org/copyleft/gpl.html


% Number of layers to show
numLayers = size(im,3);

% Determine horizontal and vertical number of subplots
s1 = floor(sqrt(numLayers));
s2 = s1 + 2;

% Determine the overall minimum an maximum entries in im for setting common
% color axis
imVec  = im(:);
maxVal = max(imVec);
minVal = min(imVec);
ca     = [minVal,maxVal];

% Loop through the layers of im, make new subplot, display current layer as
% image, set color axis and title.
for k = 1:numLayers
    subplot(s1,s2,k)
    imagesc(im(:,:,k))
    axis image off
    caxis(ca)
    title(['Layer ',num2str(k)])
end