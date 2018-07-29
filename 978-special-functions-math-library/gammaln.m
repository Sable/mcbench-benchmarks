function [f] = gammaln(z)
% GAMMALOG  Natural Log of the Gamma function valid in the entire complex plane.
%           This routine uses an excellent Lanczos series approximation
%           for the complex ln(Gamma) function.
%
%usage: [f] = gammaln(z)
%             z may be complex and of any size.
%             Also  n! = prod(1:n) = exp(gammalog(n+1))
%        
%tested under version 5.3.1
%
%References: C. Lanczos, SIAM JNA  1, 1964. pp. 86-96
%            Y. Luke, "The Special ... approximations", 1969 pp. 29-31
%            Y. Luke, "Algorithms ... functions", 1977
%            J. Spouge,  SIAM JNA 31, 1994. pp. 931
%            W. Press,  "Numerical Recipes"
%            S. Chang, "Computation of special functions", 1996
%
%see also:   GAMMA GAMMALN GAMMAINC PSI
%see also:   mhelp GAMMA
%see also:   mhelp lnGAMMA

%Paul Godfrey
%pgodfrey@conexant.com
%07-13-01


siz = size(z);
z=z(:);
zz=z;

f = 0.*z; % reserve space in advance

p=find(real(z)<0);
if ~isempty(p)
   z(p)=-z(p);
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

s=0;
for k=size(c,1):-1:2
    s=s+c(k)./(z+(k-2));
end

zg=z+g-0.5;
s2pi= 0.9189385332046727417803297;

f=(s2pi + log(c(1)+s)) - zg + (z-0.5).*log(zg);

f(z==1 | z==2) = 0.0;

if ~isempty(p)
   lpi= 1.14472988584940017414342735 + i*pi;
   f(p)=lpi-log(zz(p))-f(p)-log(sin(pi*zz(p)));
end

p=find(round(zz)==zz & imag(zz)==0 & real(zz)<=0);
if ~isempty(p)
   f(p)=Inf;
end

f=reshape(f,siz);

return

%A demo of this routine is:
clc
clear all
close all
figure(1)
ezplot lngamma
grid on
drawnow

x=-4:1/16:4.5;
y=-4:1/16:4;
[X,Y]=meshgrid(x,y);
z=X+i*Y;
f=lngamma(z);
f(f>5)=5; 
figure(2)
meshc(x,y,real(f));
view([-35 30]);
rotate3d;

return
