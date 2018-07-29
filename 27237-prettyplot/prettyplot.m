%PRETTYPLOT   Prettier linear plot. 
%   PRETTYPLOT works just like PLOT, but avoids the line and markers
%   being on top of each other. Instead, the line joins the markers
%   without touching them.
%
%   See HELP PLOT for more information on the syntax. The only
%   difference is that PRETTYPLOT turns on markers by default.
%
%   Do add all of the desired line properties to the PRETTYPLOT
%   command, rather than trying to change the properties later, as
%   that might not work as expected. The same applies to the size
%   of the figure and the axis limits.
%
%   PRETTYPLOT returns two handles for each line plotted. Even indices
%   in the handle list correspond to the markers, odd ones to the
%   lines.
%
%   Example
%      figure('position',[200,200,800,600])
%      hold on
%      set(gca,'xlim',[-3.2,3.2],'ylim',[-3,3])
%      x = -pi:pi/10:pi;
%      y = tan(sin(x)) - sin(tan(x));
%      h = prettyplot(x,y,'-+b',x,2*cos(x),'-xr','LineWidth',2,'MarkerSize',8);
%      h = [h;prettyplot(x,randn(size(x)),'-o','LineWidth',1,'MarkerSize',6,'color',[0,0.8,0])];
%      legend(h(1:2:end),'demo','cos','randn');
%
%   See also PLOT.

% (C) Copyright 2010, All rights reserved.
% Cris Luengo, Uppsala, 13 April 2010.

function h = prettyplot(varargin);
sep = 0.5;   % How much separation between the marker and the line
thin = 0.75; % How thin the connecting lines are compared to the marker lines
h = plot(varargin{:});
set(h,'LineSmoothing','on');
ax = get(h(1),'parent');
h2 = copyobj(h,ax);
set(h,'linestyle','none');
m = strcmp(get(h,'marker'),'none');
if any(m)
   set(h(m),'marker','o');
end
set(h2,'marker','none');
m = strcmp(get(h2,'linestyle'),'none');
if any(m)
   set(h2(m),'linestyle','-');
end
u = get(ax,'units');
set(ax,'units','pixels');
asp = get(ax,'position');
set(ax,'units',u);
asp = asp(3:4);
asu = [diff(get(ax,'xlim')),diff(get(ax,'ylim'))];
pxpu = asp./asu;
for ii=1:length(h)
   msz = (0.5+sep) * get(h(ii),'markersize');
   x = get(h2(ii),'xdata') * pxpu(1);
   y = get(h2(ii),'ydata') * pxpu(2); % we do the calculations in pixel units for convenience.
   x2 = [x(1:end-1);x(2:end)];
   y2 = [y(1:end-1);y(2:end)];
   dx = diff(x2);
   dy = diff(y2);
   d = sqrt(dx.^2+dy.^2);
   ix = msz.*(dx./d);
   iy = msz.*(dy./d);
   x2(1,:) = x2(1,:)+ix;
   x2(2,:) = x2(2,:)-ix;
   x2(3,:) = nan;
   y2(1,:) = y2(1,:)+iy;
   y2(2,:) = y2(2,:)-iy;
   y2(3,:) = nan;
   x2 = x2(:)';
   y2 = y2(:)';
   x2 = x2(1:end-1) / pxpu(1);
   y2 = y2(1:end-1) / pxpu(2); % convert back to axes units
   set(h2(ii),'xdata',x2);
   set(h2(ii),'ydata',y2);
   set(h2(ii),'linewidth',thin*get(h2(ii),'linewidth'));
end
h = [h';h2'];
h = h(:);
