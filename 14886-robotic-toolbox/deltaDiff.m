%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL
%% Function description:
%% input:differential angles deltax,deltay,deltaz
%% differential traslations dx,dy,dz
%% output: differential change in frame T respect to the fixed reference
%% frame
%% delta it's not a trasformation matrix
%% [dT]=[delta]*[T]

function dT=deltaDiff(T,deltax,deltay,deltaz,dx,dy,dz)

delta=[0,-deltaz,deltay,dx;
       deltaz,0,-deltax,dy;
       -deltay,deltax,0,dz;
       0      , 0    ,0 ,0];
   dT=delta*T;

end