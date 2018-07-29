clear, close all
        % Determinarea numarului de noduri pe unitatea de lungime       
nrnod=50;
        % Generarea unei retele pe domeniul considerat
[x,y]=meshgrid(0:1/(nrnod-1):2);
        % Determinarea numarului de noduri pe o linoe
N=length(x);
        % Initializarea matricelor V si Vp
V=zeros(N); Vp=V;
        % Fixarea erorii maxime impuse
erormax=0.0001;
        % Initializarea contorului de cicluri
nrp=1;
        % Ciclul repetitiv de calcul al potentialului
while nrp<3 | abs(max(max(V(2:N-1,2:N-1)-...
        Vp(2:N-1,2:N-1))))>erormax
        % - memorarea valorilor de la iteratia precedenta
    Vp=V;
        % - recalcularea potentialului in nodurile considerate
    V=V+del2(V);
	    % - impunerea conditiilor de frontiera
    V(N,:)=0; V(:,1)=0; V(:,N)=0; V(1,:)=1;
        % - incremenatarea contorului de cicluri
	nrp=nrp+1;
end;
        % Reprezentarea liniilor echipotentiale selectate
[c,h]=contour(x,y,V,[1,0.8,0.4,0.25,0.005]);
        % Etichetarea liniilor echipotentiale
clabel(c,h)
        % Setarea axelor patrate si personalizarea graficii
axis square
grid
xlabel('x')
ylabel('y')