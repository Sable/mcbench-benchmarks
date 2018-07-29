function rec=Modes_EWT1D(ewt,mfb)

%==================================================================
% function rec=Modes_EWT1D(ewt,mfb)
%
% This function reconstruct the IMFs: IMF(i)=ewt(i)psi(i) (or phi)
%
% Input:
%   -ewt: the EWT components
%   -mfb: filter bank used to generate the EWT
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2012
% Version: 1.0
%==================================================================

l=round(length(ewt{1})/2);
rec=cell(size(ewt));

for k=1:length(ewt)
    ewt{k}=[ewt{k}(l-1:-1:1);ewt{k};ewt{k}(end:-1:end-l+1)];
    rec{k}=zeros(length(ewt{1}),1);
    rec{k}=real(ifft(fft(ewt{k}).*mfb{k}));
    rec{k}=rec{k}(l:end-l);
end
