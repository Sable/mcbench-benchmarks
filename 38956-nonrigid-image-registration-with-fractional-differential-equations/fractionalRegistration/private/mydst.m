function dst = mydst(vector)
%Performs a discrete sine transformation using a fast fourier transform
%
%Given an input vector, its discrete sine transformation
%(based on the DST-I) is returned. This is a unitary transformation.
%Based on Partial Differential Equations: Analytical and Numerical Methods
%Although they were wrong, it seems.

    %Initializers
    sz = size(vector);
    vector = vector(:);
    nPoints = numel(vector);
    dst = zeros(sz);
    
    %Takes the Fourier Transformation
    fourier = fft([0;vector;0;-vector(nPoints:-1:1)]);

    %Truncates and reduces to the sine transformation
    dst(:) = imag(fourier(2:nPoints+1))./(-2);
    
end
