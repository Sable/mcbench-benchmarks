function TestPolyGon(Method)
%% Create a Random Polygon
maxsize = 100;
NbMaxPoints = 8;
[xpoly, ypoly , h] =CreateConvexPolygon(maxsize,NbMaxPoints);
Area= EstimateAreaMC(xpoly,ypoly,maxsize,2500, Method,true)