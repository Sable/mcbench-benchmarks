		% Precizarea razelor si a inaltimii
r=[20,6];
hm=5;
		% Incarcarea celor trei matrice cu datele suprafetelor
[X,Y,Z]=cylinder(r);
		% Impunerea inaltimii corpului
Z=hm*Z;
		% Desenarea corpului cu linii groase de 1,5 puncte
h=surf(X,Y,Z,'LineWidth',1.5);