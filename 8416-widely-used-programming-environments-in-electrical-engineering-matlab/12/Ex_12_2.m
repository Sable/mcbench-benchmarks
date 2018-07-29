clear all
        % Desemnarea unor variabile simbolice
syms x u v t
        % Generarea unei functii de o variabila
f=sin(x)^3;
        % Deschiderea unei ferestre grafice noi
figure(1)
        % Reprezentarea functiei f intre limitele implicite
ezplot(f)
        % Reprezentarea functiei f intre limitele [0, 8*pi]
figure(2)
ezplot(f,[0,8*pi])
        % Generarea unei functii de doua variabile
g=u^2-v^2+1;
        % Reprezentarea functiei g de doua variabile intre limitele date
figure(3)
ezplot(g,[-2,2,-5,5])
        % Generarea unei functii parametrice
x=sin(t);
y=cos(t);
        % Reprezentarea functiei parametrice intre limitele impuse
figure(4)
ezplot(x,y)