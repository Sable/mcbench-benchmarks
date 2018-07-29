function c=countif(vector,x)
%COUNTIF adalah fungsi untuk menghitung jumlah kehadiran bilangan dalam
%suatu array
[m,n]=size(vector);
d=0;
for a=1:m
    if vector(a)==x
    d=d+1;
    c=d;
    else
    c=d;
    end
end
c;