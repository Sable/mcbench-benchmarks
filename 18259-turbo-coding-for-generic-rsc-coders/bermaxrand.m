% funcion principal donde se setean los parámetros de la simulación

function bermaxrand

clear all

% parametros de poly2trellis
% K: Longitud restringida
% G: Codegenerator en octal
% F: Feedback connection en octal

% para el ejemplo de Casti, K=3, G=7, F=5
%K=3 ; G=7; F=5;

% Paper de Berrou
K=5; G=21; F=37; % este codificador tiene muy buena performance

% asigno el vector de realimentacion para terminar el trellis del primer
% codificador
assignin('base','F',F);

trellis = poly2trellis(K,G,F);
% asigno la estructura al workspace 'base'
assignin('base','trellis',trellis);

% Genero la matriz de conexiones y salidas del trellis

trellismat;


EbNovector = 0:0.5:2;

iteracionesvector = [8 10];

% Trama de longitud N
N=53*53;
assignin('base','N',N);

CantTramas=100; % cantidad de tramas que se transmiten, por cada una se 
% realiza el proceso de decodificacion

% distintos trazos para diferentes iteraciones en un mismo grafico
trazo = ['-' ':' '-.' '--'];

contador = 0;

% vector con el valor de BER para cada EbNo
bervector = zeros(length(EbNovector),1);

for j = 1:length(iteracionesvector)

    iteraciones = iteracionesvector(j);
    assignin('base','iteraciones',iteraciones);
    
    for i = 1:length(EbNovector)

        EbNo =   EbNovector(i);
        assignin('base','EbNo',EbNo);
        
        totalerrors = 0;
        
        for k=1:CantTramas
            
            % funcion que simula el esquema Tx-canal-Rx
            turbo;
                        
            % errors es una funcion
            totalerrors = totalerrors + errors; 
            
            contador = contador + 1;
            progreso = 100*contador/(length(iteracionesvector)*...
                length(EbNovector)*CantTramas)
       
        end

        bervector(i) = totalerrors/(N*CantTramas);

    end

    semilogy(EbNovector,bervector, trazo(j));
    xlabel('Eb/No [dB]');
    ylabel('BER');
    hold on
end