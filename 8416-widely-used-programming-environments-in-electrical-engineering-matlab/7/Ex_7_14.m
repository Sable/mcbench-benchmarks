		% Precizarea razelor cercurilor circumscrise si a inaltimii
r=[18,6];
hm=30;
		% Fixarea numarului laturii bazei (6 pentru hexagon)
	n=6;
		% Incarcarea celor trei matrice cu datele suprafetelor 
[X,Y,Z]=cylinder(r,n);
		% Impunerea inaltimii corpului
Z=hm*Z;
		% Desenarea corpului
h=mesh(X,Y,Z);
		% Setarea grosimii liniilor 
set(h,'LineWidth',3)
set(h,'EdgeColor','b')