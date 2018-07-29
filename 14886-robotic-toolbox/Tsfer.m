%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL



function Tmat=Tsfer(gamma,beta,r)
%%Transformation in spherical coordinates
%%input: alfa angle along z axis, beta angle along y axis, r trasl along z
%%along z axis
%%output: trasformation matrix
Tmat=RotZ(gamma)*RotY(beta)*Tras(0,0,r);

end