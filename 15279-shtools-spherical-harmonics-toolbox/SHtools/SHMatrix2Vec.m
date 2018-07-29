function [vec,lmax] = SHMatrix2Vec(A,B)

% [vec,lmax] = SHMatrix2Vec(A,B)
%
% Converts the two coefficient matrices, A and B, to the real 
% spherical harmonic coefficient vector. A contains coefficients
% by cos(m*phi) and B contains coefficients by sin(m*phi). 
% Inverse of SHMatrix2Vec.


lmax = size(A,1)-1;
vec = SHCreateVec(lmax);

j=0;
for l=0:lmax
    j=j+1;
    vec(j)=A(l+1,1);
    for m=1:l
        j=j+1;
        vec(j)=A(l+1,m+1);
        j=j+1;
        vec(j)=B(l+1,m+1);
    end
end
