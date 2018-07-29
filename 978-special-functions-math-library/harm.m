function [h] = harm(z)
%Harm    Harmonic sum function valid in the entire (complex) plane.
%        h = sum from k=1 to n of 1/k
%        n may be complex and of any size.
%        This function is useful in computing the 2nd Frobenius
%        solution for Sturm-Liouville problems.
%
%usage: h = harm(n)
%
%tested under versions 6.0 and 5.3.1
%
%see also:   GAMMA psi
%see also:   mhelp psi
%see also:   mhelp GAMMA

%Paul Godfrey
%pgodfrey@conexant.com
%Jan. 30, 2003

h = psi(z+1)-psi(1);

return





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
