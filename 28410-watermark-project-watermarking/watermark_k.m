function varargout=watermark_k(varargin)
%Questa funzione inserisce un watermark di caratteri (stringa) all'interno
%di una immagine passata come argomento di input. E' possibile specificare
%anche una chiave numerica tra gli argomenti di input.
%Sono abbilgatori almeno due parametri di input:
%               [img_w,str]=watermark_k(img,stringa);
%Restituisce l'immagine watermarked "img_w" ed una opzionale stringa di
%errore "str". Accetta in ingresso l'immagine sulla quale effettuare il
%watermarking e la stringa da inserire. E' possibile aggiungere un terzo
%parametro di input che ne rappresenta la chiave numerica:
%                   watermark_k(img,stringa,key);


if length(varargin)<2           %Controllo il numero di parametri passati in input
    return
elseif length(varargin)==3      %Se è stato specificato un terzo parametro:
    rand('seed',varargin{3});   %Fisso il seme della funzione rand
end

img=varargin{1};                %Acquisisco il primo parametro di input
stringa=varargin{2};            %Acquisisco il secondo parametro di input


im=img(:);                      %Importo l'immagine in un unico vettore colonna
if (length(stringa)+1)<=(length(im)/8)              %Controllo se la dimensione dell'immagine è sufficiente a ospitare la stringa
    im=bitand(im,uint8(ones(length(im),1)*254));    %Setto a 0 il bit meno significativo di ogni elemento di im
    t_im=uint8(zeros(length(im),1));                %Creo un vettore di appoggio per apportare momentaneamente le modifiche
    
    if length(varargin)==3      %Controllo se è presente una key:
        k=randperm(length(im)); %Creo un vettore di indici utilizzano randperm
    end
    
    for i=1:length(stringa)     %Per ogni carattere della stringa:
        for j=1:8                                   %Per ogni bit del singolo carattere:
            if length(varargin)==3                  %Controllo se è presenre una key:
                index=k((i-1)*8 + j);               %Calcolo l'indice del pixel da modificare
            else                                    %Se non è presente la key:
                index=(i-1)*8 + j;                  %Calcolo l'indice del pixel da modificare
            end
            b=bitget(uint8(stringa(i)),j);          %Acquisisco il j-esimo bit dell'i-esimo carattere
            if(b==1)                                %Se è pari a 1:
                t_im(index)=bitset(t_im(index),1);  %Setto il bit meno significato del pixel indicato da index
            end
        end
    end
    
    %Inserimento di un carattere tappo (fine stringa).
    for j=1:8                                       %Per ogni bit del carattere tappo
            if length(varargin)==3                  %Controllo se si utilizza una key:
                index=k(length(stringa)*8 + j);     %Calcolo l'indice
            else
                index=length(stringa)*8 + j;        %Calcolo l'indece senza key
            end
            t_im(index)=bitset(t_im(index),1);      %Aggiorno i bit di t_im
    end

    r_im=bitor(im,t_im);                            %Effettuo una or bit a bit tra vettore di appoggio e vettore immagine
    [x,y,z]=size(img);                              %Acquisisco le dimensioni dell'immagine
    img_w=reshape(r_im,x,y,z);                      %Ricostruisco l'immagine watermarked
    
    varargout{1}=img_w;                             %Restituisco img_w
    varargout{2}='WATERMARK INSERITO!';             %Non restituisco errori
    
else                                                %Nel caso la dimensione dell'immagine non è sufficiente a contenere "stringa":
        varargout{2}='Stringa troppo lunga per l''immagine selezionata!';       %Restituisco un errore 
end

end