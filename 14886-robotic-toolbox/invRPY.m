%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

%%Inverse kinematics of the RPY frame in closed form
%%input=RPY matrix
%%output=rotation angles in degrees as positive values
%%for convetion the returned angles are all positive

function [fia,fio,fin]=invRPY(RPYmat)

nx=RPYmat(1,1);
ny=RPYmat(2,1);
nz=RPYmat(3,1);
ox=RPYmat(1,2);
oy=RPYmat(2,2);
oz=RPYmat(3,2);
ax=RPYmat(1,3);
ay=RPYmat(2,3);
az=RPYmat(3,3);
%%Arc tan return two angles here
fia=atand(ny/nx);
fio=atand(-nz/(nx*cosd(fia)+ny*sind(fia)));
if(fio<0)
    fio=fio+180;
end

fin=atand((-ay*cosd(fia)+ax*sind(fia))/(oy*cosd(fia)-ox*sind(fia)));
if(fin<0)
    fin=fin+180;
end

end