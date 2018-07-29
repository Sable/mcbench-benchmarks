%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

%%output: rotation matrix along X axis by an angle expressed in degree
function [Rmat]=RotX(angle)

Rmat=[1 0 0 0;
      0 cosd(angle) -sind(angle) 0;
      0 sind(angle) cosd(angle) 0;
      0 0 0 1];

end