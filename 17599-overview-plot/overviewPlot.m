function overviewPlot(varargin)
%OVERVIEWPLOT creates a plot with an interactive overview axes.
%   OVERVIEWPLOT(...) takes the same input arguments as the PLOT command
%   and will create a new figure containing the plot and an inset 
%   displaying an overview of the plot. Pan and zoom operations on the main
%   axes will result in a rectangle being drawn in the inset axes 
%   representing the section of the data currently shown in the main axes.
%   Manipulating the rectangle has the same effect as panning the main
%   axes.
%   OVERVIEWPLOT(FIG,...) will put the main axes and inset axes into the 
%   figure represented by the handle FIG. Any callbacks active in the
%   figure will be overwritten as will any data present in the figure.
%
%   See also PLOT, PAN, ZOOM.

%   Copyright 2007 The MathWorks, Inc.

% Check for a figure handle as first input:
if nargin > 0
    if isscalar(varargin{1}) && ishandle(varargin{1}) ...
            && strcmpi(get(varargin{1},'Type'),'Figure')
        hFig = varargin{1};
        clf(hFig,'reset');
        varargin = varargin(2:end);
    else
        hFig = figure;
    end
end

% Create the data axes:
hMainAx = axes('Parent',hFig,'Position',[0.05 0.05 0.5 0.9]);
plot(hMainAx,varargin{:});
% Create the thumbnail axes:
hOverviewAx = axes('Parent',hFig,'Position',[0.6 0.4 0.3 .54]);
set(hOverviewAx,'XTick',[],'YTick',[],'Box','on');
% Make sure the main axes is set as gca:
set(gcf,'CurrentAxes',hMainAx);
% Replicate the children of the original axes:
copyobj(get(hMainAx,'Children'),hOverviewAx);
% Create a box representing the area of the plot being used:
xl = get(hMainAx,'XLim');
yl = get(hMainAx,'YLim');
% Prevent the axes limits from changing:
set(hOverviewAx,'XLim',xl,'YLim',yl);
% Create an overview box in the overview axes:
hBox = line('Parent',hOverviewAx,'XData',[xl(1) xl(1) xl(2) xl(2) xl(1)],...
    'YData',[yl(1) yl(2) yl(2) yl(1) yl(1)]);

% Customize the zoom for the figure:
hZoom = zoom(hFig);
% Prevent users from zooming on the thumbnail axes:
setAllowAxesZoom(hZoom,hOverviewAx,false);
% Set a callback on the zoom:
set(hZoom,'ActionPostCallback',{@localZoomCallback,hBox});

% Customize the pan for the figure:
hPan = pan(hFig);
% Prevent users from zooming on the thumbnail axes:
setAllowAxesPan(hPan,hOverviewAx,false);
% Set a callback on the zoom:
set(hPan,'ActionPreCallback',{@localStartPanMotion,hBox,hPan});

% Disable 3-D rotation for both axes in the figure:
hRotate3d = rotate3d(hFig);
setAllowAxesRotate(hRotate3d,hOverviewAx,false);
setAllowAxesRotate(hRotate3d,hMainAx,false);

% Set up a motion callback on the figure to detect when we are over the
% rectangle.
hExploreModes = [hPan;hZoom;hRotate3d];
set(hFig,'WindowButtonMotionFcn',{@localHoverCallback,hBox,hOverviewAx,hExploreModes});
% Add a button down callback to facilitate dragging the overview rectangle.
set(hFig,'WindowButtonDownFcn',{@localStartMoveCallback,hBox,hOverviewAx,hMainAx});

%-----------------------------------------------------------------------%
function localStartMoveCallback(obj,evd,hBox,hOverviewAx,hMainAx) %#ok<INUSL>
% If we click on the overview rectangle, start a drag operation.

currPoint = get(hOverviewAx,'CurrentPoint');
% Since the overview axes is 2-D, just take the first (x,y) pair we find:
currPoint = [currPoint(1,1) currPoint(1,2)];
hoverType = localComputeHoverType(currPoint,hBox);

% If we are not hovering over the rectangle, return early:
if strcmpi(hoverType,'none')
    return;
end

% Compute the difference between the current point and bottom-left corner
% of the overview box as a starting point for the drag:
xData = get(hBox,'XData');
yData = get(hBox,'YData');
% We are interested in the bottom-left corner of the box:
bottomLeft = [xData(1) yData(1)];
pointDiff = bottomLeft-currPoint;
% Install the new motion function:
oldMotionCallback = get(obj,'WindowButtonMotionFcn');
set(obj,'WindowButtonMotionFcn',{@localDragBox,hBox,hOverviewAx,pointDiff,hMainAx});

% Install a button up function to for when the drag is over:
set(obj,'WindowButtonUpFcn',{@localDragComplete,oldMotionCallback});

%-----------------------------------------------------------------------%
function localDragComplete(obj,evd,oldMotionCallback) %#ok<INUSL>
% Restore the state of the figure after a drag operation.

set(obj,'WindowButtonUpFcn','');
set(obj,'WindowButtonMotionFcn',oldMotionCallback);

%-----------------------------------------------------------------------%
function localDragBox(obj,evd,hBox,hOverviewAx,pointDiff,hMainAx) %#ok<INUSL>
% Move the box based on the new mouse position:

currPoint = get(hOverviewAx,'CurrentPoint');
% Since the overview axes is 2-D, just take the first (x,y) pair we find:
currPoint = [currPoint(1,1) currPoint(1,2)];

newBottomLeft = pointDiff+currPoint;

% Move the box up based on the new bottom left corner:
xData = get(hBox,'XData');
yData = get(hBox,'YData');

oldBottomLeft = [xData(1) yData(1)];
newDiff = newBottomLeft-oldBottomLeft;

xData = xData+newDiff(1);
yData = yData+newDiff(2);
set(hBox,'XData',xData,'YData',yData);

% Update the axes limits of the main axes:
newXLim = [xData(1) xData(3)];
newYLim = [yData(1) yData(2)];
set(hMainAx,'XLim',newXLim,'YLim',newYLim);

%-----------------------------------------------------------------------%
function localHoverCallback(obj,evd,hBox,hOverviewAx,hExploreModes) %#ok<INUSL>
% Change the pointer depending on whether we are inside the bounds of the
% box in the overview axes:

% If any exploratory mode is active, return early.
if any(strcmpi(get(hExploreModes,'Enable'),'on'))
    return;
end
currPoint = get(hOverviewAx,'CurrentPoint');
% Since the overview axes is 2-D, just take the first (x,y) pair we find:
currPoint = [currPoint(1,1) currPoint(1,2)];
pointerShape = localComputeCursorShape(currPoint,hBox);
set(obj,'Pointer',pointerShape);

%-----------------------------------------------------------------------%
function pointerShape = localComputeCursorShape(currPoint,hBox)
% Determine the cursor shape from its position

hoverType = localComputeHoverType(currPoint,hBox);

if strcmpi(hoverType,'over')
    pointerShape = 'fleur';
else
    pointerShape = 'arrow';
end

%-----------------------------------------------------------------------%
function hoverType = localComputeHoverType(currPoint,hBox)
% Depending on where the mouse is, we may be over the overview box 
% (or not at all).

xData = get(hBox,'XData');
yData = get(hBox,'YData');
% We are interested in the corners of the box:
left = xData(1);
right = xData(3);
bottom = yData(1);
top = yData(2);

% Check if we are inside the box:
if (currPoint(1) >= left) && (currPoint(1) <= right) && ...
        (currPoint(2) <= top) && (currPoint(2) >= bottom)
    hoverType = 'over';
else
    hoverType = 'none';
end

%-----------------------------------------------------------------------%
function localZoomCallback(obj,evd,hBox) %#ok<INUSL>
% Adjust the box based on the new limits of the zoomed axes:
localUpdateBox(evd.Axes,hBox);

%-----------------------------------------------------------------------%
function localStartPanMotion(obj,evd,hBox,hPan)
% Set the "WindowButtonMotionFcn" of the figure to track the axes limits.
% As long as the user is panning, make sure to update the box accordingly.
origFun = get(obj,'WindowButtonMotionFcn');
set(obj,'WindowButtonMotionFcn',{@localPanMotionCallback,evd,hBox});
set(hPan,'ActionPostCallback',{@localEndPanMotion,hBox,origFun});

%-----------------------------------------------------------------------%
function localPanMotionCallback(obj,evd,panEvd,hBox) %#ok<INUSL>
% Adjust the box based on the new limits of the zoomed axes:
localUpdateBox(panEvd.Axes,hBox);

%-----------------------------------------------------------------------%
function localEndPanMotion(obj,evd,hBox,origFun)
% Restore the original "WindowButtonMotionFcn" callback.
set(obj,'WindowButtonMotionFcn',origFun);
% Update the box based on the new limits of the panned axes:
localUpdateBox(evd.Axes,hBox);

%-----------------------------------------------------------------------%
function localUpdateBox(hAx,hBox)
% Adjust the box based on the new limits of the axes:
xl = get(hAx,'XLim');
yl = get(hAx,'YLim');
set(hBox,'XData', [xl(1) xl(1) xl(2) xl(2) xl(1)],...
    'YData',[yl(1) yl(2) yl(2) yl(1) yl(1)]);