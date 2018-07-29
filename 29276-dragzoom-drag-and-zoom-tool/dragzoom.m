function dragzoom(varargin)
%DRAGZOOM Drag and zoom tool
%
% Description:
%   DRAGZOOM allows you to interactively manage the axes in figure.
%   This simple function for usable draging and zooming of axes, using the 
%   mouse and the keyboard shortcuts.
%
%   - Supported 2D-Plots, 3D-plots, semilogx-plots, semilogy-plots, loglog-plots and Images;
%   - Supported subplots (mixed axes).
%
%
% Using:
%   dragzoom()
%   dragzoom(hFig)
%   dragzoom(hAx)
%   dragzoom(hAxes)
%   dragzoom(hFig, status)
%   dragzoom(status)
%
%
% Input:
%   hObj -- Figure or axes handle or array of axes handles
%   status -- 'on' or 'off'
%
%
% Control Enable Status of DRAGZOOM:
%   dragzoom(hFig, 'on') 	: Enable DRAGZOOM for figure "hFig"
%   dragzoom(hFig, 'off') 	: Disable DRAGZOOM for figure "hFig"
%   dragzoom('on')          : Enable DRAGZOOM for figure "GCF"
%   dragzoom('off')         : Disable DRAGZOOM for figure "GCF"
%
%
% Interactive mode:
%   Available the following actions:
% 
%   Mouse actions in 2D mode:
%   Normal mode:
%       single-click and holding LB : Activation Drag mode
%       single-click and holding RB : Activation Rubber Band for region zooming
%       single-click MB             : Activation 'Extend' Zoom mode
%       scroll wheel MB             : Activation Zoom mode
%       double-click LB, RB, MB     : Reset to Original View
% 
%   Magnifier mode:
%       single-click LB             : Not Used
%       single-click RB             : Not Used
%       single-click MB             : Reset Magnifier to Original View
%       scroll MB                   : Change Magnifier Zoom
%       double-click LB             : Increase Magnifier Size
%       double-click RB             : Decrease Magnifier Size
% 
%   Hotkeys in 2D mode:
%       '+'                         : Zoom plus
%       '-'                         : Zoom minus
%       '0'                         : Set default axes (reset to original view)
%       'uparrow'                   : Up or down (inrerse) drag
%       'downarrow'                 : Down or up (inverse) drag
%       'leftarrow'                 : Left or right (inverse) drag
%       'rightarrow'                : Right or left (inverse) drag
%       'c'                         : On/Off Pointer Symbol 'fullcrosshair'
%       'g'                         : On/Off Axes Grid
%       'x'                         : If pressed and holding, zoom and drag works only for X axis
%       'y'                         : If pressed and holding, zoom and drag works only for Y axis
%       'm'                         : If pressed and holding, Magnifier mode on
%       'l'                         : On/Off Synchronize XY manage of 2-D axes 
%       'control+l'                 : On Synchronize X manage of 2-D axes 
%       'alt+l'                     : On Synchronize Y manage of 2-D axes 
%       's'                         : On/Off Smooth Plot (Experimental)
% 
%   Mouse actions in 3D mode:
%       single-click and holding LB : Activation Drag mode
%       single-click and holding MB : Activation 'Extend' Zoom mode
%       single-click and holding RB : Activation Rotate mode
%       scroll wheel MB             : Activation Zoom mode
%       double-click LB, RB, MB     : Reset to Original View
% 
%   Hotkeys in 3D mode:
%       '+'                         : Zoom plus
%       '-'                         : Zoom minus  
%       '0'                         : Set default axes (reset to original view)
%       'uparrow'                   : Rotate up-down
%       'downarrow'                 : Rotate down-up
%       'leftarrow'                 : Rotate left-right
%       'rightarrow'                : Rotate right-left
%       'ctrl'+'uparrow'            : Up or down (inrerse) drag
%       'ctrl'+'downarrow'          : Down or up (inverse) drag
%       'ctrl'+'leftarrow'          : Left or right (inverse) drag
%       'ctrl'+'rightarrow'         : Right or left (inverse) drag
%       '1'                         : Go to X-Y view
%       '2'                         : Go to X-Z view
%       '3'                         : Go to Y-Z view
%       'v'                         : On/Off Visible Axes
%       'f'                         : On/Off Fixed Aspect Ratio
%       'g'                         : On/Off Axes Grid
% 
%
% Example:
%   x = -pi:0.1:pi;
%   y = sin(x);
%   figure; plot(x, y);
%   dragzoom
%
% Example:
%   I = imread('cameraman.tif');
%   figure; imshow(I, []);
%   dragzoom
%
% Example:
%   figure;
%   x = -pi*2:0.1:pi*2;
%   y1 = sin(x);
%   y2 = cos(x);
%   subplot(2,1,1); plot(x,y1, '.-r')
%   title('Income')
%   subplot(2,1,2); plot(x, y2, 'o-b')
%   title('Outgo')
%   dragzoom;
%
% Example:
%   figure;
%   x = -pi*2:0.1:pi*2;
%   y1 = sin(x);
%   y2 = cos(x);
%   hax1 = subplot(2,1,1); plot(hax1, x, y1, '.-r')
%   hax2 = subplot(2,1,2); plot(hax2, x, y2, 'o-b')
%   dragzoom(hax1); % manage only axes 1
%
% Example:
%   figure;
%   x = -pi*2:0.1:pi*2;
%   y1 = sin(x);
%   y2 = cos(x);
%   hax1 = subplot(2,1,1); plot(hax1, x, y1, '.-r')
%   hax2 = subplot(2,1,2); plot(hax2, x, y2, 'o-b')
%   dragzoom([hax1, hax2]); % manage axes 1 and axes 2
%
% Example:
%   figure;
%   k = 5;
%   n = 2^k-1;
%   [x,y,z] = sphere(n);
%   surf(x,y,z);
%   dragzoom;
%
% Example:
%   x = 0:100;
%   y = log10(x);
%   figure;
%   semilogx(x, y, '*-b')
%   dragzoom;
%
%
% See Also PAN, ZOOM, PANZOOM, ROTATE3D
%

% -------------------------------------------------------------------------
%   Version   : 0.9.7
%   Author    : Evgeny Pr aka iroln <esp.home@gmail.com>
%   Created   : 10.07.10
%   Updated   : 05.06.11
%
%   Copyright : Evgeny Pr (c) 2010-2011
% -------------------------------------------------------------------------

%TODO: Show Pixel Info (Pixel Value(s)) for Images
%TODO: "Sticking to Data" PointerCross

error(nargchk(0, 2, nargin));


% handles
hFig = [];
hAx = [];
hAxes = [];

% variables
mOrigFigName = [];
mOrigCallbacks = [];
mAxesInfo = [];
mDragStartX = [];
mDragStartY = [];
mDragKeysX = [];
mDragKeysY = [];
mDragShiftStep = [];
mDragSaveShiftStep = [];
mDragShiftStepInc = [];
mDragSave3DShiftStep = [];
mDrag3DShiftStep = [];
mZoomScroll = [];
mZoomMinPow = [];
mZoomMaxPow = [];
mZoomNum = [];
mZoomExtendNum = [];
mZoomKeysNum = [];
mZoom3DExtendNum = [];
mZoom3DKeysNum = [];
mZoom3DIndex = [];
mDefaultZoomGrid = [];
mDefaultZoomSteps = [];
mZoomGrid = [];
mZoomSteps = [];
mZoomIndexX = [];
mZoomIndexY = [];
mZoom3DStartX = [];
mZoom3DStartY = [];
mZoom3DBindX = [];
mZoom3DBindY = [];
mDefaultXLim = [];
mDefaultYLim = [];
mDefaultAxPos = [];
mRotStartAZ = [];
mRotStartEL = [];
mRotStartX = [];
mRotStartY = [];
mRot3DKeysInc = [];
mPointerCross = [];
mRubberBand = [];
mRbEdgeColor = [];
mRbFaceColor = [];
mRbFaceAlpha = [];
mMagnifier = [];
mMgSize = [];
mMgMinSize = [];
mMgMaxSize = [];
mMgZoom = [];
mMgMinZoom = [];
mMgMaxZoom = [];
mMgLinesWidth = [];
mMgShadow = [];
mMgSizeStep = [];
mMgZoomStep = [];
mMgDirection = [];
mLinkOpt = 'xy';

% flags
fIsEnabled = false;
fIsSelectedCurrentAxes = true;
fIsDragAllowed = false;
fIsZoomExtendAllowed = false;
fIsZoomExtend3DAllowed = false;
fIsRotate3DAllowed = false;
fIsRubberBandOn = false;
fIsPointerCross = false;
fIsAxesGrid = false;
fIsSmoothing = false;
fIsEnableDragX = true;
fIsEnableDragY = true;
fIsEnableZoomX = true;
fIsEnableZoomY = true;
fIsAxes2D = false;
fIsImage = false;
fIsMagnifierOn = false;
fIsLinkAxesOn = false;
fIsEnableControl = false;
fIsMouseOnLegend = false;


% Initialize and Setup
Initialize(varargin{:})
%--------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%==========================================================================
    function Setup()
        %Setup setup options
        
        % Drag Options
        mDragKeysX = 'normal';      % 'normal', 'reverse'
        mDragKeysY = 'normal';      % 'normal', 'reverse'
        mDragShiftStep = 3;         % step dragging on keys
        mDragShiftStepInc = 1;      % increase speed dragging on keys
        mDrag3DShiftStep = 10;      % step dragging 3D on keys
        
        % Zoom Options
        mZoomScroll = 'normal';     % 'normal', 'reverse'
        mZoomMinPow = 0;            % min zoom percent 10 ^ mZoomMinPow
        mZoomMaxPow = 5;            % max zoom perzent 10 ^ mZoomMaxPow
        mZoomNum = 51;              % count steps of log zoom grid
        mZoomExtendNum = 301;       % count steps of log grid zoom extend for 2D
        mZoomKeysNum = 181;         % count steps of log grid zoom for keys for 2D
        mZoom3DExtendNum = 201;     % count steps of log grid zoom extend for 3D
        mZoom3DKeysNum = 181;       % count steps of log grid zoom for keys for 3D
        
        % Rubber Band Options
        mRbEdgeColor = 'k';         % rubber band edge color
        mRbFaceColor = 'none';      % rubber band face color
        mRbFaceAlpha = 1;           % rubber band face alpha (transparency)
        
        % Magnifier Options
        mMgSize = 100;              % default size of magnifier (pixels)
        mMgMinSize = 50;            % min size of magnifier
        mMgMaxSize = 200;           % max size of magnifier
        mMgZoom = 2;                % default zoom on magnifier
        mMgMinZoom = 1;             % min zoom on magnifier
        mMgMaxZoom = 100;           % max zoom on magnifier
        mMgLinesWidth = 1;          % lines width on magnifier
        mMgShadow = 0.95;           % shadow area without magnifier
        mMgSizeStep = 15;           % step change in the magnifier size
        mMgZoomStep = 1.2;          % step change in the magnifier zoom
        
        % Rotate Options
        mRot3DKeysInc = 3;          % rotate increase for keys
    end
%--------------------------------------------------------------------------

%==========================================================================
    function Initialize(varargin)
        %Initialize initialize tool
        
        % Parse Input Arguments
        isWithStatus = ParseInputs(varargin{:});
        
        if isempty(hAxes), return; end
        
        hAx = hAxes(1);
        set(hFig, 'CurrentAxes', hAx);
        
        % setup tool
        Setup();
        
        % initialize tool
        UserData = get(hFig, 'UserData');
        
        if (isfield(UserData, 'axesinfo') && isWithStatus)
            mAxesInfo = UserData.axesinfo;
            mOrigCallbacks = UserData.origcallbacks;
            mOrigFigName = UserData.origfigname;
        else
            % first call dragzoom or call without enable status
            if ~isfield(UserData, 'origfigname')
                mOrigFigName = get(hFig, 'Name');
            end
            
            if isfield(UserData, 'origcallbacks')
                mOrigCallbacks = UserData.origcallbacks;
                SetOriginalCallbacks();
            end
            
            % save original callbacks
            SaveOriginalCallbacks();
            
            % get info about all axes and create axes info struct
            mAxesInfo = GetAxesInfo();
            
            % save initialize view for all axes
            for i = 1:numel(mAxesInfo)
                resetplotview(mAxesInfo(i).handle, 'InitializeCurrentView');
            end
            
            UserData.axesinfo = mAxesInfo;
            UserData.origcallbacks = mOrigCallbacks;
            UserData.origfigname = mOrigFigName;
            
            if ~isfield(UserData, 'tools')
                UserData.tools.pointercross = mPointerCross;
                UserData.tools.islinkaxeson = fIsLinkAxesOn;
            end
            
            set(hFig, 'UserData', UserData);    
        end
        
        DeleteOldTools();
        
        axi = GetCurrentAxesIndex();
        SetCurrentAxes(axi);
        SetDefaultZoomGrid();
        SetFigureName();
        
        mDragSaveShiftStep = mDragShiftStep;
        mDragSave3DShiftStep = mDrag3DShiftStep;
        
        % In case the figure will be saved
        set(hFig, 'CreateFcn', {@CreateFigureCallback});
        
        if fIsEnabled
            SetCallbacks();
        else
            SetOriginalCallbacks();
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function SaveOriginalCallbacks()
        %SaveOriginalCallbacks
        
        mOrigCallbacks.window_button_down_fcn   = get(hFig, 'WindowButtonDownFcn');
        mOrigCallbacks.window_button_up_fcn     = get(hFig, 'WindowButtonUpFcn');
        mOrigCallbacks.window_button_motion_fcn = get(hFig, 'WindowButtonMotionFcn');
        mOrigCallbacks.window_scroll_whell_fcn  = get(hFig, 'WindowScrollWheelFcn');
        mOrigCallbacks.window_key_press_fcn     = get(hFig, 'WindowKeyPressFcn');
        mOrigCallbacks.window_key_release_fcn   = get(hFig, 'WindowKeyReleaseFcn');
        mOrigCallbacks.create_fcn               = get(hFig, 'CreateFcn');
    end
%--------------------------------------------------------------------------

%==========================================================================
    function SetOriginalCallbacks()
        %SetOriginalCallbacks
        
        set(hFig, ...
            'WindowButtonDownFcn',      mOrigCallbacks.window_button_down_fcn, ...
        	'WindowButtonUpFcn',        mOrigCallbacks.window_button_up_fcn, ...
        	'WindowButtonMotionFcn',    mOrigCallbacks.window_button_motion_fcn, ...
        	'WindowScrollWheelFcn',     mOrigCallbacks.window_scroll_whell_fcn, ...
        	'WindowKeyPressFcn',        mOrigCallbacks.window_key_press_fcn, ...
        	'WindowKeyReleaseFcn',      mOrigCallbacks.window_key_release_fcn, ...
        	'CreateFcn',                mOrigCallbacks.create_fcn);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function SetCallbacks()
        %SetCallbacks
        
        if fIsAxes2D
            % 2D mode
            SetFigureCallbacks2D();
        else
            % 3D mode
            SetFigureCallbacks3D();
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function SetFigureCallbacks2D()
        %SetFigureCallbacks2D set callback-functions for processing figure events in mode 2D
        
        set(hFig, ...
            'WindowButtonDownFcn',      {@WindowButtonDownCallback2D}, ...
            'WindowButtonUpFcn',        {@WindowButtonUpCallback2D}, ...
            'WindowButtonMotionFcn',    {@WindowButtonMotionCallback2D}, ...
            'WindowScrollWheelFcn',     {@WindowScrollWheelFcn2D}, ...
            'WindowKeyPressFcn',        {@WindowKeyPressCallback2D}, ...
            'WindowKeyReleaseFcn',      {@WindowKeyReleaseCallback2D});
    end
%--------------------------------------------------------------------------

%==========================================================================
    function SetFigureCallbacks3D()
        %SetFigureCallbacks3D set callback-functions for processing figure events in mode 3D
        
        set(hFig, ...
            'WindowButtonDownFcn',      {@WindowButtonDownCallback3D}, ...
            'WindowButtonUpFcn',        {@WindowButtonUpCallback3D}, ...
            'WindowButtonMotionFcn',    {@WindowButtonMotionCallback3D}, ...
            'WindowScrollWheelFcn',     {@WindowScrollWheelFcn3D}, ...
            'WindowKeyPressFcn',        {@WindowKeyPressCallback3D}, ...
            'WindowKeyReleaseFcn',      {@WindowKeyReleaseCallback3D});
    end
%--------------------------------------------------------------------------

%==========================================================================
    function WindowButtonDownCallback2D(src, evnt)    %#ok
        %WindowButtonDownCallback2D
        
        if fIsMouseOnLegend, return; end
        
        clickType = get(src, 'SelectionType');
        
        switch clickType
            case 'normal'
                DragMouseBegin();
                mMgDirection = 'plus';
            case 'open'
                if fIsMagnifierOn
                    MagnifierSizeChange(mMgDirection);
                else
                    ResetAxesToOrigView();
                end
            case 'alt'
                RubberBandBegin();
                mMgDirection = 'minus';
            case 'extend'
                if fIsMagnifierOn
                    MagnifierReset();
                else
                    ZoomMouseExtendBegin();
                end
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function WindowButtonUpCallback2D(src, evnt)      %#ok
        %WindowButtonUpCallback2D
        
        DragMouseEnd();
        ZoomMouseExtendEnd();
        RubberBandEnd();
    end
%--------------------------------------------------------------------------

%==========================================================================
    function WindowButtonMotionCallback2D(src, evnt)  %#ok
        %WindowButtonMotionCallback2D
                
        if ~(fIsMagnifierOn || fIsDragAllowed || fIsRubberBandOn)
            % set current axes under cursor
            SelectAxesUnderCursor();
        end
        
        if fIsEnableControl
            DragMouse();
            RubberBandUpdate();
            MagnifierUpdate();
        end
        
        ZoomMouseExtend();
        PointerCrossUpdate();
    end
%--------------------------------------------------------------------------

%==========================================================================
    function WindowScrollWheelFcn2D(src, evnt)        %#ok
        %WindowScrollWheelFcn2D
        
        if fIsMouseOnLegend, return; end
        
        % Update Zoom Info
        % because it can be changed function 'zoom'
        UpdateCurrentZoomAxes();
        
        switch mZoomScroll
            case 'normal'
                directions = {'minus', 'plus'};
            case 'reverse'
                directions = {'plus', 'minus'};
        end
        
        verScrollCount = evnt.VerticalScrollCount;
        
        if (verScrollCount > 0)
            direction = directions{1};
        elseif (verScrollCount < 0)
            direction = directions{2};
        else
            return;
        end
        
        % if fIsEnableControl
        ZoomMouse(direction);
        PointerCrossUpdate();
        % end
        MagnifierZoomChange(direction);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function WindowKeyPressCallback2D(src, evnt)      %#ok
        %WindowKeyPressCallback2D
        
        modifier = evnt.Modifier;
        
        switch evnt.Key
            case '0'
                ResetAxesToOrigView();
            case {'equal', 'add'}
                ZoomKeys('plus');
            case {'hyphen', 'subtract'}
                ZoomKeys('minus');
            case 'leftarrow'
                DragKeys('left');
            case 'rightarrow'
                DragKeys('right');
            case 'uparrow'
                DragKeys('up');
            case 'downarrow'
                DragKeys('down');
            case 'c'
                SetPointerCrossKeys();
            case 'g'
                SetAxesGridKeys();
            case 'x'
                DragEnable('y', 'off');
                ZoomEnable('y', 'off');
            case 'y'
                DragEnable('x', 'off');
                ZoomEnable('x', 'off');
            case 'm'
                if fIsEnableControl
                    MagnifierOn();
                end
            case 'l'
                SetLinkAxesKeys(modifier);
            case 's'
                % smooth plot
                SetSmoothKeys();
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function WindowKeyReleaseCallback2D(src, evnt)    %#ok
        %WindowKeyReleaseCallback2D
        
        switch evnt.Key
            case {'leftarrow', 'rightarrow', 'uparrow', 'downarrow'}
                mDragShiftStep = mDragSaveShiftStep;
            case 'x'
                DragEnable('y', 'on');
                ZoomEnable('y', 'on');
            case 'y'
                DragEnable('x', 'on');
                ZoomEnable('x', 'on');
            case 'm'
                MagnifierOff();
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function WindowButtonDownCallback3D(src, evnt)    %#ok
        %WindowButtonDownCallback3D
        
        if fIsMouseOnLegend, return; end
        
        clickType = get(src, 'SelectionType');
        
        switch clickType
            case 'normal'
                DragMouseBegin3D();
            case 'open'
                ResetAxesToOrigView3D();
            case 'alt'
                RotateMouseBegin3D();
            case 'extend'
                ZoomMouseExtendBegin3D();
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function WindowButtonUpCallback3D(src, evnt)    %#ok
        %WindowButtonUpCallback3D
                
        DragMouseEnd3D();
        ZoomMouseExtendEnd3D();
        RotateMouseEnd3D();
    end
%--------------------------------------------------------------------------

%==========================================================================
    function WindowButtonMotionCallback3D(src, evnt)    %#ok
        %WindowButtonMotionCallback3D
                
        if ~(fIsDragAllowed || fIsZoomExtend3DAllowed || fIsRotate3DAllowed)
            SelectAxesUnderCursor();
        end
        
        if fIsEnableControl
            DragMouse3D();
            RotateMouse3D();
        end
        ZoomMouseExtend3D();
    end
%--------------------------------------------------------------------------

%==========================================================================
    function WindowScrollWheelFcn3D(src, evnt)    %#ok
        %WindowScrollWheelFcn3D
        
        if fIsMouseOnLegend, return; end
        
        UpdateCurrentZoomAxes3D();
        
        switch mZoomScroll
            case 'normal'
                directions = {'minus', 'plus'};
            case 'reverse'
                directions = {'plus', 'minus'};
        end
        
        verScrollCount = evnt.VerticalScrollCount;
        
        if (verScrollCount > 0)
            direction = directions{1};
        elseif (verScrollCount < 0)
            direction = directions{2};
        else
            return;
        end
        
        % if fIsEnableControl
        ZoomMouse3D(direction);
        % end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function WindowKeyPressCallback3D(src, evnt)    %#ok
        %WindowKeyPressCallback3D
        
        isModifier = ~isempty(intersect(evnt.Modifier, {'control', 'command'}));
        
        switch evnt.Key
            case {'equal', 'add'}
                ZoomKeys3D('plus');
            case {'hyphen', 'subtract'}
                ZoomKeys3D('minus');
            case 'leftarrow'
                if isModifier
                    DragKeys3D('left');
                else
                    RotateKeys3D('az-');
                end
            case 'rightarrow'
                if isModifier
                    DragKeys3D('right');
                else
                    RotateKeys3D('az+');
                end
            case 'uparrow'
                if isModifier
                    DragKeys3D('up');
                else
                    RotateKeys3D('el-');
                end
            case 'downarrow'
                if isModifier
                    DragKeys3D('down');
                else
                    RotateKeys3D('el+');
                end
            case '0'
                ResetAxesToOrigView3D();
            case '1'
                RotateKeys3D('xy');
            case '2'
                RotateKeys3D('xz');
            case '3'
                RotateKeys3D('yz');
            case 'v'
                VisibleAxesKeys3D();
            case 'f'
                SwitchAspectRatioKeys3D()
            case 'g'
                SetAxesGridKeys();
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function WindowKeyReleaseCallback3D(src, evnt)    %#ok
        %WindowKeyReleaseCallback3D
        
        switch evnt.Key
            case {'equal', 'add', 'hyphen', 'subtract'}
                SetDefaultZoomGrid3D();
            case {'leftarrow', 'rightarrow', 'uparrow', 'downarrow'}
                mDrag3DShiftStep = mDragSave3DShiftStep;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function CreateFigureCallback(src, evnt)    %#ok
        %CreateFigureCallback
        
        hFig = src;
        
        UserData = get(hFig, 'UserData');
        mAxesInfo = UserData.axesinfo;
        mOrigCallbacks = UserData.origcallbacks;
        mOrigFigName = UserData.origfigname;
        hAxes = arrayfun(@(x) x.handle, mAxesInfo);
        
        axi = GetCurrentAxesIndex();
        SetCurrentAxes(axi)
        DeleteOldTools();
    end
%--------------------------------------------------------------------------

%==========================================================================
    function SetFigureName()
        %SetFigureName Set Name of Figure
        
        enableStatus = 'off';
        if fIsEnabled
            enableStatus = 'on';
        end
        
        syncMode = 'Normal';
        if fIsLinkAxesOn
            syncMode = sprintf('Synchronized %s', upper(mLinkOpt));
        end
        
        sep = '';
        if ~isempty(mOrigFigName)
            sep = ':';
        end
        
        newName = sprintf('[DRAGZOOM : "%s" (%s)]%s %s', ...
            enableStatus, syncMode, sep, mOrigFigName);
        set(hFig, 'Name', newName)
    end
%--------------------------------------------------------------------------

%==========================================================================
    function DragMouseBegin()
        %DragMouseBegin begin draging
        
        if (~fIsDragAllowed && ~fIsMagnifierOn)
            [cx, cy] = GetCursorCoordOnWindow();
            
            mDragStartX = cx;
            mDragStartY = cy;
            
            fIsDragAllowed = true;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function DragMouseEnd()
        %DragMouseEnd end draging

        if fIsDragAllowed
            fIsDragAllowed = false;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function DragMouse()
        %DragMouse

        if fIsDragAllowed
            [cx, cy] = GetCursorCoordOnWindow();
            
            pdx = mDragStartX - cx;
            pdy = mDragStartY - cy;
            
            mDragStartX = cx;
            mDragStartY = cy;
            
            DragAxes(pdx, pdy);
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function DragKeys(direction)
        %DragKeys
        
        dx = mDragShiftStep;
        dy = mDragShiftStep;
        
        % Increment of speed when you hold the button
        mDragShiftStep = mDragShiftStep + mDragShiftStepInc;
        
        directionsX = {'right', 'left'};
        directionsY = {'down', 'up'};
        
        switch mDragKeysX
            case 'normal'
            case 'reverse'
                directionsX = fliplr(directionsX);
        end
        switch mDragKeysY
            case 'normal'
            case 'reverse'
                directionsY = fliplr(directionsY);
        end
        
        switch direction
            case directionsX{1}
                DragAxes(-dx, 0);
            case directionsX{2}
                DragAxes(dx, 0);
            case directionsY{1}
                DragAxes(0, dy);
            case directionsY{2}
                DragAxes(0, -dy);
        end
        
        PointerCrossUpdate();
    end
%--------------------------------------------------------------------------

%==========================================================================
    function DragAxes(pdx, pdy)
        %DragAxes
        
        [xLim, yLim] = GetAxesLimits();
        
        pos = GetObjPos(hAx, 'Pixels');
        pbar = get(hAx, 'PlotBoxAspectRatio');
        
        %NOTE: MATLAB Bug?
        % Fixed problem with AspectRatio and Position of Axes
        % MATLAB Function PAN is not correct works with rectangular images!
        % Here it is correctly.
        
        imAspectRatioX = pbar(2) / pbar(1);
        if (imAspectRatioX ~= 1)
            posAspectRatioX = pos(3) / pos(4);
            arFactorX = imAspectRatioX * posAspectRatioX;
            if (arFactorX < 1)
                arFactorX = 1;
            end
        else
            arFactorX = 1;
        end
        
        imAspectRatioY = pbar(1) / pbar(2);
        if (imAspectRatioY ~= 1)
            posAspectRatioY = pos(4) / pos(3);
            arFactorY = imAspectRatioY * posAspectRatioY;
            if (arFactorY < 1)
                arFactorY = 1;
            end
        else
            arFactorY = 1;
        end
        
        if fIsEnableDragX
            % For log plots, transform to linear scale
            if strcmp(get(hAx, 'xscale'), 'log')
                xLim = log10(xLim);
                xLim = FixInfLogLimits('x', xLim);
                isXLog = true;
            else
                isXLog = false;
            end
            
            dx = pdx * range(xLim) / (pos(3) / arFactorX);
            xLim = xLim + dx;
            
            % For log plots, untransform limits
            if isXLog
                xLim = 10.^(xLim);
            end
        end
        if fIsEnableDragY
            if strcmp(get(hAx, 'yscale'), 'log')
                yLim = log10(yLim);
                yLim = FixInfLogLimits('y', yLim);
                isYLog = true;
            else
                isYLog = false;
            end
            
            dy = pdy * range(yLim) / (pos(4) / arFactorY);
            
            if fIsImage
                yLim = yLim - dy; 
            else
                yLim = yLim + dy; 
            end
            
            if isYLog
                yLim = 10.^(yLim);
            end
        end
        
        SetAxesLimits(xLim, yLim);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function DragMouseBegin3D()
        %DragMouseBegin3D
        
        if ~fIsDragAllowed
            [wcx, wcy] = GetCursorCoordOnWindow('pixels');
            
            mDragStartX = wcx;
            mDragStartY = wcy;
            
            fIsDragAllowed = true;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function DragMouseEnd3D()
        %DragMouseEnd3D
        
        if fIsDragAllowed
            fIsDragAllowed = false;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function DragMouse3D()
        %DragMouse3D
        
        if fIsDragAllowed
            [wcx, wcy] = GetCursorCoordOnWindow('pixels');
            
            dx = mDragStartX - wcx;
            dy = mDragStartY - wcy;
            
            DragAxes3D(dx, dy);
            
            mDragStartX = wcx;
            mDragStartY = wcy;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function DragKeys3D(direction)
        %DragKeys3D
        
        dx = mDrag3DShiftStep;
        dy = mDrag3DShiftStep;
        
        mDrag3DShiftStep = mDrag3DShiftStep + mDragShiftStepInc;
        
        directionsX = {'right', 'left'};
        directionsY = {'down', 'up'};
        
        switch mDragKeysX
            case 'normal'
            case 'reverse'
                directionsX = fliplr(directionsX);
        end
        switch mDragKeysY
            case 'normal'
            case 'reverse'
                directionsY = fliplr(directionsY);
        end
        
        switch direction
            case directionsX{1}
                DragAxes3D(-dx, 0);
            case directionsX{2}
                DragAxes3D(dx, 0);
            case directionsY{1}
                DragAxes3D(0, dy);
            case directionsY{2}
                DragAxes3D(0, -dy);
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function DragAxes3D(dx, dy)
        %DragAxes3D
        
        axPos = GetObjPos(hAx, 'pixels');
        
        axPos(1) = axPos(1) - dx;
        axPos(2) = axPos(2) - dy;
        
        SetObjPos(hAx, axPos, 'pixels');
    end
%--------------------------------------------------------------------------

%==========================================================================
    function DragEnable(ax, action)
        %DragEnable
        
        switch lower(action)
            case 'on'
                tf = true;
            case 'off'
                tf = false;
        end
                
        switch lower(ax)
            case 'x'
                fIsEnableDragX = tf;
            case 'y'
                fIsEnableDragY = tf;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function ZoomEnable(ax, action)
        %ZoomEnable
        
        switch lower(action)
            case 'on'
                tf = true;
            case 'off'
                tf = false;
        end
                
        switch lower(ax)
            case 'x'
                fIsEnableZoomX = tf;
            case 'y'
                fIsEnableZoomY = tf;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function ZoomMouse(direction)
        %ZoomMouse zooming axes with mouse
        
        if (IsZoomMouseAllowed && ~fIsMagnifierOn)
            [acx, acy] = GetCursorCoordOnAxes();
            ZoomAxes(direction, acx, acy)
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function ZoomMouseExtendBegin()
        %ZoomMouseExtendBegin
        
        if ~fIsZoomExtendAllowed
            UpdateCurrentZoomAxes();
            
            % set new zoom grid for extend zoom
            [mZoomGrid, mZoomSteps] = ZoomLogGrid(mZoomMinPow, mZoomMaxPow, mZoomExtendNum);
            UpdateCurrentZoomAxes();
            
            [wcx, wcy] = GetCursorCoordOnWindow('pixels');
            [acx, acy] = GetCursorCoordOnAxes();
            
            mZoom3DStartX = wcx;
            mZoom3DStartY = wcy;
            
            mZoom3DBindX = acx;
            mZoom3DBindY = acy;
            
            fIsZoomExtendAllowed = true;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function ZoomMouseExtendEnd()
        %ZoomMouseExtendEnd
        
        if fIsZoomExtendAllowed
            % set default zoom grid
            SetDefaultZoomGrid();
            fIsZoomExtendAllowed = false;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function ZoomMouseExtend()
        %ZoomMouseExtend
        
        if fIsZoomExtendAllowed
            directions = {'minus', 'plus'};
            
            switch mZoomScroll
                case 'normal'
                case 'reverse'
                    directions = fliplr(directions);
            end
        
            % Heuristic for pixel change to camera zoom factor 
            % (taken from function ZOOM)
            [wcx, wcy] = GetCursorCoordOnWindow('pixels');
            
            xy(1) = wcx - mZoom3DStartX;
            xy(2) = wcy - mZoom3DStartY;
            q = max(-0.9, min(0.9, sum(xy)/70)) + 1;
   
            if (q < 1)
                direction = directions{1};
            elseif (q > 1)
                direction = directions{2};
            else
                return;
            end
            
            ZoomAxes(direction, mZoom3DBindX, mZoom3DBindY)
            
            mZoom3DStartX = wcx;
            mZoom3DStartY = wcy;            
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function ZoomKeys(direction)
        %ZoomKeys zooming axes with keyboard
        
        UpdateCurrentZoomAxes();
        
        [mZoomGrid, mZoomSteps] = ZoomLogGrid(mZoomMinPow, mZoomMaxPow, mZoomKeysNum);
        UpdateCurrentZoomAxes();
        
        [acx, acy] = GetCursorCoordOnAxes();
        
        ZoomAxes(direction, acx, acy)
        PointerCrossUpdate();
        SetDefaultZoomGrid();
    end
%--------------------------------------------------------------------------

%==========================================================================
    function ZoomAxes(direction, cx, cy)
        %ZoomAxes Zoom axes in 2D and image modes
        
        [xLim, yLim] = GetAxesLimits();
        
        if fIsImage
            mZoomIndexX = ChangeZoomIndex(direction, mZoomIndexX);
            mZoomIndexY = mZoomIndexX;
            zoomPct = GetZoomPercent(mZoomIndexX);
            
            xLim = RecalcZoomAxesLimits('x', xLim, mDefaultXLim, cx, zoomPct);
            yLim = RecalcZoomAxesLimits('y', yLim, mDefaultYLim, cy, zoomPct);            
        else
            if fIsEnableZoomX
                mZoomIndexX = ChangeZoomIndex(direction, mZoomIndexX);
                zoomPct = GetZoomPercent(mZoomIndexX);
                
                xLim = RecalcZoomAxesLimits('x', xLim, mDefaultXLim, cx, zoomPct);
            end
            if fIsEnableZoomY
                mZoomIndexY = ChangeZoomIndex(direction, mZoomIndexY);
                zoomPct = GetZoomPercent(mZoomIndexY);
                
                yLim = RecalcZoomAxesLimits('y', yLim, mDefaultYLim, cy, zoomPct);
            end
        end
        
        SetAxesLimits(xLim, yLim);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function zoomPct = GetZoomPercent(zoomIndex, zoomGrid)
        %GetZoomPercent get zoom percent

        if (nargin < 2)
            zoomGrid = mZoomGrid;
        end
        
        zoomPct = zoomGrid(zoomIndex);       
    end
%--------------------------------------------------------------------------

%==========================================================================
    function zoomIndex = ChangeZoomIndex(direction, zoomIndex, zoomSteps)
        %ChangeZoomIndex
        
        if (nargin < 3)
            zoomSteps = mZoomSteps;
        end
        
        switch direction
            case 'plus'
                if (zoomIndex < zoomSteps)
                    zoomIndex = zoomIndex + 1;
                end
            case 'minus'
                if (zoomIndex > 1)
                    zoomIndex = zoomIndex - 1;
                end
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function axLim = RecalcZoomAxesLimits(ax, axLim, axLimDflt, zcCrd, zoomPct)
        %RecalcZoomAxesLimits recalc axes limits
        
        if strcmp(get(hAx, [ax, 'scale']), 'log')
            axLim = log10(axLim);
            axLim = FixInfLogLimits(ax, axLim);
            axLimDflt = log10(axLimDflt);
            zcCrd = log10(zcCrd);
            isLog = true;
        else
            isLog = false;
        end
                
        if (zcCrd < axLim(1)), zcCrd = axLim(1); end
        if (zcCrd > axLim(2)), zcCrd = axLim(2); end
        
        rf = range(axLim);
        ra = range([axLim(1), zcCrd]);
        rb = range([zcCrd, axLim(2)]);
        
        cfa = ra / rf; 
        cfb = rb / rf;
        
        newRange = range(axLimDflt) * 100 / zoomPct;
        dRange = newRange - rf;
        
        axLim(1) = axLim(1) - dRange * cfa;
        axLim(2) = axLim(2) + dRange * cfb;
        
        if isLog
            axLim = 10.^axLim;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function UpdateCurrentZoomAxes()
        %UpdateCurrentZoomAxes
        
        [xLim, yLim] = GetAxesLimits();
        [curentZoomX, curentZoomY] = GetCurrentZoomAxesPercent(xLim, yLim);
        
        if (curentZoomX ~= GetZoomPercent(mZoomIndexX))
            [nu, mZoomIndexX] = min(abs(mZoomGrid - curentZoomX));  %#ok ([~, ...])
        end
        if (curentZoomY ~= GetZoomPercent(mZoomIndexY))
            [nu, mZoomIndexY] = min(abs(mZoomGrid - curentZoomY));  %#ok ([~, ...])
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function [curentZoomX, curentZoomY] = GetCurrentZoomAxesPercent(xLim, yLim)
        %GetCurrentZoomAxesPercent
        
        if strcmp(get(hAx, 'xscale'), 'log')
            xLim = log10(xLim);
            defaultXLim = log10(mDefaultXLim);
        else
            defaultXLim = mDefaultXLim;
        end
        if strcmp(get(hAx, 'yscale'), 'log')
            yLim = log10(yLim);
            defaultYLim = log10(mDefaultYLim);
        else
            defaultYLim = mDefaultYLim;
        end
        
        curentZoomX = range(defaultXLim) * 100 / range(xLim);
        curentZoomY = range(defaultYLim) * 100 / range(yLim);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function ZoomMouse3D(direction)
        %ZoomMouse3D
        
        if IsZoomMouseAllowed
            [wcx, wcy] = GetCursorCoordOnWindow('pixels');
            ZoomAxes3D(direction, wcx, wcy)
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function ZoomMouseExtendBegin3D()
        %ZoomMouseExtendBegin3D
        
        if ~fIsZoomExtend3DAllowed
            UpdateCurrentZoomAxes3D();
            [wcx, wcy] = GetCursorCoordOnWindow('pixels');
            
            % set new zoom grid for extend zoom
            SetNewZoomGrid3D(mZoomMinPow, mZoomMaxPow, mZoom3DExtendNum);
            
            mZoom3DStartX = wcx;
            mZoom3DStartY = wcy;
            
            mZoom3DBindX = wcx;
            mZoom3DBindY = wcy;
            
            fIsZoomExtend3DAllowed = true;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function ZoomMouseExtendEnd3D()
        %ZoomMouseExtendEnd3D
        
        if fIsZoomExtend3DAllowed
            SetDefaultZoomGrid3D();
            
            fIsZoomExtend3DAllowed = false;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function ZoomMouseExtend3D()
        %ZoomMouseExtended3D
        
        if fIsZoomExtend3DAllowed
            directions = {'minus', 'plus'};
            
            switch mZoomScroll
                case 'normal'
                case 'reverse'
                    directions = fliplr(directions);
            end
        
            % Heuristic for pixel change to camera zoom factor 
            % (taken from function ZOOM)
            [wcx, wcy] = GetCursorCoordOnWindow('pixels');
            
            xy(1) = wcx - mZoom3DStartX;
            xy(2) = wcy - mZoom3DStartY;
            q = max(-0.9, min(0.9, sum(xy)/70)) + 1;
   
            if (q < 1)
                direction = directions{1};
            elseif (q > 1)
                direction = directions{2};
            else
                return;
            end
            
            ZoomAxes3D(direction, mZoom3DBindX, mZoom3DBindY)
            
            mZoom3DStartX = wcx;
            mZoom3DStartY = wcy;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function ZoomAxes3D(direction, cx, cy)
        %ZoomAxes3D
        
        mZoom3DIndex = ChangeZoomIndex(direction, mZoom3DIndex, mZoomSteps);
        zoomPct = GetZoomPercent(mZoom3DIndex, mZoomGrid);
        
        axPos = GetObjPos(hAx, 'pixels');
        
        [axPos(1), axPos(3)] = RecalcZoomAxesPos3D(axPos(1), axPos(3), ...
            mDefaultAxPos(3), cx, zoomPct);
        
        [axPos(2), axPos(4)] = RecalcZoomAxesPos3D(axPos(2), axPos(4), ...
            mDefaultAxPos(4), cy, zoomPct);
        
        SetObjPos(hAx, axPos, 'pixels');
    end
%--------------------------------------------------------------------------

%==========================================================================
    function [npc, nsz] = RecalcZoomAxesPos3D(pc, sz, dfltSz, zcCrd, zoomPct)
        %RecalcZoomAxesPos3D
        
        dd = dfltSz * zoomPct / 100 - sz;
        rng = range([pc zcCrd]);
        cf = rng / sz; 
        nsz = sz + dd;
        npc = pc - dd * cf;
    end
%--------------------------------------------------------------------------
        
%==========================================================================
    function UpdateCurrentZoomAxes3D()
        %UpdateCurrentZoomAxes3D
        
        curentZoom = GetCurrentZoomAxesPercent3D();
        [nu, mZoom3DIndex] = min(abs(mZoomGrid - curentZoom));  %#ok ([~, ...])
    end
%--------------------------------------------------------------------------

%==========================================================================
    function currentZoom = GetCurrentZoomAxesPercent3D()
        %GetCurrentZoomAxesPercent3D

        axPos = GetObjPos(hAx, 'pixels');
        currentZoom = axPos(3) / mDefaultAxPos(3) * 100;
    end
%--------------------------------------------------------------------------

%==========================================================================
    function ZoomKeys3D(direction)
        %ZoomKeys3D
        
        UpdateCurrentZoomAxes3D();
        SetNewZoomGrid3D(mZoomMinPow, mZoomMaxPow, mZoom3DKeysNum);
        
        [wcx, wcy] = GetCursorCoordOnWindow('pixels');
        ZoomAxes3D(direction, wcx, wcy)
    end
%--------------------------------------------------------------------------

%==========================================================================
    function SetNewZoomGrid3D(minPow, maxPow, num)
        %SetNewZoomGrid3D set new zoom grid for 3D mode
        
        [mZoomGrid, mZoomSteps] = ZoomLogGrid(minPow, maxPow, num);
        UpdateCurrentZoomAxes3D();
    end
%--------------------------------------------------------------------------

%==========================================================================
    function SetDefaultZoomGrid()
        %SetDefaultZoomGrid set default zoom grid
        
        [mDefaultZoomGrid, mDefaultZoomSteps] = ...
            ZoomLogGrid(mZoomMinPow, mZoomMaxPow, mZoomNum);
        
        mZoomGrid = mDefaultZoomGrid;
        mZoomSteps = mDefaultZoomSteps;
        
        mZoomIndexX = find(mZoomGrid == 100);
        mZoomIndexY = mZoomIndexX;
        mZoom3DIndex = mZoomIndexX;
    end
%--------------------------------------------------------------------------

%==========================================================================
    function SetDefaultZoomGrid3D()
        %SetDefaultZoomGrid for 3D mode
        
        mZoomGrid = mDefaultZoomGrid;
        mZoomSteps = mDefaultZoomSteps;
        UpdateCurrentZoomAxes3D();
    end
%--------------------------------------------------------------------------

%==========================================================================
    function VisibleAxesKeys3D()
        %VisibleAxesKeys3D
        
        axi = GetCurrentAxesIndex();
        
        if mAxesInfo(axi).isvisible
            set(hAx, 'Visible', 'off');
            mAxesInfo(axi).isvisible = false;
        else
            set(hAx, 'Visible', 'on');
            mAxesInfo(axi).isvisible = true;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function SwitchAspectRatioKeys3D()
        %SwitchAspectRatioKeys3D
        
        axi = GetCurrentAxesIndex();
        
        if mAxesInfo(axi).isvis3d
            axis(hAx, 'normal');
            mAxesInfo(axi).isvis3d = false;
        else
            axis(hAx, 'vis3d');
            mAxesInfo(axi).isvis3d = true;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function RotateMouseBegin3D()
        %RotateMouseBegin3D
        
        if ~fIsRotate3DAllowed
            [wcx, wcy] = GetCursorCoordOnWindow('pixels');
            
            [az, el] = view(hAx);
            
            mRotStartAZ = az;
            mRotStartEL = el;
            mRotStartX = wcx;
            mRotStartY = wcy;
                        
            fIsRotate3DAllowed = true;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function RotateMouseEnd3D()
        %RotateMouseEnd3D
        
        if fIsRotate3DAllowed
            fIsRotate3DAllowed = false;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function RotateMouse3D()
        %RotateMouse3D
        
        if fIsRotate3DAllowed
            [wcx, wcy] = GetCursorCoordOnWindow('pixels');
            
            dAZ = mRotStartX - wcx;
            dEL = mRotStartY - wcy;
            
            az = mRotStartAZ + dAZ;
            el = mRotStartEL + dEL;
            
            SetView3D(az, el);
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function RotateKeys3D(mode)
        %RotateKeys3D
        
        [az, el] = view(hAx);
                
        switch lower(mode)
            case 'xy'
                az = 0;
                el = 90;                
            case 'xz'
                az = 0;
                el = 0;
            case 'yz'
                az = 90;
                el = 0;
            case 'az+'
                az = az + mRot3DKeysInc;
            case 'az-'
                az = az - mRot3DKeysInc;
            case 'el+'
                el = el + mRot3DKeysInc;
            case 'el-'
                el = el - mRot3DKeysInc;
        end
        
        SetView3D(az, el)
    end
%--------------------------------------------------------------------------

%==========================================================================
    function SetView3D(az, el)
        %SetView3D
        
        if (el > 90), el = 90; end
        if (el < -90), el = -90; end
        
        view(hAx, [az, el]);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function PointerCrossOn()
        %PointerCrossOn
        
        if ~fIsPointerCross
            SetPointer('fullcrosshair');
            
            % text objects
            h = [
                text('Parent', hAx)     % left
                text('Parent', hAx)     % right
                text('Parent', hAx)     % bottom
                text('Parent', hAx)     % top
                ];
            
            % create pointer cross struct
            mPointerCross = struct(...
                'htext',    h, ...
                'left',     1, ...
                'right',    2, ...
                'bottom',   3, ...
                'top',      4);
            
            PointerCrossSetup();
            fIsPointerCross = true;
            PointerCrossUpdate();
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function PointerCrossOff()
        %PointerCrossOff
        
        if fIsPointerCross
            delete(mPointerCross.htext);
            SetPointer('arrow');
            fIsPointerCross = false;
            mPointerCross = [];
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function PointerCrossSetup()
        %PointerCrossSetup
        
        left = mPointerCross.left;
        right = mPointerCross.right;
        bottom = mPointerCross.bottom;
        top = mPointerCross.top;
        
        vabt = {'top', 'bottom'};
        if fIsImage
            vabt = fliplr(vabt);
        end
        
        set(mPointerCross.htext(left), 'VerticalAlignment', 'bottom');
        set(mPointerCross.htext(right), 'VerticalAlignment', 'bottom');
        set(mPointerCross.htext(bottom), 'VerticalAlignment', vabt{1});
        set(mPointerCross.htext(top), 'VerticalAlignment', vabt{2});
        
        bgColor = [251 248 230]/255;
        set(mPointerCross.htext(left), 'BackgroundColor', bgColor);
        set(mPointerCross.htext(right), 'BackgroundColor', bgColor);
        set(mPointerCross.htext(bottom), 'BackgroundColor', bgColor);
        set(mPointerCross.htext(top), 'BackgroundColor', bgColor);
        
        edColor = [180 180 180]/255;
        set(mPointerCross.htext(left), 'EdgeColor', edColor);
        set(mPointerCross.htext(right), 'EdgeColor', edColor);
        set(mPointerCross.htext(bottom), 'EdgeColor', edColor);
        set(mPointerCross.htext(top), 'EdgeColor', edColor);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function PointerCrossUpdate()
        %PointerCrossUpdate
        
        if fIsPointerCross
            [xlim, ylim] = GetAxesLimits();
            [acx, acy] = GetCursorCoordOnAxes();
            
            left = mPointerCross.left;
            right = mPointerCross.right;
            bottom = mPointerCross.bottom;
            top = mPointerCross.top;
                        
            if fIsImage
                xValStr = sprintf(' %d ', round(acx));
                yValStr = sprintf(' %d ', round(acy));
            else
                xtick = get(hAx, 'XTick');
                ytick = get(hAx, 'YTick');
                
                %FIXME:
                prth = 5;
                
                [lenTick, maxi] = max(arrayfun(@(x) length(num2str(x)), xtick));
                atick = abs(xtick(maxi));
                flt = mod(atick, 1);
                
                if (flt == 0)
                    countDigX = lenTick + 1;
                    if countDigX > prth
                        countDigX = prth;
                    end
                else
                    countDigX = length(num2str(atick));
                    if (fix(acx) == 0)
                        countDigX = countDigX - 1;
                    end
                end
                
                [lenTick, maxi] = max(arrayfun(@(x) length(num2str(x)), ytick));
                atick = abs(ytick(maxi));
                flt = mod(atick, 1);
                
                if (flt == 0)
                    countDigY = lenTick + 1;
                    if countDigY > prth
                        countDigY = prth;
                    end
                else
                    countDigY = length(num2str(atick));
                    if (fix(acy) == 0)
                        countDigY = countDigY - 1;
                    end
                end
                
                xValStr = sprintf(' %.*g ', countDigX, acx);
                yValStr = sprintf(' %.*g ', countDigY, acy);
            end
            
            set(mPointerCross.htext(left), 'String', yValStr);
            set(mPointerCross.htext(right), 'String', yValStr);
            set(mPointerCross.htext(bottom), 'String', xValStr);
            set(mPointerCross.htext(top), 'String', xValStr);
            
            extent = get(mPointerCross.htext(left), 'Extent');
            xx = extent(3);
            
            if strcmp(get(hAx, 'xscale'), 'log')
                leftx = xlim(1);
            else
                leftx = xlim(1) - xx;
            end
            
            set(mPointerCross.htext(left), 'Position', [leftx, acy]);
            set(mPointerCross.htext(right), 'Position', [xlim(2) acy]);
            set(mPointerCross.htext(bottom), 'Position', [acx, ylim(1)]);
            set(mPointerCross.htext(top), 'Position', [acx, ylim(2)]);
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function RubberBandBegin()
        %RubberBandBegin
        
        if (~fIsRubberBandOn && ~fIsMagnifierOn)
            [acx, acy] = GetCursorCoordOnAxes();
            
            % create rubber band struct
            mRubberBand = struct(...
                'obj',	[patch('Parent', hAx), patch('Parent', hAx)], ...
                'x1',  	acx, ...
                'y1',  	acy, ...
                'x2',  	acx, ...
                'y2',  	acy);
            
            hAxes2d = GetHandlesAxes2D();
            if ~isempty(hAxes2d)
                set(hAxes2d, ...
                    'XLimMode', 'manual', ...
                    'YLimMode', 'manual');
            end
            
            RubberBandSetPos();
            RubberBandSetup();
            fIsRubberBandOn = true;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function RubberBandEnd()
        %RubberBandEnd
        
        if fIsRubberBandOn
            fIsRubberBandOn = false;
            
            delete(mRubberBand.obj);          
            RubberBandZoomAxes();
            PointerCrossUpdate();
            mRubberBand = [];
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function RubberBandUpdate()
        %RubberBandUpdate
        
        if fIsRubberBandOn
            [acx, acy] = GetCursorCoordOnAxes();
            
            mRubberBand.x2 = acx;
            mRubberBand.y2 = acy;
            RubberBandSetPos();
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function RubberBandSetPos()
        %RubberBandSetPos set position of rubber band
        
        x1 = mRubberBand.x1;
        y1 = mRubberBand.y1;
        x2 = mRubberBand.x2;
        y2 = mRubberBand.y2;
        
        set(mRubberBand.obj, ...
            'XData', [x1 x2 x2 x1], ...
            'YData', [y1 y1 y2 y2]);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function RubberBandSetup()
        %RubberBandSetup
        
        set(mRubberBand.obj(1), ...
            'EdgeColor', 'w', ...
            'FaceColor', 'none', ...
            'LineWidth', 1.5, ...
            'LineStyle', '-');
        
        set(mRubberBand.obj(2), ...
            'EdgeColor', mRbEdgeColor, ...
            'FaceColor', mRbFaceColor, ...
            'FaceAlpha', mRbFaceAlpha, ...
            'LineWidth', 0.5, ...
            'LineStyle', '-');    
    end
%--------------------------------------------------------------------------

%==========================================================================
    function RubberBandZoomAxes()
        %RubberBandZoomAxes apply zoom from rubber band
        
        xLim = sort([mRubberBand.x1, mRubberBand.x2]);
        yLim = sort([mRubberBand.y1, mRubberBand.y2]);
        
        if (range(xLim) == 0 || range(yLim) == 0)
            return;
        end
        
        [zoomPctX, zoomPctY] = GetCurrentZoomAxesPercent(xLim, yLim);
        
        if fIsImage
            zoomPctX = min(zoomPctX, zoomPctY);
            zoomPctY = zoomPctX;
        end
        
        cx = mean(xLim);
        cy = mean(yLim);
        
        xLim = RecalcZoomAxesLimits('x', xLim, mDefaultXLim, cx, zoomPctX);
        yLim = RecalcZoomAxesLimits('y', yLim, mDefaultYLim, cy, zoomPctY);
        
        SetAxesLimits(xLim, yLim);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function MagnifierOn()
        %MagnifierCreate
        
        if ~fIsMagnifierOn    
            if fIsPointerCross
                isPointerCross = true;
                PointerCrossOff();
            else
                isPointerCross = false;
            end
            
            mMgDirection = 'plus';
            
            % create magnifier struct
            mMagnifier = struct(...
                'obj',          copyobj(hAx, hFig), ...
                'frame_obj',    [], ...
                'size',         mMgSize, ...
                'zoom',         mMgZoom);
            
            fIsMagnifierOn = true;
            MagnifierSetup();
            MagnifierUpdate();
            
            if isPointerCross
                PointerCrossOn();
            end
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function MagnifierOff()
        %MagnifierOff
        
        if fIsMagnifierOn
            fIsMagnifierOn = false;
            set(hAx, 'Color', get(mMagnifier.obj, 'Color'));
            
            delete(mMagnifier.obj);
            mMagnifier = [];
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function MagnifierUpdate()
        %MagnifierUpdate
        
        if fIsMagnifierOn            
            % see original idea of magnify by Rick Hindman -- 7/29/04
            % http://www.mathworks.com/matlabcentral/fileexchange/5961
            
            [acx, acy] = GetCursorCoordOnAxes();
            [wcx, wcy] = GetCursorCoordOnWindow('pixels');
            
            [xLim, yLim] = GetAxesLimits();
            
            if strcmp(get(hAx, 'xscale'), 'log')
                xLim = log10(xLim);
                xLim = FixInfLogLimits('x', xLim);
                acx = log10(acx);
                isXLog = true;
            else
                isXLog = false;
            end
            if strcmp(get(hAx, 'yscale'), 'log')
                yLim = log10(yLim);
                yLim = FixInfLogLimits('y', yLim);
                acy = log10(acy);
                isYLog = true;
            else
                isYLog = false;
            end
            
            figPos = GetObjPos(hFig, 'pixels');
            axPos = GetObjPos(hAx, 'normalized');
            
            % always square magnifier
            pbar = get(hAx, 'PlotBoxAspectRatio');
            af = pbar(1) / pbar(2);
            if (af == 1 && (pbar(1) == 1 && pbar(2) == 1))
                af = figPos(3) / figPos(4);
            end
            
            mgSizePix = round(mMagnifier.size);
            mgZoom = mMagnifier.zoom;
            
            mgSize = mgSizePix / figPos(3); % normalized size
            
            mgPos(3) = mgSize * 2;
            mgPos(4) = mgPos(3) * af;
            
            mg3 = round(mgPos(3) * figPos(3));
            mg4 = round(mgPos(4) * figPos(4));
            
            if (mg4 < mg3)
                mgSize = (mgSizePix * (mg3 / mg4)) / figPos(3);
            end
            
            mgPos(3) = mgSize * 2;
            mgPos(4) = mgPos(3) * af;
            
            mgPos(1) = wcx / figPos(3) - mgSize;
            mgPos(2) = wcy / figPos(4) - mgSize * af;
            
            mgXLim = acx + (1 / mgZoom) * (mgPos(3) / axPos(3)) * diff(xLim) * [-0.5 0.5];
            mgYLim = acy + (1 / mgZoom) * (mgPos(4) / axPos(4)) * diff(yLim) * [-0.5 0.5];
            
            SetObjPos(mMagnifier.obj, mgPos, 'normalized');
            
            if isXLog
                mgXLim = 10.^mgXLim;
            end
            if isYLog
                mgYLim = 10.^mgYLim;
            end
            
            set(mMagnifier.obj, ...
                'XLim', mgXLim, ...
                'YLim', mgYLim);
            
            MagnifierBorderUpdate();
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function MagnifierSetup()
        %MagnifierSetup

        set(mMagnifier.obj, ...
            'Box', 'on', ...
            'XMinorTick', 'on', ...
            'YMinorTick', 'on');
        
        title(mMagnifier.obj, '');
        xlabel(mMagnifier.obj, ''); 
        ylabel(mMagnifier.obj, '');
        
        if fIsImage
            mMagnifier.frame_obj = ...
                [patch('Parent', mMagnifier.obj), ...
                patch('Parent', mMagnifier.obj)];
            
            set(mMagnifier.frame_obj, 'FaceColor', 'none');
            
            set(mMagnifier.frame_obj(1), ...
                'LineWidth', 1.5, ...
                'EdgeColor', 'w')
            set(mMagnifier.frame_obj(2), ...
                'LineWidth', 1, ...
                'EdgeColor', 'k')
            
            MagnifierBorderUpdate();
        end
        
        hLines = findobj(mMagnifier.obj, 'Type', 'line');
        if ~isempty(hLines)
            if (mMgLinesWidth ~= 1)
                set(hLines, 'LineWidth', mMgLinesWidth);
            end
        end
        
        set(hAx, 'Color', get(hAx, 'Color')*mMgShadow);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function MagnifierBorderUpdate()
        %MagnifierBorderUpdate
        
        if fIsImage
            x = get(mMagnifier.obj, 'XLim');
            y = get(mMagnifier.obj, 'YLim');
            
            set(mMagnifier.frame_obj, ...
                'XData', [x(1) x(2) x(2) x(1)], ...
                'YData', [y(1) y(1) y(2) y(2)]);
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function MagnifierSizeChange(direction)
        %MagnifierSizeChange
        
        if fIsMagnifierOn
            switch direction
                case 'plus'
                    if (mMagnifier.size < mMgMaxSize)
                        mMagnifier.size = mMagnifier.size + mMgSizeStep;
                    end
                case 'minus'
                    if (mMagnifier.size > mMgMinSize)
                        mMagnifier.size = mMagnifier.size - mMgSizeStep;
                    end
            end
            
            MagnifierUpdate();
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function MagnifierZoomChange(direction)
        %MagnifierZoomChange
        
        if fIsMagnifierOn
            switch direction
                case 'plus'
                    if (mMagnifier.zoom < mMgMaxZoom)
                        mMagnifier.zoom = mMagnifier.zoom * mMgZoomStep;
                    end
                case 'minus'
                    if (mMagnifier.zoom > mMgMinZoom)
                        mMagnifier.zoom = mMagnifier.zoom / mMgZoomStep;
                    end
            end
            
            MagnifierUpdate();
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function MagnifierReset()
        %MagnifierReset
        
        if fIsMagnifierOn
            mMagnifier.size = mMgSize;
            mMagnifier.zoom = mMgZoom;
            MagnifierUpdate();
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function SetLinkAxesKeys(modifier)
        %SetLinkAxesKeys Set Linking of 2-D axes
        
        if isempty(modifier)
            mLinkOpt = 'xy';
        else
            switch modifier{1}
                case 'control'
                    mLinkOpt = 'x';
                case 'alt'
                    mLinkOpt = 'y';
            end
        end
        
        if fIsLinkAxesOn
            LinkAxesOff();
        else
            LinkAxesOn();
        end
        
        UserData = get(hFig, 'UserData');
        UserData.tools.islinkaxeson = fIsLinkAxesOn;
        set(hFig, 'UserData', UserData);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function LinkAxesOn()
        %LinkAxesOn On of 2-D axes linking
        
        if ~fIsLinkAxesOn
            hAxes2d = GetHandlesAxes2D();
            if (length(hAxes2d) > 1)
                linkaxes(hAxes2d, mLinkOpt);
                fIsLinkAxesOn = true;
                SetFigureName();
            end
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function LinkAxesOff()
        %LinkAxesOff Off of 2-D axes linking
        
        if fIsLinkAxesOn
            fIsLinkAxesOn = false;
            
            SetFigureName();
            hAxes2d = GetHandlesAxes2D();
            linkaxes(hAxes2d, 'off');    
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function DeleteOldTools()
        %DeleteOldTools
        
        UserData = get(hFig, 'UserData');
        
        if (~isempty(UserData) && isfield(UserData, 'tools'))
            if ~isempty(UserData.tools.pointercross)
                mPointerCross = UserData.tools.pointercross;
                fIsPointerCross = true;
                PointerCrossOff();
                UserData.tools.pointercross = [];
            end
            
            if UserData.tools.islinkaxeson
                fIsLinkAxesOn = true;
                LinkAxesOff();
                UserData.tools.islinkaxeson = false;
            end
            
            set(hFig, 'UserData', UserData);
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function hAxes2d = GetHandlesAxes2D()
        %GetHandlesAxes2D Get handles of 2-D axes
        
        isAxes2d = arrayfun(@(x) x.is2d && ~x.islegend, mAxesInfo);
        hAxes2d = hAxes(isAxes2d);
        
        if ~isempty(hAxes2d)
            % Set current axes on first position
            hAxes2d(eq(hAxes2d, hAx)) = 0;
            hAxes2d = sort(hAxes2d);
            hAxes2d(eq(hAxes2d, 0)) = hAx;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function ResetAxesToOrigView()
        %ResetAxesToOrigView reset axes to original limits
        
        SetAxesLimits(mDefaultXLim, mDefaultYLim);
        PointerCrossUpdate();
        
        mZoomIndexX = find(mZoomGrid == 100);
        mZoomIndexY = mZoomIndexX;
    end
%--------------------------------------------------------------------------

%==========================================================================
    function ResetAxesToOrigView3D()
        %ResetAxesToOrigView3D reset axes to original position in 3D mode
        
        % position reset
        axi = GetCurrentAxesIndex();
        pos = mAxesInfo(axi).normposition;
        SetObjPos(hAx, pos, 'normalized');
        
        % view reset
        resetplotview(hAx, 'ApplyStoredView'); % (!!!) undocumented function
        
        if mAxesInfo(axi).isvis3d
            axis(hAx, 'vis3d');
        end
        
        % zoom reset
        mZoom3DIndex = find(mZoomGrid == 100);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function [x, y, z] = GetCursorCoordOnAxes()
        %GetCursorCoordOnAxImg
        
        crd = get(hAx, 'CurrentPoint');
        x = crd(2,1);
        y = crd(2,2);
        z = crd(2,3);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function [x, y] = GetCursorCoordOnWindow(units)
        %GetCursorCoordOnWindow
        
        if (nargin < 1), units = 'pixels'; end
        
        dfltUnits = get(hFig, 'Units');
        set(hFig, 'Units', units);
        
        crd = get(hFig, 'CurrentPoint');
        x = crd(1); 
        y = crd(2);
        
        set(hFig, 'Units', dfltUnits);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function pos = GetObjPos(h, units)
        %GetObjPos get object position
        
        if (nargin < 2), units = get(h, 'Units'); end
        
        dfltUnits = get(h, 'Units');
        set(h, 'Units', units);
        pos = get(h, 'Position');
        set(h, 'Units', dfltUnits);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function SetObjPos(h, pos, units)
        %SetObjPos set object position
        
        if (nargin < 3), units = get(h, 'Units'); end
        
        dfltUnits = get(h, 'Units');
        set(h, 'Units', units);
        set(h, 'Position', pos);
        set(h, 'Units', dfltUnits);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function [xLim, yLim] = GetAxesLimits()
        %GetAxesLimits
        
        xLim = get(hAx, 'XLim');
        yLim = get(hAx, 'YLim');
    end
%--------------------------------------------------------------------------

%==========================================================================
    function SetAxesLimits(xLim, yLim)
        %SetAxesLimits
        
        set(hAx, 'XLim', xLim);
        set(hAx, 'YLim', yLim);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function SetPointerCrossKeys()
        %SetPointerCrossKeys set pointer fullcross
        
        if fIsPointerCross
            PointerCrossOff();
        else
            PointerCrossOn();
        end
        
        UserData = get(hFig, 'UserData');
        UserData.tools.pointercross = mPointerCross;
        set(hFig, 'UserData', UserData);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function SetPointer(pointerType)
        %SetPointer set pointer symbol
        
        set(hFig, 'Pointer', pointerType);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function SetAxesGridKeys()
        %SetAxesGridKeys on/off axes grid
        
        if fIsAxesGrid
            action = 'off';
            fIsAxesGrid = false;
        else
            action = 'on';
            fIsAxesGrid = true;
        end
        
        set(hAx, 'XGrid', action, 'YGrid', action, 'ZGrid', action);
        
        if fIsMagnifierOn
            set(mMagnifier.obj, 'XGrid', action, 'YGrid', action);
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function SetSmoothKeys()
        %SetSmoothKeys on/off cmoothing plots
        
        if fIsSmoothing
            action = 'off';
            fIsSmoothing = false;
        else
            action = 'on';
            fIsSmoothing = true;
        end
        
        if ~fIsImage
            %FIXME: bug with switching opengl/painter renderer here
            %Lost figure focus
            hLine = findobj(hAx, 'Type', 'Line');
            if ~isempty(hLine)
                set(hLine, 'LineSmooth', action);   % !!! Undocumented property
            end
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function [zg, st] = ZoomLogGrid(a, b, n)
        %ZoomLogGrid log zoom grid
        
        zg = unique(round(logspace(a, b, n)));
        
        zg(zg<10) = [];	% begin zoom == 10%
        st = length(zg);
        
        if isempty(find(zg == 100, 1))
            error('dragzoom:badZoomGridOptions', 'Options for zoom grid is bad.')
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function tf = IsZoomMouseAllowed()
        %IsZoomMouseAllowed
        
        [wcx, wcy] = GetCursorCoordOnWindow();
        figPos = get(hFig, 'Position');
        
        if (wcx >= 1 && wcx <= figPos(3) && wcy >= 1 && wcy <= figPos(4))
            tf = true;
        else
            tf = false;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function tf = IsImageOnAxes(ax)
        %IsImageOnAxes
        
        if (nargin < 1), ax = hAx; end
        
        h = findobj(ax, 'Type', 'Image');
        
        if isempty(h)
            tf = false;
        else
            tf = true;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function tf = IsAxes2D(ax)
        %IsAxes2D
        
        if (nargin < 1), ax = hAx; end
        
        tf = is2D(ax); % (!!!) internal undocumented function
    end
%--------------------------------------------------------------------------

%==========================================================================
    function tf = IsLegendAxes(ax)
        %IsLegendAxes
        
        tf = strcmp(get(ax, 'Tag'), 'legend');
    end
%--------------------------------------------------------------------------

%==========================================================================
    function targetInBounds = IsInBoundsAxes(ax)
        %InBoundsAxes Check if the user clicked within the bounds of the axes. If not, do nothing
        
        targetInBounds = true;
        tol = 3e-16;
        cp = get(ax, 'CurrentPoint');
        
        XLims = get(ax, 'XLim');
        if ((cp(1,1) - min(XLims)) < -tol || (cp(1,1) - max(XLims)) > tol) && ...
                ((cp(2,1) - min(XLims)) < -tol || (cp(2,1) - max(XLims)) > tol)
            targetInBounds = false;
        end
        
        YLims = get(ax, 'YLim');
        if ((cp(1,2) - min(YLims)) < -tol || (cp(1,2) - max(YLims)) > tol) && ...
                ((cp(2,2) - min(YLims)) < -tol || (cp(2,2) - max(YLims)) > tol)
            targetInBounds = false;
        end
        
        ZLims = get(ax, 'ZLim');
        if ((cp(1,3) - min(ZLims)) < -tol || (cp(1,3) - max(ZLims)) > tol) && ...
                ((cp(2,3) - min(ZLims)) < -tol || (cp(2,3) - max(ZLims)) > tol)
            targetInBounds = false;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function tf = IsCurrentAxes(ax)
        %IsCurrentAxes
        
        hcAx = get(hFig, 'CurrentAxes');
        tf = eq(ax, hcAx);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function tf = IsAxesVis3D(ax)
        %IsAxesVis3D
        
        visProp = {
            get(ax, 'PlotBoxAspectRatioMode')
            get(ax, 'DataAspectRatioMode')
            get(ax, 'CameraViewAngleMode')
            };
        
        tf = all(strcmpi(visProp, 'manual'));
    end
%--------------------------------------------------------------------------

%==========================================================================
    function AxesInfo = GetAxesInfo()
        %GetAxesInfo make and get axes info struct
        
        countAxes = length(hAxes);
        
        AxesInfo = struct(...
            'handle',       cell(1, countAxes), ...
            'iscurrent',    cell(1, countAxes), ...
            'is2d',         cell(1, countAxes), ...
            'isimage',      cell(1, countAxes), ...  
            'isvisible',    cell(1, countAxes), ...  
            'isvis3d',      cell(1, countAxes), ...
            'islegend',     cell(1, countAxes), ...
            'position',     cell(1, countAxes), ...
            'normposition', cell(1, countAxes), ...
            'xlim',         cell(1, countAxes), ...
            'ylim',         cell(1, countAxes), ...
            'camtarget',    cell(1, countAxes), ...
            'camposition',  cell(1, countAxes));
        
        for i = 1:countAxes
            h = hAxes(i);
            
            AxesInfo(i).handle = h;
            AxesInfo(i).iscurrent = IsCurrentAxes(h);
            AxesInfo(i).is2d = IsAxes2D(h);
            AxesInfo(i).isimage = IsImageOnAxes(h);
            AxesInfo(i).isvisible = strcmpi(get(h, 'Visible'), 'on');
            AxesInfo(i).isvis3d = IsAxesVis3D(h);
            AxesInfo(i).islegend = IsLegendAxes(h);
            AxesInfo(i).position = GetObjPos(h, 'pixels');
            AxesInfo(i).normposition = GetObjPos(h, 'normalized');
            AxesInfo(i).xlim = get(h, 'XLim');
            AxesInfo(i).ylim = get(h, 'YLim');
            AxesInfo(i).camtarget = get(h, 'CameraTarget');
            AxesInfo(i).camposition = get(h, 'CameraPosition');
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function SelectAxesUnderCursor()
        %SelectAxesUnderCursor select axes under cursor as current
        
        axi = GetAxesIndexUnderCursor();
        
        if (axi > 0)
            fIsEnableControl = true;
            
            if ~mAxesInfo(axi).iscurrent
                caxi = GetCurrentAxesIndex();
                
                if isempty(caxi)
                    DeleteInvalidAxesInfo();
                    
                    axi = GetAxesIndexUnderCursor();
                    isCax2d = mAxesInfo(axi).is2d;
                else
                    isCax2d = mAxesInfo(caxi).is2d;
                end
                
                SetCurrentAxes(axi);
                
                % for fix "legend" axes capture
                if mAxesInfo(axi).islegend;
                    fIsMouseOnLegend = true;
                else
                    fIsMouseOnLegend = false;
                end
                
                % check callbacks
                if (isCax2d ~= mAxesInfo(axi).is2d)
                    % if dimension of axes has changed
                    SetCallbacks();
                    
                    if fIsPointerCross
                        % disable pointer cross
                        PointerCrossOff()
                    end
                else
                    if fIsPointerCross
                        % reset pointer cross
                        PointerCrossOff()
                        SetPointerCrossKeys()
                    end
                end
            end
        else
            fIsEnableControl = false;
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function SetCurrentAxes(axi)
        %SetCurrentAxes set current axes and work mode
        
        hAx = mAxesInfo(axi).handle;
        
        set(hFig, 'CurrentAxes', hAx);
        for i = 1:numel(mAxesInfo)
            mAxesInfo(i).iscurrent = false;
        end
        mAxesInfo(axi).iscurrent = true;
        
        fIsAxes2D = mAxesInfo(axi).is2d;
        fIsImage = mAxesInfo(axi).isimage;
        
        mDefaultAxPos = mAxesInfo(axi).position;
        mDefaultXLim = mAxesInfo(axi).xlim;
        mDefaultYLim = mAxesInfo(axi).ylim;
        
        % save info to work correctly after saving figures
        UserData = get(hFig, 'UserData');
        UserData.axesinfo = mAxesInfo;
        set(hFig, 'UserData', UserData);
    end
%--------------------------------------------------------------------------

%==========================================================================
    function axi = GetCurrentAxesIndex()
        %GetCurrentAxesIndex
        
        axi = [];
        
        for i = 1:numel(mAxesInfo)
            if (ishandle(mAxesInfo(i).handle) && mAxesInfo(i).iscurrent)
                axi = i;
                return;
            end
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function axi = GetAxesIndexUnderCursor()
        %FindAxesUnderCursor find current axes under cursor
        
        axi = GetCurrentAxesIndex();
        
        if ~fIsSelectedCurrentAxes
            caxi = GetCurrentAxesIndex();
            if ~IsInBoundsAxes(mAxesInfo(caxi).handle)
                axi = 0;
            end
            return;
        end
        
        for i = 1:numel(mAxesInfo)
            if (ishandle(mAxesInfo(i).handle) && IsInBoundsAxes(mAxesInfo(i).handle))
                axi = i;
                return;
            else
                axi = 0; % without axes
            end
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function axLim = FixInfLogLimits(ax, axLim)
        %FixInfLogLimits Fix Axes Inf Log Limits
        
        if (~all(isfinite(axLim)) || ~all(isreal(axLim)))
            
            % The following code has been taken from zoom.m
            % If any of the public limits are inf then we need the actual limits
            % by getting the hidden deprecated RenderLimits.
            oldstate = warning('off', 'MATLAB:HandleGraphics:NonfunctionalProperty:RenderLimits');
            renderlimits = get(hAx, 'RenderLimits');
            warning(oldstate);
            
            switch ax
                case 'x'
                    axLim = renderlimits(1:2);
                case 'y'
                    axLim = renderlimits(3:4);
            end
            axLim = log10(axLim);
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function DeleteInvalidAxesInfo()
        %DeleteInvalidAxesInfo
        
        invalidAxes = arrayfun(@(x) ~ishandle(x.handle), mAxesInfo);
        mAxesInfo(invalidAxes) = [];
        hAxes(invalidAxes) = [];
    end
%--------------------------------------------------------------------------

%==========================================================================
    function isWithStatus = ParseInputs(varargin)
        %ParseInputs parse input arguments
        
        isWithStatus = false;
        
        switch nargin
            case 0
                hObj = gcf;
                status = 'on';
                ih = 0;
            case 1
                if ischar(varargin{1})
                    isWithStatus = true;
                    hObj = gcf;
                    status = varargin{1};
                    ih = 2;
                    is = 1;
                else
                    hObj = varargin{1};
                    status = 'on';
                    ih = 1;
                    is = 2;
                end
            case 2
                isWithStatus = true;
                hObj = varargin{1};
                status = varargin{2};
                ih = 1;
                is = 2;
        end
        
        switch lower(status)
            case 'on'
                fIsEnabled = true;
            case 'off'
                fIsEnabled = false;
            otherwise
                error('dragzoom:invalidInputs', ...
                    'Input Argument %d must be a string "on" or "off".', is)
        end
        
        if all(ishandle(hObj))
            handleType = get(hObj(1), 'Type');
            
            switch handleType
                case 'axes'
                    hAxes = unique(hObj);
                    hFig = ancestor(hAxes(1), 'figure');
                    
                case 'figure'
                    hFig = hObj;
                    hAxes = findobj(hFig, 'Type', 'axes'); % all axes
                    
                    if isempty(hAxes)
                        warning('dragzoom:notFoundAxes', 'Not found axes objects on figure.')
                    end
                    
                otherwise
                    error('dragzoom:invalidHandle', ...
                        'Input Argument %d must be figure or axes handle.', ih)
            end
        else
            error('dragzoom:invalidInputs', ...
                'Input Argument %d must be a figure or axes handle.', ih)
        end
    end
%--------------------------------------------------------------------------

%==========================================================================
    function res = range(x)
        %RANGE
        
        res = abs(diff([min(x) max(x)]));
    end
%--------------------------------------------------------------------------

end % DRAGZOOM

