function d=sumproduct(A,B,i,l)
%SUMPRODUCT adalah fungsi untuk menghitung jumlah hasil perkalian
[a,b]=size(A);
[m,n]=size(B);

for j=1:a
c(j)=A(i,j)*B(l,j);
end
d=sum(c);