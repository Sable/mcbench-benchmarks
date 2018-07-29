function out = upConv(im,filt,step)

% Perform upsampling with [step] then convolution with filt
%   
% Input
%       im:     input image
%     filt:     filter
%     step:     sampling vector ([1 1] or [2 2])
%
% Output
%      out:     output image

% Upsampling
stop = step .* size(im);
tmp = zeros(stop);
tmp(1:step(1):stop(1),1:step(2):stop(2)) = im;

% Convolution
out=imfilter(tmp,filt,'circular');
