clear all
    % Generarea matricei A
A=11:14;
A=[A;A+10;A+20;A+30]
    % Manipularea matricei A
B=A(2,1:4)
C=A(3,[3,4])
D=A(:)'
    % Concatenarea unei matrice
G=[11 12; 21 22]
H=[G,eye(2);2.*G,ones(size(G))]