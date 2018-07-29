function r=ksrlin(x,y,h,N)
% KSRLIN   Local linear kernel smoothing regression
%
% r=ksrlin(x,y) returns the local linear Gaussian kernel regression in
% structure r such that r.f(r.x) = y(x) + e. The bandwidth and number of
% samples are also stored in r.h and r.n respectively.
%
% r=ksrlin(x,y,h) performs the regression using the specified bandwidth, h.
%
% r=ksrlin(x,y,h,n) calculates the regression in n points (default n=100).
%
% Without output, ksrlin(x,y) or ksrlin(x,y,h) will display the regression
% plot. 
%
% Algorithm
% The kernel regression is a non-parametric approach to
% estimate the conditional expectation of a random variable:
%
% E(Y|X) = f(X)
%
% where f is a non-parametric function. The normal kernel regression is a
% local constant estimator. The extension of local linear estimator is
% obtained by solving the least squares problem:
%
% min sum (y-alpha-beta(x-X))^2 kerf((x-X)/h)
%
% The local linear estimator can be given an explicit formula
%
% f(x) = 1/n sum((s2-s1*(x-X)).*kerf((x-X)/h).*Y)/(s2*s0-s1^2)
%
%where si = sum((x-X)^i*kerf((x-X)/h))/n. Compare with local constant
%estimator, the local linear estimator can improve the estimation near the
%edge of the region over which the data have been collected.
%
% See also gkde, ksdensity, ksr

% Reference:
% Bowman, A.W. and Azzalini, A., Applied Smoothing Techniques for Data
% Analysis, Clarendon Press, 1997 (p.50) 

% Example 1: smooth curve with noise
%{
x = 1:100;
y = sin(x/10)+(x/50).^2;
yn = y + 0.2*randn(1,100);
r=ksrlin(x,yn);
r1=ksr(x,yn); % downloadable from FEX ID 19195
plot(x,y,'b-',x,yn,'co',r.x,r.f,'r--',r1.x,r1.f,'m-.','linewidth',2)
legend('true','data','local linear','local constant','location','northwest');
title('Gaussian kernel regression')
%}
% Example 2: with missing data
%{
x = sort(rand(1,100)*99)+1;
y = sin(x/10)+(x/50).^2;
y(round(rand(1,20)*100)) = NaN;
yn = y + 0.2*randn(1,100);
r=ksrlin(x,yn);
r1=ksr(x,yn); % downloadable from FEX ID 19195
plot(x,y,'b-',x,yn,'co',r.x,r.f,'r--',r1.x,r1.f,'m-.','linewidth',2)
legend('true','data','local linear','local constant','location','northwest');
title('Gaussian kernel regression with 20% missing data')
%}

% By Yi Cao at Cranfield University on 12 April 2008.
%

% Check input and output
error(nargchk(2,4,nargin));
error(nargoutchk(0,1,nargout));
if numel(x)~=numel(y)
    error('x and y are in different sizes.');
end

x=x(:);
y=y(:);
% clean missing or invalid data points
inv=(x~=x)|(y~=y)|(abs(x)==Inf)|(abs(y)==Inf);
x(inv)=[];
y(inv)=[];

% Default parameters
if nargin<4
    N=100;
elseif ~isscalar(N)
    error('N must be a scalar.')
end
r.n=length(x);
if nargin<3
    % optimal bandwidth suggested by Bowman and Azzalini (1997) p.31
    hx=median(abs(x-median(x)))/0.6745*(4/3/r.n)^0.2;
    hy=median(abs(y-median(y)))/0.6745*(4/3/r.n)^0.2;
    h=sqrt(hy*hx);
elseif ~isscalar(h)
    error('h must be a scalar.')
end
r.h=h;

% Gaussian kernel function
kerf=@(z)exp(-z.*z/2)/sqrt(2*pi);

r.x=linspace(min(x),max(x),N);
r.f=zeros(1,N);
for k=1:N
    d=r.x(k)-x;
    z=kerf(d/h);
    s1=d.*z;
    s2=sum(d.*s1);
    s1=sum(s1);
    r.f(k)=sum((s2-s1*d).*z.*y)/(s2*sum(z)-s1*s1);
end

% Plot
if ~nargout
    plot(r.x,r.f,'r',x,y,'bo')
    ylabel('f(x)')
    xlabel('x')
    title('Kernel Smoothing Regression');
end
