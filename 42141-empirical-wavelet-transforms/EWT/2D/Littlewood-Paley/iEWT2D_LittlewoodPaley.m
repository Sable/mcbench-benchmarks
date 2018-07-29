function rec=iEWT2D_LittlewoodPaley(ewt,mfb)

% ======================================================================
% function rec=iEWT2D_LittlewoodPaley(ewt,mfb)
% 
% Perform the Inverse 2D Littlewood-Paley Empirical Wavelet Transform of 
% ewt accordingly to the filter bank mfb
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
% ======================================================================
W0=size(ewt{1},2);
H0=size(ewt{1},1);

W1=floor(W0/2);
H1=floor(H0/2);


%We perform the adjoint operator to get the reconstruction
for k=1:length(ewt)
    ewt{k}=[ewt{k}(H1:-1:1,W1:-1:1) ewt{k}(H1:-1:1,:) ewt{k}(H1:-1:1,end:-1:end-W1+1) ; ewt{k}(:,W1:-1:1) ewt{k} ewt{k}(:,end:-1:end-W1+1) ; ewt{k}(end:-1:end-H1+1,W1:-1:1) ewt{k}(end:-1:end-H1+1,:) ewt{k}(end:-1:end-H1+1,end:-1:end-W1+1)];
    if k==1
        rec=zeros(size(ewt{1}));
    end
    rec=rec+real(ifft2(fft2(ewt{k}).*mfb{k}));
end
rec=rec(H1+1:H1+H0,W1+1:W1+W0);