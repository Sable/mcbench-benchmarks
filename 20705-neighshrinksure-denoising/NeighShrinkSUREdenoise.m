function denoised = NeighShrinkSUREdenoise(noisy, sigma, wtype, L)
% Denoise using NeighShrink SURE (DWT)
%
% noisy: the noisy image to be denoised
% sigma: noise level
% wtype: wavelet type
% L: the number of wavelet decomposition level
% denoised: the denoised image to be returned
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

%% Determine parameters
if nargin < 4
    L = 4;
end
if nargin < 3
    wtype = 'sym8';
end

% Apply DWT to noisy
[C,S] = wavedec2(noisy,L,wtype);

% Estimate noise level
if nargin < 2
    d1 = detcoef2('d',C,S,1);
    sigma = median(abs(d1(:)))/0.6745;
end

%% Extract all detail subbands from C
C = C/sigma; % normalize the noise level of the noisy coefficients
for i = 1:L
    [H{i},V{i},D{i}] = detcoef2('all',C,S,i); 
end

% Threshold 3 details subbands in each scale
for i = 1:L
    T_H{i} = SubbandThresholding(H{i});
    T_V{i} = SubbandThresholding(V{i});
    T_D{i} = SubbandThresholding(D{i});
end

%% Regroup the thresholded subbands to Matlab C and S structure
t_C = C; 
tail = S(1,1)*S(1,2); % the number of approximation coefficients
for i = 1:L
    
    % The number of coefficients in decomposition level i
    num = S(i+1,1)*S(i+1,2);
    
    % Horizontal sbbband in decomposition level i
    head = tail+1;
    tail = head+num-1;
    t_C(head:tail) = T_H{L-i+1}(:);
    
    % Vertical sbbband in decomposition level i
    head = tail+1;
    tail = head+num-1;
    t_C(head:tail) = T_V{L-i+1}(:);
    
    % Diagonal sbbband in decomposition level i
    head = tail+1;
    tail = head+num-1;
    t_C(head:tail) = T_D{L-i+1}(:);
    
end

%% Reconstruct the denoised image
denoised_norm = waverec2(t_C, S, wtype);
denoised = denoised_norm*sigma;