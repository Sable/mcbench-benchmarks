function [MSE, PSNR] = Calc_MSE_PSNR(clean,denoised)
% Compute MSE and PSNR.
%
% clean: inputted clean image
% denoised: inputted denoised image
% MSE: outputted mean squared error
% PSNR: outputted peak signal-to-noise ratio
%
% Author: Zhou Dengwen
% zdw@ncepu.edu.cn
% Department of Computer Science & Technology
% North China Electric Power University(Beijing)(NCEPU)
%
% Last time modified: Jul. 15, 2008
%

N = prod(size(clean));
clean = double(clean(:)); denoised = double(denoised(:));
t1 = sum((clean-denoised).^2); t2 = sum(clean.^2);
MSE = t1/N;
PSNR = 10*log10(255*255/MSE);
