function [Map] = mapHistogram(Hist,Min,Max,NrBins,NrPixels,NrX,NrY)
%  This function calculates the equalized lookup table (mapping) by
%  cumulating the input histogram. Note: lookup table is rescaled in range [Min..Max].

Map=zeros(NrX,NrY,NrBins);

Scale = (Max - Min)/NrPixels;

for i = 1:NrX
    for j = 1:NrY
        
        Sum = 0;
        for nr = 1:NrBins
            Sum = Sum + Hist(i,j,nr);
            Map(i,j,nr) = fix(min(Min + Sum*Scale,Max));
        end
        
    end
end

