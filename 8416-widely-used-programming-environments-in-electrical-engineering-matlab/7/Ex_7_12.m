		% Precizarea punctelor de pe dreapta care defineste 
		% suprafata de rotatie si a inaltimii corpului
r=[2,0];
hm=10;
		% Incarcarea celor trei matrice cu datele suprafetelor
[X,Y,Z]=cylinder(r,50);
		% Impunerea inaltimii corpului
Z=hm*Z;
		% Desenarea corpului
h=surf(X,Y,Z);
		% Setarea colorilor utilizate la desenare:
		% - albastru pentru desenarea laturilor
		% - galben pentru culoarea suprafetelor
set(h,'EdgeColor','b')
set(h,'FaceColor','y')