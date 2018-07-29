function rec=iEWT1D(ewt,mfb)

% ======================================================================
% function rec=iEWT1D(ewt,mfb)
% 
% Perform the Inverse Empirical Wavelet Transform of ewt accordingly to
% the filter bank mfb
%
% Inputs:
%   -ewt: cell containing the EWT components
%   -mfb: filter bank used during the EWT
%
% Outputs:
%   -rec: reconstructed signal
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2012
% Version: 1.0
% ======================================================================

l=round(length(ewt{1})/2);

%We perform the adjoint operator to get the reconstruction
for k=1:length(ewt)
    ewt{k}=[ewt{k}(l-1:-1:1);ewt{k};ewt{k}(end:-1:end-l+1)];
    if k==1
        rec=zeros(length(ewt{1}),1);
    end
    rec=rec+real(ifft(fft(ewt{k}).*mfb{k}));
end
rec=rec(l:end-l);