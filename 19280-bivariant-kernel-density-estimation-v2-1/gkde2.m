function p=gkde2(x,p)
% function p=gkde2(x,N,h,xylim,alpha)
% GKDE2  Bivariate Gaussian Kernel Density Estimation
% 
% Usage:
% p = gkdeb(d) returns an estmate of the probability density function (pdf)
%             and the cumulative distribution function (cdf) of the given
%             random data d in p, where p.pdf and p.cdf are the pdf and cdf
%             vectors estimated at locations of (p.x, p.y), respectively
%             and p.h is the bandwidth used for the estimation. 
% p = gkdeb(d,p) specifies optional parameters for the estimation:
%             p.h  - 1x2 vector for bandwidth, [hx, hy]
%             p.xy - Nx2 matrix for locations to make estimation
%             p.xylim - 1x4 location limits as [xmin ymin xmax ymax]
%             p.alpha - a vector of probabilities to calculate inverse cdfs.
%
% Without output, gkdeb(d) and gkdeb(d,p) will disply the pdf and cdf plots.  
%
% See also: hist, histc, ksdensity, ecdf, cdfplot, ecdfhist

% Example 1: two-peak normal distribution
%{
gkde2([randn(500,2);randn(500,1)+5 randn(500,1)]);
%}
% Example 2: four-peak normal distribution
%{
gkde2([randn(100,1), (randn(100,1)-10)*2;
      randn(100,1)+10, randn(100,1);
      randn(100,1)+10, (randn(100,1)-10)*2;
      randn(100,2)]);
%}
% Example 3: uniform distribution
%{
clear p
p.xylim=[0 0 1 1];
gkde2(rand(500,2),p);
%}
% Example 4: dumbbell density
%{
X1=[randn(2000,1)-2 randn(2000,1)+2];
X2=randn(2000,2)*inv([0.8 -0.72;-0.72 0.8]);
X3=[randn(2000,1)+2 randn(2000,1)-2];
p=gkde2(((X1+X3)*4+X2*3)/11);
figure
contour(p.x,p.y,p.pdf,20);
figure
contour(p.x,p.y,p.cdf,20);
%}

% V2.1 by Yi Cao at Cranfield University on 10th August 2013
%

% Check input and output
error(nargchk(1,2,nargin));
error(nargoutchk(0,1,nargout));
[nr, nc] = size(x);
if nr ~= 2 && nc ~= 2
    error('Bivariate data required!');
end
if nc>nr
    x=x';
end 
n=length(x);
% Default parameters
if nargin<2
    N=50;
    % rule of thumb bandwidth suggested by Bowman and Azzalini (1997) p.31
    h=median(abs(x-repmat(median(x),n,1)))/0.6745*(1/n)^(1/6);
    xylim=[-inf -inf inf inf];
    xmax=max(x);
    xmin=min(x);
    xmax=min([xmax+3*h;xylim(3:4)]);
    xmin=max([xmin-3*h;xylim(1:2)]);
    x1=linspace(xmin(1),xmax(1),N);
    x2=linspace(xmin(2),xmax(2),N);
    [px,py]=meshgrid(x1,x2);
    X=[px(:) py(:)];
    p.x=px;
    p.y=py;
    p.h=h;
    p.xylim=xylim;
    dxdz=ones(N*N,1);
    p.N=N;
else % check parameters with default setting
    [p,x,dxdz,X]=checkp(x,p);
    N=p.N;
    xmin = min(X);
    xmax = max(X);
end
dxdz=dxdz/n;
p.pdf=zeros(N,N);
p.cdf=zeros(N,N);
N2=N*N;

% Bivariant Gaussian kernel function
kerf=@(t)exp(-sum(t.*t,2)/2)/(2*pi);
% cdf estimation based on A. Genz, Statistics and Computing 14:251–260, 2004
ckerf=@(t)prod(erfc(-t ./ sqrt(2))/2,2);
for k=1:N2
    h=min([min([X(k,:)-xmin;p.h]);min([xmax-X(k,:);p.h])]);
    if prod(h)<sqrt(eps)
        p.pdf(k)=0;
        r = mod(k-1,N)+1;
        c = ceil(k/N);        
        p.cdf(k)=max(max(p.cdf(1:r,1:c)));
        continue
    end
    z=(X(k+zeros(n,1),:)-x)./h(ones(n,1),:);
    p.pdf(k)=sum(kerf(z))/prod(h);
    p.cdf(k)=sum(ckerf(z));
end
% p.cdf=cumsum(p.pdf);
% p.cdf=cumsum(p.cdf,2)*prod((xmax-xmin)/N);
p.pdf(:)=p.pdf(:).*dxdz(:);
p.cdf=p.cdf/n;
p.cdf(p.cdf>1)=1;
p.cdf(p.cdf<0)=0;

% calculate icdf
if isfield(p,'alpha')
    C=contour(p.x,p.y,p.cdf,[p.alpha p.alpha]);
    p.icdfx = min(C(1,2:end));
    p.icdfy = min(C(2,2:end));
end


% Plot results
if ~nargout
    xLim=[min(p.x(:)) max(p.x(:))];
    yLim=[min(p.y(:)) max(p.y(:))];
    subplot(221)
    mesh(p.x,p.y,p.pdf);
    xlabel('x');
    ylabel('y')
    zlabel('p(x)')
    title('Estimated Probability Density Function');
    set(gca,'XLim',xLim,'YLim',yLim)
    subplot(222)
    mesh(p.x,p.y,p.cdf);
    xlabel('x');
    ylabel('y')
    zlabel('F(x)')
    title('Estimated Cumlative Distribution Function');
    set(gca,'XLim',xLim,'YLim',yLim,'ZLim',[0 1.1])
    subplot(223)
    contour(p.x,p.y,p.pdf);
    xlabel('x');
    ylabel('y')
    zlabel('p(x)')
    title('Contour of Probability Density Function');
    set(gca,'XLim',xLim,'YLim',yLim)
    subplot(224)
    contour(p.x,p.y,p.cdf);
    xlabel('x');
    ylabel('y')
    zlabel('F(x)')
    set(gca,'XLim',xLim,'YLim',yLim)
    if isfield(p,'alpha')
        title(sprintf('icdf_x = %g, icdf_y = %g',p.icdfx,p.icdfy))
    else
        title('Contour of Cumlative Distribution Function');        
    end
end

function [p,x,dxdz,z]=checkp(x,p)
%check structure p
if ~isstruct(p)
    error('p is not a structure.');
end
if ~isfield(p,'xylim')
    p.xylim=[-Inf -Inf Inf Inf];
end
if ~isfield(p,'N')
    p.N=50;
end
px.N=p.N;
py.N=p.N;
if isfield(p,'h')
    px.h=p.h(1);
    py.h=p.h(2);
end
% px = p;
% py = p;
if isfield(p,'x')
    px.x = p.x(:);
end
if isfield(p,'y')
    py.x=p.y(:);
end
px.lB = p.xylim(1);
py.lB = p.xylim(2);
px.uB = p.xylim(3);
py.uB = p.xylim(4);
[px,X,dXdz,zx] = bounded(x(:,1),px);
[py,Y,dYdz,zy] = bounded(x(:,2),py);
if isfield(p,'x') && isfield(p,'y')  
    p.x = reshape(zx,p.N,[]);
    p.y = reshape(zy,p.N,[]);
    z = [px.x py.x];
    dxdz=dXdz.*dYdz;
else
    [p.x,p.y]=meshgrid(zx,zy);
    [zx,zy]=meshgrid(px.x,py.x);
    z = [zx(:) zy(:)];
    dxdz=dYdz(:)*dXdz(:)';
end
p.h = [px.h py.h];
x = [X Y];

function [p,x,dxdz,z]=bounded(x,p)
n=length(x);
if p.lB>-Inf || p.uB<Inf
    if p.lB==-Inf
        % function for (dx_bound)/(dx_unbounded)
        dx=@(t)1./(p.uB-t);
        % function for converting x_bounded to x_unbounded 
        y=@(t)-log(p.uB-t);
        % function for converting x_unbounded to x_bounded
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
        N=p.N;
        xmax=max(x)+3*h;
        xmin=min(x)-3*h;
        p.x=linspace(xmin,xmax,N);
        z=zf(p.x);
    else
        z=p.x;
        p.x=y(p.x);
    end
    dxdz=dx(z);
else
    if ~isfield(p,'h')
        p.h=median(abs(x-median(x)))/0.6745*(4/3/n)^0.2;
    end
    error(varchk(eps, inf, p.h, 'Bandwidth, p.h is not positive.'));
    if ~isfield(p,'x')
        N=p.N;
        xmax=max(x);
        xmin=min(x);
        xmax=min(xmax+3*p.h,p.uB);
        xmin=max(xmin-3*p.h,p.lB);
        p.x=linspace(xmin,xmax,N);
    end
    dxdz=ones(size(p.x(:)));
    z=p.x;
end

function msg=varchk(low,high,n,msg)
% check if variable n is not between low and high, returns msg, otherwise
% empty matrix
if all(n>=low) && all(n<=high)
    msg=[];
end
