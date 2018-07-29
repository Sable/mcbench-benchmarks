function E=probclass2(A,B,x)
%PROBCLASS2 berfungsi untuk menghitung probabilitas transisi antara dua 
%kelas, yaitu kelas A menuju kelas B
%A adalah vektor kelas inflow saat t
%B adalah vektor kelas inflow saat t+1
%x adalah jumlah kelas
[m1,n1]=size(A);
[m2,n2]=size(B);
if m1~=m2
    sprintf('jumlah baris vektor tidak sama')
else m=m1;
end
for d1=1:x %urutan perbandingan, kolom satu dulu
    for d2=1:x %kemudian dibandingkan ke kolom dua yang terus dilooping
        c=0;d=0; %inisialisasi untuk counting
        for a=1:m %dalam hal ini dibuat perbandinganya beriringan
            if A(a)==d1 && B(a)==d2
                c=c+1;
            end
        C(d1,d2)=c;
            if A(a)==d1 %untuk menghitung kolom satu saja sebagai penentu jumlah total angka pada suatu vektor
               d=d+1;
            end
        D(d1,d2)=d;
        end
        
    end
end
C;
D;
E=C./D;