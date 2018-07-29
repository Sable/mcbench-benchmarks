function [f] = psin(n,z)
%Psin   Arbitrary order Polygamma function valid in the entire complex plane.
%
%                         d^(n+1)
%        polygamma(n,z) = --------log(Gamma(z))
%                         dz^(n+1)
%
%usage: [f] = Psin(n,z)
%
%        if n is 0 or absent then f will be the Digamma function.
%        if n=1,2,3,4,5 etc then f will be
%        the tri-, tetra-, penta-, hexa-, hepta- etc gamma functon
%        Real(n) must be zero or positive.
%
%tested under versions 6.0 and 5.3.1
%
%        Z may be complex and of any size.
%
%        This program uses the partial fraction expansion of the
%        derivative of the Log of an excellent Lanczos series approximation
%        for the Gamma function. Accurate to about 12 digits.
%
%example: psin(101, -45.6-i*29.4)
%         is near 12.5 + 9*i
%
%example: psin(10, -11.5-i*0.577007813568142)
%         is near a root of the decagamma function
%
%example: x=[1:0.005:1.250]'; [x gamma(x) log(gamma(x)) psin(0,x) psin(1,x)]
%         recreates Table 6.1 page 267 from A&S
%
%example: x=[1:0.01:2.00]'; [x psin(2,x) psin(3,x)]
%         recreates Table 6.2 page 271 from A&S
%
%example: x=1; y=[0:0.1:10]'; f=psin(0,x+i*y); [y real(f) imag(f)] 
%         recreates Table 6.8 page 288 from A&S
%
%example: x=2; y=[0:0.1:10]'; f=psin(0,x+i*y); [y real(f) imag(f)] 
%         recreates the last part of Table 6.8 page 293 from A&S
%    
%References: C. Lanczos, SIAM JNA  1, 1964. pp. 86-96
%            Y. Luke, "The Special ... approximations", 1969 pp. 29-31
%            Y. Luke, "Algorithms ... functions", 1977
%            J. Spouge,  SIAM JNA 31, 1994. pp. 931
%            W. Press,  "Numerical Recipes"
%            S. Chang, "Computation of special functions", 1996
%
%
%see also:   GAMMA GAMMALN GAMMAINC
%see also:   mhelp psi
%see also:   mhelp GAMMA

%Paul Godfrey
%pgodfrey@conexant.com
%July 22, 2004
%see gamma for calculation details...

%this routine still works even if n is complex with real(n)>=0
%don't know what the resulting function is called though

% we have bit of a problem for real(z)<0
% we could use the reflection formula, eq #6.4.7 in A&S
% but arbitrary order derivs of cot are cumberson to compute
% (it generates a polynomial in powers of cot)
% so instead we will use a modification of eq #6.4.6
% and call this program recursively to shift z by 500 until real(z)>=0


if nargin==1
   z=n;
   n=0;
end

if n==0
   f=psi(z);
   return
end

if real(n)<0
   error('Invalid Polygamma order')
end

sizeofz=size(z);

isneg=find(real(z)< 0);
isok =find(real(z)>=0);

negmethod=1;
if ~isempty(isneg)
   if negmethod==0
      zneg=z(isneg);
      gneg=psin(n,zneg+1); % recurse if to far to the left...
      hneg=-(-1).^n.*gamma(n+1).*zneg.^-(n+1);
      fneg=gneg+hneg;
   else
      zneg=z(isneg);
      %shift by, say, 500, to speed things up.
      m=500;
      gneg=psin(n,zneg+m);
      hneg=0;
      for k=m-1:-1:0
          hneg=hneg+(zneg+k).^-(n+1);
      end
      hneg=-(-1).^n.*gamma(n+1).*hneg;
      fneg=gneg+hneg;
   end
end
if ~isempty(isok)
   z=z(isok);
end

% the zeros of the Lanczos PFE series when g=607/128 are:

r=[ -4.1614709798720630-.14578107125196249*i;
    -4.1614709798720630+.14578107125196249*i;
    -4.3851935502539474-.19149326909941256*i;
    -4.3851935502539474+.19149326909941256*i;
    -4.0914355423005926;
    -5.0205261882982271;
    -5.9957952053472399;
    -7.0024851819328395;
    -7.9981186370233868;
    -9.0013449037361806;
    -9.9992157162305535;
   -11.0003314815563886;
   -11.9999115102434217;
   -13.0000110489923175587];

% the poles of the Lanczos PFE series are:
%p=[ 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13];

e=exp(1); 
g=607/128; % best results when 4<=g<=5
h=1/2;

%compute tricky PFE expansion of the deriv of the log
%of the Lanczos series. The series Lanczos' coeffs manifest
%themselves in the zero locations. The residues are all +/- 1
%compare this to A&S page 259, eq# 6.3.16 and page 260, eq# 6.4.10

s=0;
for k=length(r)-1:-1:0
    s=s+(1./((z-r(k+1)).^(n+1))-1./((z+k).^(n+1)));
end
%what happens if n is not a positive integer?
s=(-1).^n.*gamma(n+1).*s;

zgh=z+(g-h);
if n==0
%  s=log(zgh)+(-g./zgh + s);
%  use existing more accurate digamma function if n=0
%  should never reach this code since we trapped it above 
   f=psi(z);
   return
else
% do derivs of front end stuff
   s=(-1)^(n+1)*(gamma(n).*zgh.^(-n) + g*gamma(n+1).*zgh.^-(n+1))+s;
end

if ~isempty(isneg)
   f(isneg)=fneg;
end
if ~isempty(isok)
   f(isok)=s;
end

f=reshape(f,sizeofz);

return

%a demo of this program is

warning off
x=[-5:1/64:5]';

figure(1)
axis([min(x) max(x) -20 20])
grid on
hold on

y=[];
for n=0:6
    y(:,n+1)=psin(n,x);
end

plot(repmat(x,1,size(y,2)),y)


figure(2)
x=-10:1/16:10;
y=-5:1/16:5;
[X,Y]=meshgrid(x,y);
z=complex(X,Y);
f=psin(4,z);
g=log10(abs(f));
mesh(x,y,g)
rotate3d on

z=-76+54*i;
[z psin(98, z)]

disp('A zero of Psin1')
z = -0.412134547951937-i*0.597811942320597;
[z psin(1,z)]

warning on
return

% Include this complex psi function
% in case user doesn't have one

function [f] = psi(z)
%Psi     Psi (or Digamma) function valid in the entire complex plane.
%
%                 d
%        Psi(z) = --log(Gamma(z))
%                 dz
%
%usage: [f] = psi(z)
%
%tested under versions 6.0 and 5.3.1
%
%        Z may be complex and of any size.
%
%        This program uses the analytical derivative of the
%        Log of an excellent Lanczos series approximation
%        for the Gamma function.
%        
%References: C. Lanczos, SIAM JNA  1, 1964. pp. 86-96
%            Y. Luke, "The Special ... approximations", 1969 pp. 29-31
%            Y. Luke, "Algorithms ... functions", 1977
%            J. Spouge,  SIAM JNA 31, 1994. pp. 931
%            W. Press,  "Numerical Recipes"
%            S. Chang, "Computation of special functions", 1996
%
%
%see also:   GAMMA GAMMALN GAMMAINC
%see also:   mhelp psi
%see also:   mhelp GAMMA

%Paul Godfrey
%pgodfrey@intersil.com
%July 13, 2001
%see gamma for calculation details...

siz = size(z);
z=z(:);
zz=z;

f = 0.*z; % reserve space in advance

%reflection point
p=find(real(z)<0.5);
if ~isempty(p)
   z(p)=1-z(p);
end

%Lanczos approximation for the complex plane
 
g=607/128; % best results when 4<=g<=5
 
c = [  0.99999999999999709182;
      57.156235665862923517;
     -59.597960355475491248;
      14.136097974741747174;
      -0.49191381609762019978;
        .33994649984811888699e-4;
        .46523628927048575665e-4;
       -.98374475304879564677e-4;
        .15808870322491248884e-3;
       -.21026444172410488319e-3;
        .21743961811521264320e-3;
       -.16431810653676389022e-3;
        .84418223983852743293e-4;
       -.26190838401581408670e-4;
        .36899182659531622704e-5];


n=0;
d=0;
for k=size(c,1):-1:2
    dz=1./(z+k-2);
    dd=c(k).*dz;
    d=d+dd;
    n=n-dd.*dz;
end
d=d+c(1);
gg=z+g-0.5;
%log is accurate to about 13 digits...

f = log(gg) + (n./d - g./gg) ;

if ~isempty(p)
   f(p) = f(p)-pi*cot(pi*zz(p));
end

p=find(round(zz)==zz & real(zz)<=0 & imag(zz)==0);
if ~isempty(p)
   f(p) = Inf;
end

f=reshape(f,siz);

return

%A demo of this routine is:
clc
clear all
close all
x=-4:1/16:4.5;
y=-4:1/16:4;
[X,Y]=meshgrid(x,y);
z=X+i*Y;
f=psi(z);
p=find(abs(f)>10);
f(p)=10;

mesh(x,y,abs(f),phase(f));
view([45 10]);
rotate3d;

figure(2);
ezplot psi;
grid on;

One=psi(2)-psi(1)
EulerGamma=-psi(1)

return
