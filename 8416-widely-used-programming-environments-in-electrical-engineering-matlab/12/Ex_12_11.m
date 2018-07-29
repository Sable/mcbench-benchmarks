clear all, clc
syms x
        % Generarea functiei simbolice f(x)
f=(x^2-3*x+1)/(1-( x^2-3*x+1)^2)+sqrt(x^2-3*x+1)-log(1/(x^2-3*x+1))
        % Inlocuirea subexpresiei (x^2-3*x+1) cu variabila k
f_simplificat=subs(f,'(x^2-3*x+1)','k')