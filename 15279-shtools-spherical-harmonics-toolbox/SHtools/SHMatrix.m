function [A,B] = SHMatrix(vec,lmax)

% [A,B] = SHMatrix(vec[,lmax])
%
% Converts the real spherical harmonic coefficient vector to two
% coefficient matrices, A and B, such that A contains coefficients
% by cos(m*phi) and B contains coefficients by sin(m*phi).
%
% If lmax is specified, it must be a vector describing the spherical
% harmonics degrees lmax for each of the sections 1 .. length(lmax).
% This information allows the subroutine to separate the vector (vec)
% into distinct sections. If the sections are of different lengths,
% this function pads any non-existent coefficients with zeros.
% If lmax is not specified, this function checks whether vec is a valid 
% vector of spherical harmonic expansion coefficients. If so, computes
% the coefficient matrices for this vector (identical to SHVec2Matrix
% when lmax is not specified).
%
% To obtain the two coefficients corresponding to l and m<=l in the
% k'th section, evaluate A(l+1,m+1,k) and B(l+1,m+1,k), respectively.
% The invalid entries of the two matrices contain NaN's.
% Useful particularly for visualisation purposes.
 
if nargin < 2
    lmax = SHn2lm(length(vec));
end

[temp,i,j] = SHCreateVec(lmax);

if length(temp) ~= length(vec)
    error('invalid usage: input vector length and degree array mismatch');
end

len = SHl2n(max(lmax));

A = zeros(max(lmax)+1,max(lmax)+1,length(lmax));
B = zeros(max(lmax)+1,max(lmax)+1,length(lmax));

for k=1:length(lmax)
    row = zeros(1,len);
    len_k = SHl2n(lmax(k));
    row(1:len_k) = vec(i(k):j(k))';
    [A(:,:,k),B(:,:,k)] = SHVec2Matrix(row);
end