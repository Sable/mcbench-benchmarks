function dct = mydct1(vector)
%Performs a discrete cosine transformation-I using a fast fourier transform
%
%Given an input vector, its discrete cosine transformation-I is taken.
%Input vector must be two elements or longer.

    %Initializer
    sz = size(vector);
    vector = vector(:);
    nPoints = numel(vector);
    dct = zeros(sz);
    
    %DCT-I symmetry invoked on a fourier transform
    fourier = fft([vector;vector((nPoints-1):-1:2)]);

    %Truncates and removes imprecision errors (negligible imaginary parts).
    dct(:) = real(fourier(1:nPoints))/2;

end
