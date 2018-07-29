function convolutionVector = additiveConvolutionVector(step, lowerBound,...
                                                       upperBound, q)
%A basic additive left and right handed qth derivative convolution vector
    
    %Initializers
    nPoints = abs((upperBound - lowerBound)/step) + 1;
    gammaRatios = reducedGammaRatios(q, nPoints);
    cvLength = 2*nPoints-1;
    convolutionVector = zeros(1, cvLength);
    
    %Constructs the convolution vector.
    convolutionVector(nPoints:cvLength) = gammaRatios;
    convolutionVector(1:nPoints) = convolutionVector(1:nPoints)...
                                     + fliplr(gammaRatios);
	
	convolutionVector = convolutionVector.*(1/step)^q;
    
end
