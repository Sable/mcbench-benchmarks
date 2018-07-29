function output = subsampling(input, n)
% Subsample an image, the image is subsampled
% to avoid distortion due to the subsampling
% Input : image
% n : subsample 


% number of arguments check and error msg
error(nargchk(2,2,nargin)); 

input = double(input);

% create a FIR filter
Hd = zeros(13,13);
Hd(4:10,4:10) = 1;
h = fwind1(Hd, hamming(13), hamming(13));

% freq. response of the filter
%figure; freqz2(h);

% filter the image
im_filtered = imfilter(input, h, 'symmetric');

% subsample the filtered image
output = im_f(1:n:end, 1:n:end);

