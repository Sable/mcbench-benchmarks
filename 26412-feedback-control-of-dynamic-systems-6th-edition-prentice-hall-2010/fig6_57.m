% Fig. 6.57   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

numG=1;
denG=[1 1 0];
numD=[0.5 1];
denD=[0.1 1];
num=10*conv(numG,numD);
den=conv(denG,denD);
sysDG=tf(num,den);
rltool(sysDG)
% to see the Bode plot on the right as in Fig. 6.57, click on "view",  
% then "design plots % configuration", 
% then under plot 2, pick OL Bode under "plot type"

% to get Bode magnitude in db, click on "edit", then
% click on "SISO Tool preferences", then pick "db" for magnitude

% to put grids on the plots, right click on the plots, and pick "grid"
