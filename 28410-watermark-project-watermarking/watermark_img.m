function varargout=watermark_img(varargin)
%Questa funzione inserisce un'immagine watermark all'interno di un'altra 
%immagine passata come argomento di input. E' possibile specificare anche 
%una chiave numerica tra gli argomenti di input.
%Sono abbilgatori almeno due parametri di input:
%               [img_w,str]=watermark_img(img,img_logo);
%Restituisce l'immagine watermarked "img_w" ed una opzionale stringa di
%errore "str". Accetta in ingresso l'immagine sulla quale effettuare il
%watermarking e l'immagine (logo) da inserire. E' possibile aggiungere un 
%terzo parametro di input che ne rappresenta la chiave numerica:
%                   watermark_img(img,img_logo,key);

if length(varargin)<2                                   %Controllo il numero di parametri passati in input
    return
elseif length(varargin)==3                              %Se è stato specificato un terzo parametro:
    rand('seed',varargin{3});                           %Fisso il seme della funzione rand
    p=randperm(32);                                     %Creo un vettore di indici per i primi 32 pixel da modificare
end

img=varargin{1};                                        %Acquisisco l'immagine da watermarkare
img_logo=varargin{2};                                   %Acquisisco l'immagine che rappresenta il watermark

dim=size(img_logo);                                     %Ottengo le dimensioni del watermark


if prod(size(img)) >= (prod(dim)*8+32)                  %Controllo se img è sufficiente a contenere img_logo
        len=prod(dim)+4;                                %Dimensione (in byte) del watermark compresi i 4 byte dell'header


        im_w=img_logo(:);                               %Importo l'immagine watermark in un unico vettore colonna
        im=img(:);                                      %Importo l'immagine da watermarkare, in un unico vettore colonna
        im=bitand(im,uint8(ones(length(im),1)*254));    %Setto a 0 i bit meno significativi di im

        %INIZIO inserimento dell'header (dimensioni del watermark)
        dim3=dec2bin(dim(3),2);                         %Converto in binario la terza dimensione dell'immagine watermark
        for j=1:2                                       %Per ognuna delle prime due dimensioni
            bin=dec2bin(dim(j),15);                     %Converto in binario su 15 bit la j-esima dimensione
            for i=1:15                                  %Per ogni bit
                index=(j-1)*15 +i;                      %Calcolo un indice lineare
                if(bin(i)=='1')                         %Controllo se l'i-esimo bit è pari a 1
                    if length(varargin)==3              %Controllo se si utilizza una key:
                        im(p(index))=bitset(im(p(index)),1);    %Se si recupero da p l'indice pseudo casuale e setto il bit meno significativo
                    else
                    im(index)=bitset(im(index),1);      %Altrimenti utilizzo l'indice lineare
                    end
                end
            end
            %
            if dim3(j)=='1'                             %Controllo se il j-esimo bit della terza dimensione è pari a 1
                if length(varargin)==3                  %Controllo se si utilizza una key:
                    im(p(30+j))=bitset(im(p(30+j)),1);  %Se si recupero da p l'indice pseudo casuale e setto il bit meno significativo
                else
                im(30+j)=bitset(im(30+j),1);            %Altrimenti utilizzo l'indice lineare
                end
            end
        end
        %FINE inserimento dell'header (dimensioni del watermark)
        
        k=4;                                            %Pongo k=4 (32 pixel già modificati!)
        if length(varargin)==3                          %Controllo se si utilizza una key:
            p=randperm(length(im_w)*8)+32;              %Calcolo gli indici pseudo casuali per i successivi pixel
        end
        
        %INIZIO inserimento dell'immagine vera e propria
        while k<len,                                    %Finquando non si raggiunge l'intera lunghezza len                 
            k=k+1;                                      %Aggiorno k (+1 pixel)
            for j=1:8                                   %Per ogni bit del k-esimo pixel
               index=(k-1)*8 + j;                       %Calcolo l'indice lineare del pixel da modificare
               b=bitget(im_w(k-4),j);                   %Ottengo il j-esimo bit del pixel da watermarkare
               if(b==1)                                 %Se è pari a 1
                   if length(varargin)==3               %Controllo se si utilizza una key:
                       im(p(index-32))=bitset(im(p(index-32)),1);   %Se si recupero da p l'indice pseudo casuale e setto il bit meno significativo
                   else
                   im(index)=bitset(im(index),1);       %Altrimenti utilizzo l'indice lineare
                   end
               end
            end

        end
        %FINE inserimento dell'immagine vera e propria
        
        [x,y,z]=size(img);                              %Ottengo le dimensioni dell'immagine watermarked
        varargout{1}=reshape(im,x,y,z);                 %Riscostruisco le matrici
        varargout{2}='WATERMARK INSERITO!';             %Non restituisco alcun errore
        
else    %Nel caso la dimensione dell'immagine non è sufficiente a contenere il watermark:
        varargout{2}='Immagine contenitore insufficiente a contenere il Watermark'; %Restituisco un errore
end

end