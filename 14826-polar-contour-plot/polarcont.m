% POLARCONT Polar contour plot
%
% Richard Rieber
% rrieber@gmail.com
% April 4, 2007
% Updated June 15, 2007
% 
% function [C,h] = polarcont(r,theta,z,N,s)
%
% Purpose: This function creates polar contour plots on the current active
%          figure
% 
% Inputs:  o r     - Radius vector of length m
%          o theta - Angle vector in radians of length n
%          o z     - Magnitude at the points specified in r and theta of
%                    size m x n
%          o N     - The number of contours to plot [OPTIONAL]
%          o s     - Linespec as described in PLOT [OPTIONAL]
%
% Outputs: o C     - returns contour matrix C as described in CONTOURC
%          o h     - Column vector H of handles to LINE or PATCH objects,
%                    one handle per line.  
%
% OTHER NOTES:
% - Both C and h can be used as inputs to CLABEL
% - Colors are defined in colormap
% - Treat this function as a standard contour plot

function [C,h] = polarcont(r,theta,z,N,s)

[a,b] = size(z);

if a ~= length(r)
    error('r is not the same length as the first dimension of z')
end

if b ~= length(theta)
    error('theta is not the same length as the second dimension of z')
end

x = zeros(a,b);
y = zeros(a,b);

for j = 1:a
    for k = 1:b
        x(j,k) = r(j)*cos(theta(k));
        y(j,k) = r(j)*sin(theta(k));
    end
end

if nargin == 3
    [C,h] = contour(x,y,z);
elseif nargin == 4
    [C,h] = contour(x,y,z,N);
elseif nargin == 5
    [C,h] = contour(x,y,z,N,s);
else
    error('Incorrect number of inputs')
end