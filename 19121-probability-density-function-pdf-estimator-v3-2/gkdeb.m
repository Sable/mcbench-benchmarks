function p=gkdeb(x,p)
% GKDEB  Gaussian Kernel Density Estimation with Bounded Support
% 
% Usage:
% p = gkdeb(d) returns an estmate of pdf of the given random data d in p,
%             where p.pdf and p.cdf are the pdf and cdf vectors estimated at
%             p.x locations, respectively and p.h is the bandwidth used for
%             the estimation. 
% p = gkdeb(d,p) specifies optional parameters for the estimation:
%             p.h - bandwidth
%             p.x - locations to make estimation
%             p.uB - upper bound
%             p.lB - lower bound.
%             p.alpha - to calculate inverse cdfs at p.alpha locations
%
% Without output, gkdeb(d) and gkdeb(d,p) will disply the pdf and cdf
% (cumulative distribution function) plot.  
%
% See also: hist, histc, ksdensity, ecdf, cdfplot, ecdfhist

% Example 1: Normal distribution
%{
gkdeb(randn(1e4,1));
%}
% Example 2: Uniform distribution
%{
clear p
p.uB=1;
p.lB=0;
gkdeb(rand(1e3,1),p);
%}
% Example 3: Exponential distribution
%{
clear p
p.lB=0;
gkdeb(-log(1-rand(1,1000)),p);
%}
% Example 4: Rayleigh distribution
%{
clear p
p.lB=0;
gkdeb(sqrt(randn(1,1000).^2 + randn(1,1000).^2),p);
%}

% V3.2 by Yi Cao at Cranfield University on 7th April 2010
%

% Check input and output
error(nargchk(1,2,nargin));
error(nargoutchk(0,1,nargout));

n=length(x);
% Default parameters
if nargin<2
    N=100;
    h=median(abs(x-median(x)))/0.6745*(4/3/n)^0.2;
    xmax=max(x);
    xmin=min(x);
    xmax=xmax+3*h;
    xmin=xmin-3*h;
    dx=(xmax-xmin)/(N-1);
    p.x=xmin+(0:N-1)*dx;
    p.pdf=zeros(1,N);
    p.cdf=zeros(1,N);
    p.h=h;
    dxdz=ones(size(p.x));
    z=p.x;
else
    [p,x,dxdz,z]=checkp(x,p);
    N=numel(p.x);
    h=p.h;
end

% Gaussian kernel function
kerf=@(z)exp(-z.*z/2);
ckerf=@(z)(1+erf(z/sqrt(2)))/2;
nh=n*h*sqrt(2*pi);

for k=1:N
    p.pdf(k)=sum(kerf((p.x(k)-x)/h));
    p.cdf(k)=sum(ckerf((p.x(k)-x)/h));
end
p.x=z;
p.pdf=p.pdf.*dxdz/nh;
dx=[0 diff(p.x)];
p.cdf=p.cdf/n;
% p.cdf=cumsum(p.pdf.*dx);

if isfield(p,'alpha')
    n=numel(p.alpha);
    p.icdf=p.alpha;
    for k=1:n
        alpha=p.alpha(k);
        ix=find(p.cdf>alpha,1)-1;
        x1=p.x(ix);
        x2=p.x(ix+1);
        F1=p.cdf(ix);
        F2=p.cdf(ix+1);
        p.icdf(k)=x1+(alpha-F1)*(x2-x1)/(F2-F1);
    end
end

% Plot
if ~nargout
    subplot(211)
    plot(p.x,p.pdf,'linewidth',2)
    grid
%     set(gca,'ylim',[0 max(p.pdf)*1.1])
    ylabel('f(x)')
    title('Estimated Probability Density Function');
    subplot(212)
    plot(p.x,p.cdf,'linewidth',2)
    ylabel('F(x)')
    title('Cumulative Distribution Function')
    xlabel('x')
    grid
    meanx = sum(p.x.*p.pdf.*dx);
    varx = sum((p.x-meanx).^2.*p.pdf.*dx);
    text(min(p.x),0.6,sprintf('mean(x) = %g\n var(x) = %g\n',meanx,varx));
    if isfield(p,'alpha') && numel(p.alpha)==1
        text(min(p.x),0.85,sprintf('icdf at %g = %g',p.alpha,p.icdf));
    end
end

function [p,x,dxdz,z]=checkp(x,p)
n=numel(x);
%check structure p
if ~isstruct(p)
    error('p is not a structure.');
end
if ~isfield(p,'uB')
    p.uB=Inf;
end
if ~isfield(p,'lB')
    p.lB=-Inf;
end
if p.lB>-Inf || p.uB<Inf
    [p,x,dxdz,z]=bounded(x,p);
else
    if ~isfield(p,'h')
        p.h=median(abs(x-median(x)))/0.6745*(4/3/n)^0.2;
    end
    error(varchk(eps, inf, p.h, 'Bandwidth, p.h is not positive.'));
    if ~isfield(p,'x')
        N=100;
        xmax=max(x);
        xmin=min(x);
        xmax=xmax+3*p.h;
        xmin=xmin-3*p.h;
        dx=(xmax-xmin)/(N-1);
        p.x=xmin+(0:N-1)*dx;
    end
    dxdz=ones(N,1);
    z=p.x;
end
p.pdf=zeros(size(p.x));
p.cdf=zeros(size(p.x));

function [p,x,dxdz,z]=bounded(x,p)
if p.lB==-Inf
    dx=@(t)1./(p.uB-t);
    y=@(t)-log(p.uB-t);
    zf=@(t)(p.uB-exp(-t));
elseif p.uB==Inf
    dx=@(t)1./(t-p.lB);
    y=@(t)log(t-p.lB);
    zf=@(t)exp(t)+p.lB;
else
    dx=@(t)(p.uB-p.lB)./(t-p.lB)./(p.uB-t);
    y=@(t)log((t-p.lB)./(p.uB-t));
    zf=@(t)(exp(t)*p.uB+p.lB)./(exp(t)+1);
end
x=y(x);
n=numel(x);
if ~isfield(p,'h')
    p.h=median(abs(x-median(x)))/0.6745*(4/3/n)^0.2;
end
h=p.h;
if ~isfield(p,'x')
    N=100;
    xmax=max(x);
    xmin=min(x);
    xmax=xmax+3*h;
    xmin=xmin-3*h;
    p.x=xmin+(0:N-1)*(xmax-xmin)/(N-1);
    z=zf(p.x);
else
    z=p.x;
    p.x=y(p.x);
end
dxdz=dx(z);

function msg=varchk(low,high,n,msg)
% check if variable n is not between low and high, returns msg, otherwise
% empty matrix
if n>=low && n<=high
    msg=[];
end

