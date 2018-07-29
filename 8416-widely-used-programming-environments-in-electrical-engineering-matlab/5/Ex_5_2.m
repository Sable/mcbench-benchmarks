clear
    % Generarea unei matrice pline B
B=zeros(7);
B(1,1)=1; B(2,2)=2; B(3,7)=4; 
B(4,5)=3; B(7,3)=5; B(7,4)=2
    % Convertirea sa in matrice rara
A=sparse(B)
    % Afisarea informatiilor aferente celor doua matrice
whos A B
    % Reprezentarea grafica a distributiei elementelor nenule din A
spy(A)
    % Extragerea numarului de elemente nenule din A
n=nnz(A)
    % Extragerea elementelor nenule din A
nonzeros_A=nonzeros(A)
