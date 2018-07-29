%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

%%Function description:
%%Transformation of the end effector frame following the Euler angles
%%in closed form
%%input: rotation angles along y,z,y axis expressed in degrees

function [EulerMat]=Euler(fi1,theta,fi2)

EulerMat=[cosd(fi1)*cosd(theta)*cosd(fi2)-sind(fi1)*sind(fi2),-cosd(fi1)*cosd(theta)*sind(fi2)-sind(fi1)*cosd(fi2),cosd(fi1)*sind(theta),0;
        sind(fi1)*cosd(theta)*cosd(fi2)+cosd(fi1)*sind(fi2),-sind(fi1)*cosd(theta)*sind(fi2)+cosd(fi1)*cosd(fi2),sind(fi1)*sind(theta),0;
        -sind(theta)*cosd(fi2),sind(theta)*sind(fi2),cosd(theta),0;
        0                      ,0                   ,0          ,1;];
    
    

end