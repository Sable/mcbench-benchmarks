function D=sumcumul(matriks)
%SUMCUMUL adalah fungsi untuk menghitung jumlah kumulatif bilangan dari 
%suatu array vektor matriks 
[m,n]=size(matriks);
for a=1:m
    for b=1:n
    D(a,b)=sum(matriks(1:a,b));
    end
end
D;