function [X_n] = normxas(X,vi,vf)

% NORMXAS normalize XAS spectra to absorbance range from 0 (at pre-edge region) to 1 (at pos-edge (EXAFS) region).
% 
% INPUTS:
% X (samples x variables) matrix of spectral data
% vi (1 x 1) scalar indicating the initial variable of the pos-edge region to be considered to set the unit absorbance
% vf (1 x 1) scalar indicating the final variable of the pos-edge region to be considered to set the unit absorbance
% 
% OUTPUTS:
% X_n (samples x variables) matrix of normalized spectral data
% 
% By Cleiton A. Nunes
% UFLA,MG,Brazil

X_n=X-min(min(X));
m_exafs=1/mean(mean(X_n(:,vi:vf)));
X_n=X_n*m_exafs;