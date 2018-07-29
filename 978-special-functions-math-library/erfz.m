function f = erfz(zz)
%ERFZ  Error function for complex inputs
%   f = erfz(z) is the error function for the elements of z.
%   Z may be complex and of any size.
%   Accuracy is better than 12 significant digits.
%
%   Usage:  f = erfz(z)
%
%   Ref: Abramowitz & Stegun section 7.1
%   equations 7.1.9, 7.1.23, and 7.1.29
%
%   Tested under version 5.3.1
%
%   See also erf, erfc, erfcx, erfinc, erfcore

%   Main author Paul Godfrey <pgodfrey@conexant.com>
%   Small changes by Peter J. Acklam <jacklam@math.uio.no>
%   09-26-01

   error(nargchk(1, 1, nargin));
   
   % quick exit for empty input
   if isempty(zz)
      f = zz;
      return;
   end
   
   twopi = 2*pi;
   sqrtpi=1.772453850905516027298;

   f = zeros(size(zz));
   ff=f;

   az=abs(zz);
   p1=find(az<=8);
   p2=find(az> 8);

if ~isempty(p1)
   z=zz(p1);

   nn = 32;

   x = real(z);
   y = imag(z);
   k1 = 2 / pi * exp(-x.*x);
   k2 = exp(-i*2*x.*y);

   s1 = erf(x);

   s2 = zeros(size(x));
   k = x ~= 0;          % when x is non-zero
   s2(k) = k1(k) ./ (4*x(k)) .* (1 - k2(k));
   k = ~k;              % when x is zero
   s2(k) = i / pi * y(k);

   f = s1 + s2;

   k = y ~= 0;          % when y is non-zero
   xk = x(k);
   yk = y(k);

   s5 = 0;
   for n = 1 : nn
      s3 = exp(-n*n/4) ./ (n*n + 4*xk.*xk);
      s4 = 2*xk - k2(k).*(2*xk.*cosh(n*yk) - i*n*sinh(n*yk));
      s5 = s5 + s3.*s4;
   end
   s6 = k1(k) .* s5;
   f(k) = f(k) + s6;
   ff(p1)=f;
end

if ~isempty(p2)
   z=zz(p2);
   pn=find(real(z)<0);

   if ~isempty(pn)
      z(pn)=-z(pn);   
   end

   nmax=193;
   s=1;
   y=2*z.*z;
   for n=nmax:-2:1
       s=1-n.*(s./y);
   end

   f=1.0-s.*exp(-z.*z)./(sqrtpi*z);

   if ~isempty(pn)
      f(pn)=-f(pn);
   end

   pa=find(real(z)==0);
%  fix along i axis problem
   if ~isempty(pa)
      f(pa)=f(pa)-1;
   end

   ff(p2)=f;
end

f=ff;

return

   %a demo of this function is
   x = -4:0.125:4;
   y = x;
   [X, Y] = meshgrid(x,y);
   z = complex(X, Y);
   f = erfz(z);
   af = abs(f);
   %let's truncate for visibility
   p = find(af > 5);
   af(p) = 5;
   mesh(x, y, af);
   view(-70, 40);
   rotate3d on;

   return
