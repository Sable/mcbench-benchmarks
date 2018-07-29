function [ewtC,mfbR,mfbC,BR,BC] = EWT2D_Tensor(im,params)

%=========================================================================
%
% function [ewtC,mfbR,mfbC] = Tensor_EWT2D(im,Nscale)
%
% Performs the 2D Empirical Wavelet transform based on the tensor product 
% approach.
%
% Inputs:
%   -im: input image
%   -params: structure containing the following parameters:
%       -params.log: 0 or 1 to indicate if we want to work with
%                    the log of the ff
%       -params.preproc: 'none','plaw','poly','tophat'
%       -params.method: 'locmax','locmaxmin','ftc'
%       -params.N: maximum number of supports (needed for the
%                  locmax and locmaxmin methods)
%       -params.degree: degree of the polynomial (needed for the
%                       polynomial approximation preprocessing)
%
% Outputs:
%   -ewtC: structure containing all subband images
%   -mfbR: filter bank used for the rows
%   -mfbC: filter bank used for the columns
%   -BR: detected boundaries used for the rows
%   -BC: detected boundaries used for the columns
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
% ========================================================================

% ================
%    ROWS FIRST
% ================
% We extend the signal by miroring horizontally to deal with the boundaries
l=round(size(im,2)/2);
imR=[im(:,(l-1:-1:1)) im im(:,(end:-1:end-l))];
% We take the FFT for each row
fftim=fft(imR');
% We compute the FFT magnitude mean
meanfft=sum(abs(fftim),2)/size(fftim,2);

% We detect the boundaries
boundaries = EWT_Boundaries_Detect(meanfft,params);
BR=boundaries*pi/round(length(meanfft)/2);

% We build the corresponding filter bank
mfbR=EWT_Meyer_FilterBank(BR,length(meanfft));

% We filter the signal to extract each subband
ewtR=cell(length(mfbR),1);
for k=1:length(mfbR)
    filter=repmat(conj(mfbR{k}),1,size(fftim,2));
    ewtR{k}=real(ifft(filter.*fftim))';
   
    ewtR{k}=ewtR{k}(:,l:end-l-1);
end

% ================
%   COLUMNS NEXT
% ================
% We extend the signal by miroring vertically to deal with the boundaries
l=round(size(im,1)/2);
imC=[im((l-1:-1:1),:); im ; im((end:-1:end-l),:)];

% We take the FFT for each column
fftim=fft(imC);

% We compute the FFT magnitude mean
meanfft=sum(abs(fftim),2)/size(fftim,2);

% We detect the boundaries
boundaries = EWT_Boundaries_Detect(meanfft,params);
BC=boundaries*pi/round(length(meanfft)/2);

% We build the corresponding filter bank
mfbC=EWT_Meyer_FilterBank(BC,length(meanfft));

% We filter the signal to extract each subband
ewtC=cell(length(mfbR),length(mfbC));
for k=1:length(mfbC)
    filter=repmat(conj(mfbC{k}),1,size(fftim,2));
    for s=1:length(mfbR)
        imC=[ewtR{s}((l-1:-1:1),:); ewtR{s} ; ewtR{s}((end:-1:end-l),:)];
        
        fftim=fft(imC);
        ewtC{s}{k}=real(ifft(filter.*fftim));
        
        ewtC{s}{k}=ewtC{s}{k}(l:end-l-1,:);
    end
end