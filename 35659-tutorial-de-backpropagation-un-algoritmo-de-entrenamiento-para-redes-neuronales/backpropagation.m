%Algoritmo de Entrenamiento de BACKPROPAGATION para Redes Neuronales
%por Paul Acquatella B.
%Creado: 27 Enero 2009

function entrenamiento = backpropagation(X,D,L,rate,alfa,dmse)
%% 1. Inicialización Y Cálculo de Parámetros

%Parámetros del algoritmo
    mse = Inf;                  %Asumiendo Pesos Iniciales Malos
    epoch = 1;

%Se calculan los tamaños respectivos de las matrices
    [N,P] = size(X);            %Numero de Patrones P y Entradas N
    [Q,Pd] = size(D);           %Numero de Patrones P y Salidas Q 
    depth = length(L);          %Profundidad de la red - nro capas
    
%Inicializar Matriz de Pesos para cada capa en el rango [-1,1]
W = cell(1,depth-1);            %Pre-alocacion de la matriz de pesos
for m = 1:depth-2
    W{1,m} = [-1+2*rand(L(1,m+1),L(1,m)+1)];
end
W{end} = [-1+2*rand(L(end),L(end-1)+1)];

%Inicializar Matrices de los delta-pesos de ajuste
dW = cell(1,depth-1);               %Pre-alocacion de los delta pesos
for m = 1:depth-1
    dW{m} = zeros(size(W{m}));
end

%Inicializar los campos locales inducidos 'v'
v = cell(1,depth);                %Pre-alocacion de los campos locales
for i=1:depth-1;
    v{i} = [zeros(L(i),1); 1]; 
end
v{end} = zeros(L(end),1);

%Inicializar las salidas 'y' de cada capa
y = cell(1,depth-1);             %Pre-alocacion de las salidas locales
for i=1:depth-2;
    y{i} = zeros(L(i+1),1);
end
y{end} = zeros(L(end),1);


%% 2. Cálculo Forward y Backward para cada epoch

while (mse > dmse) && (epoch <= 10000)
    e = zeros(Q,P);
    err = zeros(1,P);
    for p = 1:P
        %Cálculo Forward capa-por-capa para cada patrón p
        v{1}(1:end-1) = X(:,p);
        for i = 1:depth-1
            y{i} = W{i}*v{i};                   
            if i < depth-1
                v{i+1}(1:end-1) = tansig(y{i}); %Cálculo de la salida
            else
                v{i+1} = tansig(y{i});          %Cálculo de la salida
            end
        end
        %Cálculo de la señal de error
        e(:,p) = D(:,p)-v{end};
        %Cálculo de la energía del error
        if size(D,1) == 1
            err(1,p)=0.5*(e(:,p).^2);
        elseif size(D,1) > 1
            err(1,p)=0.5*sum(e(:,p).^2);
        end
        
        %Cálculo Backward capa-por-capa para cada patrón p        
        delta = e(:,p).*(tansig('dn',y{end}));
        %Ajuste de pesos
        for i = depth-1:-1:1                 
            dW{i} = rate * delta * v{i}' + alfa.*dW{i};
            W{i} = W{i} + dW{i};
            if i > 1
                delta = tansig('dn',y{i-1}).*(delta'*W{i}(:,1:end-1))';
            end
        end
    end
    %Cálculo del mean square error
    mse = (1/P)*sum(err);
    epoch = epoch +1;
    hold on
    figure(2)
    semilogx(epoch,mse,'ro')
    hold off
end

entrenamiento.pesos = W;
entrenamiento.epocas = epoch;
entrenamiento.estructura = L;
entrenamiento.error = mse;

