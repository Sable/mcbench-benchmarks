		% Specificarea dimensiunii retelei pe o directie
n=25;
		% Formarea unui vector cu pas constant de n elemente
v=linspace(-1,1,n);
		% Formarea unei retele tridimensional de nxnxn pe cubul unitar 
[X,Y,Z]=meshgrid(v,v,v);
		% Evaluarea functiei date in nodurile retelei 
V=X.^2+Y.^2+Z.^2;
		% Determinarea nodului de la jumatatea axei
m=round(n/2);
		% Lansarea comenzii pentru reprezentarea grafica
slice(V,[m],[m],[m],n)
		% Fixarea limitelor sistemului de axe de coordonate
axis([0,n,0,n,0,n])