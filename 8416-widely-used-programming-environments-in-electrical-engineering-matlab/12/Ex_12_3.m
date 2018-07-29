clear all
        % Desemnarea unor variabile simbolice
syms x a
        % Generarea unei functii simbolice
f=sin(x)+cos(a)
        % Calcularea derivatei de ordinul 1 in functie de x
df_pe_dx=diff(f)
        % Calcularea derivatei de ordinul 1 in functie de a
df_pe_da=diff(f,a)
        % Calcularea derivatei de ordinul 2 in functie de x
df2_pe_dx=diff(f,2)
        % Calcularea derivatei de ordinul 2 in functie de a
df2_pe_da=diff(f,a,2)