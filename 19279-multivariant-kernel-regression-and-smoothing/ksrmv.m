function r=ksrmv(x,y,hx,z)
% KSRMV   Multivariate kernel smoothing regression
%
% r=ksrmv(x,y) returns the Gaussian kernel regression in structure r such that
%   r.f(r.x) = y(x) + e
% The bandwidth and number of samples are also stored in r.h and r.n
% respectively.
%
% r=ksrmv(x,y,h) performs the regression using the specified bandwidth, h.
%
% r=ksrmv(x,y,h,z) calculates the regression at location z (default z=x).
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
% See also gkde, ksdensity, ksr

% Example 1: smoothing a noised logo
%{
L = 40*membrane(1,25)+randn(51);
[x,y]=meshgrid(0:50);
r=ksrmv([x(:) y(:)],L(:));
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
r=ksrmv([x(:) y(:)],L(:));
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
% 
% % Vectorization, Not suitable for large data set
% % Firstly, diagnal matrix for bandwidth
% H=diag(1./hx);
% 
% % Then scale X by the bendwidth
% X=r.x*H;
% 
% % Square of X
% X2=sum(X.*X,2)/2;
% 
% % Scale Xi
% C=H*x';
% 
% % Square of Xi
% C2=sum(C.*C)/2;
% 
% % D = ((X - Xi) / H)^T ((X - Xi) / H)
% D=C2(ones(N,1),:)+X2(:,ones(1,r.n))-X*C;
% 
% % only elements whos values < 12 need to evaluated since exp(-12) = 6.1e-6
% idx=D<12;
% 
% % prepare local variable
% Z=zeros(N,r.n);
% 
% % Z = exp(-D)
% Z(idx)=exp(-D(idx));
% 
% % f(x) = sum Z*Yi / sum Z
% r.f=sum(Z.*y(:,ones(1,N))',2)./sum(Z,2);

% Improved efficient code

% Scaling first
H=diag(1./hx);
x=x*H;
x1=r.x*H;

% Gaussian kernel function
kerf=@(z)exp(-sum(z.*z,2)/2);

% allocate memory
r.f=zeros(N,1);

% Loop through each regression point
for k=1:N
    % scaled deference from regression point
    xx=abs(x-x1(k+zeros(r.n,1),:));
    % select neighbours using exp(-5^2/2)<5e-6
    idx=all(xx<5,2);
    % kernel function
    z=kerf(xx(idx,:));
    % regression
    r.f(k)=sum(z.*y(idx))/sum(z);
end
