function draw_points (pnts)
%DRAW_POINTS
% draw points one by one in a new figure
% usages:
%   draw_points(pnts);
% pnts must be a Mx2 double matrix

M = size(pnts, 2);
if (M~=2 || ~isa(pnts,'double')) 
    error('pnts must be a Mx2 double matrix');
end
hfig = figure;
hax = axes('parent', hfig);
plot(pnts(:,1),pnts(:,2),...
    'parent', hax,...
    'linestyle', 'none',...
    'marker', 'o');
axis('square');
set(hfig, 'name', 'example: view user-defined data type');