
function testDCC
%
% Copyright (c) May 28, 2009. Dengwen Zhou. All rights reserved.
% Department of Computer Science & Technology
% North China Electric Power University(NCEPU)
%
% Last time modified: Oct. 11, 2012
%

close all
clear all
clc

% Set the zooming level
level = 1;

% Read the original image.
name = 'Lena';
type = '.png';
ifname = ['.\original_images\' name type];
ORIG = imread(ifname);

% Downsample the original image
ORIG_LR = ORIG(1:2^level:end-1,1:2^level:end-1);
ORIG_LR = im2double(ORIG_LR);

% Do the interpolation 
tic;
k = 5; T = 1.15;
OUTgo = ORIG_LR;
for s = 1:level
    OUT = DCC(OUTgo,k,T);
    OUT = im2uint8(OUT);
    OUTgo = OUT;
end
toc

% Save the interpolated image
ifname = ['.\resulted_images\' name '_HR' num2str(2^level) '.tiff'];
imwrite(OUT,ifname);

% Compute error
OUT = imread(ifname);
b = 12;
[MSE, SNR, PSNR] = Calc_MSE_SNR(ORIG,OUT,b);
disp(['MSE = ', num2str(MSE)]);
disp(['SNR = ', num2str(SNR)]);
disp(['PSNR = ', num2str(PSNR)]);
