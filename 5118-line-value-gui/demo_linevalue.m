function demo_linevalue(obj)
% DEMO_LINEVALUE Line intensity demo using callbacks.
%
%    This file demonstrates how to use the Image Acquisition Toolbox and
%    MATLAB's GUI capabilities to build an application that allows a user
%    to interactively explore acquired images.
%
%    When the demo is started it acquires a snapshot from an image
%    acquisition device and plots the intensity of the pixels in one row of
%    that image.  If the image is a color image, the intensity is plotted
%    for each band of the image.
%
%    Using the GUI it is possible to change the line that is plotted.
%    Other actions include scanning through all of the lines in the image
%    automatically or continuously updating the image and plotting the
%    intestity of a single line.
%
%    Normally the demo uses the first supported image acqisition object
%    found.  However, the optional parameter OBJ can be used to specify an
%    existing VIDEOINPUT object to use.
%
%    See also VIDEOINPUT.

% DT 4/2004
% Copyright 2004 The MathWorks, Inc.
% $Revision: $   $Date: $

% Check the input arguments.  If an argument is supplied verify that it is
% a valid videoinput object.
if (nargin == 0)
    obj = [];
elseif ( (nargin == 1) && ~isa(obj, 'imaqdevice') && ~isvalid(obj) )
    error('imaq:ghostdemo:invalidobject', 'OBJ must be a valid VIDEOINPUT object.');
end

% Create the GUI.  This could also be done using GUIDE.
handles = localConfigureGUI;

% Configure the videoinput object.  If one was provided, it will be used.
% Otherwise a new object will be created.
handles = localConfigureObject(obj, handles);

% Set up the callbacks for the GUI widgets.
localConfigureCallbacks(handles);

% Simulate the user pressing the snapshot button.  This will acquire an
% image and display it and the intensity values.  After this the program is
% driven by the callbacks set up previously.
snapshotDown(handles.snapshot, [], handles)

function handles = localConfigureObject(obj, handles)
% localConfigureObject sets up the callbacks on the videoinput object OBJ
% to work with the demo.  If an object is not passed in, then a new object
% will be created.
%
% The object's TimerFcn will be used because that allows callbacks to be
% scheduled as rapidly as possible.  If the callbacks are executing too
% rapidly (for example the processing takes too long), then some callbacks
% will be dropped.  Since the data is just being displayed to the screen,
% this is the desired behavior.  If processing every frame is necessary,
% the FramesAcquiredFcn should be used.

% Create the object if necessary.
if isempty(obj)
    obj = localCreateObj;
else
    % Set the object's tag so that it can be found later.
    set(obj, 'Tag', 'User linevalue object');
end

% Set the window title now that the name of the object is known.  This is
% just cosmetic.
set(handles.figure, 'Name', ['Line value demo using: ' obj.Name]);

% Store the object in the handles struct for later use.
handles.imaqObj = obj;

% Configure the object for manual trigger.  This allows the object to be
% started and acquire data.  Since the object is acquiring data, calls to
% GETSNAPSHOT will return the latest frame very quickly.  However, the
% object does not log data until TRIGGER is called, so only a single frame
% is ever in memory.
triggerconfig(obj, 'manual');

% Configure the callbacks.  Use the same callback as the snapshot button
% since the desired behavior is identical to clicking that button.
obj.TimerFcn = {@localGetSnapshot, handles};
obj.TimerPeriod = .01;

% End of localConfigureObject

function obj = localCreateObj
% localCreateObj searches for the first supported device with a
% default format.  Once found, it creates an object for that device and
% returns the object to the calling function.  Some devices do not have
% default formats and can not be used since the GUI doesn't provide a
% method of specifying camera files.

% Determine the available adaptors.
info = imaqhwinfo;

adaptorName = [];
adaptorID = [];
adaptorIndex = 1;

% Search through all of the installed adaptors until an available adaptor
% with hardware that has a default format is found.
while (isempty(adaptorName) && isempty(adaptorID))
    
    if (adaptorIndex > length(info.InstalledAdaptors))
        error('imaq:ghostdemo:nohardware', 'No hardware compatible with GHOSTDEMO was found.');
    end
    
    % Get information on the current adaptor.
    curAdaptor = info.InstalledAdaptors{adaptorIndex};
    adaptorInfo = imaqhwinfo(curAdaptor);
    
    % For the current adaptor, search through each installed device looking
    % for a device that has a default format.
    idIndex = 1;
    while (isempty(adaptorID) && (idIndex <= length(adaptorInfo.DeviceIDs)))
        curID = adaptorInfo.DeviceIDs{idIndex};
        if ~isempty(adaptorInfo.DeviceInfo(idIndex).DefaultFormat)
            adaptorName = curAdaptor;
            adaptorID = curID;
        end
        
        % If the current device doesn't have a default format check the
        % next one.
        idIndex = idIndex + 1;
    end
    
    % Check the next adaptor.
    adaptorIdnex = adaptorIndex + 1;
end

% Create the object.
obj = videoinput(adaptorName, adaptorID);

% Configure the object's tag so that it can be found later by using
% IMAQFIND.
set(obj, 'Tag', 'Line Value Demo Object');

% End of localCreateObj

function localCleanup(hObject, events)
% This function is called when the user closes the demo's figure window.
% It needs to stop any running objects.  Additionally, if the demo created
% an object, that object needs to be deleted.  Finally the figure window
% should be closed.

% Find the object that the user passed in, if any.  If the object is found
% stop it.
obj = imaqfind('Tag', 'User linevalue object');
if ~isempty(obj)
    stop([obj{:}]);
end

% Find the object that the demo created, if any.  If an object is found,
% stop it and then delete it.
obj = imaqfind('Tag', 'Line Value Demo Object');
if ~isempty(obj)
    stop([obj{:}])
    delete([obj{:}])
end

% This will close the figure window.
delete(hObject);

% End of localCleanup

function snapshotDown(handle, event, handles);
% This is the function that is called when the user clicks on the "Get
% Snapshot" button.  This simply passes the work off to a local function
% which is the same function that the object's TimerFcn is configured to
% call.
localGetSnapshot(handles.imaqObj, [], handles)

% End of snapshotDown

function localGetSnapshot(obj, event, handles)
% This is the function that is responsible for updating the image data.
% After a new image is acquired, the callback for the slider is called to
% update the intensity plot.

% Get the data and store it in the object's UserData field.  This allows
% multiple functions access to the data without using a global variable.
data = getsnapshot(obj);
obj.UserData = data;

% Display the image in the correct set of axes.
% axes(handles.imageAxes);
% imagesc(data);

% Turn of the tick marks and labels for the axes.
set(handles.imageAxes, 'Visible', 'off');

% Call the slider callback.
sliderCallback(handles.lineSlider, [], handles);

% End of localGetSnapshot

function sliderCallback(callbackObj, event, handles)
% This function updates the intensity plots.  It is called whenever the
% user moves the slider or when a new image is acquired.

% Get the handle to the slider.  Since this function is called from
% multiple locations, don't trust that the callbackObj parameter is
% correct.
slider = handles.lineSlider;

% Get the current line value.  Line values must be integers.
curValue = floor(get(slider, 'Value'));

% Get information about the current data source.
obj = handles.imaqObj;
data = obj.UserData;
res = obj.VideoResolution;

% The slider is initialized with a value of zero.  Since line values are
% always positive-definite, if the value is currently zero, this means that
% this is the first time that the function is called.  Since data is
% available, it is now possible to do some configuration that wasn't
% possible earlier.
if (curValue == 0)
    
    % Calculate a new current value that will be in the middle of the
    % image.
    curValue = floor(res(2) / 2);
    
    % Set the limits for the slider.  Configure the small slider step to be
    % one line and the large step to be 10.
    set(slider, 'Min', 1, 'Max', res(2), 'SliderStep', ...
        [1/(res(2) - 1) 10/(res(2) - 1)], 'Value', curValue);
    
    % Turn on the visibility of the lines depending on the color space.
    % For RGB and YCbCr, there are three lines, otherwise there is just
    % one.
    switch lower(obj.ReturnedColorSpace)
        case 'rgb'
            set([handles.redLine handles.blueLine handles.greenLine], ...
                'Visible', 'on');
            legend([handles.redLine handles.greenLine handles.blueLine], {'Red', 'Green', 'Blue'});
        case 'grayscale'
            set(handles.blackLine, 'Visible', 'on');
            legend(handles.blackLine, {'Intensity'});
            axes(handles.imageAxes);
            colormap(gray(255));
        case 'ycbcr'
            set([handles.redLine handles.blueLine handles.greenLine], ...
                'Visible', 'on');
            legend([handles.redLine handles.blueLine handles.greenLine], 'Y', 'U', 'V');
    end
    
    % Configure the x-axis so that there is no unused space.
    set(handles.dataAxes, 'XLimMode', 'manual');
    set(handles.dataAxes, 'XLim', [1 res(1)]);
    
    % If the data is of type UINT8 or UINT16 then prescale the y-axis,
    % otherwise let it autoscale.
    switch class(data)
        case 'uint8'
            set(handles.dataAxes, 'YLimMode', 'manual');
            set(handles.dataAxes, 'YLim', [0 255]);
        case 'uint16'
            set(handles.dataAxes, 'YLimMode', 'manual');
            set(handles.dataAxes, 'YLim', [0 65535]);
    end          
end

% Update the edit box.
set(handles.lineEdit, 'Value', curValue);
set(handles.lineEdit, 'String', num2str(curValue));

% Update the intensity plot depending on the type of image returned.
switch lower(obj.ReturnedColorSpace)
    case 'rgb'
        % Draw the R, G, and B intensities.
        set(handles.redLine, 'Xdata', 1:res(1), 'Ydata', data(curValue, :, 1))
        set(handles.greenLine, 'Xdata', 1:res(1), 'Ydata', data(curValue, :, 2))
        set(handles.blueLine, 'Xdata', 1:res(1), 'Ydata', data(curValue, :, 3))
        
        % Create a red line in the image to show which line is plotted.
        % Since the image might be scaled, make the line two pixels wide to
        % ensure that it is always drawn.
        data([curValue curValue+1], :, 1) = 255;
        data([curValue curValue+1], :, 2:3) = 0;
    case 'grayscale'
        % Draw the intensity line.
        set(handles.blackLine, 'Xdata', 1:res(1), 'Ydata', data(curValue, :, 1));

        % Create a white line in the image to show which line is plotted.
        % Since the image might be scaled, make the line two pixels wide to
        % ensure that it is always drawn.
        data([curValue curValue+1], :, 1) = 255;
    case 'ycbcr'
        % Draw the Y, U, and V intensity lines.
        set(handles.redLine, 'Xdata', 1:res(1), 'Ydata', data(curValue, :, 1))
        set(handles.greenLine, 'Xdata', 1:res(1), 'Ydata', data(curValue, :, 2))
        set(handles.blueLine, 'Xdata', 1:res(1), 'Ydata', data(curValue, :, 3))
        
        % Create a red line in the image to show which line is plotted.
        % Since the image might be scaled, make the line two pixels wide to
        % ensure that it is always drawn.
        data([curValue curValue+1], :, 1) = 255;
        data([curValue curValue+1], :, 2:3) = 0;
end

% Update the image with the indication of the current line.
axes(handles.imageAxes);
imagesc(data);
set(handles.imageAxes, 'Visible', 'off');

drawnow;

% End of sliderCallback

function editCallback(handle, event, handles)
% This function is called when the user types a value into the edit field
% in the GUI.  It validates that the value entered is a number and then
% calls the slider callback to do the works.

% Get the value entered as a number.
curValue = str2double(get(handle, 'String'));

if isnan(curValue)
    % If the value entered wasn't a number, restore the previous value.
    set(handle, 'String', num2str(get(handle, 'Value')));
else
    % The value entered was a number so update the slider's value and then
    % execute the callback.
    set(handles.lineSlider, 'Value', curValue);
    sliderCallback(handles.lineSlider, [], handles);
end

% End of editCallback

function scanDown(handle, event, handles)
% This function is called when the user clicks on the Scan button.  It
% updates the button and then calls another local function to scan through
% the lines.

% Get the current value of the button.  Since the user clicked on the
% button, change the state of the button.
value = ~get(handle, 'Value');
set(handle, 'Value', value);

% If the button was off, it is now on.
if (value)
    % Update the string displayed on the button.
    set(handle, 'String', 'Stop Scan');
    
    % Call the function that scans through the lines.
    localDoScan(handles);
end

% At this point either the localDoScan function completed or the user
% clicked on the button to stop the scan.  Turn the button off and update
% the string.
set(handle, 'Value', false)
set(handle, 'String', 'Scan Lines');

% End of scanDown

function localDoScan(handles)
% This function scans through all of the lines in the current image. As
% with most of the other functions, this function calls the slider callback
% to do most of the work.

% Start with line 1.
curLine = 1;

% Get the object to determine the number of lines.
obj = handles.imaqObj;
res = obj.VideoResolution;

% Loop while the scan button is depressed and there are more lines.
while ( get(handles.scan, 'Value') && (curLine <= res(2)) )
    
    % Update the value of the slider.
    set(handles.lineSlider, 'Value', curLine);
    
    % Execute the callback.
    sliderCallback(handles.lineSlider, [], handles);
    
    % Move to the next line.
    curLine = curLine + 1;
end

% End of localDoScan

function updateDown(handle, event, handles)
% This function is called when the user clicks on the Continuous Update
% button.  This function starts or stops the image acquisition object which
% has been configured to have its TimerFcn call the localGetSnapshot
% function in this file.

% Update the value of the button.
val = ~get(handle, 'Value');
set(handle, 'Value', val);

if val
    % The button is down.  Update the string and start the object.
    set(handle, 'String', 'Stop Updating')
    start(handles.imaqObj);
else
    % The button is up.  Update the string and stop the object.
    set(handle, 'String', 'Continuous Update')
    stop(handles.imaqObj);
end

% End of updateDown
    
function handles = localConfigureGUI
% This function draws the GUI and sets up the UICONTROLS.

figHandle = figure('Units', 'characters', 'MenuBar', 'none', ...
'Color', [0.831372549019608 0.815686274509804 0.784313725490196],...
'Name', 'guide_linevalue', 'NumberTitle', 'off',...
'Position', [105 23 180 50], ...
'CloseRequestFcn', @localCleanup);
handles.figure = figHandle;

dataAxes = axes('Parent', figHandle, 'Units', 'Normalized', ...
'Position', [0.05 0.32 0.45 0.63], 'Tag', 'dataAxes');
xlabel('Pixel Position');
ylabel('Pixel Value');
handles.dataAxes = dataAxes;

handles.redLine = line(1, 1, 'Color', 'Red', 'Visible', 'off');
handles.greenLine = line(1, 1, 'Color', 'Green', 'Visible', 'off');
handles.blueLine = line(1, 1, 'Color', 'Blue', 'Visible', 'off');
handles.blackLine = line(1, 1, 'Color', 'Black', 'Visible', 'off');

imageAxes = axes('Parent', figHandle, 'Units', 'Normalized', ...
'Position', [0.53 0.32 0.45 0.63], 'Tag', 'imageAxes', 'Visible', 'off');
handles.imageAxes = imageAxes;

instructPanel = uipanel('Parent', figHandle, 'FontSize', 10,...
'Title', 'Instructions', 'Units', 'Normalized', ...
'Position', [0.02 0.027 0.48 0.23], 'Tag','instructPanel');

instructText = uicontrol('Parent', instructPanel, 'Style', 'Edit',...
'Units', 'normalized', 'FontSize', 10, 'HorizontalAlignment', 'left',...
'Position', [0.02 0.05 0.97 0.8], 'Tag', 'instructText', 'Enable', ...
'Inactive', 'Max', 100);
handles.instructText = instructText;

crlf = sprintf('\n');
set(instructText, 'String', ...
    ['This demo allows you to interactively explore the pixel values of'...
     ' an image acquired with a VIDEOINPUT object.  When the demo is '...
     'launched, an object is created using the localConfigureObject '...
     'function, then the callback for the "Get Snapshot" button, ' ...
     'snapshotDown is called to display the image and the pixel '...
     'values.' crlf crlf 'Most of the work is done by the callback for '...
     'the slider which is sliderCallback.  Also of interest are the '...
     'callbacks for the other buttons, scanDown and updateDown.'])
     

 controlPanel = uipanel('Parent', figHandle, 'FontSize',10,...
'Title', 'Control', 'Position', [0.53 0.027 0.45 0.23], 'Tag', 'uipanel2');
handles.controlPanel = controlPanel;

lineSlider = uicontrol('Parent', controlPanel, 'Units','normalized',...
'Position', [0.115 0.6 0.715 0.12], 'Style', 'slider', 'Tag', 'lineSlider', ...
'Value', 0);
handles.lineSlider = lineSlider;

lineEdit = uicontrol('Parent', controlPanel, 'Units', 'normalized',...
'BackgroundColor', [1 1 1], 'FontSize', 10, ...
'Position', [0.87 0.6 0.1 0.14], 'Style', 'edit', 'Tag', 'lineEdit');
handles.lineEdit = lineEdit;

lineText = uicontrol('Parent', controlPanel, 'Units', 'normalized',...
'FontSize', 10, 'Position', [0.025 0.6 0.07 0.1], 'String', 'Line:',...
'Style', 'text', 'Tag', 'lineText');
handles.lineText = lineText;

snapshot = uicontrol('Parent', controlPanel, 'Units', 'normalized',...
'FontSize', 10, 'Position', [0.025 0.2 0.3 0.2], ...
'String', 'Get Snapshot', 'Tag', 'Snapshot', 'enable', 'on', ...
'Interruptible', 'off');
handles.snapshot = snapshot;

scan = uicontrol('Parent', controlPanel, 'Units', 'normalized',...
'FontSize', 10, 'Position', [0.35 0.2 0.3 0.2], 'String', 'Scan Lines',...
'Tag', 'Scan', 'enable', 'inactive', 'Style', 'Togglebutton');
handles.scan = scan;

update = uicontrol('Parent', controlPanel, 'Units', 'normalized',...
'FontSize', 10, 'Position', [0.675 0.2 0.3 0.2], ...
'String', 'Continuous Update', 'Tag','Update', 'enable', 'inactive', ...
'Style', 'Togglebutton');
handles.update = update;

% End of localConfigureGUI

function localConfigureCallbacks(handles)
% Configures the callbacks of the various UI components.
set(handles.snapshot, 'Callback', {@snapshotDown, handles});
set(handles.lineSlider, 'Callback', {@sliderCallback, handles});
set(handles.lineEdit, 'Callback', {@editCallback, handles});
set(handles.scan, 'ButtonDownFcn', {@scanDown, handles});
set(handles.update, 'ButtonDownFcn', {@updateDown, handles});