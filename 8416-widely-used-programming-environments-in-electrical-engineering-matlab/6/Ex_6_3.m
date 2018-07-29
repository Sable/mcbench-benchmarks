		% Generarea vectorului alfa
alfa=0:pi/50:2*pi;
		% Incarcarea vectorului y
y=sin(alfa).^2;
		% Reprezentarea grafica y=f(alfa)
plot(alfa,y)
		% Personalizarea reprezentarii grafice
		% - precizarea titluluicu font Arial Black ingrosat 
title('\fontname{Arial Black} \bf  EXEMPLU')
		% - precizarea etichetelor axelor
xlabel('\alpha')
ylabel('sin^{2} (\alpha)')
		% - modificarea scalarii axelor
axis([0 2*pi 0 1.2])
		% - scrierea unui text in figura
text(pi/2,1.05,'Maximul')
        % - plasarea unei legende
legend('Patratul sinusului')
		% - plasarea unei retele de linii
grid on