function test
% Test NeighShrink SURE image denoising
% This software is non-optimized Matlab codes and provided
% for non-commercial and research purposes only
%
% Author: Zhou Dengwen
% zdw@ncepu.edu.cn
% Department of Computer Science & Technology
% North China Electric Power University(Beijing)(NCEPU)
%
% References:
% [1] Zhou Dengwen, Cheng Wengang, "Image denoising with an optimal
% threshold and neighbouring window," 
% Pattern Recognition Letters, vol.29, no.11, pp.1694¨C1697, 2008
%
% Last time modified: Jul. 15, 2008
%

% Read the clean image
Xclean = double(imread('lena.png'));
[nRow, nCol] = size(Xclean);

% Add Gaussian white noise with variance sigma^2 and mean 0
sigma = 30;
seed = 0;  % random seed
randn('state', seed);
noise = randn(nRow, nCol);
Xnoisy = Xclean + sigma*noise/std2(noise);

% Denoise using NeighShrink SURE (DWT)
L = 4; % the number of wavelet decomposition levels
wtype = 'sym8'; % wavelet type

% Denoise using NeighShrink SURE
tic;
Xdenoised = NeighShrinkSUREdenoise(Xnoisy, sigma, wtype, L);
toc

% Estimate the denoising effcet (i.e. computing MSE and PSNR)
[MSE, PSNR] = Calc_MSE_PSNR(Xclean,Xdenoised)