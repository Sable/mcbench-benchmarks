function F_KI=rekursi1(file,n_class,n_stor,n_stor2,r_tar)
%rekursi adalah fungsi untuk melakukan proses rekursi
%untuk menentukan nilai l untuk setiap f_ki pada suatu tahap t
%apabila k,l adalah kelas tampungan dengan jumlah kelas a
%apabila i,j adalah kelas inflow dengan jumlah kelas c
%b_kl adalah matriks tiga dimensi berbentuk (axc)xa. axc yang pertama 
%adalah ixl, sedangkan a terakhir adalah untuk k.
%b_kl adalah hasil yang didapat (misalnya energi
%listrik) apabila status sistem berubah dari k menuju l pada tahap t dan
%pada inflow i
%p_ij adalah matriks cxc probabilitas transisi dari i ke j untuk tahap t
%f_lj adalah matriks nilai hasil optimum optimasi pada tahap t+1, dengan
%bentuk matriks adalah axc. Matriks ini telah diketahui sebelumnya karena
%optimasinya dilakukan secara backward, dari t=12 menuju t=11 dan
%seterusnya.
p_ij=valclass(file,n_class);
[i,j,t1]=size(p_ij);


t=t1;
for d=1:t1-1
    if t==t1
    f_lj=zeros(n_stor,i,t+1);
    else
    f_lj=f_ki;
    end

    t
    for l=1:n_stor2
        for k=1:n_stor
            for i=1:n_class
                r_kil(k,i,t,l)=k+i-f_lj(k,i,t+1);
                b_kil(k,i,t,l)=(r_kil(k,i,t,l)-r_tar).^2;
                b_sig(k,i,t,l)=b_kil(k,i,t,l)+sumproduct(p_ij,f_lj,i,l);
            end
        end
    end
    r_kil;
    b_kil;
    b_sig;

    for k=1:n_stor
        for i=1:n_class
            f_ki(k,i,t)=posmax(b_sig(k,i,t,:));
        end
    end
    f_ki
    t=t1-d;
end

