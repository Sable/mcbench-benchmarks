function a=IGHM(b)
%IGHM Single-level inverse discrete 2-D multiwavelet transform.
%   IGHM performs a single-level 2-D multiwavelet reconstruction
%   using GHM multiwavelet with four multi-filters
%
%   Y = IGHM(X) computes the original matrix from the approximation
%   coefficients matrix LL and details coefficients matrices 
%   LH, HL, HH, obtained by a multiwavelet decomposition of the 
%   original input matrix and puts the result in Y.
%
%   The size of Y is half that of X which should be
%   a square matrix of size NxN where N is power of 2 since
%   X is de-vectorized by a repeated row postprocessing.
%
%   X should be arranged as [LL,LH;HL,HH].
%
%   See also GHM, GHMAP, IGHMAP DD2, IDD2, DWTMODE, WAVEDEC2, WAVEINFO.

%   Auth: Dr. Bessam Z. Hassan
%   Last Revision: 27-Feb-2004.
%   Copyright 1995-2002 The MathWorks, Inc.
% $Revision: 1.0 $

% initialize the coefficients
H0=[3/(5*sqrt(2)),4/5;-1/20,-3/(10*sqrt(2))];
H1=[3/(5*sqrt(2)),0;9/20,1/sqrt(2)];
H2=[0,0;9/20,-3/(10*sqrt(2))];
H3=[0,0;-1/20,0];
G0=[-1/20,-3/(10*sqrt(2));1/(10*sqrt(2)),3/10];
G1=[9/20,-1/sqrt(2);-9/(10*sqrt(2)),0];
G2=[9/20,-3/(10*sqrt(2));9/(10*sqrt(2)),-3/10];
G3=[-1/20,0;-1/(10*sqrt(2)),0];
% check the input
if nargin == 0,
	error('Not enough input arguments.');
end
if isempty(b)
   a = [];
   return
end
[N,M]=size(b);N=ceil(N/2);M=ceil(M/2);
if N~=2^round(log(N)/log(2))
    error('size of the input should be power of 2');
end
if M~=N
    error('the input matrix must be square');
end
% construct the W matrix
w=[H0,H1,H2,H3;G0,G1,G2,G3];
for i=1:N/2-1
    W(4*(i-1)+1:4*i,4*i-3:4*i+4)=w;
end
W=[W;[[H2,H3;G2,G3],zeros(4,2*N-8),[H0,H1;G0,G1]]];
p=[];X=[];
% coefficient shuffling
b1=b(1:N,1:N);b2=b(1:N,N+1:2*N);b3=b(N+1:2*N,1:N);b4=b(N+1:2*N,N+1:2*N);
b1=b1';b2=b2';b3=b3';b4=b4';
T(1:2:N,:)=b1(1:N/2,:);T(2:2:N,:)=b1(N/2+1:N,:);T=T';b1(1:2:N,:)=T(1:N/2,:);b1(2:2:N,:)=T(N/2+1:N,:);
T(1:2:N,:)=b2(1:N/2,:);T(2:2:N,:)=b2(N/2+1:N,:);T=T';b2(1:2:N,:)=T(1:N/2,:);b2(2:2:N,:)=T(N/2+1:N,:);
T(1:2:N,:)=b3(1:N/2,:);T(2:2:N,:)=b3(N/2+1:N,:);T=T';b3(1:2:N,:)=T(1:N/2,:);b3(2:2:N,:)=T(N/2+1:N,:);
T(1:2:N,:)=b4(1:N/2,:);T(2:2:N,:)=b4(N/2+1:N,:);T=T';b4(1:2:N,:)=T(1:N/2,:);b4(2:2:N,:)=T(N/2+1:N,:);
b=[b1,b2;b3,b4];
p=b';
% column vector shuffling
ii=0:4:2*N-1;jj=sort([ii+1,ii+2]);kk=sort([ii+3,ii+4]);
z(jj,:)=p(1:N,:);z(kk,:)=p(N+1:2*N,:);
% column inverse transform
X=W'*z;
% downsampling columns (repeated row postprocessing)
aa=X(1:2:2*N,:);
p=aa';
% row vector shuffling
ii=0:4:2*N-1;jj=sort([ii+1,ii+2]);kk=sort([ii+3,ii+4]);z=[];
z(jj,:)=p(1:N,:);z(kk,:)=p(N+1:2*N,:);
% row inverse transform
X=W'*z;
%downsampling rows (repeated row postprocessing)
a=X(1:2:2*N,:);


