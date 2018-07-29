function [Hist] = makeHistogram(Bin,XSize,YSize,NrX,NrY,NrBins)
%  This function classifies the greylevels present in the array image into
%  a greylevel histogram. The pLookupTable specifies the relationship
%  between the greyvalue of the pixel (typically between 0 and 4095) and
%  the corresponding bin in the histogram (usually containing only 128 bins).

Hist=zeros(NrX,NrY,NrBins);

for i=1:NrX
    for j=1:NrY
        bin=Bin(1+(i-1)*XSize:i*XSize,1+(j-1)*YSize:j*YSize);
        for i1=1:XSize
            for j1=1:YSize
                Hist(i,j,bin(i1,j1)) = Hist(i,j,bin(i1,j1)) + 1;
            end
        end
    end
end
