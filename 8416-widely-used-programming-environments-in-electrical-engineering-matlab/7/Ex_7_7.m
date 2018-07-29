		% Incarcarea variabilei c si a vectorului t
c=0.3;
t=0:0.1:100;
		% Determinarea coordonatelor punctelor definite de sistemul de ecuatii
r=c.*t;
x=r.*sin(t);
y=r.*cos(t);
		% Trasarea liniei spatiale reprezentand spirala lui 
		% Arhimede cu o linie rosie de grosime 1,5
plot3(x,y,t,'r','LineWidth',1.5)
		% Plasarea unui rastru spatial
grid
		% Etichetarea celor trei axe
xlabel('x')
ylabel('y')
zlabel('t')