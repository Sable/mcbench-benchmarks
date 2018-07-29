function [vec_a,vec_b] = SHDecompose(vec,lmax)

% [vec_a,vec_b] = SHDecompose(vec[,lmax])
%
% Decomposes the vector of layered spherical harmonic coefficients
% into coefficients corresponding to cos(m*phi) terms and those
% corresponding to sin(m*phi) terms.

vec_a = zeros(size(vec));
vec_b = zeros(size(vec));
 
[temp,i,j] = SHCreateVec(lmax);

for k=1:length(lmax)
    vec_k = vec(i(k):j(k));
    for n=1:length(vec_k)
        index = i(k)+n-1;
        [l,m] = SHn2lm(n);
        if m>=0
            vec_a(index) = vec(index);
        elseif m<0
            vec_b(index) = vec(index);
        end
    end
end