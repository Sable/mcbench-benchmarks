% Peaks ordering
function peaks = OrderPeaks(copyPeak,Regions)
i=1;
peaks = zeros(1,Regions);
while (isempty(copyPeak)==0)
    peaks(i) = min(copyPeak);
    copyPeak(find(copyPeak==peaks(i)))=[];
    i=i+1;
end

