function zoomfixticks_rev(fig,method,varargin)
%ZOOMFIXTICKS allows zoom to work on a figure whose AXES tick labels are manually set
%   ZOOMFIXTICKS(FIG) operates on the figure with handle FIG.
%   ZOOMFIXTICKS(AX) operates on the figure with child AXES handle AX.
%   ZOOMFIXTICKS with no arguments operates on the current figure.
%
%   Note that when using this function, you will need to modify the FIXTICKS
%   subfunction to meet your application needs.  Alternatively, you can comment
%   out the function and supply it as an M-file function on the MATLAB path.  
%   If you supply your own, make sure that the M-file is named "fixticks.m", and
%   it takes a single input argument, the handle to an AXES object.
%
%   Example:
%       hf = figure;
%       xdata = [0:.01:1];
%       ydata = 100000*sin(2*pi*5*xdata);
%       plot(xdata,ydata);
%       zoomfixticks(hf)

%   Greg Aloe
%   8-8-2002
%   Copyright 2002-2004 The MathWorks, Inc.

%   Edited by Alex Taylor, 09-01-2004, to handle change to zoom button tag
%   between version 6 and 7

% Set up the figure if there are less than 2 arguments
if nargin < 2
    % Make sure the input is a handle to an AXES or FIGURE
    if nargin==0
        % If no arguments, assume the current figure
        fig = gcf;
    elseif ishandle(fig) & ~strcmp(lower(get(fig,'type')),'figure')
        % If FIG is a handle, but not to a figure, assume it's an axes and get its parent
        fig = get(fig,'parent');
    end

    % Error out if the input is not a handle, or not a handle to a figure or axes
    if ~ishandle(fig) | (ishandle(fig) & ~strcmp(lower(get(fig,'type')),'figure'))
        error('Input argument must be a handle to an AXES or FIGURE object.')
    end
    
    % Initialize the setup of the figure
    init(fig)
else
    % if 2 or more arguments, perform the desired operation
    feval(method,varargin{:})
end
    

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function init(fig)
% This function sets up the figure so that zooms will work even when the AXES
% ticklabels are set manually
 
%detect version
v=version;

%Get proper handles to zoom in and zoom out uitoggletool buttons.  Account
%for difference in tag names between version 6 and version 7

if (str2num(v(1))<7)
    hin = findall(fig,'tag','figToolZoomIn');
    hout = findall(fig,'tag','figToolZoomOut');
else
    hin = findall(fig,'tag','Exploration.ZoomIn');
    hout = findall(fig,'tag','Exploration.ZoomOut');
end

% Change the callback for the "Zoom In" toolbar button
set(hin,'ClickedCallback','zoomfixticks(gcbf,''zoomInCallback'',gcbo,gcbf)')

% Change the callback for the "Zoom Out" toolbar button
set(hout,'ClickedCallback','zoomfixticks(gcbf,''zoomOutCallback'',gcbo,gcbf)')

% Fix the ticks on initialization
fixticks(gca(fig))

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function zoomInCallback(hcbo,fig)
% Callback for the "Zoom In" button

% First call what is normally called during a zoom in
putdowntext('zoomin',hcbo)

% If the button is depressed, force WindowButtonDownFcn to call the DOWNFCN subfunction
if strcmp(get(hcbo,'state'),'on')
    set(fig,'WindowButtonDownFcn','zoomfixticks(gcbf,''downFcn'',gcbf)')
end


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function zoomOutCallback(hcbo,fig)
% Callback for the "Zoom Out" button

% First call what is normally called during a zoom out
putdowntext('zoomout',hcbo)

% If the button is depressed, force WindowButtonDownFcn to call the DOWNFCN subfunction
if strcmp(get(hcbo,'state'),'on')
    set(fig,'WindowButtonDownFcn','zoomfixticks(gcbf,''downFcn'',gcbf)')
end


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function downFcn(fig)
% Since the button was pressed, tell the figure that we are starting a zoom
zoom(fig,'down');

% After the zoom, fix the ticks
fixticks(gca(fig))


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function fixticks(ax)
% This function will perform the desired ticklabel fixing
% This is the function you will want to modify to meet your application needs
% Alternatively, you can comment out this function to call an M-file function
% in its place.

% EXAMPLE:
% First update the axes so the ticks are as expected
drawnow
% Get the ticks
tick=get(ax,'ytick');
% Convert ticks to a string of the desired format
tickstr=num2str(tick',7);
% Reset the labels to the new format
set(ax,'yticklabel',tickstr);

