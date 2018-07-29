function frequencyFilter(f) 
% questo M-file ha lo scopo di implementare il filtraggio dell'immagine nel
% dominio di Fourier tramite un filtro Gaussiano. Il parametro di ingresso
% f specifica la frequenza di taglio del filtro. Se l'immagini è a livelli
% di grigio l'operazione di filtraggio vien fatta una volta solo, mentre
% per le immagini a colori il filtraggio vien fatto una volta per ognuna
% delle 3 matrici


% definizione delle variabili globali, in comune a quelle dell'interfaccia
% principale
global IP
global IT

IT=double(IT);
    if length(size(IT))==2              % controllo dell'immagine se essa è a colori o meno.
        % Qua viene trattata l'immagini in livelli di grigio
        F=fft2(IT);                   % trasformata di Fourier dell'immagine
        
        % queste operazioni implementano un filtro Gaussiano
        [M,N]=size(IT)
        x=-ceil(N/2)+1:floor(N/2);
        y=-ceil(M/2)+1:floor(M/2);
        [X,Y]=meshgrid(x,y);
        G=exp(-(X.^2+Y.^2)./(2*(f^2)));   % vengono creati valori numerici del filtro con frequenza di taglio f( che copre il ruolo della varianza)
        G=fftshift(G);                    % per come è fatta la trasformata bidimensionale di Fourier, il filtro va adattato ad essa ovvero i valori alti vanno posizionati negli angoli.
        
        Y=G.*F;                           % moltiplicazione tra filtro e trasformata dell'immagine           
        y=real(ifft2(Y));                 % antitrasformata del risultato
    
    else                                  % se l'immagine è a livelli di grigio la stessa operazione una volta per ognuna delle 3 componenti
        I1=IT(:,:,1);
        f1=fft2(I1);
        I2=IT(:,:,2);
        f2=fft2(I2);
        I3=IT(:,:,3);
        f3=fft2(I3);
        [M,N]=size(I1);

        x=-ceil(N/2)+1:floor(N/2);
        y=-ceil(M/2)+1:floor(M/2);
        [X,Y]=meshgrid(x,y);
        G=exp(-(X.^2+Y.^2)./(2*(f^2)));  
        G=fftshift(G);   

        Y1=G.*f1;
        y1=real(ifft2(Y1));
        Y2=G.*f2;
        y2=real(ifft2(Y2));
        Y3=G.*f3;
        y3=real(ifft2(Y3));
        y=zeros(size(IT));
        y(:,:,1)=y1;
        y(:,:,2)=y2;
        y(:,:,3)=y3;
    end
        
IP=uint8(y);                             % conversione da double a uint8
figure(3)
imshow(IP);

