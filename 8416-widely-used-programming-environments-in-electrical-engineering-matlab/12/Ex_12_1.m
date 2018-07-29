clear all
        % Generarea unei variabile numerice
t=0.1
        % Convertirea sa in variabila simbolica sub diferite formate
t_simb=sym(t)
rez_r=sym(t,'r')
rez_d=sym(t,'d')
rez_e=sym(t,'e')
rez_f=sym(t,'f')
        % Desemnarea unor variabile simbolice
syms a b c
        % Generarea unei variabile simbolice complexe
syms x y real
z=x+j*y
        % Generarea unei matrice cu elemente simbolice
A=[a,b,c;b,c,a]
		% Definirea unei functii simbolice
f=sin(a*x)/b
        % Vizualizarea variabilelor din spatiul de lucru
whos
        % Afisarea variabilelor simbolice din functia f
var_simb=findsym(f)
        % Afisarea variabilei independente din functia f
var_indep=findsym(f,1)
