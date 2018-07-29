            % Diferite reprezentari grafice speciale
            % **************************************
			% ***** Grafica nr.1. *****
	subplot(4,2,1)
			% Desenarea unui poligon
			% - desemnarea coordonatelor varfurilor
	x=[0 2 4 3 1 0];
	y=[0 1 2 4 3 0];
			% - reprezentarea poligonului
	fill(x,y,'y')
			% - plasarea unui titlu
	title('FILL')
			% ***** Grafica nr.2. *****
	subplot(4,2,2)
	x=0:pi/10:2*pi;
	y=sin(x);
			% Reprezentarea grafica utilizand comanda bar
	bar(x,y)
	title('BAR')
			% - fixarea limitelor axelor de coordonate
	axis([0 2*pi -1.1 1.1])
			% ***** Grafica nr.3. *****
	subplot(4,2,3)
			% Reprezentarea grafica utilizand comanda stem
	stem(x,y)
	title('STEM')
	axis([0 2*pi -1.1 1.1])
			% ***** Grafica nr.4. *****
	subplot(4,2,4)
			% Reprezentarea grafica utilizand comanda stairs
	stairs(x,y)
	title('STAIRS')
	axis([0 2*pi -1.1 1.1])
			% ***** Grafica nr.5. *****
	subplot(4,2,5)
			% Generarea unui vector de eroare aleatoare 
	e=rand(size(x)).*y./5;
			% Reprezentarea grafica utilizand comanda errorbar
	errorbar(x,y,e)
	title('ERRORBAR')
	axis([0 2*pi -1.1 1.1])
			% ***** Grafica nr.6. *****
	subplot(4,2,6)
			% Regenerarea vectorului x cu un pas mai mic
	x=0:pi/100:2*pi;
			% Reincarcarea vectorului y
	y=sin(x);
			% Reprezentarea grafica utilizand comanda hist
	hist(y,20)
	title('HIST')
            % ***** Grafica nr.7. *****
	subplot(4,2,7)
			% Reprezentarea grafica utilizand comanda pie
	pie([2 4 3 6],{'Nord','Sud','Est','Vest'})
	title('PIE')
            % ***** Grafica nr.8. *****
	subplot(4,2,8)
			% Reprezentarea grafica utilizand comanda area
	z = [1,5,6;3,4,7;2,8,3;2,6,10];
	area(z)
	title('AREA')