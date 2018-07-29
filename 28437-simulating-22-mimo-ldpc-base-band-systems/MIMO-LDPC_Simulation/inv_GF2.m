function [b]=inv_GF2(A)
%Ainv=inv_GF2(A)
%For examples and more details, please refer to the LDPC toolkit tutorial at
%http://arun-10.tripod.com/ldpc/ldpc.htm 
dim=size(A);
rows=dim(1);
cols=dim(2);

for i=1:rows
   for j=1:rows
      unity(i,j)=0;
   end
   unity(i,i)=1;
end

for i=1:rows
   b(1:rows,i)=gflineq(A,unity(1:rows,i));
end


