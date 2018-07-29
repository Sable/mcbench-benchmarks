function suono_tastierino(f1,f2)
%Genera un segnale, somma di due segnali sinusoidali a frequenze f1 ed f2
%dalla durata di 0.5 secondi e per una frequenza di campionamento di 8000
%campioni al secondo. Infine riproduce il suono sintetizzato.


fc=8000;  %Fisso la frequenza di campionamento

%Genero il vettore di valori 
y=sin(2*pi*f1*linspace(0,0.5,4e3))+sin(2*pi*f2*linspace(0,0.5,4e3));

wavplay(y,fc)  %Riproduce il suono a 8000 Hz

end