% ****************************
% Verificarea patratului magic
% ****************************
		% Generarea matricei continand patratul magic
A=magic(4)
		% Insumarea elementelor de pe fiecare coloana
sum(A)
		% Transpunerea matricei B
B=A';
		% Insumarea elementelor de pe fiecare coloana a
		% matricei B (de pe fiecare linie a matricei A)
sum(B)
		% Extragerea diagonalei principale a matricei A
C=diag(A);
		% Insumarea elementelor diagonalei principale a matricei A
sum(C)
		% Inversarea ordinii coloanelor matricei A 
		% (rotirea matricei in jurul axei verticale)
D=fliplr(A); 
		% Extragerea diagonalei principale a matricei D 
		% (a anti-diagonalei principale a matricei A)
E=diag(D);
		% Insumarea elementelor anti-diagonalei principale a matricei A
sum(E)

