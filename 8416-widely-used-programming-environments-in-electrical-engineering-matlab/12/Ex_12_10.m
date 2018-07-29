clear all, clc
syms a x
        % Obtinerea expresiei simbolice s
s=solve(x^3+a*x+1)
        % Afisarea ei sub forma usoara de citit 
pretty(s)
        % Extragerea subexpresiei s si afisarea expresiei simplificate 
r=subexpr(s)