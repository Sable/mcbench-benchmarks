function [Z, Xcluster, Ycluster, cluster] = kmedia(X,Y,k)

%%%%%%%%%%%%%%%%
%  Parametros  %
%%%%%%%%%%%%%%%%
s=size(X);
s=s(2);
cluster=zeros(1,s); % Espacio temporal interno de la funcion.
cambios=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Inicializacion de los centros  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Z= inicializa_centros(X, Y, k);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bucle iterativo de clustering (Programa principal)  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while cambios==1,
    cambios=0;
    
    % Calcula y asigna a cada coordenada {X,Y} su centro mas cercano.
    for i=1:s,
        m=cercano(X(i), Y(i), Z, k);
        if  m~=cluster(i),  % Comparamos el valor anterior del centro mas cercano.
            cambios=1;
        end;
        cluster(i)=m;
    end;
    
    % Si ha cambiado alguna asignacion recalculamos los centros
    if cambios==1,
        Z=recalcula(cluster, X, Y, k,Z);
    end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Separamos los puntos en k vectores representativos de los k patrones  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Xcluster=0;
Ycluster=0;
for m=1:k
    inedx=0;
    index=find(cluster==m);
    s2=size(index);
    s2=s2(2);
    for n=1:s2
        Xcluster(1,n,m)= X(index(n));
        Ycluster(1,n,m)= Y(index(n));
    end;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Fin del programa principal                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %              Codigo de las subfunciones utilizadas                 %%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Funcion para calcular el centro mas cercano a cada punto  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [m] = cercano(x, y, Z, k)
    dtemp=0;
    d=0;
    for j=1:k
        P=[x y];
        d=distancia(Z(j,:), P); % Distancia del centro al punto.
        if j<2,
            m=j;    % La primera distancia siempre es valida.
            dtemp=d;
        elseif d < dtemp,
            m=j;    % Nos quedamos con el centro al que corresponde 
            dtemp=d;  % la menor de las distancias.
        end;
    end;
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Funcion para reasignar los centros  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Zout1] = recalcula(cluster, X, Y, k, Z) %Realiza la media de los puntos asigandos a cada clase corersp. a los centros
	s=size(X);
	s=s(2);
	valor=zeros(1,k);
	Zout=zeros(k,2);
	for m=1:k
        index=find(cluster==m);
        if isempty(index)==0
            sindex=size(index);
            sindex=sindex(2);  
            Zout1(m,1)=(sum(X(index))) / sindex;
            Zout1(m,2)=(sum(Y(index))) / sindex;        
        else
            Zout1(m,:)=Z(m,:);
        end;
	end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Calcula la distancia entre dos putos  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dist]=distancia(P1, P2)
    dist=sqrt( ((P1(1)-P2(1))^2) + ((P1(2)-P2(2))^2) );% Distancia entre dos puntos.
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Inicializa los centros  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Z]=inicializa_centros(X, Y, k)
    % Distribuye los centros uniformemente
    dx= (max(X))-(min(X));
    dy= (max(Y))-(min(Y));
    dzx= dx/(k+1);    % distancia entre centros coordenada X.
    dzy= dy/(k+1);    % distancia entre centros coordenada Y.
    for i=1:k,
        Z(i,1)=min(X)+(dzx*i);
        Z(i,2)=min(Y)+(dzy*i);
    end;