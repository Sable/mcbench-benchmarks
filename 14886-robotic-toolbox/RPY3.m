%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

%%Transformation of the end effector frame following the RPY angles
%%as a 3 rotation transformation along z,y,x axis
%%input: rotation angles along y,z,x axis expressed in degrees

function [RPYmat]=RPY3(fia,fio,fin)

RPYmat=RotZ(fia)*RotY(fio)*RotX(fin);
    

end