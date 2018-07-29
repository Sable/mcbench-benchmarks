clear all
close all
clc
load('\dades.mat')
ON=15;  %Umbral del número de elementos para la eliminación de un agrupamiento. 
OC=10;  %Umbral de distancia para la unión de agrupamientos.
OS=7;  %Umbral de desviación típica para la división de un agrupamiento.
k=4;   %Número (máximo) de agrupamientos.
L=2;   %Máximo número de agrupamientos que pueden mezclarse en una sola iteración.
I=10;  %Máximo número de iteraciones permitidas.
NO=1;  %Parametro extra para responder automaticamente que no a la peticion de cambial algun parametro.
min=50; %Minima distancia que un punto debe de estar de cada centro. Si no deseas eliminar ningun punto
        % dale un valor elevado.
%%%%%%%%%%%%%%%%%%%%%
%  Funcion ISODATA  %
%%%%%%%%%%%%%%%%%%%%%
[centro, Xcluster, Ycluster, A, clustering]=isodata(X, Y, k, L, I, ON, OC, OS, NO, min);
clc;
fprintf('Numero de agrupaciones: %d',A);

% Presentacion de resultados por pantalla.

% Creamos los colores.
colr=zeros(A,3);
for i=1:A
    colr(i,:)=rand(1,3);
end;

% Representamos la informacion.
figure;
hold on;
for i=1:A,
    n=find(clustering==i);
    p=plot(X(n), Y(n),'.');set(p,'Color',colr(i,:));title(A)
end;

%plot(centro(:,1), centro(:,2), 'g.');

clc;
fprintf('Numero de agrupaciones: %d',A);
% Borramos variables temporales.
clear n;clear i;clear p;clear colr;clear NO;