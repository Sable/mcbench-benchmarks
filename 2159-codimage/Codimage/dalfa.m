function n=dalfa(c)
%------------------------------------------------------------------------------------------  
%  DALFA
%  
%  The program converts a word coded in base 26 in a number n.  
%  
%  The carried out operation is the inverse one of the one made by the program c=calfa(n).  
%
%  The syntax is n=dalfa(c), where c is a vector that contains the word that will be  
%
%  decoded, for example c = 'abraxas',n=dalfa(c)(up to 24 letters).
%
%  If the number of letters of the word is bigger than 12 it returns a vector.
%
%  Author: Francisco Echegorri  
%  E-mail: fdefac@montevideo.com.uy  
%  Created in September of 2002.  
%------------------------------------------------------------------------------------------
%El programa convierte una palabra codificada en base 26 en un número n.
%La operación que realiza es la inversa de la hecha por el programa c=calfa(n).
%La sintaxis es n=dalfa(c), donde c es un vector que contiene la palabra a 
%decodificar, por ejemplo c='abraxas',n=dalfa(c).
%Si el número de letras de la palabra es mayor que 12 devuelve un vector.
%------------------------------------------------------------------------------------------
i=1;j=1;d=length(c);
y=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];
i=1;j=1;c1=[c(1)];y1=[y(1)];
if d<=12
while i<=d
   c1=[c(i)];y1=[y(j)];
   while c1~=y1&j<=25
    c1=[c(i)]; j=j+1;y1=[y(j)];
   end
      i=i+1;x(i-1)=j-1;j=1; 
   end
   dim=length(x);e=dim-1;n=0;k=1;
while e>=0
   n=n+x(k)*26^e;k=k+1;e=e-1;
end
else
   c1=c(1:12);n1=dalfa(c1);c2=c(13:d);n2=dalfa(c2);
   n=[n1,n2];
end

   