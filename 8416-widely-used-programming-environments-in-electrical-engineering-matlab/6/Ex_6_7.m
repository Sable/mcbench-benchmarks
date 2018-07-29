		% Generarea vectorilor x si y
x=0:pi/50:2*pi;
y=sin(x);
		% Stergerea figurilor create anterior
clf
		% Reprezentarea grafica y=f(x) 
		% - obtinerea identificatorului de control grafic
		%   al liniilor
		% - setarea grosimii liniei 
h1=plot(x,y,'LineWidth',[2.5]);
grid on
		% Obtinerea identificatorului de control grafic
		% al axelor
h2=gca;
		% Obtinerea identificatorului de control grafic
		% al figurii
h3=gcf;
		% Precizarea numelui figurii curente
set(h3,'Name','Exemplu nr.1')
		% Inactivarea barei de meniuri a ferestrei grafice
set(h3,'MenuBar','none')
		% Specificarea modului de scriere a textelor de pe axe
set(h2,'FontAngle','italic')
		% Stabilirea fontul pentru textele de pe axe
set(h2,'FontName','Symbol')
		% Definirea dimensiunii fontului 
set(h2,'FontSize',[16])
		% Activarea sublinierii textului
set(h2,'FontWeight','bold')
		% Definirea tipul de linie utilizat la
		% desenarea rastrului
set(h2,'GridLineStyle','--')
		% Specificarea lungimii liniutei de divizare a axelor
set(h2,'TickLength', [0.025 0.025])
		% Determinarea orientarii liniutelor de divizare
set(h2,'TickDir','out') 
		% Setarea grosimii liniilor de desenare a obiectelor
		% axe
set(h2,'LineWidth',2) 
		% Precizarea valorii minime si maxime de pe 
		% axa de coordonate x
set(h2,'XLim',[0 2*pi])
		% Specificarea valorilor unde se plaseaza
		% liniute de divizare pe axa x
set(h2,'XTick',[0 pi 2*pi])
		% Specificarea textul care se utilizeaza ca
		% etichetele liniutelor de divizare pe axa x
set(h2,'XTickLabels',['0 ';'p ';'2p'])