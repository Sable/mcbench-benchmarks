function t_sub_coef = SubbandThresholding(sub_coef)
% Threshold the noisy subband according to NeighShrink SURE rule
%
% sub_coef: inputted noisy subband
% t_sub_coef: outputted thresholded subband
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

%% Determine the optimal threshold and neighborhood size

% Compute the risks of all neighborhood sizes and the corresponding
% optimal thresholds
Rsim_set = [1 2 3]; k = 0;
for Rsim = Rsim_set
    k = k + 1;
    [risk(k),thres(k)] = OptimalThreshold(sub_coef,Rsim);
end

% Select the optimal neighborhood size and the corresponding threshold
[guess,ibest] = min(risk);
threshold = thres(ibest); Rsim = Rsim_set(ibest);

%% Threshold the noisy subband using NeighShrink rule
ext_sub_coef = padarray(sub_coef,[Rsim,Rsim],0);% Fill the noisy subband using zero
[nRow,nCol] = size(sub_coef); % Compute the size of the noisy subband 
t_sub_coef = zeros(nRow,nCol);
for i = Rsim+1:Rsim+nRow
    for j = Rsim+1:Rsim+nCol
        ux = ext_sub_coef(i-Rsim:i+Rsim,j-Rsim:j+Rsim); % neighborhood of the current pixel
        S = sum(ux(:).^2);
        factor = max(1-threshold^2/S,0);
        t_sub_coef(i-Rsim,j-Rsim) = factor*sub_coef(i-Rsim,j-Rsim);
    end
end
