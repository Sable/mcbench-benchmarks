function varargout = gtrack(newVarName,titleFmt)
% default format for printing coordinates in title
if nargin<2,	titleFmt = '%3.5f';		end

% === mouse states ===
global mouseButton; % 'down' or 'up'

% track mouseMovement
global mouseMotion; % 'moving' or 'stationary'
global mouseMoveDirection; % 'N', 'S', 'E', 'W'; 'NW', 'NE', 'SW', 'SE', 'stationary'
global whichMouseButton; % 'left' or 'right'
global currentLocation; % x, y coordinates
global previousLocation; % x, y coordinates

previousLocation = 'unassigned';

% get current figure event functions
currFcn = get(gcf, 'windowbuttonmotionfcn');
currFcn2 = get(gcf, 'windowbuttondownfcn');
currTitle = get(get(gca, 'Title'), 'String');

% add data to figure handles
handles = guidata(gca);
if (isfield(handles,'ID') & handles.ID==1)
	disp('gtrack is already active.');
	return;
else
	handles.ID = 1;
end
handles.currFcn = currFcn;
handles.currFcn2 = currFcn2;
handles.currTitle = currTitle;
handles.theState = uisuspend(gcf);
guidata(gca, handles);

% set event functions 
set(gcf,'Pointer','crosshair');
set(gcf, 'windowbuttonmotionfcn', @gtrack_OnMouseMove);        
set(gcf, 'windowbuttondownfcn', @gtrack_OnMouseDown);          
set(gcf, 'windowbuttonupfcn', @gtrack_OnMouseUp);     

% declare variables
xInd = 0;
yInd = 0;
clickData = [];	

% set output mode
if nargout,	
	uiMode = 'uiwait';		% use UIWAIT and return to clickData
	uiwait;
elseif nargin && isvarname(newVarName)	% dont'e use UIWAIT and assign in caller 
	uiMode = 'nowait';				% workspace to variable newVarName
else
	uiMode = 'noreturn';	% dont't use UIWAIT and don't return results (print only)
end


%% --- nested functions ---------------------------------------------------

%% mouse move callback
function gtrack_OnMouseMove(src,evnt)

% get mouse position
pt = get(gca, 'CurrentPoint');
xInd = pt(1, 1);
yInd = pt(1, 2);
currentLocation = [xInd yInd];

if (~strcmp(previousLocation, 'unassigned'))
    changesInVectoralDistance = currentLocation - previousLocation;
    
    xDelta = changesInVectoralDistance(1, 1);
    yDelta = changesInVectoralDistance(1, 2);
    
    % degreesInMovement = NaN, if there is no movement
    degreesInMovement = atan(yDelta/xDelta)*(180/pi);
        
    if (xDelta == 0) && (yDelta == 0)
        mouseMoveDirection = 'stationary';
        mouseMotion = 'stationary';
    elseif (xDelta == 0) && (yDelta > 0)
        mouseMoveDirection = 'N';
        mouseMotion = 'moving';
    elseif (xDelta == 0) && (yDelta < 0)
        mouseMoveDirection = 'S';        
        mouseMotion = 'moving';
    elseif (xDelta > 0) && (yDelta == 0)
        mouseMoveDirection = 'E';     
        mouseMotion = 'moving';
    elseif (xDelta < 0) && (yDelta == 0)
        mouseMoveDirection = 'W';  
        mouseMotion = 'moving';
        degreesInMovement = degreesInMovement + 180;
    elseif (xDelta > 0) && (yDelta > 0)
        mouseMoveDirection = 'NE';
        mouseMotion = 'moving';
    elseif (xDelta < 0) && (yDelta > 0)
        mouseMoveDirection = 'NW'; 
        mouseMotion = 'moving';
        degreesInMovement = degreesInMovement + 180;
    elseif (xDelta < 0) && (yDelta < 0)
        mouseMoveDirection = 'SW';
        mouseMotion = 'moving';
        degreesInMovement = degreesInMovement + 180;
    elseif (xDelta > 0) && (yDelta < 0)
        mouseMoveDirection = 'SE';         
        mouseMotion = 'moving';
    end
    
    distanceMoved = sqrt((xDelta^2)+(yDelta^2));
    polarCoordinates = [distanceMoved degreesInMovement];
    
    fprintf('Mouse moved in the direction of %s at %s degrees. Distance: %s\n', ...
        mouseMoveDirection, num2str(degreesInMovement), num2str(distanceMoved)); 
end

% check if its within axes limits
xLim = get(gca, 'XLim');	
yLim = get(gca, 'YLim');
if xInd < xLim(1) | xInd > xLim(2)
	title('Out of X limit');	
	return;
end
if yInd < yLim(1) | yInd > yLim(2)
	title('Out of Y limit');
	return;
end

% update figure title
try
	title(['X = ' num2str(xInd,titleFmt) ', Y = ' num2str(yInd,titleFmt)]);
% possibility of wrong format strings...
catch
	gtrack_Off()
	error('TRACK: Error printing coordinates. Check that you used a valid format string.')
end

% update the location
previousLocation = currentLocation;

end


%% mouse click callback
function gtrack_OnMouseDown(src,evnt)
whichMouseButton = get(gcf,'SelectionType');
if strcmp(whichMouseButton,'alt')
	% gtrack_Off % if left button, terminate
    %return
    whichMouseButton = 'right';
end

if strcmp(whichMouseButton,'normal')
	% gtrack_Off
	%return    
    whichMouseButton = 'left';
end

% else add click to clickData
clickData(end+1).x = xInd;
clickData(end).y = yInd;
fprintf('%s Mouse Button Down at X = %f   Y = %f\n',whichMouseButton, xInd, yInd); % update mouse position

if (strcmp(mouseMotion, 'moving'))
    fprintf('Mouse is dragged.\n\n');
end

end

function gtrack_OnMouseUp(src,evnt)
whichMouseButton = get(gcf,'SelectionType');
if strcmp(whichMouseButton,'alt')
	% gtrack_Off % if left button, terminate
	%return    
    whichMouseButton = 'right';
end

if strcmp(whichMouseButton,'normal')
	% gtrack_Off
	%return    
    whichMouseButton = 'left';
end

% else add click to clickData
clickData(end+1).x = xInd;
clickData(end).y = yInd;
fprintf('%s Mouse Button Up at X = %f   Y = %f\n',whichMouseButton, xInd, yInd); % update mouse position

end


%% terminate callback
function gtrack_Off(src,evnt)

% restore default figure properties
handles = guidata(gca);
set(gcf, 'windowbuttonmotionfcn', handles.currFcn);
set(gcf, 'windowbuttondownfcn', handles.currFcn2);
set(gcf,'Pointer','arrow');
title(handles.currTitle);
uirestore(handles.theState);
handles.ID=0;
guidata(gca,handles);

% if there are outputs to assign do so
switch uiMode
	case 'uiwait'	% data return as output argument (clickData)
		varargout{1} = clickData;
		uiresume,
	case 'nowait'	% data assigned in base workspace as new variable
		assignin('base',newVarName,clickData);
		fprintf('Variable %s assigned with click data.\n',newVarName);
	case 'noreturn'
					% nothing to return
end

end

%% --- end nested functions -----------------------------------------------

end % end everything

% improved version of GTRACK
% 
% GTRACK Track mouse position and show coordinates in figure title.
% 
% 	GTRACK Activates GTRACK. Once it is active the mouse position is
% 	constantly tracked and printed on the figure title. A left-click will
% 	print the coordinates in the command line and store them. Clicking the
% 	mouse right button deactivates GTRACK.
% 
% USAGE
% 	gtrack() tracks the mouse and prints coordinates in the command line.
% 
% 	clickData = gtrack() will return the click positions in clickData using
% 	UIWAIT. Matlab will be in wait mode until the user finishes clicking.
% 
% 	gtrack('newVar') tracks the mouse and creates a new variable in the
% 	base workspace called 'newVar' with the click coordinates. This mode
% 	does not use UIWAIT.
%
%	gtrack([],titleFormat) uses titleFormat as the format string for
%	printing the mouse coordinates in the title.
%
