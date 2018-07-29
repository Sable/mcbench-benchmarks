function varargout=dewatermark_img(varargin)
%Questa funzione effettua l'operazione di estrazione di un watermark di
%tipo immagine, inserito tramite la funzione watermark_img.
%Accetta almeno un parametro di ingresso e restituisce un solo parametro di
%uscita (l'immagine appunto). Può accettare un'eventuale key numerica 
%utilizzata anche durante la fase di watermarking.
%                   img_log=dewatermark_img(img_w,key);

if length(varargin)==0                          %Controllo il numero di parametri passati in input
    return
elseif length(varargin)==2                      %Se è stato specificato un secondo parametro:
    rand('seed',varargin{2});                   %Fisso il seme della funzione rand
    p=randperm(32);                             %Creo un vettore di indici per i primi 32 bit da leggere
end

im_w=varargin{1}(:);                            %Acquisisco il primo parametro di input e lo metto in un vettore colonna

dim_l=0;                                        %Creo una variabile di appoggiò che conterrà le dimensioni del watermark
dim3_b=0;                                       %Creo una variabile di appoggio che conterrà la terza dimensione del watermark in bit

%INIZIO lettura dell'header (dimensioni del watermark)
for j=1:2                                       %Per ognuna delle prime due dimensioni
    for i=1:15                                  %Per ogni bit della j-esima dimensione
        index=(j-1)*15 +i;                      %Calcolo l'indice lineare per i pixel da leggere
        if length(varargin)==2                  %Controllo se si sta utilizzando una key:
          dim_b(i)=bitget(im_w(p(index)),1);    %Acquisisco l'i-esimo bit della j-esima dimensione, recuperando da p l'indice pseudo-casuale
        else
        dim_b(i)=bitget(im_w(index),1);         %Altrimenti utilizzo l'indice lineare
        end
    end
    dim_l(j)=bin2dec(num2str(dim_b));           %Converto in decimale la j-esima dimensione
    
    %Acquisizione del j-esimo bit della terza dimensione
    if length(varargin)==2                      %Controllo se si sta utilizzando una key:
        dim3_b(j)=bitget(im_w(p(30+j)),1);      %Acquisisco il j-esimo bit della terza dimensione, recuperando da p l'indice pseudo-casuale
    else
    dim3_b(j)=bitget(im_w(30+j),1);             %Altrimenti utilizzo l'indice lineare
    end
end
%FINE lettura dell'header (dimensioni del watermark)
dim_l(3)=bin2dec(num2str(dim3_b));              %Converto in decimale la terza dimensione

len=prod(dim_l)+4;                              %Dimensione (in byte) del watermark compresi i 4 byte dell'header
im_log(prod(dim_l))=0;                          %Creo un contenitore per i len-4 pixel del watermark
k=4;                                            %Pongo k=4 (32 bit già letti!)
if length(varargin)==2                          %Controllo se si sta utilizzando una key:
   p=randperm(prod(dim_l)*8)+32;                %Calcolo gli indici pseudo casuali per i successivi pixel
end

%INIZIO lettura dell'immagine vera e propria
while k<len,                                    %Finquando non si leggono tutti i pixel del watermark
    k=k+1;                                      %Aggiorno k (+1 pixel)
    for j=1:8                                   %Per ogni bit del (k-4)-esimo pixel del watermark
       index=(k-1)*8 + j;                       %Calcolo l'indice lineare per i pixel da leggere
       if length(varargin)==2                   %Controllo se si sta utilizzando una key:
          b=bitget(im_w(p(index-32)),1);        %Acquisisco il j-esimo bit del pixel da leggere, recuperando da p l'indice pseudo-casuale
       else
       b=bitget(im_w(index),1);                 %Altrimenti utilizzo l'indice lineare
       end
       
       if b==1                                  %Se il bit acquisito è pari a 1
        im_log(k-4)=bitset(im_log(k-4),j);      %Setto il j-esimo bit del (k-4)-esimo pixel del watermark
       end
    end
end
%FINE lettura dell'immagine vera e propria

im_log=uint8(im_log);                           %Converto i valori di im_log in interi

varargout{1}=reshape(im_log,dim_l(1),dim_l(2),dim_l(3));    %Ricostruisco le matrici dell'immagine watermark

end