function b=ghmap2(a)
%GHMAP2 Single-level discrete 2-D multi-wavelet transform.
%   GHM performs a single-level 2-D multiwavelet decomposition
%   using GHM multiwavelet with four multi-filters
%
%   Y = GHMAP(X) computes the approximation
%   coefficients matrix LL and details coefficients matrices 
%   LH, HL, HH, obtained by a multiwavelet decomposition of the 
%   input matrix X and puts the result in Y=[LL,LH;HL,HH].
%
%   The size of Y is the same as that of X which should be
%   a square matrix of size NxN where N is power of 2 since
%   X is vectorized by critical sampling preprocessing.
%   The preprocessing filter is of order 2 degree 2.
%   LL, LH, HL, and HH will have the size N/2xN/2
%
%   See also IGHMAP, GHMAP, IGHMAP2, DD2, IDD2, WAVEDEC2, WAVEINFO.

%   Auth: Dr. Bessam Z. Hassan
%   Last Revision: 27-Feb-2004.
%   Copyright 1995-2002 The MathWorks, Inc.
% $Revision: 1.0 $
if nargin == 0,
	error('Not enough input arguments.');
end
if isempty(a)
   b = [];
   return
end
H0=[3/(5*sqrt(2)),4/5;-1/20,-3/(10*sqrt(2))];
H1=[3/(5*sqrt(2)),0;9/20,1/sqrt(2)];
H2=[0,0;9/20,-3/(10*sqrt(2))];
H3=[0,0;-1/20,0];
G0=[-1/20,-3/(10*sqrt(2));1/(10*sqrt(2)),3/10];
G1=[9/20,-1/sqrt(2);-9/(10*sqrt(2)),0];
G2=[9/20,-3/(10*sqrt(2));9/(10*sqrt(2)),-3/10];
G3=[-1/20,0;-1/(10*sqrt(2)),0];
[N,M]=size(a);
if N~=2^round(log(N)/log(2))
    error('size of the input should be power of 2');
end
if M~=N
    error('the input matrix must be square');
end
w=[H0,H1,H2,H3;G0,G1,G2,G3];
for i=1:N/4-1
    W(4*(i-1)+1:4*i,4*i-3:4*i+4)=w;
end
W=[W;[[H2,H3;G2,G3],zeros(4,N-8),[H0,H1;G0,G1]]];
p=[];X=[];
% preprocess rows
X(1:2:N,:)=10/(8*sqrt(2))*a(1:2:N,:)+3/(8*sqrt(2))*a(2:2:N,:)+3/(8*sqrt(2))*[zeros(1,N);a(2:2:N-1,:)];
X(2:2:N,:)=a(2:2:N,:);
z=W*X;
ii=0:4:N-1;jj=sort([ii+1,ii+2]);kk=sort([ii+3,ii+4]);
p=[p;z(jj,:);z(kk,:)];
aa=p';X=[];
% preprocess columns
X(1:2:N,:)=10/(8*sqrt(2))*aa(1:2:N,:)+3/(8*sqrt(2))*aa(2:2:N,:)+3/(8*sqrt(2))*[zeros(1,N);aa(2:2:N-1,:)];
X(2:2:N,:)=aa(2:2:N,:);
z=W*X;
p=[];
ii=0:4:N-1;jj=sort([ii+1,ii+2]);kk=sort([ii+3,ii+4]);
p=[p;z(jj,:);z(kk,:)];
b=p';b1=b(1:N/2,1:N/2);b2=b(1:N/2,N/2+1:N);b3=b(N/2+1:N,1:N/2);b4=b(N/2+1:N,N/2+1:N);
T=[b1(1:2:N/2,:);b1(2:2:N/2,:)]';b1=[T(1:2:N/2,:);T(2:2:N/2,:)]';
T=[b2(1:2:N/2,:);b2(2:2:N/2,:)]';b2=[T(1:2:N/2,:);T(2:2:N/2,:)]';
T=[b3(1:2:N/2,:);b3(2:2:N/2,:)]';b3=[T(1:2:N/2,:);T(2:2:N/2,:)]';
T=[b4(1:2:N/2,:);b4(2:2:N/2,:)]';b4=[T(1:2:N/2,:);T(2:2:N/2,:)]';
b=[b1,b2;b3,b4];