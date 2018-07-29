function A=posmax(vector)
%fungsi ini untuk menghitung pada baris ke berapa suatu vector mencapai
%nilai maksimum
[m,n,o,p]=size(vector);
for i=1:p-1
if vector(i+1)>vector(i)
    c=i+1;
else
    c=i;
end
end
A=c;
