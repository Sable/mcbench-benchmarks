function gammaRatios = reducedGammaRatios(q, numPoints)
%Generates gamma ratios in a way so that there is no overall scale factor
%for the fractional differintegral matrix of 1/gamma(-q).
    gammaRatios = zeros(1, numPoints);
    gammaRatios(1) = 1;
    
    for i = 2:numPoints
        gammaRatios(i) = (i-2-q)*gammaRatios(i-1)/(i-1);
    end
end