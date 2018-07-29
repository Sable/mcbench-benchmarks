clear all
close all
clc
load('\dades.mat')
k=4;

%%%%%%%%%%%%%%%%%%%%%
%  Funcion k-means  %
%%%%%%%%%%%%%%%%%%%%%
[centro, Xcluster, Ycluster, clustering]=kmedia(X, Y, k);

% Presentacion de resultados por pantalla.

% Creamos los colores.
colr=zeros(k,3);
for i=1:k
    colr(i,:)=rand(1,3);
end;

% Representamosla informacion.
figure;
hold on;
for i=1:k,
    n=find(clustering==i);
    p=plot(X(n), Y(n),'.');set(p,'Color',colr(i,:));title(k)
end;

clc;
fprintf('Numero de agrupaciones: %d',A);
% Borramos variables temporales.
clc;clear n;clear i;clear p;clear colr;