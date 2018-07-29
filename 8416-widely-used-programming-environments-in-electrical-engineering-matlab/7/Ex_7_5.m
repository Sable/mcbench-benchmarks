		% Evaluarea functiei date
[X,Y]=meshgrid(-3.75:0.25:3.5);
Z=peaks(X,Y);
		% Aproximarea gradientului
[px,py] = gradient(Z,0.5,0.5);
		% Trasarea liniilor de contur
contour(X,Y,Z)
hold on
		% Desenarea in aceeasi figura
		% a vectorilor orientati
quiver(X,Y,px,py,2)
hold off 