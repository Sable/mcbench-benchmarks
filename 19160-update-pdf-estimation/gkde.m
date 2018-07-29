function p=gkde(x,p)
% GKDE  Gaussian kernel density estimation and update.
% 
% Usage:
% p = gkde(d) returns an estmate of pdf of the given random data d in p,
%             where p.f is the pdf vector estimated at p.x locations, 
%             p.h and p.n are the bandwidth and number of samples used for
%             the estimation. 
% p = gkde(d,p) calculates (p.n=0) or updates (p.n>0) the pdf estimation
%             using locations at p.x, bandwidth p.h and previous estimation
%             p.f. For a fresh estimation, p.f=0. Specify p.hnew if a
%             change of bandwidth is required.
%
% Without any output, gkde(d) or gkde(d,p) will disply the estimated
% (updated) pdf plot.  
%
% See also hist, histc, ksdensity, ecdf, cdfplot, ecdfhist

% Example 1: Normal distribution
%{
gkde(randn(1e5,1));
%}
% Example 2: Uniform distribution and update
%{
p=gkde(rand(1e3,1));
plot(p.x,p.f,'b','linewidth',2)
hold on
p=gkde(rand(1e3,1),p);
plot(p.x,p.f,'r','linewidth',2)
p=gkde(rand(1e3,1),p);
plot(p.x,p.f,'g','linewidth',2)
p=gkde(rand(1e3,1),p);
plot(p.x,p.f,'c','linewidth',2)
hold off
%}
% Example 3: Two sets of Gaussian random data with different means
%{
X1=randn(1e3,1)-5;
X2=randn(1e3,1);
p1=gkde(X1);
p2=gkde(X2,p1);
p3=gkde([X1;X2]);
dx=mean(diff(p1.x));
subplot(211)
plot(p1.x,p1.f,'b',p2.x,p2.f,'r',p3.x,p3.f,'c','linewidth',2)
legend('orginal','updated','joint estimation')
ylabel('f(x)')
grid
title('Probability Density Function')
subplot(212)
plot(p1.x,cumsum(p1.f*dx),'b',p2.x,cumsum(p2.f*dx),'r',p3.x,cumsum(p3.f*mean(diff(p3.x))),'c','linewidth',2)
ylabel('F(x)')
title('Probability Function: F(x)=\int_-_\infty^xf(x)dx')
xlabel('x')
grid
meanx1 = sum(p1.x.*p1.f*dx);
varx1 = sum((p1.x-meanx1).^2.*p1.f*dx);
meanx2 = sum(p2.x.*p2.f*dx);
varx2 = sum((p2.x-meanx2).^2.*p2.f*dx);
meanx3 = sum(p3.x.*p3.f*mean(diff(p3.x)));
varx3 = sum((p3.x-meanx3).^2.*p3.f*mean(diff(p3.x)));
str1=sprintf('old mean(x) = %g\n old var(x) = %g\n',meanx1,varx1);
str2=sprintf('new mean(x) = %g\n new var(x) = %g\n',meanx2,varx2);
str3=sprintf('joint mean(x) = %g\n joint var(x) = %g\n',meanx3,varx3);
text(max(p1.x),0.3,[str1 str2 str3]) 
%}

% V2.0 by Yi Cao at Cranfield University on 11th March 2008
%

% Check input and output
error(nargchk(1,2,nargin));
error(nargoutchk(0,1,nargout));

% features of given data
x=x(:);
n=numel(x);

% Default parameters, optimal for Gaussian kernel
if nargin<2
    N=100;
    p.h=median(abs(x-median(x)))*1.5704/(n^0.2);
    dx=p.h*3;
    p.n=0;
    p.x=linspace(min(x)-dx,max(x)+dx,N);
    p.f=zeros(1,N);
end

% check the structue
checkp(p);

% scale back if update
if p.n>0
    p.f=p.f*p.n;
    dx=mean(diff(p.x));
    xl=p.x(1)-min(x)+3*p.h;
    nl=max(0,ceil(xl/dx));
    xh=max(x)+p.h*3-p.x(end);
    nh=max(0,ceil(xh/dx));
    p.x=[p.x(1)-nl*dx:dx:p.x(1)-dx p.x p.x(end)+dx:dx:p.x(end)+nh*dx];
    p.f=[zeros(1,nl) p.f zeros(1,nh)];
end
N=numel(p.x);

% Gaussian kernel function
kerf=@(z)exp(-z.*z/2)/sqrt(2*pi);

% density estimation or update
for k=1:N
    p.f(k)=p.f(k)+sum(kerf((p.x(k)-x)/p.h))/p.h;
end
p.n = p.n + n;
p.f = p.f / p.n;

% Plot
if ~nargout
    plot(p.x,p.f)
    set(gca,'ylim',[0 max(p.f)*1.1])
    ylabel('f(x)')
    xlabel('x')
    title('Estimated Probability Density Function');
end

function checkp(p)
%check structure p
if ~isstruct(p) || ~all(isfield(p,{'x','f','n','h'}))
    error('p is not a right structure.');
end
error(varchk(eps, inf, p.h, 'Bandwidth, p.h is not positive.')); 

function msg=varchk(low,high,n,msg)
% check if variable n is not between low and high, returns msg, otherwise
% empty matrix
if n>=low && n<=high
    msg=[];
end
