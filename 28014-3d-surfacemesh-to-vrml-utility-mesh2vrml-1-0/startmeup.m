clear all;
close all;
a=linspace(-10, 10, 100);
[X, Y]=meshgrid(a,a);
%[X, Y, Z]=peaks(100); %Hills and valleys
Z=X.^2+Y.^2; %Parabolic
%Z=sin(X).* cos(Y); % Waves
file=mesh2vrml(X,Y,Z);