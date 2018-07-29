clear; clf;
		% Introducerea punctelor definite
		% -	vectorul x cu abscisele punctelor
x=0:5;	
		% -	vectorul y cu ordonatele punctelor
y=[0 0.5 4.5 0 2 0];	
		% Generarea vectorului xx cu pasul fin
xx=0:0.1:5;
        % Reprezentarea grafica cu subplot-uri
h=subplot(2,2,1)
        % Precizarea positiei si marimii celulei de figura
set(h,'position',[0.05,0.55,0.4,0.4])
        % Se reprezinta cu *-uri negre puntele date
plot(x,y,'ko');
hold on
		% Aproximarea cu un polinom de gradul 1
		% -	determinarea coeficientilor
		%   polinomului de aproximare
c=polyfit(x,y,1);	
		% -	evaluarea polinomului in punctele din xx
polinom=polyval(c,xx);
        % - reprezentarea grafica a functiei de aproximare
plot(xx,polinom,'r','LineWidth',1.5);
        % Personalizarea graficii
grid on;
title('Polinom de aproximare de gradul 1');	

        % Repetarea procedurii pentru 
        % polinomul de gradul 2
h=subplot(2,2,2)
set(h,'position',[0.5,0.55,0.4,0.4])
plot(x,y,'ko');
hold on
c=polyfit(x,y,2);	
polinom=polyval(c,xx);
plot(xx,polinom,'g','LineWidth',1.5);        
grid on;
title('Polinom de aproximare de gradul 2');	
        % Polinomul de gradul 4
h=subplot(2,2,3)
set(h,'position',[0.05,0.05,0.4,0.4])
plot(x,y,'ko');
hold on
c=polyfit(x,y,4);	
polinom=polyval(c,xx);
plot(xx,polinom,'b','LineWidth',1.5);
grid on;
title('Polinom de aproximare de gradul 4');	

        % Polinomul de gradul 6
h=subplot(2,2,4)
set(h,'position',[0.5,0.05,0.4,0.4])
plot(x,y,'ko');
hold on
c=polyfit(x,y,6);	
polinom=polyval(c,xx);
plot(xx,polinom,'m','LineWidth',1.5);        
grid on;
title('Polinom de aproximare de gradul 6');	
