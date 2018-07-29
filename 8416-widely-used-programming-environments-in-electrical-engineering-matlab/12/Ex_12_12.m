clear all, clc
syms t;
        % Generarea matricelor A si B
A=[cos(t),sin(t);-sin(t),cos(t)]
B=[sin(t),cos(t);-cos(t),-sin(t)]
        % Calcularea sumei A+B
SumAB=A+B
        % Calcularea expresiei A.^2+B.^2 si simplificarea ei
Expr1=A.^2+B.^2
Expr1_simplificat=simplify(Expr1)
        % Calcularea expresiei A^2+B^2
Expr2=simplify(A^2+B^2)
        % Calcularea inversei matricei A si simplificarea ei
InvA=inv(A)
InvA_simplificat=simplify(InvA)
        % Calcularea determinantului matricei B
DetB=det(B)