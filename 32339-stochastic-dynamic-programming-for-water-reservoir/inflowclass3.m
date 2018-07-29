function D=inflowclass3(file,n_class)
%INFLOWCLASS3 berfungsi untuk mendistribusikan data matriks inflow dalam
%berbagai kelas inflow
%file adalah file .txt atau .mat tempat matriks inflow tersimpan
%file dapat bersumber dari file .xls yang disimpan sebagai .txt
%n_class adalah jumlah kelas inflow yang diinginkan
%perhitungan dalam inflowclass3 didasarkan pada incremental jumlah naik
%tetap
%D adalah matriks kelas inflow dari input
%I adalah matriks kelas representatif

A=load(file); %untuk membuka file (tipe .txt)
[m,n]=size(A);

%penentuan selisih atau increment
B=(max(A)-min(A))/n_class;

%penentuan nilai maksimum per kelas
for a=1:n_class
    C(a,:)=min(A)+B*a;
end

%penentuan kelas inflow dari matriks input
for a=1:m
    F1(a,1)=a; %vektor kolom menunjukkan jumlah data
    for b=1:n
        E(1,b)=b; %vektor baris menunjukkan jumlah tahap
        c=1;
        for d=1:n_class+1
        if A(a,b)<=C(c,b)
           D(a,b)=c;
        else
           c=d;
        end
        end
    end
end
D;

%penghitungan jumlah anggota kelas -untuk menentukan kelas representatif
for b=1:n
    for a=1:n_class
    G(a,b)=countif(D(:,b),a);
    end
end
G;
Gx=sumcumul(G); %matriks jumlah kumulatif terhadap baris sebelumnya 
%- untuk menentukan kelas representatif

H=sort(A); %mengurutkan matriks input

%penghitungan nilai kelas representatif
for b=1:n
       for c=1:n_class
           F2(c,1)=c; %vektor kolom menunjukkan jumlah kelas (numpang ya)
           if c==1
           I(c,b)=mean(H(1:Gx(c,b),b));    
           else
           I(c,b)=mean(H(Gx(c,b)-G(c,b):Gx(c,b),b));
           end
       end
end
I
sprintf('Matriks kelas inflow')
Z1=[horzcat(0,E);horzcat(F1,D)];
sprintf('Nilai representasi kelas inflow')
Z2=[horzcat(0,E);horzcat(F2,I)];