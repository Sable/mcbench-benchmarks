function StripChart(mode,arg2,arg3)
%STRIPCHART provides scrolling display of streaming data.
%   This strip chart is a special kind of XY plot meant to convey recent
%   history of a waveform, such as voltage over time by dynamic updates
%   with new data. This version only supports 1 "trace" so user code must
%   make multiple calls, one per channel for example. The strip chart must
%   be properly initialized and updated, so there are 2 operating modes.
%
%   STRIPCHART(MODE,...) where MODE can be 'Initialize' or 'Update'. The
%   additional arguments depend on MODE.
%
%   STRIPCHART('Initialize',HAXES) makes the specified axes look like a
%   strip chart recorder, enforcing the axes conventions described below.
%
%   STRIPCHART('Initialize',HAXES,XUNITS) allows you to specify the
%   measurement units of the X axis for appropriate labeling of spacing per
%   division. XUNITS must be a string.
%
%   STRIPCHART('Update',HLINE,YDATA) updates the strip chart with new data.
%   YDATA is an M-length vector.  M new points get added to the right.
%   Everything else shifts left. The M oldest points are discarded. If the
%   initially defined number of points, N is less than M, then only the
%   most recent N points are used for the update.
%
%   Example:
%     x = 1:1000;
%     y = sin(2*pi*x/1000);
%     hLine = plot(x,y);
%     stripchart('Initialize',gca)
%     for i=1:1000
%       stripchart('Update',hLine,y(i))
%     end
%
%   NOTE:
%       For initialization details type HELP STRIPCHART/INITIALIZE
%       For update details type HELP STRIPCHART/UPDATE

% Copyright 2003-2010 The MathWorks, Inc.

% check syntax usage 
error(nargchk(2,3,nargin))
error(nargchk(0,0,nargout))

%input argument checking and parsing
if findstr(lower(mode),'initialize')
  if nargin>2
    initialize(arg2,arg3)  %INITIALIZE(HAXES,XUNITS)
  else
    initialize(arg2)  %INITIALIZE(HAXES)
  end
elseif findstr(lower(mode),'update')
  error(nargchk(3,3,nargin))
  update(arg2,arg3)  %UPDATE(HLINE,YDATA)
else
  error(['invalid mode ' mode])
end


%--------------------------------------------------------------------------
function initialize(hAxes,xUnits)
%INITIALIZE axes to look like strip chart.
%   INITIALIZE(HAXES) prepares the specified axes to be a strip chart.
%       HAXES must be a valid axes handle.
%       Double buffering is enforced on its parent figure.
%       The X tick spacing is preserved but right justified.
%       Grid lines are enabled for both X and Y axes.
%       The X label states the distance per division.
%   INITIALIZE(HAXES,XUNITS) allows specification of X axis units.
%       XUNITS must be a string.
%       The X label reads accordingly.

if nargin<3, xUnits=''; end

if ~ishandle(hAxes), error('invalid axes handle'), end
if ~strmatch(get(hAxes,'type'),'axes'), error('invalid HAXES'), end
if ~isa(xUnits,'char'), error('invalid XUNITS'), end

% make sure only one axes, not array of handles
if length(hAxes)>1, error('hAxes must be scalar, not array'), end

fig = get(hAxes,'parent');
if ~strcmp(get(fig,'type'),'figure'), error('invalid parent figure'), end
set(fig,'DoubleBuffer','on')

% maintain X tick spacing
Ticks = get(hAxes,'XTick');
dX = mean(diff(Ticks));

% enforce right justification for grid lines & remove X tick labels
Range = get(hAxes,'XLim');
if Range(end)~=Ticks(end)
  Ticks = fliplr(Range(end):-dX:Range(1));
  set(hAxes,'XTick',Ticks)
end
set(hAxes,'XTickLabel',[],'XTickMode','Manual','XGrid','On','YGrid','On')

% label X axis with units/division
xlabel(sprintf('%g %s/div',dX,xUnits))


%--------------------------------------------------------------------------
function update(hLine,newData)
%UPDATE strip chart with new data.
%   UPDATE(HLINE,YDATA) adds new data to the specified line plot.
%       HLINE must be a valid line handle.
%       YDATA is an N-length vector of new Y values.
%       The N new points append to right (N oldest points discarded).

if ~ishandle(hLine), error('invalid axes handle'), end
if ~strmatch(get(hLine,'type'),'line'), error('invalid HLINE'), end
% make sure only one line, not array of handles
if length(hLine)>1, error('hLine must be scalar, not array'), end
if ~all(ishandle(hLine)), return, end

yData = get(hLine,'YData');     % old data
nPts = length(newData);         % how much new data

if nPts>length(yData)                   % more new data than original
  nPts = length(yData);                 % only keep last part
  newData = newData(end-nPts+1:nPts);
end

yData(1:end-nPts) = yData(nPts+1:end);  % shift old data left
yData(end-nPts+1:end) = newData;        % new data goes on right
if ~ishandle(hLine), return, end
set(hLine,'YData',yData)                % update plot
drawnow                                 % refresh display
