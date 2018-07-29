function A=storageclass(lwl,hwl,sto_class)
%STORAGECLASS berfungsi untuk membagi kapasitas tampungan dalam beberapa
%kelas
%lwl adalah low water level operation (m3)
%hwl adalah high water level operation (m3)
%sto_class adalah jumlah storage class
%berbeda dengan inflowclass, nilai kelas disini adalah nilai batas
incr=(hwl-lwl)/(sto_class-1);
%penentuan nilai maksimum per kelas
for a=0:(sto_class-1)
    A(a+1,:)=lwl+incr*a;
end
A;


