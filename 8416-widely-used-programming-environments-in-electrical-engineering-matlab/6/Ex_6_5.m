		% Generarea vectorului x si y
x=0:pi/100:2*pi;
y=sin(x).^2.*cos(x).^2;
		% Reprezentarea functiei in coordonate polare
polar(x,y)