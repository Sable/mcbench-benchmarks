function modifiedConvolver = operatorModifier(operatorVector, time, alpha)
%Turns an operator analogous to matrix A into ~[alpha*I - time*A]
%
%convolutionVector is intended to be a vector that operatess on an input
%when convolved with the input, but can be any vector used for convolution.
%Time is a time step.
%
%Creates a modified convolution vector that can be used to solve the 
%discrete diffusion equation. 

    middleIndex = round((numel(operatorVector)+1)/2);
    
    modifiedConvolver = -time.*operatorVector;
    modifiedConvolver(middleIndex) = modifiedConvolver(middleIndex)+alpha;

end