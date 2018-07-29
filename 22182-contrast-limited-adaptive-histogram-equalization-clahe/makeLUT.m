function [LUT] = makeLUT(Min,Max,NrBins)
%  To speed up histogram clipping, the input image [Min,Max] is scaled down to
%  [0,uiNrBins-1]. This function calculates the LUT.


Max1 = Max + max(1,Min) - Min;
Min1 = max(1,Min);

BinSize = fix(1 + (Max - Min)/NrBins);
LUT = zeros(fix(Max - Min),1);
for i=Min1:Max1
    LUT(i) = fix((i - Min1)/BinSize);
end

