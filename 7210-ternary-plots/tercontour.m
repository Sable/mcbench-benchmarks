function [h,c,hcb]=tercontour(c1,c2,c3,d,values)
%FUNCTION [HG,HTICK,HCB]=TERCONTOUR(C1,C2,C3,D,VALUES) plots the values in the 
% vector d as a contour plot in a ternary diagram.
% The three vectors c1,c2,c3 define the position of a data value within the
% ternary diagram.
% The values to be contoured can be specified in the optional vector VALUES
% (as in Matlab's own contour function).
% The ternary axis system is created within the function.
% Axis label can be added using the terlabel function.
% The function returns three handels: hg can be used to modify the grid lines,
% htick must be used to access the tick label properties, and hcb is the handle
% for the colorbar.
%
% Uli Theune, Geophysics, University of Alberta
% 2002 - ...
%

if nargin < 4
    error('Error: Not enough input arguments.');
    return
end
if (length(c1)+length(c2)+length(c3))/length(c1) ~=3
    error('Error: all arrays must be of equal length.');
    return
end

if nargin == 4
    c='r';
end

if max(c1+c2+c3)>1
    for i=1:length(c1)
        c1(i)=c1(i)/(c1(i)+c2(i)+c3(i));
        c2(i)=c2(i)/(c1(i)+c2(i)+c3(i));
        c3(i)=c3(i)/(c1(i)+c2(i)+c3(i));
    end
end

hold on
x=0.5-c1*cos(pi/3)+c2/2;
y=0.866-c1*sin(pi/3)-c2*cot(pi/6)/2;
% Create short vectors for the griding
xg=linspace(0,1,25);
yg=linspace(0,0.866,25);
[X,Y]=meshgrid(xg,yg);
clear xg yg;
Z=griddata(x,y,d,X,Y);
if nargin==4
    [c,h]=contour(X,Y,Z);
else
    [c,h]=contour(X,Y,Z,values);
end
% clabel(c,h)
% set(h,'linewidth',2)
hold off
axis image
caxis([min(d) max(d)])
hcb=colorbar;
