function [outVol] = convolution3D_FFTdomain(inVol,inKer)
%% convolution3D_FFTdomain - Performs a fast 3D convolution between a volume and a kernel using mutliplication in the Fourrier space. 
%
% Syntax:  [outVol] = convolutionInFFTdomain(inVol,inKer,inMsg)
% Inputs:
%       inVol - input volume (real / complex)
%       inKer - input kernel (real / complex)
% Outputs:
%       outVol - output convolved volume (real / complex) - precision of the output format is the same as the input
%       volume. The output volume is the central part of the convolution with same size as inVol.
%       size(outVol)=size(inVol) ('same' option of convn).
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none

% Author: Christopher Coello
% Work address: Preclinical PET/CT Unit
% Email address: s.c.coello@medisin.uio.no
% Website: http://www.med.uio.no/imb/english/services/public/pet/
% 2012/03/13; Last revision: 2012/03/16
% Created with Matlab version: 7.13.0.564 (R2011b)
%%

% Check if both inputs are real numbers
realInput = isreal(inVol) && isreal(inKer);

% Check the precision of the input volume
if strcmp(class(inVol),'double'),
    indDb=1;
else
    indDb=0;
end

% Size of the input volumes
inVolSize=size(inVol);
inVolSide=max(inVolSize);
inKerSize=size(inKer);
inKerSide=max(size(inKer));

% Fourrier tranform of the volume and inKer.
extr(1:3)={};
for iDim=(1:3),
    inVol=fft(inVol,inVolSide+inKerSide-1,iDim);
    inKer=fft(inKer,inVolSide+inKerSide-1,iDim);
    extr{iDim}=ceil((inKerSize(iDim)-1)/2)+(1:inVolSize(iDim));
end

% Multiplication of the Fourrier tranforms
conv_FFT=inVol.*inKer;

% Inverse Fourrier Transform of the convolution
for iDim=(1:3),
    conv_FFT=ifft(conv_FFT,[],iDim);
end

% Crop the side of the image in relation to the size of the kernel
convinVol=conv_FFT(extr{:});

% limit the results
if realInput,
    convinVol=real(convinVol);
end

% Format the output into single precision if needed
if indDb,
    outVol=convinVol;
else
    outVol=single(convinVol);
end