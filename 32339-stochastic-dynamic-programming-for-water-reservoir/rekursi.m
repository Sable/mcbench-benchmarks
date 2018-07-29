function F_KI=rekursi(file,n_class,n_stor,r_tar)
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
k=n_stor;

for t=t1:-1:1
    if t==t1
        f_lj=zeros(k,i,t1);
        for a=1:n_stor
            for b=1:n_class
               for c=1:n_stor
                    r_kil(a,b,c,t)=b+a-f_lj(a,b,t);
                end
            end
        end
        b_kil(:,:,:,t)=(r_kil(:,:,:,t)-r_tar*ones(k,i,k)).^2;
        sigma_li(:,:,t)=f_lj(:,:,t)*p_ij(:,:,t)';
        for a=1:n_stor
            b_li(:,:,t)=b_kil(:,:,a,t);
            bsigma(:,:,t)=sigma_li(:,:,t)+b_li(:,:,t);        
            f_ki(:,:,a,t)=posmatr(bsigma(:,:,t));    
        end
   % else
      %  f_lj=f_ki(:,:,:,t+1);
       % for a=1:n_stor
          %  for b=1:n_class
            %   for c=1:n_stor
               %     r_kil(a,b,c,t)=b+a-f_lj(a,b,t);
               % end
           % end
        %end
        %b_kil(:,:,:,t)=(r_kil(:,:,:,t)-r_tar*ones(k,i,k)).^2;
       % sigma_li(:,:,t)=f_lj(:,:,t)*p_ij(:,:,t)';
        %for a=1:n_stor
          %  b_li(:,:,t)=b_kil(:,:,a,t);
         %   bsigma(:,:,t)=sigma_li(:,:,t)+b_li(:,:,t);        
          %  f_ki(:,:,a,t)=posmatr(bsigma(:,:,t));    
       % end
    end
end
f_ki
