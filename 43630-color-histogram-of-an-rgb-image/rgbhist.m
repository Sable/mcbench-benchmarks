function H = rgbhist(I,nBins)
%% RGBHIST: color Histogram of an RGB image.
% nBins   : number of bins per EACH color => histogram is 'nBins^3' long.
% H       : The vectorized histogram.
% Author  : Mopuri K Reddy, SERC, IISc, Bengalur, INDIA.
% Date    : 25/10/2013.

if (size(I, 3) ~= 3)
    error('rgbhist:numberOfSamples', 'Input image must be RGB.')
end
tic
H=zeros([nBins nBins nBins]);
for i=1:size(I,1)
    for j=1:size(I,2)
        p=double(reshape(I(i,j,:),[1 3]));
        p=floor(p/(256/nBins))+1;
        H(p(1),p(2),p(3))=H(p(1),p(2),p(3))+1;
    end
end
toc
H=H(:);
% We can use 'reshape' to get back to 3D histogram
