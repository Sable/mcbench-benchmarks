function bitword=dewatermark_k(varargin)
%Questa funzione effettua l'operazione di estrazione di un watermark di
%tipo stringa, inserito tramite la funzione watermark_k.
%Accetta almeno un parametro di ingresso e restituisce un solo parametro di
%uscita (la stringa appunto). Può accettare un'eventuale key numerica 
%utilizzata anche durante la fase di watermarking.
%                    bitword=dewatermark_k(img_w,key);



if length(varargin)==0                          %Controllo il numero di parametri passati in input
    return
elseif length(varargin)==2                      %Se è stato specificato un secondo parametro:
    rand('seed',varargin{2});                   %Fisso il seme della funzione rand
end

img_w=varargin{1};                              %Acquisisco il primo parametro di input

i=1;                                            %Creo ed inizializzo un indice a 1
flag=0;                                         %Creo ed inizializzo una flag a 0
im=img_w(:);                                    %Importo l'immagine in un unico vettore colonna
bitword=[''];                                   %Creo il contenitore per la stringa

if length(varargin)==2                          %Controllo se si sta utilizzando una key:
    k=randperm(length(im));                     %Creo un vettore di indici utilizzano randperm
end

while (i<=length(im))&&(flag==0),               %Finquando non analizzo tutta l'immagine e non trovo il carattere tappo:
    bitchar=uint8(0);                           %Pulisco la variabile bitchar
    for j=1:8                                   %Operazioni effettuate 8 pixel alla volta
        if length(varargin)==2                  %Controllo se si sta utilizzando una key:
            index=k((i-1) + j);                 %Calcolo l'indice del pixel da leggere
        else
            index=(i-1) + j;                    %Calcolo l'indice del pixel da leggere
        end
        b=bitget(im(index),1);                  %Estraggo il bit meno significativo
        if(b==1)                                %Se è pari a 1
            bitchar=bitset(bitchar,j);          %Setto il j-esimo bit del carattere bitchar
        end
    end
    if(bitchar==255)                            %Controllo se il carattere letto è il tappo
        flag=1;                                 %Se si pongo flag a 1
    else
        b_index=(i-1)/8 +1;                     %Altrimenti calcolo l'indice della posizione del carattere nella stringa
        bitword(b_index)=char(bitchar);         %Aggiorno la stringa
        i=i+8;                                  %Aggiorno il contatore i
    end

end

end