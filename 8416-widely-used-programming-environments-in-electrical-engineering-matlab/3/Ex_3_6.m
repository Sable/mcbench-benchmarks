% *****************************************************
% Program de rezolvare a unui sistem de ecuatii liniare
% *****************************************************
		% Se sterge spatiul de lucru
clear;
		% Se genereaza matricea coeficientilor (a)
		% - se incarca o matrice 2x3 cu valorile 1
a=ones(2,3);
		% - se modifica elementele care nu sunt 1
a(2,1)=0;     
a(1,3)=8;
		% - se incarca ultimul rand din matricea a
a(3,:)=[1 3 5]   	
		% Se incarca vectorul b
b=[27;5;22]
		% Se rezolva sistemul de ecuatii liniare cu prima metoda prezentata
x1=a\b;
		% Se rezolva sistemul de ecuatii liniare cu a doua metoda prezentata
x2=inv(a)*b;
		% Se incarca solutia exacta
solutia_buna=(1:3)';
		% Se calculeaza erorile
eror1=(solutia_buna-x1)';
eror2=(solutia_buna-x2)';
		% Se afiseaza rezultatele
disp('Solutia 1:'); disp(x1');
disp('Eroarea 1:'); disp(eror1);
disp('Solutia 2:'); disp(x2');
disp('Eroarea 2:'); disp(eror2);