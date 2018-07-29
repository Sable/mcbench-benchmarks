
%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

%%Transformation of the end effector frame following the Euler angles in
%%closed form
%%input: rotation angles along y,z,y axis expressed in degrees
function [EulerMat]=Euler3(fi1,theta,fi2)

EulerMat=RotZ(fi1)*RotY(theta)*RotZ(fi2);

end