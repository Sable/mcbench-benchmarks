        % Rezolvarea ecuatiei diferentiale
y=dsolve('D2y=12*x^2-10','y(0)=4','Dy(0)=0','x')
        % Vizualizarea pe ecran a solutiei
pretty(y)
        % Reprezentarea grafica a solutiei pe intervalul dat
ezplot(y,[0,2.5])