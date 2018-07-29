function [Z, Xcluster, Ycluster, A, cluster] = isodata(X, Y, k, L, I, ON, OC, OS, NO, min);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parametros interos de la funcion  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s=size(X);
s=s(2);
cluster=zeros(1,s); % Espacio temporal interno de la funcion.
iter=0;
final=0;
vuelve3=0;
A=1;     % Lo inicializamos para el primer caso.
primeravez=1;   % Para en el primer cilo del while no nos pida la modificacion de parametros.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  1.Inicializacion de los centros  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Z= inicializa_centros(X, Y, A);


%%%%%%%%%%%%%%%%%%%%%%%%
%  Programa principal  %
%%%%%%%%%%%%%%%%%%%%%%%%

while final==0,   %inicio del bucle de iteraciones.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%  2.Establecer los valores de los parametros  %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    if primeravez==0,
		if vuelve3==0,
            [Ltemp, Itemp, ktemp, ONtemp, OCtemp, OStemp]=parametros(L, I, k, ON, OC, OS, iter);
        end;
    end;
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%  3.Calcula y asigna a cada coordenada {X,Y} su centro mas cercano  %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    primeravez=0;
	vuelve3=1;
	for i=1:s,
        cluster(i)=cercano(X(i), Y(i), Z, A);
	end;
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%  4.Eliminar agrupamientos  %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Funcion que nos reduce (si hace falta) el numero de centros y de agrupamientos encontrados.
	[Z, A, cluster]=eliminar(A, cluster, Z, X, Y, ON);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%  5.Actualiza los centros de los agrupamientos  %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Z=recalcula(cluster, X, Y, A, Z);
    
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%  6.Terminar, dividir o mezclar  %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (iter==I),
        final=1;
        next=0;
	else
        next=decide78(iter, k, A);
    end;


	%%%%%%%%%%%%%%%
	%  7.Dividir  %
	%%%%%%%%%%%%%%%
	if next==1,
        next=2;
        hubo_division=0;
        A2=A;
  	    divide=0;
        % Dispersion por agrupamiento, dispersion global
        % Y dispersion por variable y componente de maxima dispersion por orden respectivo.
        [Di, D, STM]= dispersion(X, Y, Z, cluster, A);
	
        % Division / Divide todos los agrupamientos que cumplan la condicion
		i=0;    % Si se cumplen las condiciones realiza una division e itera.                           
		while (hubo_division==0) & (i < A),      % Si para algun...                                     
		    i=i+1;                                                                                      
		    index=find(cluster==i); % Index nos indica los valores del agrupamiento a particionar.      
		    sindex=size(index);                                                                         
		    sindex=sindex(2);                                                                           
		    if  (STM(i)>OS) & (  ((Di(i,1)>D(1)) & (Di(i,2)>D(2)) & (sindex>(2*(ON+1)))) | (A<=(k/2)) ), 
		        hubo_division=1;                                                                        
		        next=1;                                                                                 
		        [Z, cluster]=dividir(STM, A, cluster, Z, i, (A+1), X, Y);    % Division.                 
		        A=A+1;  % Indicamos que hay un nuevo agrupamiento.                                      
		        iter=iter+1;                                                                            
		   end;                                                                                         
		end;                                                                                            

    end;

    
	%%%%%%%%%%%%%%%
	%  8.Mezclar  %
	%%%%%%%%%%%%%%%
	if  next==2,
        %Calcula y ordena las L distancias menores entre los centros.
        [orden, Dij]= distancia_centros(A, Z, OC, L);   %Si orden==0 --> no hay nada para mezclar.
        % Union de agrupamientos.
        if  orden(1) > 0,
            [cluster, Z, A]=union(A, orden, cluster, Z, Dij);
            % Recacula los centros.
            Z=recalcula(cluster, X, Y, A, Z);
        end;
	end;
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%  9.Terminar o volver a iterar  %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if next==2
        [iter,final,vuelve3]= termina_o_itera(iter, I, NO);
    end;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Final del while(bucle principal del programa)  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end;    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Elmina puntos que no cumplan al minima distancia  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:s
    temp=0;
    P=[X(j) Y(j)];
    for i=1:A,
        if distancia(P,Z(i,:)) > min,
            temp=temp+1;
        end;
    end;
    if  temp==A,
        cluster(j)=0;
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
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Dispersion por agrupamietno y dispersion global  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Ditemp, Dtemp, STMAX] = dispersion(X, Y, Z, cluster, A)
    Ditemp=zeros(A,2);
    Dtemp=zeros(1,2);
    ST=zeros(A,2);
    STMAX=zeros(1,A);
    for i=1:A,
        suma=[0 0];
        index=find(cluster==i);
        sindex=size(index);
        for j=index,
            P=[X(j), Y(j)];
            d=distancia(Z(i,:), P  );% Distancia de Xi al centro Zi.
            suma(1)=suma(1) + (d * X(j));   % sumax
            suma(2)=suma(2) + (d * Y(j));   % sumay
        end;
        % Dispersion por agrupamiento
        Ditemp(i,:)=suma / sindex(2);
        % Dispersion global temporal
        Dtemp(1,:)=Dtemp(1,:) + (Ditemp(i,:) * sindex(2));% Sumatorio Ni*Di
        %Dispersion por variable
        ST(i,1)=std(X(index));
        ST(i,2)=std(Y(index));
        % Componente de maxima dispersion
        STMAX(i)=max(ST(i,:));
    end;
    % Dispersion global acabada
    Dtemp(1,:)=Dtemp(1,:) / A;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Reduce el numero de centros y de agrupamientos encontrados  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Ztemp, Atemp, clustertemp]=eliminar(A, cluster, Z, X, Y, ON)
	%Asignacion.
    %desplazamiento: sirve para indicar que centros y agrupaviones hay que
    %eliminar
	desplazamiento=zeros(1,A);  % Sus posibles valores son: -1, (=0) o (>0).
	for i=1:A,                  % Si -1: este grupo se alimina. Si 0: no varia.
        cont=find(cluster==i);  % Si >0: se le restan tantas posiciones como indique su valor.
        scont=size(cont);
        
        if scont(2) < ON
            desplazamiento(i)=-1;
            if  i < A,
                for j=(i+1):A
                    desplazamiento(j)=desplazamiento(j)+1;
                end;
            end;    
        end;
	end;
	%Actuacion.
    [Ztemp, Atemp, clustertemp]=reduce(desplazamiento, A, cluster, Z);
	% Asigna centros a los puntos que queden sueltos de la eliminacion
	% anterior.
    if isempty(Ztemp)==1,  % Por si eliminamos todos los grupos.
        Atemp=1;
        Ztemp(1,1)=median(X);
        Ztemp(1,2)=median(Y);
    end;
	vacio=find(clustertemp==0);
	if  isempty(vacio)==0
        for i=vacio,
            clustertemp(i)=cercano(X(i), Y(i), Ztemp, Atemp);
        end;
	end;
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Une los centros con distancias adecuadas y nos deuelve el  %
%  nuevo valor de el numero de centros y de agrupaciones      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [clustertemp, Ztemp, Atemp]=union(A, orden, cluster, Z, Dij)
    clustertemp=cluster;
    sorden=size(orden);
    unidos=0;
    uindex=0;
    sunidos=size(unidos);
    marca=zeros(1,A);
    imarca=0;
    for i=1:sorden(2),
        yaunido=0;
        temp=[0 0];
        %Miram si qualque dels centre asociats ja ha estat unit.
        [fcnum(1),fcnum(2)]=find(Dij==orden(i)); %   fcnum(1) < fcnum(2)
        for j=1:2,
            if isempty( find(unidos==fcnum(j)) )==0,
                yaunido=1;
            else
                temp(j)=fcnum(j);
            end;
        end;
        
        if yaunido==0
            for h=1:2;  %Guardamos los centros a unir en la lista de centros unidos.
                unindex=uindex+1;
                unidos(unindex)=temp(h);
            end
            marca(fcnum(2))=-1;
            selec=find(clustertemp==fcnum(2));   % Seleccinamos el grupo del centro con numero resp. mas grande y
            clustertemp(selec)=fcnum(1);         % lo unimos al del centro de valor respectivo mas pequeño.
        end;
    end;
    
    adicion=0;  %Colocamos en el vector 'marca' la informacion de la forma que nos interesa.
    for i=1:A
        if  marca(i) >= 0,
            marca(i)=marca(i)+adicion;
        else
            adicion=adicion+1;
        end;
    end;
    % Nos reduce (si hace falta) el numero de centros y de agrupamientos encontrados.
    [Ztemp, Atemp]=reduce(marca, A, clustertemp, Z);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Reduce el numero de centros y grupos  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Ztemp, Atemp, clustertemp]=reduce(desplazamiento, A, cluster, Z)
    Atemp=A;
    clustertemp=cluster;
    Ztemp=find(Atemp==999999);
    
    for i=1:A
        if  (desplazamiento(i) < 0),
            selec=find(cluster==i);
            if isempty(selec)==0
                clustertemp(selec)=0;
            end;
            Atemp=Atemp-1;
        else
            Ztemp( (i-desplazamiento(i)), :)= Z(i,:);
            selec=find(clustertemp==i);
            clustertemp(selec)=clustertemp(selec)-desplazamiento(i);
        end;
    end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Calcula las distancias entre los centros y ordena  %
%  en forma ascendente las L distancias menores       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [orden, Dij]= distancia_centros(A, Z, OC, L)
    Dij=zeros((A-1),A);
    %Calcular las distancias entre centros.
    for i=1:(A-1),
        for j=(1+i):A,
            Dij(i,j)=distancia(Z(i,:), Z(j,:));
        end;
    end;
    
    %Ordenar las L distancias menores que OC. ~
    index= find( (Dij>0) & (Dij<OC) )';
    if (isempty(index))==0,
        orden=sort(Dij(index));
        sorden=size(orden);
        if sorden(2)>L
            orden=orden(1,1:L);
        end;
    else
        orden=0;
    end;

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Divide un agrupamiento  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Ztemp, clustertemp]=dividir(ST, A, cluster, Z, ncentro, Atemp, X, Y)
    clustertemp=cluster;
    Ztemp=Z;
    k2=0.5;          % 0 < k2 < 1
    Yi=ST(ncentro) * k2;
    Ztemp(Atemp,:)=Ztemp(ncentro,:);         % nou centre i agrupament
    m=find( Ztemp(ncentro,:)==max(Ztemp(ncentro,:)) );    % indice de la coordenada mayor.
    Ztemp(ncentro,m)=Ztemp(ncentro,m)+Yi;  % Z+=Z(ncentro)
    Ztemp(Atemp,m)=Ztemp(Atemp,m)-Yi;      % Z-=Z(Atemp)
    % Asignamos cada punto al nuevo centro que tenga mas cercano (Z+ o Z-),
    % por defecto debido a la forma de tratarlo, el centro por defecto es
    % Z+.
    dividendo= find(clustertemp==ncentro);
    for i=(dividendo),
        P=[X(i), Y(i)];
        if  (distancia( P, Ztemp(ncentro,:) )) >= (distancia(P, Ztemp(Atemp,:))),  %d(Z+) >= d(Z-)
            clustertemp(i)=Atemp;
        end;
    end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Calcula la distancia entre dos putos  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dist]= distancia(Z1, Z2)
    dist=sqrt( ((Z1(1)-Z2(1))^2) + ((Z1(2)-Z2(2))^2) );% Distancia entre dos puntos.
    
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
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Funcion para actuaizar o parametros  del algoritmo  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Ltemp, Itemp, ktemp, ONtemp, OCtemp, OStemp]=parametros(L, I, k, ON, OC, OS, iter)
    Ltemp=L; Itemp=I; ktemp=k; ONtemp=ON; OCtemp=OC; OStemp=OS;
    comienza=0;
    while comienza==0,
        preg=find(comienza==9);% Da resultado vacio.
        fprintf('\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n');
        fprintf('Iteracion actual: %d \n',iter);
        fprintf('L=%d, I=%d, k=%d, ON=%d, OC=%d, OS=%d \n',L,I,k,ON,OC,OS);
        fprintf('Que parametro deseas modificar? \n(1: L / 2: I / 3: k / 4: ON / 5: OC / 6: OS / 7: Ninguno) \n');
        while isempty(preg)==1,
            preg=input('Eleccion:');
        end;
        if preg==7
            comienza=1;
        else
            valor=find(comienza==9);% Da resultado vacio.
            while isempty(valor)==1,
                valor=input('Valor:');
            end;
            if preg==1,
                Ltemp=valor;
                elseif preg==2,
                    Itemp=valor;
                    elseif preg==3,
                        Ktemp=valor;
                        elseif preg==4,
                            ONtemp=valor;
                            elseif preg==5,
                                OCtemp=valor;
                                elseif preg==6,
                                    OStemp=valor;
            end;
        end;
    end;

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Decidimos si acabar el programa o volver a iterar cambiando o algun parametro  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [itertemp,FINtemp,vuelve3temp]= termina_o_itera(iter, I, NO)
    itertemp=iter;
    FINtemp=0;
    vuelve3temp=1;
    if itertemp==I,
        FINtemp=1;
    else
        if NO==1
            vuelve3temp=1;    
        else
            preg2=find(iter==0); % Resp. vacia
            fprintf('\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n');
            fprintf('Iteracion actual: %d \n',itertemp);
            while (isempty(preg2)==1) | ( (preg2~=2) & (preg2~=1) ),
                fprintf('Desea modificar algun parametro antes de volver iterar? (SI=1 / NO=2) \n Respuesta:');
                preg2=input('');
            end;
            if preg2==1
                vuelve3temp=0;  % Ve a paso2 (modifica parametros).
            else
                vuelve3temp=1;  % Ve a paso3.
            end;
        end;
        itertemp=itertemp+1;
    end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%  Decide si ir al paso 8 o al 7  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [nexttemp]=decide78(iter, k, A)
    nexttemp=0;
    if A <= (k/2)
        nexttemp=1;     % Va a paso 7.
    end
    if ( (A>=(2*k)) | ( (iter>0) & (((iter+1)/2)>(ceil(iter/2)))) )   % Si a>=2k o la iteracion es par.
        nexttemp=2;     % Va a paso 8.
    end
    if nexttemp==0
        nexttemp=1;
    end;