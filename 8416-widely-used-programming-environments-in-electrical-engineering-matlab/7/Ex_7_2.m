		% Generarea retelei de noduri pe domeniului considerat
[X,Y]=meshgrid(-3.75:0.05:3.5);
		% Evaluarea functiei de doua variabile de reprezentat
Z=peaks(X,Y);
		% Reprezentarea liniilor de contur
contourf(X,Y,Z)
