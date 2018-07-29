function [sig r mav] = estimate_noise_dwt(img, Wname)

% sig = estimate_noise_dwt(img)
% sig = estimate_noise_dwt(img, wavelet_name)
% [sig SNR] = estimate_noise_dwt(img, wavelet_name)
% [sig SNR MAV] = estimate_noise_dwt(img, wavelet_name)
%
% sig will be the estimated standard deviation of the noise in the image img
% wavelet_name is the name of the wavelet family to use (e.g 'haar' 'db1'
% (default) 'db2' etc.)
%
% SNR is the estimated SNR on the finest detail level
% MAV is the noise estimator of Donoho
%
% Based on method from "Noise Reduction for Magnetic Resonance Images via
%  Adaptive Multiscale Products Thresholding", Paul Bao, Lei Zhang, 2003


if nargin < 2
    Wname = 'db1';
end

if (max(img(:)) <= 0)
    disp('ERROR: Illegal values found in input image');
    return;
end

acc_cD = [];
for l=1:size(img,3)
    for ll=1:size(img,4)
        frame = img(:,:,l,ll);
        [cA,cH,cV,cD] = dwt2(frame,Wname);
        acc_cD = [acc_cD, cD];
    end
end

W = acc_cD(:);
sig_f = sqrt(mean(W.*W));

Wa = W(abs(W)>sig_f);
Wb = W(abs(W)<=sig_f);

sig_wa = sqrt(mean(Wa.*Wa));
sig_wb = sqrt(mean(Wb.*Wb));

siG_g = sqrt((sig_wa*sig_wa) - (8.673 * sig_wb*sig_wb));

r = siG_g / sig_wb;

sig = sig_f / sqrt(1 + r*r);

if nargout > 2
    mav = median(abs(W(W<=sig_f))) / 0.6745;
    if size(img, 1) < 512
        %mav= 1.19*mav - 5.93 ;
        mav= 1.25*mav - 4 ; % For 256x256
    else
        mav= 1.67*mav - 3; % For 512x512
    end
end

