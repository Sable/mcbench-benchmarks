%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

%%output: rotation matrix along Y axis by an angle expressed in degree
function [Rmat]=RotY(angle)

Rmat=[cosd(angle) 0 sind(angle) 0; 
       0  1 0 0;
       -sind(angle) 0 cosd(angle) 0;
       0 0 0 1];

end