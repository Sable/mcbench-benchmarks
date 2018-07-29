		% Generarea retelei de noduri pe domeniului considerat
[X,Y]=meshgrid(-3.75:0.05:3.5);
		% Evaluarea functiei de doua variabile de reprezentat
Z=peaks(X,Y);
        % Specificarea nivelelor de reprezentat
v=[-1:2:7];
		% Lansarea comenzii pentru reprezentarea grafica
[C,h]=contour(X,Y,Z,v,'r');
		% Setarea grosimii liniilor de contur
set(h,'LineWidth',1.5);