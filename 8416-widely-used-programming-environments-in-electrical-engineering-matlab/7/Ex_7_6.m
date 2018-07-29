		% Evaluarea functiei date
[X,Y]=meshgrid(-3.75:0.25:3.5);
Z=peaks(X,Y);
		% Comanda destinata desenarii a 30 de linii de contur spatiale
[C,h]=contour3(X,Y,Z,30);
		% Setarea grosimii liniilor de contur la 1,5 puncte
set(h,'LineWidth',1.5)
		% Plasarea unui grid 3D
grid on
		% Determinarea limitelor axelor
axis([-3,3,-3,3,-6,6])
		% Etichetarea celor trei axe
xlabel('x')
ylabel('y')
zlabel('z')
		% Scrierea unui titlui
title('REPREZENTAREA CU LINII DE CONTUR SPATIALE')
