clear; clf;
		% Incarcarea vetorului x
x=-2.5:0.01:2.5;
		% Evaluarea functiei date
y=funct2(x);
		% Calcularea aproximativa a derivatei
df=diff(y)./diff(x);
		% Reprezentarea grafica a functiei de derivat 
plot(x,y,'g:')
hold on
		% Incarcarea vectorului xd cu n-1 elemente 
		% din vectorul x
xd=x(2:length(x));
		% Reprezentarea grafica a derivatei 
plot(xd,df,'m-')
		% Calcularea elementelor vectorului produs
produs=df(1:length(df)-1).*df(2:length(df));
		% Incarcarea punctelor critice in vectorul minmax
minmax=xd(find(produs<0));
		% Evaluarea functiei in punctele critice
fminmax=y(find(produs<0)+1);
		% Reprezentarea grafica a maximelor si minimelor
        % locale ale functiei initiale 
plot(minmax,fminmax,'kx','MarkerSize',14)
grid on
        % Trasarea liniilor de grid prin punctele gasite
        % - obtinerea valorilor la care se plaseaza 
        %   liniutele de divizare implicite
xtick=get(gca,'XTick');
        % - gasirea valorilor minime si maxime ale acestora 
xtickmin=min(xtick); xtickmax=max(xtick);
        % - generarea vectorului noilor linii de divizare pe axa x 
xtick=[xtickmin,minmax,xtickmax];
        % - setarea noilor liniute de divizare 
set(gca,'XTick',xtick);
set(gca,'YTick',0);
    	% Plasarea unei legende
legend('Functia','Derivata');
