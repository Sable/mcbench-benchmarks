% this function calculate the PSNR

function [PeakSNR, Mean2err]=psnr(OriginalImage, DegradedImage)
OriginalImage=double(OriginalImage);
DegradedImage=double(DegradedImage);
[N,M] = size(OriginalImage);
Imax = max(max(DegradedImage));
SumOfDiff2 = sum(sum((OriginalImage-DegradedImage).*(OriginalImage-DegradedImage)));
Mean2err=SumOfDiff2./(M*N);
sdf=Imax^2./(Mean2err);
if sdf ==0
    sdf=1;
end

PeakSNR = 10*log10(sdf);

