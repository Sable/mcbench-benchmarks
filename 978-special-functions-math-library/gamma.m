function [f] = gamma(z)
% GAMMA  Gamma function valid in the entire complex plane.
%        Accuracy is 15 significant digits along the real axis
%        and 13 significant digits elsewhere.
%        This routine uses a superb Lanczos series
%        approximation for the complex Gamma function.
%
%        z may be complex and of any size.
%        Also  n! = prod(1:n) = gamma(n+1)
%
%usage: [f] = gamma(z)
%       
%tested on versions 6.0 and 5.3.1 under Sun Solaris 5.5.1
%
%References: C. Lanczos, SIAM JNA  1, 1964. pp. 86-96
%            Y. Luke, "The Special ... approximations", 1969 pp. 29-31
%            Y. Luke, "Algorithms ... functions", 1977
%            J. Spouge,  SIAM JNA 31, 1994. pp. 931-944
%            W. Press,  "Numerical Recipes"
%            S. Chang, "Computation of special functions", 1996
%            W. J. Cody "An Overview of Software Development for Special
%            Functions", 1975
%
%see also:   GAMMA GAMMALN GAMMAINC PSI
%see also:   mhelp GAMMA
%
%Paul Godfrey
%pgodfrey@conexant.com
%http://my.fit.edu/~gabdo/gamma.txt
%Sept 11, 2001

siz = size(z);
z=z(:);
zz=z;

f = 0.*z; % reserve space in advance

p=find(real(z)<0);
if ~isempty(p)
   z(p)=-z(p);
end

%Lanczos approximation for the complex plane
%calculated using vpa digits(256)
%the best set of coeffs was selected from
%a solution space of g=0 to 32 with 1 to 32 terms
%these coeffs really give superb performance
%of 15 sig. digits for 0<=real(z)<=171
%coeffs should sum to about g*g/2+23/24

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

%Num Recipes used g=5 with 7 terms
%for a less effective approximation

z=z-1;
zh =z+0.5;
zgh=zh+g;
%trick for avoiding FP overflow above z=141
zp=zgh.^(zh*0.5);

ss=0.0;
for pp=size(c,1)-1:-1:1
    ss=ss+c(pp+1)./(z+pp);
end

%sqrt(2Pi)
sq2pi=  2.5066282746310005024157652848110;
f=(sq2pi*(c(1)+ss)).*((zp.*exp(-zgh)).*zp);

f(z==0 | z==1) = 1.0;

%adjust for negative real parts
if ~isempty(p)
   f(p)=-pi./(zz(p).*f(p).*sin(pi*zz(p)));
end

%adjust for negative poles
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

x=-4:1/16:4.5;
y=-4:1/16:4;
[X,Y]=meshgrid(x,y);
z=X+i*Y;
which gamma
f=gamma(z);
p=find(abs(f)>10);
f(p)=10;
figure(1);
mesh(x,y,abs(f));
view([-35 30]);
rotate3d;
gamma([1:18]')

clear f
%create a gold standard to compare against
f(0+1)=1;
for n=1:170
    f(n+1)=n*f(n);
end
f=f(:);
n=[1:171]';

which gamma
g=gamma(n);
ler=(f-g)./f;
lerr=abs(ler);
p=find(lerr==0);
lerr(p)=eps;
y=log10(lerr);
figure(2)
plot(n,y,'b')
grid on
hold on

ud=pwd;
cd ..
which gamma
g=gamma(n);
cd(ud)
mer=(f-g)./f;
merr=abs(mer);
p=find(merr==0);merr(p)=eps;
yy=log10(merr);
plot(n,yy,'r')
axis([1 171 -16 -13])
xlabel('n')
ylabel('Log10(Relative error)')
title('Matlab real Gamma in RED, Lanczos complex Gamma in BLUE')

figure(3)
plot(n,ler,'b');hold on
plot(n,mer,'r');grid on
axis([1 171 -1e-13 1e-13])
xlabel('n')
ylabel('Relative error')
title('Matlab real Gamma in RED, Lanczos complex Gamma in BLUE')

return
