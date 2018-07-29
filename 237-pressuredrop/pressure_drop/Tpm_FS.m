function FS = Tpm_FS(P,X)
% TPM_MN  Fitzsimmons two-phase multiplier
% TPM_MN(P,X) Returns the Fitzsimmons two-phase 
% multipier for a steam-water system 
%  Called function: Tpm_MN(P,X)
%  Required Inputs are: P - pressure (kPa), X - quality (fraction)
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;  % set the format of the calculations

% Call the Martinalli-Nelson two-phase multiplier
MN=Tpm_MN(P,X);

% Calculate the Fitzsimmons two-phase multiplier
FS=1.0+0.65*(MN-1.0);

return