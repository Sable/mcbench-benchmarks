		% Se sterge spatiul de lucru
clear;
        % Stabilirea numarului de necunoscute
N=1000;
        % Se genereaza matricea coeficientilor (a)
a=rand(N);
		% Se incarca vectorul termenilor liberi b
b=randn(N,1);
        % Setarea cronometrului
t0=cputime;
        % Se rezolva sistemul de ecuatii liniare cu prima metoda prezentata
x1=a\b;
        % Se calculeaza timpul de calcul necesar
t1=cputime-t0;
        % Setarea cronometrului
t0=cputime;
        % Se rezolva sistemul de ecuatii liniare cu a doua metoda prezentata
x2=inv(a)*b;
        % Se calculeaza timpul de calcul necesar
t2=cputime-t0;
        % Se afiseaza timpii de calcul
disp('Timp de calcul metoda 1:'); disp(t1');
disp('Timp de calcul metoda 2:'); disp(t2');
        
