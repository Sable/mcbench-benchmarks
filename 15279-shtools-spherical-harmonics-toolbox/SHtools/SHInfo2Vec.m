function [vec,lmax] = SHInfo2Vec(lmcosi)

% [vec,lmax] = SHInfo2Vec(lmcosi)
%
% The input coefficient structure
% lmcosi in the format [l m Ccos Csin] in order, m>=0.
% This format is provided by plm2rot and other functions
% of the library DOTM by F. J. Simons
% Outputs the real spherical harmonic coefficient vector.
 
lmax = lmcosi(end,1);

A(1:lmax+1,1:lmax+1) = NaN;
B(1:lmax+1,1:lmax+1) = NaN;

j=0;
for l=0:lmax
    for m=0:l
        j=j+1;
        A(l+1,m+1)=lmcosi(j,3);
        B(l+1,m+1)=lmcosi(j,4);
    end
end

[vec,lmax] = SHMatrix2Vec(A,B);
