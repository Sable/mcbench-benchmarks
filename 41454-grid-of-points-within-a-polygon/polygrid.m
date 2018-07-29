%inPoints = getPolygonGrid(xv,yv,ppa) returns points that are within a 
%concave or convex polygon using the inpolygon function.

%xv and yv are columns representing the vertices of the polygon, as used in
%the Matlab function inpolygon

%ppa refers to the points per unit area you would like inside the polygon. 
%Here unit area refers to a 1.0 X 1.0 square in the axes. 

%Example: 
% L = linspace(0,2.*pi,6); xv = cos(L)';yv = sin(L)'; %from the inpolygon documentation
% inPoints = getPolygonGrid(xv, yv, 10^5)
% plot(inPoints(:, 1),inPoints(:,2), '.k');

function [inPoints] = polygrid( xv, yv, ppa)

	N = sqrt(ppa);
%Find the bounding rectangle
	lower_x = min(xv);
	higher_x = max(xv);

	lower_y = min(yv);
	higher_y = max(yv);
%Create a grid of points within the bounding rectangle
	inc_x = 1/N;
	inc_y = 1/N;
	
	interval_x = lower_x:inc_x:higher_x;
	interval_y = lower_y:inc_y:higher_y;
	[bigGridX, bigGridY] = meshgrid(interval_x, interval_y);
	
%Filter grid to get only points in polygon
	in = inpolygon(bigGridX(:), bigGridY(:), xv, yv);
%Return the co-ordinates of the points that are in the polygon
	inPoints = [bigGridX(in), bigGridY(in)];

end

