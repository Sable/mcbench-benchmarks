% a function approximation using fuzzy 
% written by: NKN (C) -2006 : wineviruse@yahoo.com
clc
clear all
close all
%
% **    Design a fuzzy system to approximate a function
%       the function may not be defined analytically 
%       but the values of the function in n point is defined
%       for example : x E [-3 3] from g(x)=sin(x)
%       the approximation is calculated from a fuzzy set design
%       our fuzzy function approximates sin function with an error
%       less than 0.2
%**     note :  this program uses a function named ' isinrange ' so copy it 
%       to your directory

a=-3;
b=3;
acc=.2;
n=(((abs(a)+abs(b)))/acc)+1;
ii=1;
for x=a:0.5:b
e(1)=a;
e(n)=b;
sumup=0;
sumdown=0;
MuA(1)=isinrange(a,a+acc,x);
MuA(n)=isinrange(b-acc,b,x);
for j=2:1:n-1
    e(j)=a+acc*(j-1);
    MuA(j)=isinrange(e(j-1),e(j+1),x);
    sumup=sumup+sin(e(j))*MuA(j);
    sumdown=sumdown+MuA(j);
end
fx(ii)=(sumup+MuA(1)*sin(e(1))+MuA(n)*sin(e(n)))/(sumdown+MuA(1)+MuA(n));
gx(ii)=sin(x);
plot(x,fx(ii),'ro',x,gx(ii),'kx');hold on
ii=ii+1;
end