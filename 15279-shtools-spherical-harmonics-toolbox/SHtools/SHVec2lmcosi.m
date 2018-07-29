function lmcosi = SHVec2Info(vec)

% lmcosi = SHVec2Info(vec)
%
% Converts the real spherical harmonic coefficient vector to two
% coefficient matrices, A and B, such that A contains coefficients
% by cos(m*phi) and B contains coefficients by sin(m*phi).
% Proceeds to convert A and B to a single coefficient structure
% lmcosi in the format [l m Ccos Csin] in order, m>=0.
% This format is required by plm2rot and other functions
% of the library DOTM by F. J. Simons
 
[A,B]= SHVec2Matrix(vec);

lmax = size(A,1)-1;

count = 0;
for l=0:lmax
    for m=0:l
        count = count+1;
    end
end

lmcosi(1:count,1:4) = 0;

j=0;
for l=0:lmax
    for m=0:l
        j=j+1;
        lmcosi(j,1)=l;
        lmcosi(j,2)=m;
        lmcosi(j,3)=A(l+1,m+1);
        lmcosi(j,4)=B(l+1,m+1);
    end
end