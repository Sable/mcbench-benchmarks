% This demo works on only the Approximate region of the Wavelet Transform

clc; clear all;
close all;

figureIndex = 0;

imageFolder = 'images';

% targetImage = 'chp_mri_squareSized.jpg';
targetImage = 'Cdm_hip_fracture_343_original_squareSized.jpg';

targetImage = strcat(imageFolder, '\', targetImage);

originalImage = imread(targetImage);
%levelOfDecomposition = input('enter the number of levels of decomposition');
%originalImageInGray = rgb2gray(originalImage); 
originalImageInGray = originalImage;

originalDimensions = size(originalImageInGray);

levelOfDecomposition = 5;   % level N = 5

%waveletType = 'db4';
%waveletType = 'haar';
waveletType = 'sym8';

[C_desired, S_desired] = wavedec2(double(originalImageInGray),levelOfDecomposition,waveletType);
S_bookingKeepingOnLevel_N = S_desired;

tt = 1; % 100

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% N LEVELS Decomposition
for currentLevelOfDecomposition = levelOfDecomposition:-1:1
    i = currentLevelOfDecomposition;
    %if (currentLevelOfDecomposition == levelOfDecomposition) % works only at the highest specified level of decomposition
        cA_N_desired{i} = appcoef2(C_desired, S_desired, waveletType, i);   
    %end
    
    [cH_desired{i}, cV_desired{i}, cD_desired{i}] = detcoef2('all', C_desired, S_desired, i); % for specific use : 'h', 'v', 'd', in place of 'all'
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Denoising/ restoration, compression, enhancement, etc. operations may be
% done as follows before reconstruction
%{
% C_desired, S_desired assumed to be C_noisy, S_noisy in the following example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% < ILLUSTRATION: OPERATIONS IN WAVELET DOMAIN >
for currentLevelOfDecomposition = levelOfDecomposition:-1:1
    i = currentLevelOfDecomposition;
    % if (currentLevelOfDecomposition == levelOfDecomposition) % works only at the highest specified level of decomposition
        cA_noisy{i} = appcoef2(C_noisy, S_noisy, waveletType, i);
        
        dnA{i} = < OPERATIONS > (cA_noisy{i}, <otherParameters> );         
    % end
    
    [cH{i}, cV{i}, cD{i}] = detcoef2('all', C_noisy, S_noisy, i);

    dnH{i} = < OPERATIONS > (cH{i}, <otherParameters> );
    dnV{i} = < OPERATIONS > (cV{i}, <otherParameters> );    
    dnD{i} = < OPERATIONS > (cD{i}, <otherParameters> );    

% reshape if to be display independently
if (currentLevelOfDecomposition == levelOfDecomposition)
    dnAm{i} = (reshape(dnA{i}, size(cA_N_noisy,1), size(cA_N_noisy,2)));
end

dnHm{i} = (reshape(dnH{i}, size(cH{i},1),size(cH{i},2)));
dnVm{i} = (reshape(dnV{i}, size(cV{i},1),size(cV{i},2)));
dnDm{i} = (reshape(dnD{i}, size(cD{i},1),size(cD{i},2)));

end

% ==============================================================
% === << note that the reconstruction would be as follows >> ===
% ==============================================================
level_N_Coefficients = [dnA{levelOfDecomposition}' dnH{levelOfDecomposition}' dnV{levelOfDecomposition}' dnD{levelOfDecomposition}']; % complete 4 quadrants on the top most left hand quadrant

alignedWaveletQuandrants = level_N_Coefficients;

for currentLevelOfDecomposition = (levelOfDecomposition-1):-1:1
    alignedWaveletQuandrants = [alignedWaveletQuandrants dnH{currentLevelOfDecomposition}' dnV{currentLevelOfDecomposition}' dnD{currentLevelOfDecomposition}'];
end
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RECONSTRUCTION
% line up into column arrays
cA_N_colArray = cA_N_desired{levelOfDecomposition}; cA_N_colArray = cA_N_colArray(:)';
cH_colArray =  cH_desired{levelOfDecomposition}; cH_colArray = cH_colArray(:)';
cV_colArray = cV_desired{levelOfDecomposition}; cV_colArray = cV_colArray(:)';
cD_colArray = cD_desired{levelOfDecomposition}; cD_colArray = cD_colArray(:)';

level_N_Coefficients = [cA_N_colArray cH_colArray cV_colArray cD_colArray]; % complete 4 quadrants on the top most left hand quadrant

alignedWaveletQuandrants = level_N_Coefficients;

for currentLevelOfDecomposition = (levelOfDecomposition-1):-1:1
    i = currentLevelOfDecomposition;
    % line up into column arrays
    cA_N_colArray = cA_N_desired(:)'; 
    cH_colArray =  cH_desired{i}; cH_colArray = cH_colArray(:)';
    cV_colArray = cV_desired{i}; cV_colArray = cV_colArray(:)';
    cD_colArray = cD_desired{i}; cD_colArray = cD_colArray(:)';

    alignedWaveletQuandrants = [alignedWaveletQuandrants cH_colArray cV_colArray cD_colArray];
end

recoveredImage = waverec2(alignedWaveletQuandrants, S_bookingKeepingOnLevel_N, waveletType);

PSNR(originalImageInGray, recoveredImage);

MSN = sum((double(originalImageInGray(:))-double(recoveredImage(:))).^2)./(size(originalImageInGray,1)*size(originalImageInGray,2))
   
mode = 'tree';
mode = 'square';
displayResultantWaveletImages(cA_N_desired, cH_desired, cV_desired, cD_desired, levelOfDecomposition, mode);

% displayResultantImages(cA_N_desired, cH_desired, cV_desired, cD_desired);

%{
[UM]: 

%}
    