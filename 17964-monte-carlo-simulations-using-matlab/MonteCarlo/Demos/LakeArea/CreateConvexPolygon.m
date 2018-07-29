function [xpoly, ypoly , h] = CreateConvexPolygon(ContainingSquareWidth,NbPointsMax)
h = figure;

rectangle('Position',[0,0,ContainingSquareWidth,ContainingSquareWidth]);
rand('twister',0);
Points = ContainingSquareWidth * rand(NbPointsMax,2);
K = convhull(Points(:,1),Points(:,2));

xpoly = Points(K,1);
ypoly = Points(K,2);
hold on;

plot(xpoly,ypoly,'-r','LineWidth',2);
