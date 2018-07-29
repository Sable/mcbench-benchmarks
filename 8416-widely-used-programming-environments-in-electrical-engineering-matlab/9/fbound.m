function tprim=fbound(x,y)
        % Functie care evalueaza o ecuatie diferentiala
        % ordinara cu conditii de frontiera

    	% Initializarea vectorului tprim in vederea 
        % formarii unui vector coloana
tprim=zeros(2,1);
        % Implementarea sistemului de ecuatii diferentiale
tprim(1)=y(2);
tprim(2)=-abs(y(1));