function varargout = pline(p1, p2, varargin)
%
% POINTS = PLINE(p1, p2, varargin)
% This is a simple function for drawing a line pixel by pixel on a given 
% region of interest (roi).
%
% INPUT:
% p1, p2:       points in the format [x1, y1], [x2, y2] that define the 
%               line.
% varargin:     rectangular ROI defined by two points in the format:
%               varagin{1} = [x1, y1] and varagin{2} = [x2, y2]
% OUTPUT:
% slope:    slope for the detected line in the its parametric expression
%           y = slope*x + intercept. It is computed in varargout{1};
% inter:    intercept point in the y-axis for the detected line in its
%           parametric expression y = slope*x + intercept. It is computed 
%           in varargout{2};
% pixels:
%
% EXAMPLES:
%           I = imload('frogs.bmp');
%           roi_tl = [0 0];
%           roi_br = [size(I,2) size(I,1)];
%           points = pline([52 44; 86 123], roi_tl, roi_br);

if nargin == 2
    roi1 = [Inf Inf];
    roi2 = [-Inf -Inf];
elseif nargin == 4
    roi1 = varargin{1};
    roi2 = varargin{2};
else
    error('Invalid number of inputs: type ''help'' PLINE');
end
x = [];
y = [];

% line equation: y = slope*x + inter;
% slope-intercept parametres
roil = min(roi1(1),roi2(1));
roir = max(roi1(1),roi2(1));
roib = min(roi1(2),roi2(2));
roiu = max(roi1(2),roi2(2));
slope = (p2(1)*p2(2)-p2(1)*p1(2))/(p2(1)^2-p1(1)*p2(1));
inter = (p2(1)*p1(2)-p1(1)*p2(2))/(p2(1)-p1(1));
if isinf(slope)
    y(:,1) = roib:roiu;
    x = p1(1)*ones(size(y));
else
    x1(:,1) = roil:roir;
    y1(:,1) = slope*x1 + inter;
    y2(:,1) = roib:roiu;
    x2(:,1) = (y2 - inter)/slope;
    x = [x1; x2];
    y = [y1; y2];
end
pixels = sortrows(round([x y]), 1);

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

if nargout == 0   % draw lines
    plot(pixels(:,1), pixels(:,2), 'r', 'LineWidth',2);
%    plot([x(1) x(end)], [y(1) y(end)], format, 'LineWidth', 2);
else
    varargout{1} = slope;
    varargout{2} = inter;
    varargout{3} = pixels;
end

 