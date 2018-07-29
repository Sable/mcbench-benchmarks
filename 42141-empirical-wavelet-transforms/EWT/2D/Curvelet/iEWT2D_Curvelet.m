function rec = iEWT2D_Curvelet(ewt,mfb)

%==========================================================================
% function rec = iEWT2D_Curvelet(ewt,mfb)
%
% This function performs the inverse empirical curvelet transform from the
% curvelet filters and the coefficients of the forward transform.
%
% Input:
%   -ewt: structure containing the coefficients from the forward transform
%   -mfb: the empirical filters
%
% Output:
%   -rec: the reconstructed image
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%==========================================================================

%We perform the adjoint operator to get the reconstruction
rec=fft2(ewt{1}).*mfb{1};

for k=2:length(ewt)
    for t=1:length(ewt{k})
        rec=rec+fft2(ewt{k}{t}).*mfb{k}{t};
    end
end
rec=real(ifft2(rec));
