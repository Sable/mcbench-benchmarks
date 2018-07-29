function [p,Ainv,B]=fadlev(A)
%
% FADLEV  Faddeev-Leverrier approach to generate coefficients of the
% characteristic polynomial and inverse of a given matrix
% Uasage:        [p,Ainv,B]=fedlev(A)
%
% Input:     A - the given matrix
% Output:    p - the coefficient vector of the characteristic polynomial 
%           B - a cell array of the sequency of matrices generated, where
%               B{1} = A                    p(1)=trace(B{1})
%               B{2} = A*(B{1}-p(1)*I)      p(2)=trace(B{2})/2
%               .....
%               B{n} = A*(B{n-1}-p(n-1)*I)  p(n)=trace(B{n})/n
%   
%           Ainv - The inverse of A calculated as
%               Ainv = (B{n-1}-p(n-1)*I)/p(n)
%
% Example:
%{
A=magic(5);
[p,B]=fadlev(A);
fprintf('Check inverse: norm(B-inv(A))=%g\n',norm(B-inv(A)));
fprintf('Check polynomial: norm(p-poly(A))=%g\n',norm(p-poly(A)));
%}
% By Yi Cao on 17 August 2007 at Cranfield University
%
% Reference: 
% Vera Nikolaevna Faddeeva, "Computational Methods of Linear
% Algebra," (Translated From The Russian By Curtis D. Benster), Dover
% Publications Inc. N.Y., Date Published: 1959 ISBN: 0486604241. 
%

[n,m]=size(A);
if n~=m
    error('The given matrix is not square!');
end

[B{1:n}]=deal(A);
p=ones(1,n+1);
for k=2:n
    p(k)=-trace(B{k-1})/(k-1);
    B{k}=A*(B{k-1}+p(k)*eye(n));
end
p(n+1)=-trace(B{n})/n;
Ainv=-(B{n-1}+p(n)*eye(n))/p(n+1);

