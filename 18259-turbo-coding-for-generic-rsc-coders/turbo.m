% funcion que replica el esquema de transmisión / recepción turbo

function turbo

% esta funcion crea el escenario de transmisión/recepción

N = evalin('base','N'); % traigo las variables del workspace
EbNo = evalin('base','EbNo');
iteraciones = evalin('base','iteraciones');
trellis = evalin('base','trellis');
F = evalin('base','F'); % realimentacion del codificador

% calculo la memoria del codificador (igual a K-1)

M = log2(trellis.numStates);

Sigma = 10^(-EbNo/20); % EbNo esta en dB, Eb = 1

Lc = 2/(Sigma^2);

%transmito N-M bits de información, necesito M bits para terminar el
%trellis

source = polar2bin(sign(randn(N-M,1))); %source vale 0 o 1

%Genero la redundancia sin interleaver

[X1p_temp FinalState] = convenc(source,trellis, 0);

%Termino el trellis del primer codificador
%la realimentacion debe incluir a todos los estados (o hay q cambiar el
%codigo)

tailbits = zeros(M,1);
tailbitscoded = zeros(M,1);

% paso de octal a binario las conexiones de realimentacion del codificador
F_dec = oct2dec(F);
F_bin = dec2bin(F_dec, M);

for n=1:M
    FinalStateBin = dec2bin(FinalState, M);
    weight=0;
    for m=1:M
        % si F_bin(m+1) == '1', ese registro esta realimentado
        % F_bin(1) es la conexion de la entrada al codificador (no
        % pertenece a los estados del codificador
        
        if FinalStateBin(m) == '1' & F_bin(m+1) == '1'
            weight = weight + 1;
        end
    end

    tailbits(n) = mod(weight,2); % si el estado tiene cantidad de '1' par, 
                               % entonces a la X-OR debe entrar un cero

    % ahora ingreso al codificador con el tail bit
    PreviousState = FinalState;
    [tailbitscoded(n) FinalState] = ...
        convenc(tailbits(n),trellis, PreviousState);
    
end

% le agrego a los bits del primer codificador los tailbits codificados

X1p_bin = [X1p_temp; tailbitscoded];


% ahora renombro la fuente agregando los tailbits

source = [source; tailbits];
assignin('base','source',source);


%Genero el bit sistematico incluyendo tailbits

Xs_bin = source;

%Genero la redundancia pasando a 'source' por un interleaver aleatorio

source_int = randintrlv(source,12345);

X2p_bin = convenc(source_int,trellis, 0);

%Ahora armo la secuencia de salida X
%Genero una matriz de salida, la primera columna es Xs
%La segunda tiene en las posiciones impares la paridad sin interleaver
% y en las pares la paridad con interleaver

X_bin = zeros(N,2);

X_bin(:,1) = Xs_bin;

for i=1:N/2
    X_bin(2*i-1,2) = X1p_bin(2*i-1);
    X_bin(2*i,2) = X2p_bin(2*i);
end

% paso las secuencias de salida a formato polar

X = bin2polar(X_bin);



%Genero el ruido gaussiano del canal de comunicaciones

Ruido = Sigma*randn(N,2);


%En el receptor

Y = zeros(N,2); 
Y = X + Ruido;

% La información extrínseca inicialmente es nula

Le1 = zeros(N,1);
Le2 = zeros(N,1);

% Relleno las redundancias en las posiciones impares para el primer
% decodificador y las pares para el segundo

Yp1 = zeros(N,1);
Yp2 = zeros(N,1);


for i=1:N/2
    Yp1(2*i-1) = Y(2*i-1,2);
    Yp2(2*i) = Y(2*i,2);
end

%Genero las secuencias que van a entrar a cada decodificador

Inputdec1 = zeros(3*N,1);
Inputdec2 = zeros(3*N,1);

% Lazo de iteraciones

for i=1:iteraciones

    Inputdec1 = [Le2 Y(:,1) Yp1];

    %Ingreso al Dec1, y recibo como salida la Le1
    
    %le aviso a decmax que es el decoder 1 para que ponga beta(N+1,1)=0;
    decoder = 1;
    assignin('base','decoder',decoder);
    
    dec1output = decmax(Inputdec1);
    
    % La segunda columna de la salida de Dec1 no tiene utilidad

    Le1 = dec1output(:,1);
    
    % Preparo la entrada para Dec2
    
    % interleave de la información extrínseca Le1
    Le1_int = randintrlv(Le1,12345);

    % interleave de la información sistemática Y(:,1)
    Y1_int = randintrlv(Y(:,1),12345);
    
    
    Inputdec2 = [Le1_int Y1_int Yp2];
    
    decoder = 2;
    assignin('base','decoder',decoder);
    
    dec2output = decmax(Inputdec2);
    
    Le2 = randdeintrlv(dec2output(:,1),12345);

end


% decisión dura de la salida decodificada de Dec2
dec2output_hard = sign(dec2output(:,2));

% paso la decisión dura a binario
dec2output_hard_bin = polar2bin(dec2output_hard);

% deinterleave de la secuencia decodificada
decout = randdeintrlv(dec2output_hard_bin,12345);

assignin('base','decout',decout);
