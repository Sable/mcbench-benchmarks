function [ax1 ax2] = popout(h, xmin, xmax, extraprops)
% POPOUT create popout plot
%   [ax1 ax2] = popout(h, xmin, xmax)
%      creates a popout plot (e.g. outset plot) from axis contained in the
%      figure specfied by handle h, from limits specified by xmin and xmax.
%
%   [ax1 ax2] = popout(h, xmin, xmax, props)
%      creates a popout plot (e.g. outset plot) from axis contained in the
%      figure specfied by handle h, from limits specified by xmin and xmax
%      with axes properties specified by the structure props (see example below).
%
%      popout plot inherits all graphics properties of the axis in figure h 
%      (e.g. linewidth, labels).
%
%      However, extra axes properties (for each axis) may be specfied to override inherited 
%      properties, such as:
%
%      props.axes1.position = [0.1 0.15 0.7 0.8];
%      props.axes2.position = [0.5 0.1 0.4 0.6];
%      props.axes2.fontsize = 20;
%
%      Any valid axis property (fontsize, xtick, yticklabel, etc...) may be 
%      provided for each axis.
%
%
%   example:
%
%       x=0:0.1:100;
%       y = bessel(1,x);
%       plot(x,y);
%       popout(gcf, 10, 20);
%
%   more complex popout plot example (with axes properties):
%
%       x=0:0.1:100;
%       y1 = bessel(1,x);
%       y2 = bessel(1,x)*2;
% 
%       plot(x,y1, x, y2, 'linewidth', 2); grid on;
%       xlabel('time'); ylabel('amplitude');
%       title('Bessel functions');
%       set(gca, 'fontsize', 12, 'linewidth', 2);
%       ylim([-10 2]);
%       
%       props.axes1.position = [0.1 0.15 0.7 0.8];
%       props.axes2.position = [0.5 0.1 0.4 0.6];
%       props.axes1.fontsize = 10;
%       props.axes2.fontsize = 18;
%       props.axes2.linewidth = 2;
%       props.xlabel = 'poput x-label';
%       props.ylabel = 'poput y-label';
% 
%       [ax1 ax2] = popout(gcf, 10, 20, props);
%
%
%       Copyright 2011, Simon Henin <shenin@gc.cuny.edu>

if nargin < 4,
   extraprops.axes1.position = [0.1 0.55 0.65 0.35]; 
   extraprops.axes2.position = [0.3 0.1 0.6 0.55]; 
end

type = get(h, 'Type');
if strcmp(type, 'figure'),
    ax1 = get(h, 'children');
else
    ax1 = h;
end
padding = 10;

ax2 = copyobj(ax1, h);
set(ax2, 'position', extraprops.axes2.position);


children = get(ax1, 'children');
ylimit = get(ax1, 'Ylim');
set(ax1, 'position',extraprops.axes1.position);
ylim([ylimit(1)+ylimit(1)*(padding/100) ylimit(2)+ylimit(2)*(padding/100)]);

ymax = 0;
ymin = 0;
for i=1:length(children),
    xd = get(children(i), 'xdata');
    index = find(xd >= xmin & xd <= xmax);
    yd =  get(children(i), 'ydata');
    ymax = max(ymax, max(yd(index)));
    ymin = min(ymin, min(yd(index)));
end

axes(ax1);
rectangle('Position',[xmin,ymin,xmax-xmin,ymax-ymin], 'linewidth', 2);

axes(ax2);
title('');
xlim([xmin xmax]);
ylim([ymin ymax]);

% add special pop-out properties
if isfield(extraprops, 'xlabel'),
   xlabel(extraprops.xlabel); 
end
if isfield(extraprops, 'ylabel'),
   ylabel(extraprops.ylabel); 
end

% add axes properties
fields = fieldnames(extraprops.axes1);
for i=1:length(fields),
   set(ax1, fields{i}, getfield(extraprops.axes1, fields{i})); 
end
fields = fieldnames(extraprops.axes2);
for i=1:length(fields),
   set(ax2, fields{i}, getfield(extraprops.axes2, fields{i})); 
end

% add pop-out lines
[xf1 yf1] = popout_getcoords(ax1, xmin, ymin);
[xf2 yf2] = popout_getcoords(ax2, xmin, ymin);
annotation('line',[xf1 xf2],[yf1 yf2]);

[xf1 yf1] = popout_getcoords(ax1, xmin, ymax);
[xf2 yf2] = popout_getcoords(ax2, xmin, ymax);
annotation('line',[xf1 xf2],[yf1 yf2]);

[xf1 yf1] = popout_getcoords(ax1, xmax, ymin);
[xf2 yf2] = popout_getcoords(ax2, xmax, ymin);
annotation('line',[xf1 xf2],[yf1 yf2]);

[xf1 yf1] = popout_getcoords(ax1, xmax, ymax);
[xf2 yf2] = popout_getcoords(ax2, xmax, ymax);
annotation('line',[xf1 xf2],[yf1 yf2]);

axes(ax2);


function [x y] = popout_getcoords(ax, x, y)


%% Get limits
axun = get(ax,'Units');
set(ax,'Units','normalized');
axpos = get(ax,'Position');
axlim = axis(ax);
axwidth = diff(axlim(1:2));
axheight = diff(axlim(3:4));


x = (x-axlim(1))*axpos(3)/axwidth + axpos(1);
y = (y-axlim(3))*axpos(4)/axheight + axpos(2);


%% Restore axes units
set(ax,'Units',axun)