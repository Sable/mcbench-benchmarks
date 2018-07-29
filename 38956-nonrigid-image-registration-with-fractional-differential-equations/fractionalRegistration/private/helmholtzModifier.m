function modifiedConvolver = helmholtzModifier(convolutionVector, alpha)
%Turns a convolution analogous to matrix A into a convolution [alpha*I - A]
%
%convolutionVector is intended to be a vector that operatess on an input
%when convolved with the input, but can be any vector used for convolution.
%
%Creates a convolution vector that can solve the discrete Helmholtz 
%equation of the form [I - A]u = f where I is the identity matrix, A is a
%derivative operator, U is the unknown vector, and F is a known vector.

    modifiedConvolver = operatorModifier(convolutionVector, 1, alpha);

end