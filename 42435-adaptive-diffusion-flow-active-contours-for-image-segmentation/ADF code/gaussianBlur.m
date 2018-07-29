function GI = gaussianBlur(I,s)
% GAUSSIANBLUR blur the image with a gaussian kernel
%     GI = gaussianBlur(I,s) 
%     I is the image, s is the standard deviation of the gaussian
%     kernel, and GI is the gaussian blurred image.

%    Chenyang Xu and Jerry L. Prince 6/17/97
%    Copyright (c) 1996-97 by Chenyang Xu and Jerry L. Prince

M = gaussianMask(1,s);
M = M/sum(sum(M));   % normalize the gaussian mask so that the sum is
                     % equal to 1
GI = xconv2(I,M);
