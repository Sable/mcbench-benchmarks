function Y=dd2(x)
%DD2 Single-level discrete 2-D wavelet transform.
%   DD2 performs a single-level 2-D wavelet decomposition
%   using Daubechies wavelet with four coefficients
%
%   Y = DD2(X) computes the approximation
%   coefficients matrix LL and details coefficients matrices 
%   LH, HL, HH, obtained by a wavelet decomposition of the 
%   input matrix X and puts the result in Y=[LL,LH;HL,HH].
%
%   The size of Y is the same as that of X which should be
%   a square matrix of size NxN where N is power of 2.
%   LL, LH, HL, and HH will have the size N/2xN/2
%   Minimum size of X is 4x4.
%   See also IDD2, DWTMODE, WAVEDEC2, WAVEINFO.

%   Auth: Dr. Bessam Z. Hassan
%   Last Revision: 27-Feb-2004.
%   Copyright 1995-2002 The MathWorks, Inc.
% $Revision: 1.0 $

%initialize coefficients

c0=(1+sqrt(3))/(4*sqrt(2));c1=(3+sqrt(3))/(4*sqrt(2));
c2=(3-sqrt(3))/(4*sqrt(2));c3=(1-sqrt(3))/(4*sqrt(2));

%check the inputs

[N,M]=size(x);
if N~=2^round(log(N)/log(2))
    error('size of the input should be power of 2');
end
if M~=N
    error('the input matrix must be square');
end

% construct the W matrix

w=[c0,c1,c2,c3];wi=[c3,-c2,c1,-c0];
W=[];X=x;p=zeros(N,N);
for i=1:N/2-1
    W(2*(i-1)+1:2*i,2*i-1:2*i+2)=[w;wi];
end
W=[W;[[w(3:4);wi(3:4)],zeros(2,N-4),[w(1:2);wi(1:2)]]];

% row transformation

z=W*X;

% row permutation
p(1:N,:)=[z(1:2:N,:);z(2:2:N,:)];

% column transformation

X=p';z=W*X;
p=zeros(N,N);

% column permutation

p(1:N,:)=[z(1:2:N,:);z(2:2:N,:)];
Y=p';