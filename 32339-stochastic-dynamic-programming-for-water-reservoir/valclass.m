function Z=valclass(file,n_class)

A2=inflowclass3(file,n_class);
[m,n]=size(A2);
for a=1:n-1
        B=A2(:,a);
        C=A2(:,a+1);
        E=probclass2(B,C,n_class);
        Z(:,:,a)=[E];
end
        Bx=A2(:,n);
        Cx=A2(:,1);
        E=probclass2(B,C,n_class);
        Z(:,:,n)=[E];
%sprintf('Matriks Probabilitas Transisi pada setiap Tahap')
        Z;
