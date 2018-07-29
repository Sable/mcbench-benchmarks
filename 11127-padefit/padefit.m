function [n,d] = padefit(num,den,kn,kd)
%Pade rational polynomial fitting
%
%  This program finds 2 polynomials, num(x) and den(x), of order kn and kd
%  such that num(x)/den(x) matchs as many terms as possible in the quotient
%  of the user supplied Num and Den polynomials.
%
%  One or both of the polynomials, Num and Den, are intended to be truncated
%  versions of an infinite length Taylor type polynomial.
%
%  Rational polynomial functions have zeros and poles and hence,
%  can be computationaly very useful.
% 
%  All polynomials are in the standard row Matlab format
%
%usage: [num, den] = padefit(Num, Den, kn, kd)
%
%example: [num, den]=padefit(1,[-1 1], 6, 0)
%example: [num, den]=padefit(ones(1,20),1, 0, 1)
%
%  These examples use the symbolic toolbox to provide the input Taylor series,
%  but the Padefit program itself does not require the symbolic toolbox.
%
%example: syms x real; [num, den]=padefit(sym2poly(taylor(exp(x), 14)),1,5,5)
%example: syms x real; [num, den]=padefit(sym2poly(taylor(tan(x), 14)),1,5,5)
%example: syms x real; [num, den]=padefit(sym2poly(taylor(cos(x), 14)),1,6,6)
%example: syms x real; [num, den]=padefit(sym2poly(taylor(sin(x), 14)),1,5,6)
%
%example: syms x real; [num, den]=padefit(sym2poly(taylor(tanh(x), 14)),1,5,6)
%example: syms x real; [num, den]=padefit(sym2poly(taylor(sinh(x), 14)),1,5,6)
%example: syms x real; [num, den]=padefit(sym2poly(taylor(cosh(x), 14)),1,6,6)
%
%example: syms x real; [num, den]=padefit(sym2poly(taylor(atan(x), 14)),1,5,6)
%example: syms x real; [num, den]=padefit(sym2poly(taylor(acos(x), 14)),1,5,6)
%example: syms x real; [num, den]=padefit(sym2poly(taylor(asin(x), 14)),1,5,6)
%
%example: syms x real; [num, den]=padefit(sym2poly(taylor(atanh(x), 14)),1,5,6)
%example: syms x real; [num, den]=padefit(sym2poly(taylor(asinh(x), 14)),1,5,6)
%example: syms x real; [num, den]=padefit(sym2poly(taylor(acosh(x)/-i, 14)),pi/2,5,6)
%
%example: syms x real; [num, den]=padefit(sym2poly(taylor(sin(x),14)),sym2poly(taylor(cos(x), 14)),5,6)
%example: syms x real; [num, den]=padefit(sym2poly(taylor(exp(sin(x)), 14)),1,5,5)
%example: syms x real; [num, den]=padefit(sym2poly(taylor(exp(-cos(x)), 14)),1/exp(1),6,6)
%
%example: syms x real; [num, den]=padefit(sym2poly(taylor(sin(x)/x, 14)),1,6,6)
%example: syms x real; [num, den]=padefit(sym2poly(taylor((cos(x)-1)/x, 16)),1,7,6)
%example: syms x real; [num, den]=padefit(sym2poly(taylor(zeta(x), 2)),1,2,2)
%example: syms x real; [num, den]=padefit(sym2poly(taylor(erf(x), 14)),2/sqrt(pi),5,6)
%example: syms x real; [num, den]=padefit(sym2poly(taylor(erf(x)/x, 14)),2/sqrt(pi),6,6)
%example: syms x real; [num, den]=padefit(sym2poly(taylor(exp(-x*x), 18)),1,8,8)
%example: syms x real; [num, den]=padefit(sym2poly(taylor(besselj(0,x), 24)),1,8,8)
%example: syms x real; [num, den]=padefit(sym2poly(taylor(log(x+1), 15)),1,7,7)
%
%see also: Pade, Conv, Deconv

%Paul Godfrey
%pgodfrey@conexant.com
%4-4-06

debug=0;
if debug==1
   num= 1;
   den= [-1 1];
   kn =6;
   kd= 0;
end
if debug==2
   syms x real;
   num=sym2poly(taylor(exp(x),22));
   den=1;
   kn=2;
   kd=2;
end
if debug==3
   num=[10 9 8 7 6 5 4 3 2 1 -1];
   den=num+10;
   kn=3;
   kd=3;
end

if exist('kn','var') & exist('kd','var')
   kn=round(real(kn));
   kd=round(real(kd));
else
   kn=5;
   kd=5;
end

if exist('den','var')
   den=den;
else
   den=1;
end

if kn<=0 & kd<=0
   n=num(end);
   d=den(end);
   return
end

nn=kn+1;
dd=kd+1;

z=zeros(nn+dd+1,1);

den=flipud([z; den(:)]);
den=den(1:nn+dd+1);

num=flipud([z; num(:)]);
num=num(1:nn+dd+1);

L=tril(toeplitz(den(1:nn+dd-2)));
R=tril(toeplitz(num(1:nn+dd-2)));

A=[L(:,1:nn-1) -R(:,1:dd-1)];

b=num(2:nn+dd-1)*den(1)-den(2:nn+dd-1)*num(1);
nd=pinv(A)*b;

if debug~=0
  A=A
  b=b
  nd=nd
  keyboard
end

n=[num(1);nd(   1:kn )]; n=fliplr(n.');
d=[den(1);nd(kn+1:end)]; d=fliplr(d.');

maxd=max(abs(d));
if maxd==0, maxd=1; end

n=n/maxd;
d=d/maxd; % normalize max value of den to be 1

if debug~=0, save padedata; end

return

%a demo of this routine is

clc
clear all
format short

syms x real
taydiv(1,[-1 1],12)

[n,d]=padefit(1,[-1 1],11,0)
taydiv(n,d,12)

[n,d]=padefit(n,d,0,1)
taydiv(n,d,12)

[n,d]=padefit(n,d)
taydiv(n,d,12)

[n,d]=padefit(sym2poly(taylor(exp(x),19)),1)
taydiv(n,d,12)

[n,d]=padefit(sym2poly(taylor(tan(x),19)),1)
taydiv(n,d,12)

[n,d]=padefit(sym2poly(taylor(sin(x),19)),1)
taydiv(n,d,12)

[n,d]=padefit(sym2poly(taylor(cos(x),19)),1)
taydiv(n,d,12)

[n,d]=padefit(sym2poly(taylor(exp(i*x),19)),1)
taydiv(n,d,12)

[n,d]=padefit(sym2poly(taylor(log(x+1),15)),1,7,7)
taydiv(n,d,25)

[n,d]=padefit(sym2poly(taylor(sin(x)/x,19)),1)
taydiv(n,d,12)

[n,d]=padefit(sym2poly(taylor(erf(x)/x,19)),1)
taydiv(n,d,12)

[n,d]=padefit( sym2poly(taylor(exp( x/2),19)),sym2poly(taylor(exp(-x/2),19)))
taydiv(n,d,12)

clear all
close all
syms z real
[n,d]=padefit(sym2poly(taylor(erf(z),19)),1,9,8)
taydiv(n,d,12)
nr=roots(n);
dr=roots(d);
figure(1);hold on
plot(nr,'ob'); grid on
plot(dr,'xr');
axis([-5 5 -5 5])

x=-5:1/32:5; x=x(:);
y=polyval(n,x)./polyval(d,x);
figure(2)
plot([x x],[erf(x) y]); grid on

return
