function num=detection(f,modulo)
%%% VERSIONE DI DETECTION DOVE LA SOGLIA è SCELTA COME IL MASSIMO DELLA FFT
%%% SOLO NEGLI INTERVALLINI, PER LA VERSIONE GRAFICA DEL PROGRAMMA

base_f=[697 770 852 941 1209 1336 1477];      % frequenze dtmf
f_rilevate=zeros(1,length(base_f));           % vettore delle freq rilevate
finestra=2;                                   % scelgo la semiampiezza della finestra di controllo (in Hz)
num=0;                                        % tasto premuto

% rilevamento soglia e definizione finestre
for j=1:length(base_f)                             % per ogni finestra
    a(j)=find(f>(base_f(j)- finestra),1,'first');  % l'estremo inf è l'indice del primo valore dell'asse f maggiore uguale di centro-semiampiezza
    b(j)=find(f>(base_f(j)+ finestra),1,'first');  % l'estremo sup è l'indice del primo valore dell'asse f maggiore uguale di centro+semiampiezza
    soglia_parziale(j)=max(modulo(a(j):b(j)));     % il vettore delle soglie parziali raccoglie il massimo del modulo in ogni finestra
end

soglia=max(soglia_parziale)/3;                     % la soglia è un terzo del massimo di tutte le finestre

                                            
                                           
                                     
                                         

for i=1:length(base_f)                       
    if (soglia_parziale(i)>soglia)            % per ogni finestra controlla se il massimo è maggiore della soglia
        f_rilevate(i)=base_f(i);              % se il massimo è maggiore della soglia registra la frequenza fondamentale nella lista delle frequenze rilevate
    else
        f_rilevate(i)=0;                      % altrimenti lascia a zero
    end
end

indici=find(f_rilevate);     % trova tutti gli elementi diversi da zero e ne restituisce gli indici nel vettore ind

if (length(indici)>2) || (length(indici)==0)
    disp('tasto non rilevato correttamente')
    num='errore';
else
    if indici==[1 5]
            disp('hai premuto il tasto 1')
            num='1';
        elseif indici==[1 6]
            disp('hai premuto il tasto 2')
            num='2';
        elseif indici== [1 7]
            disp('hai premuto il tasto 3')
            num='3';
        elseif indici== [2 5]
            disp('hai premuto il tasto 4')
            num='4';
        elseif indici== [2 6]
            disp('hai premuto il tasto 5')
            num='5';
        elseif indici== [2 7]
            disp('hai premuto il tasto 6')
            num='6';
        elseif indici== [3 5]
            disp('hai premuto il tasto 7')
            num='7';
        elseif indici== [3 6]
            disp('hai premuto il tasto 8')
            num='8';
        elseif indici== [3 7]
            disp('hai premuto il tasto 9')
            num='9';
        elseif indici== [4 5]
            disp('hai premuto il tasto *')
            num='asterisco';
        elseif indici== [4 6]
            disp('hai premuto il tasto 0')
            num='0';
        elseif indici== [4 7]
            num='cancelletto';
            disp('hai premuto il tasto #')
    else
            disp('tasto non rilevato correttamente')
            num='errore';
    end
end
    






           