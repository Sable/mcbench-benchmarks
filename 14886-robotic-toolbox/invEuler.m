

%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

%%Inverse kinematics of the euler frame in closed form
%%input=euler matrix
%%output=rotation angles in degrees as positive values
%%for convetion the returned angles are all positive

function [fi1,theta,fi2]=invEuler(EulerMat)

nx=EulerMat(1,1);
ny=EulerMat(2,1);
nz=EulerMat(3,1);
ox=EulerMat(1,2);
oy=EulerMat(2,2);
oz=EulerMat(3,2);
ax=EulerMat(1,3);
ay=EulerMat(2,3);
az=EulerMat(3,3);
%%Arc tan return two angles here
fi1=atand(ay/ax);
theta=atand((ax*cosd(fi1)+ay*sind(fi1))/az);
if(theta<0)
    theta=theta+180;
end

fi2=atand((-nx*sind(fi1)+ny*cosd(fi1))/(-ox*sind(fi1)+oy*cosd(fi1)));
if(fi2<0)
    fi2=fi2+180;
end

end