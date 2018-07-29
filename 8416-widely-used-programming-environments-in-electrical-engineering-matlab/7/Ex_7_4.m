		% Generarea retelei de noduri pe domeniului considerat
[X,Y]=meshgrid(-3.75:0.05:3.5);
		% Evaluarea functiei de doua variabile de reprezentat
Z=peaks(X,Y);
		% Incarcarea nivelelor negative de reprezentat
v_neg=-3:0.5:-1;
		% Incarcarea nivelelor pozitive de reprezentat
v_poz=1:0.5:7;
		% Desenarea liniilor de contur corespunzatoare 
		%  - nivelelor negative cu linii intrerupte albastre
contour(X,Y,Z,v_neg,'b--');
hold on
		%  - nivelelor pozitive cu linii continue rosii	
contour(X,Y,Z,v_poz,'r-');
hold off
