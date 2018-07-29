function hierarchicalBoxplot(x,grp,separatorlines,color)
%HIERARCHICALBOXPLOT Boxplot showing grouping variable hierarchy
%   HIERARCHICALBOXPLOT(X,GRP) creates a boxplot of the data in X, grouped
%   according to the grouping variables represented by the columns of GRP.
%   The groupings are shown hierarchically, with the groups in each column
%   of GRP being shown as groups within the groups of the next column.
%
%   HIERARCHICALBOXPLOT(X,GRP,SEPLINES,COLOR) adds COLOR-colored separator
%   lines between the grouping levels specified by the vector SEPLINES.
%   See the 'factorseparator' option of BOXPLOT for details on how to
%   specify separator lines.  By default, SEPLINES is 2:n (where n is the
%   number of different grouping levels), so lines are shown between all
%   but the lowest level of the hierarchy.  COLOR can be specified using
%   any standard MATLAB color specification.  By default, COLOR is mid-gray
%   (RGB = [0.5 0.5 0.5]).  COLOR-colored boxes are also drawn around the
%   text labels.
%
%   Note: BOXPLOT readjusts the label positions whenever the figure is
%   resized (including docking/undocking).  HIERARCHICALBOXPLOT does *not*.
%   Too much resizing may cause strange-looking label positions.
%
%   See also: BOXPLOT
%
%   Examples:
%   x = randn(400,1);
%   y1 = nominal(randi(2,400,1),{'Yes','No'});
%   y2 = nominal(randi(3,400,1),{'X','Y','Z'});
%   y3 = nominal(randi(2,400,1),{'Hello','Goodbye'});
%   y = [y1,y2,y3];
%   hierarchicalBoxplot(x,y)
%
%   load carsmall
%   origin = cellstr(Origin);
%   idx = ismember(origin,{'Germany','Japan','USA'});
%   hierarchicalBoxplot(MPG(idx),{Model_Year(idx),origin(idx)})

% Copyright 2013 The MathWorks, Inc.
% Written by Matt Tearle
% Last updated March 2013

% Check inputs and set defaults
if nargin<2
    error('Function requires at least two inputs')
elseif nargin<4
    % default color = mid-grey
    color = 0.5*[1,1,1];
end

% Number of grouping variables (ie columns of grp)
n = size(grp,2);
if (nargin<3)
    separatorlines = 2:n;
end
% Number of groups within each grouping variable
numgrps = zeros(1,n);
if iscell(grp)
    for k = 1:n
        numgrps(k) = numel(unique(grp{k}));
    end
else
    for k = 1:n
        numgrps(k) = numel(unique(grp(:,k)));
    end
end
% The total number of grouping combinations at each level
numgrps = cumprod(numgrps);
% The total number of grouping combinations overall
N = numgrps(n);

% Make a boxplot
% The grouping ordering seems backwards to me, so I'm flipping it
% Start with all separators (and remove some later, as needed)
boxplot(x,fliplr(grp),...
    'plotstyle','compact','labelorientation','horizontal',...
    'factorseparator',1:n);

% Find some needed graphics handles
hbxplt = get(gca,'children');   % the boxplot group
hall = get(hbxplt,'children');  % the individual components
halltype = get(hall,'type');    % the types of the components
hsepln = hall(end-n+1:end);     % the separator lines

htxt = hall(strcmpi('text',halltype));  % the text labels
if length(htxt) ~= (N*n)
    delete(gcf)
    error('Some of the group combinations had no data and hierarchicalBoxplot can''t cope with that.  Sorry!')
end
% Reorder the text labels (flip vertically)
set(htxt,'units','data')
txtpos = get(htxt,'position');  % get the current positions
txtpos = cat(1,txtpos{:});      % extract to matrix, rather than cell array
txtpos(:,2) = flipud(txtpos(:,2));  % flip the vertical positions

% Center the text labels horizontally within groups
xtxt = reshape(txtpos(:,1),N,n);    % Get the current locations
% Recalculate locations by averaging groups
for k = 2:n
    m = numgrps(k-1);
    for j = 1:N
        ii = floor((j-1)/m);
        i1 = 1 + m*ii;
        i2 = m*(1+ii);
        xtxt(j,k) = mean(xtxt(i1:i2,1));
    end
end
% Update position with new x locations
txtpos(:,1) = xtxt(:);
for k = 1:length(htxt)
    set(htxt(k),'position',txtpos(k,:))
end

% Draw boxes around the text labels
% Fake it using line segments
% Note that positions of the text labels are in axis (data) units
txtpos = get(htxt,'extent');
txtpos = cat(1,txtpos{:});
xl = xlim;
yl = ylim;
y1 = min(yl);           % Top of the labels is the bottom of the axes
y2 = min(txtpos(:,2));  % Get the bottom of each row of text labels
y = linspace(y1,y2,n+1);    % y locations for the boxes
% Draw horizontal lines
for k = 2:(n+1)
    line(xl,[y(k),y(k)],'parent',gca,'clipping','off','color',color)
end
% Draw vertical lines on the ends
line(xl(1)*[1,1],[y1,y2],'parent',gca,'clipping','off','color',color)
line(xl(2)*[1,1],[y1,y2],'parent',gca,'clipping','off','color',color)
% Draw the various vertical lines,
% using the positions of the preexisting separator lines
for j = 1:n
    newy = get(hsepln(j),'YData');
    newy(newy==yl(2)) = y(j+1);
    line(get(hsepln(j),'XData'),newy,'parent',gca,'clipping','off','color',color)
end
% Make the separator lines the same color as the label boxes
set(hsepln,'color',color)

% Delete the separator lines not specified by the user (or default)
delete(hsepln(setdiff(1:n,separatorlines)))

% Turn off the listener that repositions the text labels whenever the
% figure is resized
appd = getappdata(hbxplt,'boxlisteners');
for j=1:numel(appd)
    listj = appd{j};
    if isa(listj,'handle.listener') || isa(listj,'property.listener')
        delete(listj)
    end
end
