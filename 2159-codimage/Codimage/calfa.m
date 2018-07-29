function c=calfa(n)
%------------------------------------------------------------------------------------------
%  CALFA
%
%  The following program codes a number n like a word, that is to say it is written in  
% 
%  base 26 and by means of a substitution it transforms it into the letters of the alphabet.  
%
%  The syntax is c=calfa(n).
%
%  Author: Francisco Echegorri  
%  E-mail: fdefac@montevideo.com.uy  
%  Created in September of 2002.
%------------------------------------------------------------------------------------------
%El programa codifica un número n en base a el alfabeto,es decir lo escribe en 
%base 26 y mediante una sustitución lo convierte en las letras del alfabeto.
%La sintaxis es c=calfa(n).
%------------------------------------------------------------------------------------------
if length(n)==1
x=nbm(n,26);d=length(x);
y=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];
i=1;c=[];
while i<d
   c=[c,y(x(i)+1)];i=i+1;
end
if i==d
   c=[c,y(x(d)+1)];
end
else
   c1=calfa(n(1));c2=calfa(n(2));c=[c1,c2];
end
function y=nbm(n,m)
%Este programa convierte un número n en base 10 en un número en base m.
%El vector y contiene el número n en base m.
%Ejemplo 365=1031(base 7).
%La sintaxis es y=nbm(n,m).
i=1;
while n>=m 
   x(i)=mod(n,m);n=fix(n/m);i=i+1;
end
x(i)=n;
d=length(x);
y=x(d:-1:1);
q=length(y);
