function [A,B,I] = SHVec2Matrix(vec)

% [A,B,I] = SHVec2Matrix(vec)
%
% Converts the real spherical harmonic coefficient vector to two
% coefficient matrices, A and B, such that A contains coefficients
% by cos(m*phi) and B contains coefficients by sin(m*phi).
% Useful particularly for visualisation purposes.
% To obtain the two coefficients corresponding to l and m<=l,
% evaluate A(l+1,m+1) and B(l+1,m+1), respectively.
% The invalid entries of the two matrices contain NaN's.
% If the third output argument is present, also outputs the matrix
% of character information about the contents of A and B.
 

lmax = SHVec2l(vec);

A(1:lmax+1,1:lmax+1) = NaN;
B(1:lmax+1,1:lmax+1) = NaN;
I(1:lmax+1,1:lmax+1) = {''};

j=0;
for l=0:lmax
    I(l+1,1)={['l=' num2str(l) ' m=' num2str(0)]};
    j=j+1;
    A(l+1,1)=vec(j);
    B(l+1,1)=0;
    for m=1:l
        I(l+1,m+1)={['l=' num2str(l) ' m=' num2str(m)]};
        j=j+1;
        A(l+1,m+1)=vec(j);
        j=j+1;
        B(l+1,m+1)=vec(j);
    end
end
