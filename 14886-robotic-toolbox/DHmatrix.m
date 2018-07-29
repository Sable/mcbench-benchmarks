%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

function [Mdh]=DHmatrix(theta,d,a,alpha)
%%output: DH matrix
%%input: DH parameters:
%%theta: rotation along x(n) axis
%%d: traslation along z(n) axis
%%a: translation along x(n+1) axis
%%alpha: rotation along x(n+1) axis
%%all angles expressed in degrees

Mdh=[cosd(theta) -sind(theta)*cosd(alpha) sind(theta)*sind(alpha) a*cosd(theta);
     sind(theta) cosd(theta)*cosd(alpha)  -cosd(theta)*sind(alpha) a*sind(theta);
     0,sind(alpha),cosd(alpha),d;
     0,0,0,1];


end