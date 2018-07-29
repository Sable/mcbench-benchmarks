%Lee filter for speckle noise reduction
% author: Grzegorz Mianowski
% based on
% http://www.mathworks.com/matlabcentral/fileexchange/9456-lee-filter
%Usage - myLee(I)

function OIm=myLee(I)

I = double(I);
OIm = I;
window_size = 3;
means = imfilter(I, fspecial('average', window_size), 'replicate');
sigmas = sqrt((I-means).^2/window_size^2);
sigmas = imfilter(sigmas, fspecial('average', window_size), 'replicate');

ENLs = (means./sigmas).^2;
sx2s = ((ENLs.*(sigmas).^2) - means.^2)./(ENLs + 1);
fbar = means + (sx2s.*(I-means)./(sx2s + (means.^2 ./ENLs)));
OIm(means~=0) = fbar(means~=0);

% OIm=uint8(OIm); % if needed