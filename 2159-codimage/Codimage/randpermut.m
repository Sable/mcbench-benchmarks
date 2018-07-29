function y=randpermut(x,N)
%-----------------------------------------------------------------------------------------
%  RANDPERMUT.
%  The program generates a sequence of numbers from 1 to N in aleatory order.
%
%  The syntax is y=randpermut(x,N), where x is an initial " seed ".
%
%  x=[x1,x2] where x1 or x2 is a smaller number that one of up to 16 digits.
%
%  Author: Francisco Echegorri  
%  E-mail: fdefac@montevideo.com.uy  
%  Created in September of 2002.  
%----------------------------------------------------------------------------------------
x1=[]; h=waitbar(0,'Generating a vector with aleatory order...');
if length(x)==1
for i=1:N
   w=x.*997;x=w-fix(w);
   x1=[x1,x];waitbar(i/N,h)
 end
 [nula,y]=sort(x1);close(h)
else
   if mod(N,2)==0
      for i=1:N/2
   w=x.*997;x=w-fix(w);
   x1=[x1,x];waitbar(i/(N/2),h)
      end
   [nula,y]=sort(x1);close(h)
   else
      for i=1:fix(N/2)
        w=x.*997;x=w-fix(w);
        x1=[x1,x];waitbar(i/(fix(N/2)+1),h)
     end
     w=x(1).*997;x=w-fix(w);x1=[x1,x];
      [nula,y]=sort(x1);close(h)
   end
end

   
