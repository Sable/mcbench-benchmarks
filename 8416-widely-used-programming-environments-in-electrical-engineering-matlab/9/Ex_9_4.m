clear; clf;
		% Precizarea limitelor de integrare
x0=0; xf=2.5;
		% Specificarea conditiilor initiale
y0=[0 4];
		% Apelarea functiei destinata integrarii 
		% ecuatiei diferentiale
		%  - in x si y sunt stocate solutiile
[x y]=ode45(@fsist,[x0,xf],y0);
		% Reprezentarea derivatei de ordinul I., 
		% memorata in prima coloana a vectorului solutie y
plot(x,y(:,1),'r-.');
hold on;
		% Reprezentarea in aceeasi figura 
		% a variatiei solutiei, memorata in a doua coloana a 
		% vectorului solutie y
plot(x,y(:,2),'b-');
legend('Derivata de ordinul I.','Solutia ecuatiei')
grid