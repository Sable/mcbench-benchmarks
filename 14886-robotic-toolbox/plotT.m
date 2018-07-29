%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

%%input: transformation matrix of a point
%%output: a figure representing position and orientation of the point

function plotT(T)

nx=T(1,1);
ny=T(2,1);
nz=T(3,1);
ox=T(1,2);
oy=T(2,2);
oz=T(3,2);
ax=T(1,3);
ay=T(2,3);
az=T(3,3);
px=T(1,4);
py=T(2,4);
pz=T(3,4);
hold on
grid on
%%plot a dot as the position
plot3(px,py,pz,'ro');
xlabel('x');
ylabel('y');
zlabel('z');
%%plot 
line([px,px+nx],[py,py+ny],[pz,pz+nz],'LineWidth',2,'Color','red','Tag','n');
line([px,px+ox],[py,py+oy],[pz,pz+oz],'LineWidth',2,'Color','blue','Tag','o');
line([px,px+ax],[py,py+ay],[pz,pz+az],'LineWidth',2,'Color','black','Tag','a');
title('T position and orientation');
hold off
end