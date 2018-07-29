function handle=shadedcolorbar(loc,cax,shadelim,cmap)
%SHADEDCOLORBAR Display shaded color bar (color scale).
% function handle=shadedcolorbar(loc,cax,shadelim,cmap)
%   where loc is an axis handle, 'horiz', or 'vert'.  Can be ommitted.  
%   cax is the color axis of the major data
%   shadelim is the shadelimit used in shadedpcolor
%   cmap is the colormap used.  
%
%   Creates a colorbar to accompany a shaded pcolor plot.  
%
%   See also: shadedpcolor.m, colorbar1.m

% $Id: shadedcolorbar.m,v 1.1 2007/03/04 18:25:48 jklymak Exp jklymak $

if nargin<3
  error('Usage: handle=shadedcolorbar(loc,cax,shadelim,cmap)');
elseif nargin==3;
  cmap = shadelim;
  shadelim=cax;
  cax = loc;
  loc = 'vert';
end;

ax = [];

if ~isstr(loc), 
  if length(loc) == 1
    ax = loc;
    if ~strcmp(get(ax,'type'),'axes'),
      error('Requires axes handle.');
    end
    rect = get(ax,'position');
    if rect(3) > rect(4), loc = 'horiz'; else loc = 'vert'; end
  elseif length(loc) == 2
    range = loc;
    loc = 'vert';
  else
    error('Requires a handle to an axes or 2-element color vector.')
  end
end;

t = linspace(cax(1),cax(end),size(cmap,1));
h = gca;

if nargin==0,
  % Search for existing colorbar
  ch = get(gcf,'children'); ax = [];
  for i=1:length(ch),
    d = get(ch(i),'userdata');
    if prod(size(d))==1, if d==h, 
      ax = ch(i); 
      pos = get(ch(i),'Position');
      if pos(3)<pos(4), loc = 'vert'; else loc = 'horiz'; end
      break; 
    end, end
  end
end

if strcmp(get(gcf,'NextPlot'),'replace'),
  set(gcf,'NextPlot','add')
end

if loc(1)=='v', % Append vertical scale to right of current plot
  stripe = 0.075; edge = 0.02; 
  if isempty(ax),
    pos = get(h,'Position');
    [az,el] = view;
    if all([az,el]==[0 90]), space = 0.05; else space = .1; end
    set(h,'Position',[pos(1) pos(2) pos(3)*(1-stripe-edge-space) pos(4)])
    rect = [pos(1)+(1-stripe-edge)*pos(3) pos(2) stripe*pos(3) pos(4)];

    % Create axes for stripe
    ax = axes('Position', rect);
  else
    axes(ax);
  end
  
  % Create color stripe
  n = size(cmap,1);
  m = 160;
  shadedpcolor((1:m)/m,t,repmat([1:n]',1,m),repmat(linspace(shadelim,1,m),n,1),[1 ...
                      n],[shadelim 1],shadelim,cmap,1);shading flat; 
  set(ax,'Ydir','normal')

  % Create color axis
  ylim = get(ax,'ylim');
  units = get(ax,'Units'); set(ax,'Units','pixels');
  pos = get(ax,'Position');
  set(ax,'Units',units);
  yspace = get(ax,'FontSize')*(ylim(2)-ylim(1))/pos(4)/2;
  xspace = .5*get(ax,'FontSize')/pos(3);
  yticks = get(ax,'ytick');
  ylabels = get(ax,'yticklabel');
  labels = []; width = [];
  for i=1:length(yticks),
    labels = [labels;text(1+0*xspace,yticks(i),deblank(ylabels(i,:)), ...
         'HorizontalAlignment','right', ...
         'VerticalAlignment','middle', ...
         'FontName',get(ax,'FontName'), ...
         'FontSize',get(ax,'FontSize'), ...
         'FontAngle',get(ax,'FontAngle'), ...
         'FontWeight',get(ax,'FontWeight'))];
    width = [width;get(labels(i),'Extent')];
  end

  % Shift labels over so that they line up
  [dum,k] = max(width(:,3)); width = width(k,3);
  for i=1:length(labels),
    pos = get(labels(i),'Position');
    set(labels(i),'Position',[pos(1)+width pos(2:3)])
  end

  % If we need an exponent then draw one
  [ymax,k] = max(abs(yticks));
  if abs(abs(str2num(ylabels(k,:)))-ymax)>sqrt(eps),
    ex = log10(max(abs(yticks)));
    ex = sign(ex)*ceil(abs(ex));
    l = text(0,ylim(2)+2*yspace,'x 10', ...
         'FontName',get(ax,'FontName'), ...
         'FontSize',get(ax,'FontSize'), ...
         'FontAngle',get(ax,'FontAngle'), ...
         'FontWeight',get(ax,'FontWeight'));
    width = get(l,'Extent');
    text(width(3)-xspace,ylim(2)+3.2*yspace,num2str(ex), ...
         'FontName',get(ax,'ExpFontName'), ...
         'FontSize',get(ax,'ExpFontSize'), ...
         'FontAngle',get(ax,'ExpFontAngle'), ...
         'FontWeight',get(ax,'ExpFontWeight'));
  end

  set(ax,'yticklabelmode','manual','yticklabel','')
  set(ax,'xticklabelmode','manual','xticklabel','')

else, % Append horizontal scale to top of current plot

  if isempty(ax),
    pos = get(h,'Position');
    stripe = 0.075; space = 0.1;
    set(h,'Position',...
      [pos(1) pos(2)+(stripe+space)*pos(4) pos(3) (1-stripe-space)*pos(4)])
    rect = [pos(1) pos(2) pos(3) stripe*pos(4)];

    % Create axes for stripe
    ax = axes('Position', rect);
  else
    axes(ax);
  end

  % Create color stripe
  n = size(cmap,1);
  m = 160;
  shadedpcolor((1:m)/m,t,repmat([1:n],m,1), ...
               repmat(linspace(shadelim,1,m)',1,n),[1 n],[shadelim ...
                      1]*m,shadelim,cmap,0);  
  set(ax,'Ydir','normal')
  set(ax,'yticklabelmode','manual')
  set(ax,'yticklabel','')
end
set(ax,'userdata',h)
set(gcf,'CurrentAxes',h)
set(gcf,'Nextplot','Replace')

if nargout>0, handle = ax; end


