% MOUSEINPUT_TIMEOUT returns continuous mouse locations with timeout
% OUT = MOUSEINPUT_TIMEOUT returns the sequence of mouse locations between
%    a button press and a button release in the current axes. It does
%    not timeout. OUT is an Nx2 matrix, where OUT(1,:) is the location
%    at button press and OUT(END,:) is the location at button release.
%
% OUT = MOUSEINPUT_TIMEOUT(T) times out after a period of T seconds. 
%   T can be a fractional value (T=inf indicates no timeout). If
%   the mouse-button has not been pressed during that time, OUT is [].
%   If the timeout occurs during a mouse movement, OUT contains the 
%   mouse locations before the timeout. 
% 
% OUT = MOUSEINPUT_TIMEOUT(T,AH) records the mouse movement from 
%   the axes specified by axes handle AH. 
%  
% Note: MOUSEINPUT_TIMEOUT differs from GINPUT in two ways. 
% (1) It does not return information about which mouse button 
%     was pressed, and
% (2) It ignores key presses.
%
% Example:
%  % record movements from current axes, timeout after 4.5 sec
%  out = mouseinput_timeout(4.5, gca); 
%  figure; 
%  plot(out(:,1), out(:,2), '.-'); % plot the mouse movement
%
% See also ginput, waitforbuttonpress
% 
%  Gautam Vallabha, Sep-23-2007, Gautam.Vallabha@mathworks.com

% Copyright 2009 The MathWorks, Inc.
%
% Updated minor typo that caused an error in 2009b
%            (Gautam Vallabha, Nov-17-2009)

function selectedPts = mouseinput_timeout(timeoutval, axesHandle)

if ~exist('axesHandle', 'var')
    axesHandle = gca;
end

if ~exist('timeoutval', 'var'), 
    timeoutval = inf;
end

if ~(ishandle(axesHandle) && strcmp(get(axesHandle,'type'),'axes'))
    error('Axis handle is not valid');
end

if ~(isscalar(timeoutval) && (timeoutval > 0))
    error('Timeout should be a positive scalar');
end

%-----------------------
figHandle = get(axesHandle, 'parent');

selectedPts = [];

% get existing figure properties
oldProperties = get(figHandle, ...
    {'WindowButtonDownFcn','WindowButtonUpFcn',...
     'WindowButtonMotionFcn', 'units','pointer'});

% replace with new properties to register mouse input
set(figHandle, ...
    {'WindowButtonDownFcn','WindowButtonUpFcn',...
     'WindowButtonMotionFcn', 'units','pointer'}, ...
    { @buttonDownCallback, @buttonUpCallback, ...
      [], 'pixels', 'crosshair' }); 
figLocation = get(figHandle, 'Position'); 

% key step: wait until timeout or until UIRESUME is called
if isinf(timeoutval)
    uiwait(figHandle);
else
   uiwait(figHandle, timeoutval);
end

% restore pre-existing figure properties
set(figHandle, ...
    {'WindowButtonDownFcn','WindowButtonUpFcn',...
     'WindowButtonMotionFcn', 'units','pointer'}, ...
     oldProperties);
 
%% --------------------------------------------

    function buttonMotionCallback(obj, eventdata) %#ok<INUSD>
        pt = mapCurrentPosition();
        selectedPts(end+1,:) = pt(1,1:2);
    end

    function buttonDownCallback(obj, eventdata) %#ok<INUSD>
        selectedPts = [];
        set(obj, 'WindowButtonMotionFcn', @buttonMotionCallback);
    end

    function buttonUpCallback(obj, eventdata) %#ok<INUSD>
        pt = mapCurrentPosition();
        selectedPts(end+1,:) = pt(1,1:2);
        set(obj, 'WindowButtonMotionFcn', [] );
        uiresume(figHandle);
    end

%% --------------------------------------------
% The following adjustment is based on GINPUT
    function pt = mapCurrentPosition()
        scrn_pt = get(0, 'PointerLocation');              
        set(figHandle,'CurrentPoint',...
            [scrn_pt(1) - figLocation(1) + 1, scrn_pt(2) - figLocation(2) + 1]);
        pt = get(axesHandle,'CurrentPoint');       
    end
%%
end