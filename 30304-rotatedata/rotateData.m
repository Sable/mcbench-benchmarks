function [xr,yr,xor,yor,theta] = rotateData(x,y,xo,yo,theta,direction)
%[XR,YR,xr,yr,THETA] = rotateData(X,Y,X0,Y0,THETA,DIRECTION)
%
%   Rotate coordinates especified by [X,Y] around the point [X0,Y0], by an
%   angle (in radians) defined by THETA and to the direction especified by
%   DIRECTION.
%
%   THETA is a scalar if the user wishes to define it. THETA can also be
%   calculated based on the slope defined by two points in [X,Y]. If the
%   angle is to be calculated, THETA has to be a two-element vector with
%   the integer indices between which the linear slope in [X,Y] will be
%   calculated. If defined as an output, THETA calculated (or provided) in 
%   the function is also returned.
%
%   DIRECTION should be either 'clockwise' (default) or 'anticlockwise'.
%
%   [XR,YR] are the coordinates rotated relative to the input coordinates'
%   origin. [xr,yr] are the coordinates translated to the origin [XO,YO]
%   used for the rotation.
%
%Rafael Guedes, UoW
%26/11/2010
%

%-- Make sure we have row vectors
x = x(:)';
y = y(:)';

%-- Check out whether direction has been defined
switch nargin
    case 5
        direction = 'clockwise';
end

%-- Calculate theta in case it is not given
if length(theta) > 1
    if round(theta) ~= theta
        error('Indices given in THETA must be integers')
    elseif length(theta) > 2
        error('THETA must be have either 1 or 2 elements')
    end
    i0 = theta(1);
    i1 = theta(2);
    dx = x(i1)-x(i0);
    dy = y(i1)-y(i0);
    theta = atan(dy/dx);
end

%-- Bring vectors to rotation origin
X = x-xo;
Y = y-yo;

%-- Define rotation matrix
switch lower(direction)
    case 'clockwise'
        r = [cos(theta) sin(theta); -sin(theta) cos(theta)];
    case 'anticlockwise'
        r = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    otherwise
        error('DIRECTION must be either ''clockwise'' or ''anticlockwise''')
end

%-- Define outputs
XYr = r*[X;Y];
xor = XYr(1,:);
yor = XYr(2,:);

xr = xor+xo;
yr = yor+yo;

