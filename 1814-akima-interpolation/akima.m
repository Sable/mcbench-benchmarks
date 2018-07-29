function yi=akimai(x,y,xi)
%
% Usage: yi=akimai(x,y,xi)
%
%        Given vectors x and y (of the same length)
%        and the array xi at which to interpolate,
%        fits piecewise cubic polynomials and returns
%        the interpolated values yi at xi.
%
% Ref. : Hiroshi Akima, Journal of the ACM, Vol. 17, No. 4, October 1970,
%        pages 589-602.
%
% Programmer: N. Shamsundar, University of Houston, 6/2002
%   Correction to lines 32-33, 9/2004,  motivated by Gilford Ward,
%     to make routine work correctly for linear data.
%
% Notes: Use only for precise data, as the fitted curve passes through the
%        given points exactly. This routine is useful for plotting a pleasingly
%        smooth curve through a few given points for purposes of plotting.
%
x=x(:); y=y(:); xi=xi(:); n=length(x);
if n~=length(y), error('input x and y arrays must be of same length'), end
dx=diff(x); if any(dx <= 0) error('input x-array must be in strictly ascending order'), end
if any(xi<x(1)) | any(xi > x(n))
  warning('All interpolation points xi must lie between x(1) and x(n)')
end
m=diff(y)./dx;
mm=2*m(1)-m(2);     mmm=2*mm-m(1);     % augment at left
mp=2*m(n-1)-m(n-2); mpp=2*mp-m(n-1);   % augment at right
m1=[mmm; mm; m; mp; mpp];              % slopes
dm=abs(diff(m1)); f1=dm(3:n+2); f2=dm(1:n); f12=f1+f2;
id=find(f12 > 1e-8*max(f12)); b=m1(2:n+1);
b(id)=(f1(id).*m1(id+1)+f2(id).*m1(id+2))./f12(id);
c=(3*m-2*b(1:n-1)-b(2:n))./dx;
d=(b(1:n-1)+b(2:n)-2*m)./dx.^2;

% Loop replaced by vector ops following tip from johannes.korsawe@volkswagen.de
% 1/19/2006
%
[ncnt,bin]=histc(xi,x);
bin=min(bin,n-1);
bb=bin(1:length(xi));
wj=xi-x(bb);
yi=((wj.*d(bb) +c(bb)).*wj+b(bb)).*wj+y(bb);