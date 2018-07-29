function h = ang(centre,radius,span,style)
% ANG
% Plots an angle arc with specified position and circumference.
% Example:
%                 ang([3 2],5,[0 pi/2],'k-')
% Plots an arc with centre (3,2) and radius (5) that represents
% The angle specified from 0 to pi/2, and with the preferred style 'k-'.
% Draws heavily from Zhenhai Wang's circle function on the File Exchange.
%
% Husam Aldahiyat, October, 2008.

theta = linspace(span(1),span(2),100);
rho = ones(1,100) * radius;
[x,y] = pol2cart(theta,rho);
x = x + centre(1);
y = y + centre(2);
h = plot(x,y,style);
end