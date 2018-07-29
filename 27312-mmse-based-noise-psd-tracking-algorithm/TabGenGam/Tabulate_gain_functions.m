function [Gdft,Gmag,Gmag2]=Tabulate_gain_functions(gamma,nu)
% function [Gdft,Gmag,Gmag2]=Tabulate_gain_functions(gamma,nu)
%tabulates the gain functions for complex-DFT estimation, magnitude DFT estimation and the magnitude squared estimator
%under the "generalized gamma"-model for the DFT-magnitudes for parameters gamma  and nu.
%For explanations, derivations and motivations, see:
%J.S. Erkelens, R.C. Hendriks and  R. Heusdens
%"On the Estimation of Complex Speech DFT Coefficients without Assuming Independent Real and Imaginary Parts", 
%IEEE signal processing letters 2008.
%and
% J.S. Erkelens, R.C. Hendriks, R. Heusdens, and J. Jensen,
% "Minimum mean-square error estimation of discrete Fourier coefficients
% with Generalized Gamma priors", IEEE Trans. Audio, Speech and Language
% Processing, August 2007.
%
% INPUT variables:
% Gamma,nu: distributional parameters of generalized Gamma density
%
% OUTPUT variables:
% Gdft:  Matrix with gain values for speech DFT estimation,
%        evaluated at all combinations of a priori and a posteriori SNR in the
%        input variables Rksi and Rgam. To be multiplied with the noisy complex DFT coefficient.
% 
% Gmag: Matrix with gain values for speech spectral amplitude estimation,
%       evaluated at all combinations of a priori and a posteriori SNR in the
%       input variables Rprior and Rpost. To be multiplied with the noisy amplitude.

% Gmag2:  Matrix with gain values for the amplitude-squared estimator (to be
%         multiplied with the SQUARE of the noisy amplitude).
%
% Copyright 2007: Delft University of Technology, Information and
% Communication Theory Group. The software is free for non-commercial use.
% This program comes WITHOUT ANY WARRANTY.
%
% Last modified: 22-11-2007.


nargchk(2,2,nargin)
ksi_range=-40:1:50;  % range of a priori values
gam_range=-40:1:50;  % range of a posteriori values

if gamma==2
    if nu <= 0
        error('nu-value is not in valid range. For gamma=1 it holds that nu > 0')        
    else
        [Gdft]=TabulateGenGam2dft(-40:1:50,-40:1:50,nu);  %%tabulate the gain function for complex-DFT estimator for gamma=2
        [Gmag,Gmag2]=TabulateGainGamma2(-40:1:50,-40:1:50,nu);%%tabulate the gain functions for DFT magnitude and magnitude squared estimatorestimator for gamma=2
    end
elseif gamma==1
    if nu <= 0.5
        error('nu-value is not in valid range. For gamma=1 it holds that nu > 0.5')        
    else
        K=20; % is the number of terms used to approximat the Bessel functions for small argument approximations.
        [Gdft]=TabulateGenGam1dft(-40:1:50,-40:1:50,nu,K); %%tabulate the gain function for complex-DFT estimator for gamma=1
        [Gmag,Gmag2]=TabulateGainGamma1(-40:1:50,-40:1:50,nu,K);%%tabulate the gain functions for DFT magnitude and magnitude squared estimatorestimator for gamma=1
    end
elseif ((gamma~=1) | (gamma~=2))
    error('Use gamma = 1 or gamma = 2')     
end 

