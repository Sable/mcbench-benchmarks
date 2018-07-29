function [xo yo R] = circle_fit(x,y)
% A function to find the best circle fit (radius and center location) to
% given x,y pairs
% 
% Val Schmidt
% Center for Coastal and Ocean Mapping
% University of New Hampshire
% 2012
% 
% Arguments:
% x:         x coordinates
% y:         y coordinates
%
% Output:
% xo:        circle x coordinate center
% yo:        circle y coordinate center
% R:         circle radius

x = x(:);
y = y(:);

% Fitting a circle to the data - least squares style. 
%Here we start with
% (x-xo).^2 + (y-yo).^2 = R.^2
% Rewrite:
% x.^2 -2 x xo + xo^2 + y.^2 -2 y yo + yo.^2 = R.^2
% Put in matrix form:
% [-2x -2y 1 ] [xo yo -R^2+xo^2+yo^2]' = -(x.^2 + y.^2)
% Solve in least squares way...
A = [-2*x -2*y ones(length(x),1)];
x = A\-(x.^2+y.^2);
xo=x(1);
yo=x(2);
R = sqrt(  xo.^2 + yo.^2  - x(3));
