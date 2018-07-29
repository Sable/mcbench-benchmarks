clear
        % Memorarea timpului pornirii programului
t0=clock;
		% Prealocarea vectorului y
y=zeros(50001,1);
		% Initializarea unui contor de ciclu
n=0;
		% Executarea ciclului for
for t=0:0.001:50
	n=n+1;
	y(n)=sin(t);
end
		% Calcularea timpului parcurs de la 
		% pornirea programului
durata=etime(clock,t0)
