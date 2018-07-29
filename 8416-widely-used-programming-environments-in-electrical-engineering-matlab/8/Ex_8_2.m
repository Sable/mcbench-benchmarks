        	% Stergerea spatiul de lucru si a figurii curente
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
            % Se reprezinta cu *-uri negre punctele date
	plot(x,y,'ko');
	hold on
		    % Interpolarea liniara
            % si reprezentarea functiilor obtinute
	yy=interp1(x,y,xx,'linear');
	plot(xx,yy,'r','LineWidth',1.5);
            % Personalizrea reprezentarii grafice
	grid on;
	title('LINEAR');	
	
		    % Interpolarea de tip nearest
	h=subplot(2,2,2)
	set(h,'position',[0.5,0.55,0.4,0.4])
    plot(x,y,'ko');
	hold on
	yy=interp1(x,y,xx,'nearest');
	plot(xx,yy,'g','LineWidth',1.5);
	grid on;
	title('NEAREST');	
            
			% Interpolarea de tip spline
	h=subplot(2,2,3)
    set(h,'position',[0.05,0.05,0.4,0.4])
 	plot(x,y,'ko');
	hold on
	yy=interp1(x,y,xx,'spline');
	plot(xx,yy,'m','LineWidth',1.5);
	grid on;
	title('SPLINE')
	
            % Interpolarea de tip cubic
	h=subplot(2,2,4)
    set(h,'position',[0.5,0.05,0.4,0.4])
    plot(x,y,'ko');
	hold on
	yy=interp1(x,y,xx,'cubic');
	plot(xx,yy,'b','LineWidth',1.5);
	grid on;
	title('CUBIC')