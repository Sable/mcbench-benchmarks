function out = corrDn(im, filt, step)
% Perform convolution between im and filt then downsampling by vector [step]
%   
% Input
%       im:     input image
%     filt:     filter
%     step:     sampling vector ([1 1] or [2 2])
%
% Output
%      out:     output image

% Convolution
% Reverse filt coefficients, to do correlation instead of convolution
filt = rot90(filt,2);
tmp=imfilter(im,filt,'circular');

% Downsampling
out = tmp(1:step(1):size(im,1), 1:step(2):size(im,2));
