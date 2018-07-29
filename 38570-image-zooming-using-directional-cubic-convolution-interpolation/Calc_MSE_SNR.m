function [MSE, SNR, PSNR] = Calc_MSE_SNR(I1,I2,b)
% This function computes MSE, SNR and PSNR between two gray
% images excluding a border of width b on all four sides. 
% The two gray images must have the same size.
%
%          I1(:,:)      first input original image, range 0~255
%          I2(:,:)      second input observed image, range 0~255
%          b            width of border on each side of the image to exclude 
%                       from error calculations
%          MSE          output, mean square error
%          SNR          output, signal noise ratio
%          PSNR         output, peak signal noise ratio
%
% Copyright (c) Apr., 2006. Dengwen Zhou. All rights reserved.
% Department of Computer Science & Technology
% North China Electric Power University(NCEPU)
%
% Last time modified: Oct. 11, 2012
%

% Exclude b border pixels
I1 = double(I1); I2 = double(I2);
I1 = I1(b+1:end-b,b+1:end-b);
I2 = I2(b+1:end-b,b+1:end-b);

% Compute the errors
num = numel(I1);
d = sum((I1(:)-I2(:)).^2); 
s = sum(I1(:).^2);
MSE = d/num;
SNR = 10*log10(s/d);
PSNR = 10*log10(255*255/MSE);
