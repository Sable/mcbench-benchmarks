%BCSFRONTIER BlueChipStock rolling efficient frontiers

addpath ./source

load BlueChipBacktest0
load BlueChipBacktest

% Plot 3D efficient frontiers

figure(1);
surf(X0,Y0,Z0,'FaceColor','interp','EdgeColor','none','FaceLighting','phong');
ylabel('\bfStd.Dev. of Returns');
zlabel('\bfMean of Returns');
title('\bfRolling Efficient Frontiers (Absolute Total Return)');
camlight right;
view(30,30);

i = input('Continue >');

figure(1);
surf(X,Y,Z,'FaceColor','interp','EdgeColor','none','FaceLighting','phong');
ylabel('\bfStd.Dev. of Returns');
zlabel('\bfMean of Returns');
title('\bfRolling Efficient Frontiers (Relative Total Return vs DJIA)');
camlight right;
view(30,30);
