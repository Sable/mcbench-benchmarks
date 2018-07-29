function A=posmatr(matriks)
%fungsi ini untuk menghitung pada baris ke berapa suatu matriks mencapai
%nilai maksimum
[m,n,o,p]=size(matriks);
for j=1:p
        A(1,j)=posmax(matriks(:,j));
end
A;
