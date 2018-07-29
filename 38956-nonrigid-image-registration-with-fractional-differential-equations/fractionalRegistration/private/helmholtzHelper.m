function derivativeVector = helmholtzHelper(inputVector, q, alpha)
%Generates the helmholtz derivative vector for forward/backward convolving.
%
%helmholtzHelper takes a row or column input vector and a float, q, that is
%the order of the derivative to be taken, and generates a shifted operator
%operator that is modified for the Helmholtz equation. The vector returned
%is the equivalent of [I - A] where A is the operator.

    %Generates the derivative operator vector.
    [step, lowerBound, upperBound] = defaultBoundaries(numel(inputVector));
    derivativeVector = -additiveConvolutionVector(step, lowerBound, ...
                                                 upperBound, q);

    %Undoes a derivative.
    derivativeVector = helmholtzModifier(derivativeVector, alpha);
    derivativeVector = shiftOperator(derivativeVector);

end
