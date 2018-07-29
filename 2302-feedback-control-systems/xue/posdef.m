function [key,sdet]=posdef(A)
[nr,nc]=size(A); sdet=[];
for i=1:nr
   sdet=[sdet,det(A(1:i,1:i))];
end
key=1; 
if any(sdet<=0), key=0; end
