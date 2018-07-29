		% Stabilirea numarului de nuante
n=140;
		% Definirea hartii de culori 
colormap(gray(n))
		% Obtinerea matricei de culori
C=colormap;
		% Reprezentarea hartii de culori
pcolor([1:n;1:n])
		% Setarea modului de colorare cu interpolare 
shading interp