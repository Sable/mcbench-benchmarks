%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

function [Rmat]=RotZ(angle)
%%output: rotation matrix along Z axis by an angle expressed in degree
Rmat=[ cosd(angle) -sind(angle) 0 0 
       sind(angle) cosd(angle) 0 0;
       0  0  1 0;
       0 0 0  1];

end