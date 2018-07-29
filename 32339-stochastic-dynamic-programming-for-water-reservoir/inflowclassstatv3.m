function A5=inflowclassstat1(file)
%INFLOWCLASSSTAT1 berfungsi untuk mendistribusikan matriks inflow dalam
%berbagai kelas
%INFLOWCLASSSTAT1 dipergunakan ketika memilih mendistribusikan kelas dalam 
%format statistikal
%dalam hal ini kelas dipastikan hanya 3 buah
A1=load(file); %untuk membuka file txt disimpan di A1
[m,n]=size(A1);
%penentuan rerata
A2=mean(A1);
A3=std(A1);
%penentuan nilai maksimum per kelas
A4(1,:)=A2-0.5*A3;
A4(2,:)=A2+0.5*A3;
A4(3,:)=max(A1);
for a=1:m
    for b=1:n
        c=1; 
        for d=1:3+1
        if A1(a,b)<=A4(c,b)
           A5(a,b)=c;
        else
           c=d;
        end
        end
    end
end
A4;
A5


