		% Determinarea punctelor de pe curba data
t=sin(0:pi/10:4*pi);
		% Precizarea inaltimii
hm=4*pi;
		% Incarcarea celor trei matrice cu datele suprafetelor
[X,Y,Z]=cylinder(t);
		% Impunerea inaltimii corpului
Z=hm*Z;
		% Desenarea corpului obtinut
surf(X,Y,Z)