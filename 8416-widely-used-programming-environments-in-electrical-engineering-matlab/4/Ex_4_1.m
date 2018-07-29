		% Incarcarea coeficientilor vectorului a
a=[1, -3, 2];
		% Incarcarea coeficientilor vectorului b care are radacinile 2, 3 si 4
b=poly([2,3,4])
		% Calcularea coeficientilor polinomului a*b
produs=conv(a,b)
		% Calcularea radacinilor polinomului produs
radacini=roots(produs)
		% Determinarea coeficientilor derivatei polinomului b
deriv=polyder(b)