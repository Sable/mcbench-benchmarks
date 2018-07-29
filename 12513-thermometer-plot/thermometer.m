function h = thermometer(varargin)
% Create a Thermometer plot.
% THERMOMETER(DATA, MAX) - Create a thermometer 
%    where DATA is a set of 1D data to plot in the thermometer.
%    Each entry in DATA adds onto the previous number, thus:
%    [ 3 4 5 ] will show the '3' between 0 and 3, and '4' between 3
%    and 7, and '5' between 7 and 12.
% THERMOMETER(DATA, MIN, MAX) 
%    MIN and MAX represent the minimum and maximum thermometer
%    values.
%    Values in DATA add onto MIN. Thus, if MIN is 10, and DATA is
%    [ 3 4 ] then the '3' is shown between 10 and 13, and the '4'
%    between 13 and 17.
% THERMOMETER(..., { 'name1', 'name2' }) 
%    Area labels.
% THERMOMETER(..., { GOAL 'label' })
%    At a specific GOAL, add LABEL.
%    The GOAL value is absolute, and does not change based on MIN
%    or MAX.
%
% The thermometer code has been tweeked to look good printed from
% painters.  Using Zbuffer or OpenGL will make it looks strange.
%
% To adjust the tick labels, modify GCA's yticks.
%
% To make the zone labels alternate sides, uncomment the section
% that contains the word 'left'.
%
% Example:
% thermometer([ 3 4 ], 10, { 'tasks' 'bugs' }, { 8 'Almost There' })

% History:
%  Version 1.2: Update doc to better describe data.
%
%  Version 1.1:  Fixed problem using color-order for shading
%  elements so more than 7 entries can be used.
%
%
% Eric Ludlam
% Copyright (c) 2006 The MathWorks Inc.

  data = varargin{1};

  if any(data < 0)
      error('DATA Values for thermometer must be > 0.');
  end
  
  if nargin >= 3 && isnumeric(varargin{3})
    inputy = [ varargin{2} varargin{3} ];
    base = 4;
  else
    inputy = [ 0 varargin{2} ];
    base = 3;
  end
  
  names = {};
  goals = {};
  
  while nargin >= base

    nexta = varargin{base};
    
    if ~iscell(nexta)
      error('Arguments after MAX must be cell arrays');
    end
    
    if ischar(nexta{1})
    
      names = cell(size(data,1),1);
      names(1:length(varargin{base})) = varargin{base};
      
    elseif isnumeric(nexta{1})
      
      goals = nexta;
      
    else
      
      error('Unknown cell array format for thermometer.', nexta); %#ok
      
    end
    
    
    base = base + 1;
  end
  
  lw = 2;
  ax = newplot;
  
  set(ax,'color','white');
  total = inputy(2) - inputy(1);
  yl = [ inputy(1)-(total/15) inputy(2) ];
  set(ax,'ylim', yl)
  set(ax,'xlim', [ 0 1 ])
  set(ax,'xtick', [] )
  set(ax,'plotboxaspectratio',[ 1 20 1 ]);
  set(ax,'box','on');
  set(ax,'tickdir','out');
  set(ax,'ygrid','on');
  set(ax,'gridlinestyle','-');
  set(ax,'box','off');

  co = get(gca,'colororder');  
  
  l = get(gca,'loose');
  l(1) = l(end);
  set(gca,'loose',l);
  
  % Draw a circle at bottom of thermometer
  
  rectangle('position',[-.5 inputy(1)-(total/15*1.5) 2 total/15*1.6 ],...
            'curvature',[ 1 1 ],...
            'facecolor',co(1,:),'edgecolor','k',...
            'clipping','off',...
            'linewidth',3);

  % Data Patchs
  
  % One number being plotted
    
  surface('xdata', [ 0 1 ] , 'ydata', [ yl(1) data(1)+inputy(1) ], ...
          'zdata', [ 1 1 ; 1 1 ],  ...
          'facecolor', co(1,:) ,'edgecolor','none');

  if ~isempty(names)
    yzonelabel_t(inputy(1), data(1)+inputy(1), names{1}, 'right');
  end
  
  bottom = data(1)+inputy(1);

  % A stacked data plot
  for i = 2:length(data)

    cidx = i-1;
    color = co(mod(cidx,size(co,1))+1,:);
      
    surface('xdata', [ 0 1 ] , 'ydata', [ bottom bottom+data(i) ], ...
            'zdata', [ 0 0 ; 0 0 ],  ...
            'facecolor', color ,'edgecolor','none');      
    %if ~mod(i,2)
    %  lr = 'left';
    %else
    lr = 'right';
    %end

    if ~isempty(names) && length(names) >= i
      yzonelabel_t(bottom, bottom+data(i), names{i}, lr);
    end
  
    bottom = bottom+data(i);
    
  end

  while ~isempty(goals)
    
    pointlabel(goals{1}, goals{2}, false);
    
    goals = goals(3:end);
    
  end
  
    % Put a new box onto the axes.
  line('xdata',[0 0 1 1],'ydata', [ inputy(1) yl(2) yl(2) inputy(1) ],...
       'zdata',[1 1 1 1],...
       'color','k','linewidth',lw,'clipping','off');
  
  if nargout > 0
      h = ax;
  end

end
  
function pointlabel(yval, str, left)
% Create a fancy label at yval
  
  if left
    xdata = [ 0 -.7 ];
    txtpos = -.8;
    ha = 'right';
  else
    xdata = [ 1 1.7 ];
    txtpos = 1.8;
    ha = 'left';
  end
  ydata = [ yval yval ];
  
  line(xdata,ydata,'color','k','clipping','off');
  line(1,yval,'color','k',...
       'markersize',6,...
       'marker','diamond','markerfacecolor','k');
  line(0,yval,'color','k',...
       'markersize',6,...
       'marker','diamond','markerfacecolor','k');
  line([0 1],ydata,'color','k','linestyle',':');
  text(txtpos,yval,str,'horizontalalign',ha,...
       'verticalalign','middle');
  
end

function yzonelabel_t(start, fin, str, side)
% Create a small label thingy between START and END
% STR is an optional string to add to the label.  The text
% representing the total Y value encompassed is also included.
% SIDE is a string, either 'left', or 'right'.

  xl = xlim;
  xr = xl(2);
  xl = xl(1);
  factor = abs(xl-xr);
  
  switch side
   case 'left'
    in = xl-1.2*factor;
    out = xl-2*factor;
    xdata = [ in out out in ];
    txtpos = xl-2.1*factor;
    rot = 90;
   case 'right'
    in = xr + .5*factor;
    out = xr + .7*factor;
    xdata = [ in out out in ];
    txtpos = xr + .8*factor;
    rot = -90;
  end
  ydata = [ start start fin fin ];
  
  mid = (start + fin) / 2;
  
  numstr = num2str(fin-start);
  
  if isempty(str)
    newstr = numstr;
  else
    newstr = [ numstr char(10) str ];
  end
  
  l = line(xdata,ydata,'color','k');
  t = text(txtpos, mid, newstr,'rotation',rot,...
           'fontsize',10,...
           'horizontalalign','center',...
           'verticalalign','bottom');
  set([ l t ], 'xliminclude','off',...
               'clipping','off');
  
end