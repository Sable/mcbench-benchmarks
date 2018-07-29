clear all
    % Generarea matricei A
A=[11,12,13,14;21,22,23,24;31,32,33,34;41,42,43,44]
    % Manipulari cu matricea A
B=A(2,2:4)
C=A(2,:)
D=A(1:2:3,:)
E(:,[3,5,7])=A(:,2:4)
F=A(:,[1 3 2 4])
    % Utilizarea filtrelor logice
Filt=zeros(size(A));
Filt(1,3)=1; Filt(2,4)=1; Filt(4,4)=1;
    % Transforarea matricei numerice in matrice logica
Filt=logical(Filt)
A_filtrat=A(Filt)'
    % Stergerea unei coloane din matricea A
A(:,2)=[ ]
