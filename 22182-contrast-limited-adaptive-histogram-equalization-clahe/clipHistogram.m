function [Hist] = clipHistogram(Hist,NrBins,ClipLimit,NrX,NrY)
%  This function performs clipping of the histogram and redistribution of bins.
%  The histogram is clipped and the number of excess pixels is counted. Afterwards
%  the excess pixels are equally redistributed across the whole histogram (providing
%  the bin count is smaller than the cliplimit).

for i = 1:NrX
    for j = 1:NrY
        %   Calculate the total number of excess pixels.
        NrExcess = 0;
        for nr = 1:NrBins
            excess=Hist(i,j,nr) - ClipLimit;
            if excess > 0
                NrExcess = NrExcess + excess;
            end
        end

        %  Clip histogram and redistribute excess pixels in each bin
        binIncr = NrExcess / NrBins;
        upper = ClipLimit - binIncr;
        for nr = 1:NrBins
            if Hist(i,j,nr) > ClipLimit
                Hist(i,j,nr) = ClipLimit;
            else
                if Hist(i,j,nr) > upper
                    NrExcess = NrExcess + upper - Hist(i,j,nr);
                    Hist(i,j,nr) = ClipLimit;
                else
                    NrExcess = NrExcess - binIncr;
                    Hist(i,j,nr) = Hist(i,j,nr) + binIncr;
                end
            end
        end
        
        if NrExcess > 0
            stepSize = max(1,fix(1+NrExcess/NrBins));
            for nr = 1:NrBins
                NrExcess = NrExcess - stepSize;
                Hist(i,j,nr) = Hist(i,j,nr) + stepSize;
                if NrExcess < 1
                    break;
                end
            end
        end
        
    end
end
