function r=kdtree_ksrmv(x,y,hx,z)
% KDTREE_KSRMV   Multivariate kernel smoothing regression with kd-tree acceleration
%
% r=kdtree_ksrmv(x,y) returns the Gaussian kernel regression in structure r such that
%   r.f(r.x) = y(x) + e
% The bandwidth and number of samples are also stored in r.h and r.n
% respectively.
%
% r=kdtree_ksrmv(x,y,h) performs the regression using the specified bandwidth, h.
%
% r=kdtree_ksrmv(x,y,h,z) calculates the regression at location z (default z=x).
%
% Algorithm
% The kernel regression is a non-parametric approach to estimate the
% conditional expectation of a random variable:
%
% E(Y|X) = f(X)
%
% where f is a non-parametric function. Based on the kernel density
% estimation, this code implements the Nadaraya-Watson kernel regression
% using the Gaussian kernel as follows:
%
% f(x) = sum(kerf((x-X)/h).*Y)/sum(kerf((x-X)/h))
%
% For multivariant regression, when the measured data set and/or the number
% of regression data points are large, the computation required is
% intensive. To alleviate this problem, the kd-tree algorithm is used here
% to quickly identify the nearest neighbours around the regression points.
% The kd-tree code can be downloaded from the FEX ID 7030 and should be in
% the search path.
%
% See also gkde, ksdensity, ksr, ksrmv, kdtree

% Example 1: smoothing a noised logo
%{
L = 40*membrane(1,25)+randn(51);
[x,y]=meshgrid(0:50);
r=kdtree_ksrmv([x(:) y(:)],L(:));
Lr=L;
Lr(:)=r.f;
subplot(121), surf(x,y,L)
subplot(122), surf(x,y,Lr)
%}
% Example 2: smoothing noised peaks with 20% missing data
%{
L = 10*peaks(50)+randn(50);
I = ceil(rand(500,1)*2500);
L(I) = NaN;
[x,y]=meshgrid(1:50);
r=kdtree_ksrmv([x(:) y(:)],L(:));
Lr=L;
Lr(:)=r.f;
subplot(121), surf(x,y,L)
subplot(122), surf(x,y,Lr)
%}

% By Yi Cao at Cranfield University on 20 March 2008.
%

% Check input and output
error(nargchk(2,4,nargin));
error(nargoutchk(0,1,nargout));

if ~exist('kdtree','file') || ~exist('kdtree_range','file')
    error('Kdtree is not in the path. It can be downloaded from FEX ID 7030.');
end

y=y(:);
if size(x,1)~=size(y,1)
    error('x and y have different rows.');
end
d=size(x,2);

% Default parameters
if nargin<4
    z=x;
elseif size(z,2)~=d
    error('z must have the same number of columns as x.')
end
r.x=z;
N=size(z,1);

% clean missing or invalid data points
inv=(y~=y);
x(inv,:)=[];
y(inv)=[];
r.n=numel(y);

if nargin<3
    % optimal bandwidth suggested by Bowman and Azzalini (1997) p.31
    hy=median(abs(y-median(y)))/0.6745*(4/(d+2)/r.n)^(1/(d+4));
    hx=median(abs(x-repmat(median(x),r.n,1)))/0.6745*(4/(d+2)/r.n)^(1/(d+4));
    hx=sqrt(hy*hx);
elseif size(hx,2)~=d
    error('h must be a scalar.')
end
r.h=hx;
H=diag(1./hx);
x1=x*H;
tree=kdtree(x1);
x2=r.x*H;
% Gaussian kernel function
kerf=@(z)exp(-sum(z.*z,2)/2);
r.f=zeros(N,1);
for k=1:N
    x0=x2(k,:);
    idx=kdtree_range(tree,[x0-5;x0+5]');
    n=numel(idx);
    z=kerf(x0(ones(n,1),:)-x1(idx,:));
    r.f(k)=sum(z.*y(idx))/sum(z);
end
