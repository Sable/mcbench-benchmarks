function [step, lowerBound, upperBound] = defaultBoundaries(nPoints)
%Generates default lower bound, upper bound, and step for qth derivatives.

    step = 1;
    lowerBound = 1;
    upperBound = nPoints;
    
end
