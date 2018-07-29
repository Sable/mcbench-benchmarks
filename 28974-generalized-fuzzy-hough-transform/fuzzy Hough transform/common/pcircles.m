function pcircles(fhdl, center, radius, varargin)
%
% PCIRCLE(fhdl, center, radius, varargin)
% A simple function for drawing a circle on the selected figure using
% polylines.
%
% INPUT:
% fhdl:         figure handler
% center:       center of the circle in [x0 y0] format
% radius:       radius of the circle (in pixels)
% varargin:     colors, plot symbols and line types

format = '-w';  % default
if nargin == 4
    format = varargin{1};
end

x0 = center(1);
y0 = center(2);
nseg = ceil(2*pi*radius);
theta = 0 : (2 * pi / nseg) : (2 * pi);
x = radius * cos(theta) + x0;
y = radius * sin(theta) + y0;

figure(fhdl), hold;
plot(x0, y0, '.r', 'LineWidth',5);
plot(x, y, format);
