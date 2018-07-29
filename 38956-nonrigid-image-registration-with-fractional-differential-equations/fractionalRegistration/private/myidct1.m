function idct = myidct1(vector)
%Determines the inverse discrete cosine tranform of a vector using an fft.
%
%Given a row vector, returns the inverse discrete cosine transformation of
%the vector. Since the DCT-I is its own inverse, this simply entails
%renormalizing.

    idct = (2/(numel(vector)-1))*mydct1(vector);

end
