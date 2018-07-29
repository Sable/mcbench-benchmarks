function im=iEWT2D_Tensor(ewt2d,mfbR,mfbC)

%=========================================================================
%
% function im = iTensor_EWT2D(ewt2d,mfbR,mfbC)
%
% Performs the inverse 2D Empirical Wavelet transform based on the tensor 
% product approach.
%
% Inputs:
%   -ewt2d: structure containing the 2D EWT transform components
%   -mfbR: filter bank used for the rows
%   -mfbC: filter bank used for the columns
%
% Outputs:
%   -im: reconstructed image
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
% ========================================================================

% We start to inverse the columns filtering by using the adjoint
% formulation 
l=round(size(ewt2d{1}{1},1)/2);
ewtR=cell(length(mfbR),1);
for s=1:length(mfbR)
    for k=1:length(mfbC)
        fftim=fft([ewt2d{s}{k}((l-1:-1:1),:); ewt2d{s}{k} ; ewt2d{s}{k}((end:-1:end-l),:)]);

        filter=repmat(mfbC{k},1,size(fftim,2));
        if k==1
            ewtR{s}=zeros(size(fftim));
        end
        ewtR{s}=ewtR{s}+real(ifft(filter.*fftim));     
    end
    ewtR{s}=ewtR{s}(l:end-l-1,:);
end

% Next we inverse the rows filtering
l=round(size(ewtR{1},2)/2);
for s=1:length(mfbR)
    fftim=fft([ewtR{s}(:,(l-1:-1:1)) ewtR{s} ewtR{s}(:,(end:-1:end-l))]');
    if s==1
       im=zeros(size(fftim))';
    end
    
    filter=repmat(mfbR{s},1,size(fftim,2));
    im=im+real(ifft(filter.*fftim))';
end
im=im(:,l:end-l-1);