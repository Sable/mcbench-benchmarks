function varargout = rgbhist(I)
%RGBHIST   Histogram of RGB values.

if (size(I, 3) ~= 3)
    error('rgbhist:numberOfSamples', 'Input image must be RGB.')
end

nBins = 256;

rHist = imhist(I(:,:,1), nBins);
gHist = imhist(I(:,:,2), nBins);
bHist = imhist(I(:,:,3), nBins);

hFig = figure;
h(1) = stem(1:256, rHist);
h(2) = stem(1:256 + 1/3, gHist);
h(3) = stem(1:256 + 2/3, bHist);

set(h, 'marker', 'none')
set(h(1), 'color', [1 0 0])
set(h(2), 'color', [0 1 0])
set(h(3), 'color', [0 0 1])

 