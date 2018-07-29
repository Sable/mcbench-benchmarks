%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

%%Transformation of the end effector frame following the RPY angles in
%%closed form
%%input: rotation angles along y,z,x axis expressed in degrees

function [RPYmat]=RPY(fia,fio,fin)

RPYmat=[cosd(fia)*cosd(fio),cosd(fia)*sind(fin)*sind(fio)-sind(fia)*cosd(fin),cosd(fia)*sind(fio)*cosd(fin)+sind(fia)*sind(fin),0;
        sind(fia)*cosd(fio),sind(fia)*sind(fio)*sind(fin)+cosd(fia)*cosd(fin),sind(fia)*sind(fio)*cosd(fin)-cosd(fia)*sind(fin),0;
        -sind(fio),cosd(fio)*sind(fin),cosd(fio)*cosd(fin),0;
        0,0,0,1];
    

end