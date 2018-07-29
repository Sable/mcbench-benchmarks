function rec=iEWT2D_Ridgelet(ewt,mfb)

%==========================================================================
% function rec=iEWT2D_Ridgelet(ewt,mfb)
%
% This function performs the inverse 2D Empirical Ridgelet of ewt 
% accordingly to the filter bank mfb .
%
% TO RUN THIS FUNCTION YOU NEED TO HAVE THE MATLAB POLARLAB TOOLBOX OF 
% MICHAEL ELAD: http://www.cs.technion.ac.il/~elad/Various/PolarLab.zip
%
% Inputs:
%   -ewt: cell containing the 2D EWT components
%   -mfb: filter bank used during the EWT
%
% Output:
%   -rec: reconstructed image
%
% Author: Jerome Gilles - Giang Tran
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%==========================================================================

PseudoFFT=zeros(size(ewt{1}));

% We perform the reconstruction of the Pseudo-Polar FFT domain by performing 
% the adjoint operator of the EWT1D
for k=1:length(ewt)
    PseudoFFT=PseudoFFT+fftshift(fft(ewt{k}).*mfb{k},1);
end

rec=real(IPPFFT(PseudoFFT,1e-6));