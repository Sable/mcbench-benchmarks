function jewelersLoupe(hFig)
%JEWELERSLOUPE modifies a figure to enable a Jeweler's Loupe tool.
%   JEWELERSLOUPE(FIG) will modify the figure with handle FIG to allow a
%   jeweler's loupe tool, which magnifies the axes by a factor of 4, to 
%   appear whenever a user clicks on an axes. Dragging will cause the loupe
%   to follow the cursor. The tool assumes that any axes clicked will be a 
%   linear 2-D axes. Performance will degrade as the amount of data in the
%   axes increates. If no figure is given, the loupe will appear in the 
%   current figure.
%
%   Example:
%   plot(magic(3));
%   jewelersLoupe(gcf);
%
%   See also PAN, ZOOM.

%   Copyright 2008 The MathWorks, Inc.

% If a figure has not been passed in, 
if nargin < 1
    hFig = gcf;
end

% Make sure we have a valid figure:
if ~ishandle(hFig) || ~strcmpi(get(hFig,'Type'),'figure')
    error('JEWELERSLOUPE:INVALIDFIGURE',...
        'The first input argument must be a valid figure.');
end

% Set up the callback for the loupe:
set(hFig,'WindowButtonDownFcn',@localCreateLoupe);

%------------------------------------------------------------------------%
function localCreateLoupe(hFig,evd) %#ok<INUSD>
% The loupe will appear for the current axes.
hAx = get(hFig,'CurrentAxes');

% If the axes is empty, we won't do anything.
if isempty(hAx)
    return;
end

% The loupe is implemented in terms of a separate axes:
hLoupe = axes('Parent',hFig,'Tag','loupe','HandleVisibility','off',...
    'XTickLabel','','YTickLabel','','XTick',[],'YTick',[],'Box','on');
% Set up the initial loupe position:
localUpdateLoupePosition(hFig,hLoupe);

% Copy the contents of the axes into the loupe:
copyobj(get(hAx,'Children'),hLoupe);

% We will zoom by a factor of 4 into the loupe based on the current point
% in the axes.
localDoZoom(hLoupe,hAx);

% Set callbacks for motion and button up:
set(hFig,'WindowButtonMotionFcn',{@localMoveLoupe,hAx,hLoupe});
set(hFig,'WindowButtonUpFcn',{@localCleanUp,hLoupe});

%------------------------------------------------------------------------%
function localMoveLoupe(hFig,evd,hAx,hLoupe) %#ok<INUSL>
% Move the loupe based on the current point:
localUpdateLoupePosition(hFig,hLoupe);

% Perform the zoom operation on the axes:
localDoZoom(hLoupe,hAx);

%------------------------------------------------------------------------%
function localCleanUp(hFig,evd,hLoupe) %#ok<INUSL>
% Clean up after the loupe has finished execution:

% Remove the callbacks:
set(hFig,'WindowButtonMotionFcn','');
set(hFig,'WindowButtonUpFcn','');

% Delete the loupe:
delete(hLoupe);

%------------------------------------------------------------------------%
function localUpdateLoupePosition(hFig,hLoupe)
% Moves the loupe based on the current point in the figure:

% The loupe should be centered on the current location and take up 25% of
% the figure space.
oldUnits = get(hFig,'Units');
set(hFig,'Units','Normalized');
mousePoint = get(hFig,'CurrentPoint');
set(hFig,'Units',oldUnits);
loupePosition = [(mousePoint-.125) .25 .25];
set(hLoupe,'Position',loupePosition);

%------------------------------------------------------------------------%
function localDoZoom(hLoupe,hAx)
% First, calculate the center based on the current point in the axes:
newCenter = get(hAx,'CurrentPoint');
% We are assuming a 2-D axes, so we will take the first two coordinates.
newCenter = newCenter(1,1:2);

% Zoom in by a factor of 4 around the given center point.
center_x = newCenter(1);
center_y = newCenter(2);

% Start by zooming the X-limits:
origXLim = get(hAx,'XLim');
xmin = origXLim(1);
xmax = origXLim(2);
dx = diff(origXLim);
newdx = dx * (1/4);
newdx = min(newdx,xmax-xmin);
newXLim = [center_x-newdx/2 center_x+newdx/2];

% Next, zoom the Y-limits:
origYLim = get(hAx,'YLim');
ymin = origYLim(1);
ymax = origYLim(2);
dy = diff(origYLim);
newdy = dy * (1/4);
newdy = min(newdy,ymax-ymin);
newYLim = [center_y-newdy/2 center_y+newdy/2];

% Update the limits:
set(hLoupe,'XLim',newXLim,'YLim',newYLim);
