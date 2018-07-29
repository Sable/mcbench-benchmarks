function LineManipulator(lineHandle,controlMode)
%% LineManipulator(LINEHANDLE,CONTROLMODE)
%  Adds ButtonDown, ButtonMotion and Keypress-functions to the figure that
%  contains LINEHANDLE allowing mouse-based data manipulation.
%  Be aware that the figure, the axes, the line and its UserData will be changed.
%  The intended use is to allow the user of a gui to create a curve.
%  After applying the function to the line each mouseclick in the axes triggers
%  the manipulation-function on and off.
%
%  While in manipulation-mode...
%   pressing (or holding) 'a' will add new points to the line and
%   pressing 'r' will remove the closest point from the line
%
%  Input:
%   LINEHANDLE  - has to be a handle to a line object (the axes of LINEHANDLE
%                 can be housed in a figure or uipanels)
%   CONTROLMODE - has to be one of the following strings:
%     'nocheck'                - everything is allowed
%     'stopx','stopy','stopxy' - blocks the moving data point when it would
%                                pass the neigbouring points on the x/y-axis
%     'pushx','pushy','pushxy' - pushes all other data points with the moving
%                                data point if it would pass them on the x/y-axis
%     'off'                    - disables the functionality, deactivates the 
%                                manipulated title and switches appearance back
%                                to normal
%
%  Example:
%   lineHandle=plot(1:10);
%   LineManipulator(lineHandle,'nocheck')
%
% Works with Matlab R2012a
% Needs to be able to import java.awt.Robot
%
%        Author: Thomas Otterstätter, Stuttgart, Germany
% Last modified: 2012/07/16

% checking if the inputs are as expected
controlModeStrings={'off','nocheck','stopx','stopy','stopxy','pushx','pushy','pushxy'}; % allowed strings
if ~(nargin==2 && numel(lineHandle)==1 && ishandle(lineHandle) && strcmpi(get(lineHandle,'type'),'line') ...
        && ischar(controlMode) && ismember(controlMode,controlModeStrings))
    disp('Input has to be one line handle and one of the following controlMode-strings:')
    disp(controlModeStrings)
    
% turn off behaviour
elseif strcmpi(controlMode,'off') 
    if ~isempty(get(lineHandle,'UserData'))
        OldData=get(lineHandle,'UserData');
        set(lineHandle,'UserData',[],'Marker',OldData.Marker,'MarkerSize',OldData.MarkerSize)
        set(OldData.Title,'String',OldData.TitleString)

        % disabling the callback-functions
        set(OldData.figHandle,'WindowButtonDownFcn',[])
        set(OldData.figHandle,'WindowButtonMotionFcn',[])
        set(OldData.figHandle,'KeyPressFcn',[])

        % deleting the "ghostline"
        delete(OldData.ghostLineHandle);
    end
    
% standard behaviour
else
    % setting some variables that are needed
    axHandle=get(lineHandle,'parent');
    LineControlActive=false;
    
    % searching for the figure that contains lineHandle - because only a figure can control the WindowButtonFcns
    figHandle=get(axHandle,'parent');
    while ~strcmp(get(figHandle,'type'),'figure')
        % searching iteratively, because the axes might be a child of a uipanel
        figHandle=get(figHandle,'parent');
    end
    % applying the callback-functions
    set(figHandle,'WindowButtonDownFcn',@ButtonFcn)
    set(figHandle,'WindowButtonMotionFcn',@MotionFcn)
    set(figHandle,'KeyPressFcn',@KeyFcn)
    
    % Storing all the "old" data to enable the turning off/switching back functionality
    OldData.Marker=get(lineHandle,'Marker');
    OldData.MarkerSize=get(lineHandle,'MarkerSize');
    OldData.Title=get(axHandle,'Title');
    OldData.TitleString=get(get(axHandle,'Title'),'String');
    OldData.figHandle=figHandle;
    
    % making the LineMarkers a little bit more visible and adding a similar (dotted) line to help the user
    hold(axHandle,'on')
    OldData.ghostLineHandle=plot(axHandle,get(lineHandle,'XData'),get(lineHandle,'YData'),'Color',get(lineHandle,'Color')...
        ,'Linewidth',get(lineHandle,'LineWidth')*0.5,'LineStyle',':');
    if get(lineHandle,'Color')==[1 0 0] %#ok<BDSCA>
        set(lineHandle,'Marker','.','MarkerSize',10,'MarkerEdgeColor','b')
    else
        set(lineHandle,'Marker','.','MarkerSize',10,'MarkerEdgeColor','r')
    end
    
    % storing OldData in lineHandles UserData
    set(lineHandle,'tag','linemanipulator','UserData',OldData)
    
    % adding a title as an info text
    title(axHandle,sprintf('Start/end line manipulation by clicking in the axes\nwhile activated press or hold ''a'' to add points\n or press ''r'' to remove points'));
    
    % data, objects and adjustments needed for mouse repositioning
    screenSize=get(0,'screensize');
    import java.awt.Robot;
    mouse=Robot;
    axPixelPosition=[0 0 0 0]; % declaring it here makes this a 'global' variable (which may not be the most beautiful way, but is very convenient)
end

%% ButtonFcn(~,~)
%  Nested function that activates/deactivates the MotionFunction/Keypress
    function ButtonFcn(~,~)
        % check if the current point is visible == inside the axes and not only inside the figure (feels better and helps to reduce
        % obscure behaviour when running in a figure with multiple axes)
        currentPoint=get(axHandle,'CurrentPoint');
        cAxis=[get(axHandle,'XLim') get(axHandle,'YLim')];
        if currentPoint(1,1)>=cAxis(1) && currentPoint(1,1)<=cAxis(2) && currentPoint(1,2)>=cAxis(3) && currentPoint(1,2)<=cAxis(4)
            % toggle state
            LineControlActive=~LineControlActive;
            
            if ~LineControlActive
                % return to "default"-view
                set(figHandle,'Pointer','arrow');
                title(axHandle,sprintf('Start/end line manipulation by clicking in the axes\nwhile activated press or hold ''a'' to add points\n or press ''r'' to remove points'));
            else
                % switch to crosshair-pointer and add a title/info text
                set(figHandle,'Pointer','fullcrosshair');
                title(axHandle,sprintf(['current position [x=' num2str(currentPoint(1,1)) ',y=' num2str(currentPoint(1,2)) ']\npress or hold ''a'' to add points\npress ''r'' to remove points']));
                
                % fetch closest data point to current point
                XData=get(lineHandle,'XData');
                YData=get(lineHandle,'YData');
                [~,minDistIndex]=min((XData-currentPoint(1,1)).^2+(YData-currentPoint(1,2)).^2);
                % calculate the pixel-coordinates on the screen to reposition the mouse pointer
                % (this will result in obscure behaviour if the figure is resized while in manipulation-mode)
                UpdatePixelCoords;
                cAxis=[get(axHandle,'XLim') get(axHandle,'YLim')];
                NewMouseX=axPixelPosition(1)+axPixelPosition(3)*(XData(min(minDistIndex,end))-cAxis(1))/(cAxis(2)-cAxis(1));
                NewMouseY=screenSize(4)-(axPixelPosition(2)+axPixelPosition(4)*(YData(min(minDistIndex,end))-cAxis(3))/(cAxis(4)-cAxis(3)));
                mouse.mouseMove(NewMouseX,NewMouseY);
            end
        end
    end

%% MotionFcn(~,~)
%  Nested function that controls the data points depending on mouse movement (toggled on/off by mouseclicks via 'ButtonFcn')
    function MotionFcn(~,~)
        if LineControlActive
            % fetch closest data point to current point
            currentPoint=get(axHandle,'CurrentPoint');
            XData=get(lineHandle,'XData');
            YData=get(lineHandle,'YData');
            [~,minDistIndex]=min((XData-currentPoint(1,1)).^2+(YData-currentPoint(1,2)).^2);
            
            % no-check-mode (closest point moves to current point)
            if strcmpi(controlMode,'nocheck')
                XData(minDistIndex)=currentPoint(1,1);
                YData(minDistIndex)=currentPoint(1,2);
            end
            
            % stop-x-axis-mode (moving over x-values of the neighbouring points is not possible)
            if strcmpi(controlMode,'stopx')
                if ~(minDistIndex>1 && XData(minDistIndex-1)>currentPoint(1,1) ...
                        || minDistIndex<length(XData) && XData(minDistIndex+1)<currentPoint(1,1))
                    XData(minDistIndex)=currentPoint(1,1);
                    YData(minDistIndex)=currentPoint(1,2);
                end
            end
            % stop-y-axis-mode (moving over y-values of the neighbouring points is not possible)
            if strcmpi(controlMode,'stopy')
                if ~(minDistIndex>1 && YData(minDistIndex-1)>currentPoint(1,2) ...
                        || minDistIndex<length(YData) && YData(minDistIndex+1)<currentPoint(1,2))
                    XData(minDistIndex)=currentPoint(1,1);
                    YData(minDistIndex)=currentPoint(1,2);
                end
            end
            % stop-x/y-axis-mode (moving over x/y-values of the neighbouring points is not possible)
            if strcmpi(controlMode,'stopxy')
                if ~(minDistIndex>1 && XData(minDistIndex-1)>currentPoint(1,1) ...
                        || minDistIndex<length(XData) && XData(minDistIndex+1)<currentPoint(1,1))
                    XData(minDistIndex)=currentPoint(1,1);
                end
                if ~(minDistIndex>1 && YData(minDistIndex-1)>currentPoint(1,2) ...
                        || minDistIndex<length(YData) && YData(minDistIndex+1)<currentPoint(1,2))
                    YData(minDistIndex)=currentPoint(1,2);
                end
            end
            
            % push-x-axis-mode (other x-values are pushed in front of the current point)
            if strcmpi(controlMode,'pushx') || strcmpi(controlMode,'pushxy')
                % set all x-values between the change to the lower/upper boundary if their index is below/above the closest point
                if currentPoint(1,1)>=XData(minDistIndex)
                    XData(1:end>=minDistIndex & XData>=XData(minDistIndex) & XData<=currentPoint(1,1))=currentPoint(1,1);
                else
                    XData(1:end<=minDistIndex & XData<=XData(minDistIndex) & XData>=currentPoint(1,1))=currentPoint(1,1);
                end
            end
            % push-y-axis-mode (other y-values are pushed in front of the current point)
            if strcmpi(controlMode,'pushy') || strcmpi(controlMode,'pushxy')
                % set all y-values between the change to the lower/upper boundary if their index is below/above the closest point
                if currentPoint(1,2)>=YData(minDistIndex)
                    YData(1:end>=minDistIndex & YData>=YData(minDistIndex) & YData<=currentPoint(1,2))=currentPoint(1,2);
                else
                    YData(1:end<=minDistIndex & YData<=YData(minDistIndex) & YData>=currentPoint(1,2))=currentPoint(1,2);
                end
            end
            
            % update line and title
            set(lineHandle,'XData',XData,'YData',YData);
            title(axHandle,sprintf(['current position [x=' num2str(currentPoint(1,1)) ',y=' num2str(currentPoint(1,2)) ']\npress or hold ''a'' to add points\npress ''r'' to remove points']));
        end
    end

%% KeyFcn(~,~)
%  Nested function that controls the adding/removing of data points depending on keypress (toggled on/off by mouseclicks via 'ButtonFcn')
    function KeyFcn(~,~)
        if LineControlActive
            % fetch closest data point to current point
            currentPoint=get(axHandle,'CurrentPoint');
            XData=get(lineHandle,'XData');
            YData=get(lineHandle,'YData');
            [~,minDistIndex]=min((XData-currentPoint(1,1)).^2+(YData-currentPoint(1,2)).^2);
            
            if strcmpi(get(figHandle,'CurrentCharacter'),'a') % 'a' pressed => add a data point
                % the new point is added slightly displaced (1/10000th of the axis-range) in the direction of the next point
                % (usually this is the direction that feels right when the mouse pointer is moved further)
                cAxis=[get(axHandle,'XLim') get(axHandle,'YLim')];
                if minDistIndex<length(XData)
                    XData=[XData(1:minDistIndex) currentPoint(1,1)+sign(XData(minDistIndex+1)-XData(minDistIndex))*(cAxis(2)-cAxis(1))/10000 XData(minDistIndex+1:end)];
                    YData=[YData(1:minDistIndex) currentPoint(1,2)+sign(YData(minDistIndex+1)-YData(minDistIndex))*(cAxis(4)-cAxis(3))/10000 YData(minDistIndex+1:end)];
                elseif length(XData)>1
                    XData=[XData(1:minDistIndex) currentPoint(1,1)+sign(XData(minDistIndex)-XData(minDistIndex-1))*(cAxis(2)-cAxis(1))/10000 XData(minDistIndex+1:end)];
                    YData=[YData(1:minDistIndex) currentPoint(1,2)+sign(YData(minDistIndex)-YData(minDistIndex-1))*(cAxis(4)-cAxis(3))/10000 YData(minDistIndex+1:end)];
                else
                    XData=[XData(1:minDistIndex) currentPoint(1,1)];
                    YData=[YData(1:minDistIndex) currentPoint(1,2)];
                end
            elseif strcmpi(get(figHandle,'CurrentCharacter'),'r') && length(XData)>1 % 'r' pressed => remove a data point
                XData(minDistIndex)=[];
                YData(minDistIndex)=[];
            end
            % udate the line
            set(lineHandle,'XData',XData,'YData',YData);
            
            % if closest point was deleted, reposition mouse pointer to the next data point of the line
            % (usually this feels better than the closest point)
            if strcmpi(get(figHandle,'CurrentCharacter'),'r')
                % calculate the pixel-coordinates on the screen to reposition the mouse pointer
                cAxis=[get(axHandle,'XLim') get(axHandle,'YLim')];
                NewMouseX=axPixelPosition(1)+axPixelPosition(3)*(XData(min(minDistIndex,end))-cAxis(1))/(cAxis(2)-cAxis(1));
                NewMouseY=screenSize(4)-(axPixelPosition(2)+axPixelPosition(4)*(YData(min(minDistIndex,end))-cAxis(3))/(cAxis(4)-cAxis(3)));
                mouse.mouseMove(NewMouseX,NewMouseY);
            end
        end
    end

%% UpdatePixelCoords()
%  Nested function that is used to update axPixelPosition
    function UpdatePixelCoords()
        originalUnits=get(axHandle,'units');
        set(axHandle,'units','pixels')
        axPixelPosition=get(axHandle,'position');
        set(axHandle,'units',originalUnits)
        figFound=false;
        searchHandle=get(axHandle,'parent');
        while ~figFound % searching iteratively, because the axes might be a child of a uipanel
            originalUnits=get(searchHandle,'units');
            set(searchHandle,'units','pixels')
            tmpPos=get(searchHandle,'position');
            axPixelPosition(1:2)=axPixelPosition(1:2)+tmpPos(1:2); % only accumulating the lower left points (width/height is only needed for the axes itself)
            set(searchHandle,'units',originalUnits)

            if strcmp(get(searchHandle,'type'),'figure')
                figFound=true;
            else
                searchHandle=get(searchHandle,'parent');
            end
        end
    end
end