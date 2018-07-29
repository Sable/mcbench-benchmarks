function varargout = pcircle(center, radius, varargin)
%
% POINTS = PCIRCLE(center, radius, varargin)
% A simple function for drawing a circle pixel by pixel on a given 
% region of interest (roi).
%
% INPUT:
% center:       center of the circle in [x0 y0] format
% radius:       radius of the circle (in pixels)
% varargin:     rectangular ROI defined with:
%               varagin{1} = (x1, y1) and varagin{2} = (x2, y2)
%
% OUTPUT:
% pixels:       list of circle coordinates in the format (x, y)

if nargin == 2
    roi1 = [Inf Inf];
    roi2 = [-Inf -Inf];
elseif nargin == 4
    roi1 = varargin{1};
    roi2 = varargin{2};
else
    error('Invalid number of inputs: type ''help'' PCIRCLE');
end

roil = min(roi1(1),roi2(1));
roir = max(roi1(1),roi2(1));
roib = min(roi1(2),roi2(2));
roiu = max(roi1(2),roi2(2));
x0 = center(1);
y0 = center(2);
nseg = ceil(2*pi*radius);
theta = 0:(2*pi/nseg):(2*pi);
x(:,1) = radius*cos(theta) + x0;
y(:,1) = radius*sin(theta) + y0;
pixels = round([x y]);

% delete repeated pixels
dpixels = abs(diff(pixels(:,1))) + abs(diff(pixels(:,2)));
ind = find(dpixels == 0);
pixels(ind,:) = [];
if (pixels(1,1) == pixels(end,1) & pixels(1,2) == pixels(end,2))
    pixels(end,:) = [];
end
% delete pixels out of the ROI (<=0)
rows = find(pixels(:,1) < roil | pixels(:,1) > roir);
pixels(rows,:) = [];
cols = find(pixels(:,2) < roib | pixels(:,2) > roiu);
pixels(cols,:) = [];

if nargout == 0   % draw circles
%    plot(x0, y0, 'xr', 'LineWidth',2); % also plots the center
    plot(pixels(:,1), pixels(:,2), 'r', 'LineWidth',2);
else
    varargout{1} = pixels;
end

