function idst = myidst(vector)
%Determines the inverse discrete sine tranform of a vector using an fft.
%
%Given a row vector, returns the inverse discrete sine transformation of
%the vector. Uses a fourier transform to make the process more efficient.

    %Initializers
    sz = size(vector);
    vector = vector(:);
    nPoints = numel(vector);
    idst = zeros(sz);
    
    %Undoes coefficients on the dst vector.
    vector = vector*(-2i);
    
    %Take inverse Fourier Transform
    oddSymmetry = ifft([0;vector;0;-vector(nPoints:-1:1)]);

    % Truncate
    idst(:) = oddSymmetry(2:nPoints+1);

end
