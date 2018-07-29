%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

clf
clear
%%Cartesian manipulator with an RPY wrist
px=2.3;
py=1.7;
pz=7.4;

fia=32;
fio=178;
fin=4;
Tcartesian=Tras(px,py,pz);
Torient=RPY(fia,fio,fin);

%%The trasformation matrix is:
Tend=Tcartesian*Torient;
figure(1);
plot3(0,0,0,'r');
plotT(Tend);
title('Cartesian manipulator example');
%%Cylindrical manipulator with an Euler wrist
Tcyl=Tcyl(62,8.2,5.2)*Euler(32,15,17);
figure(2);
plot3(0,0,0,'r');
plotT(Tcyl);
title('Cylindrical manipulator example');
%%Spherical maninupaltor with an Euler an RPY wrist
Tsfer=Tsfer(40,50,10)*RPY(10,0,10);
figure(3);
plot3(0,0,0,'r');
plotT(Tsfer);
title('Spherical manipulator example');

%%Invert the Euler transformation
euwrist=Euler(32,15,17);
[fi1,fio,fi2]=invEuler(euwrist);
fprintf('Invers euler angles %d %d %d \n',fi1,fio,fi2);
rpywrist=RPY(5,10,15);
[fia,fio,fin]=invRPY(rpywrist);
fprintf('Invers rpy angles %d %d %d \n',fia,fio,fin);