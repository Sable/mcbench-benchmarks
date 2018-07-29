function varargout = imSelectROI(img,varargin)
%==========================================================================
%  Author: Andriy Nych ( nych.andriy@gmail.com )
% Version: 733250.03649467591
%--------------------------------------------------------------------------
% This functions displays GUI for selecting square or rectangular part
% of the input image IMG. To perform selection user must click mouse twice:
% at two corners of the selection area.
% User can change the shape at any moment, even when first point is set,
% unless it is not forbidden by additional parameters.
% Use also cam change the way the selection area is calculated
% from the two selected points.
% Depending on the combination of the shape and mode it could be:
%--------------------------------------------------------------------------
% Shape       Mode        Result
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Rectangle   Free        Rectangle with one corner at first point (P1)
%                         and another corner at second point (P2).
% Rectangle   Centered    Rectangle with its center at first point (P1)
%                         and corner at second point (P2).
% Square      Free        Square of the largest size that can be
%                         fitted into rectangle made by (P1) and (P2)
%                         with one corner at (P1).
% Square      Centered    Square of the largest size that can be
%                         fitted into centered rectangle.
%                         Center of the square is at (P1).
%--------------------------------------------------------------------------
% Behavior of the imSelectROI can be altered by providing additional
% parameters in MatLab well-known ParamName,ParamValue style.
%
% NOTE      This function was developed under MatLab R2006b.
% ====      It requires Image Processing Toolbox to work.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Syntax
% ======
%                   imSelectROI( img, param1, val1, param2, val2, ...)
%             ROI = imSelectROI( img, param1, val1, param2, val2, ...)
% [ ROI, SelImg ] = imSelectROI( img, param1, val1, param2, val2, ...)
%
% Displays GUI and returns:
%
% SelImg - Selected part of the image passed as first parameter.
%          Even if first parameter is a file name (see below).
%
% ROI - structure with fields:
%   ROI.Xmin    - minimal value of X coordinate of the selected area
%   ROI.Xmax    - maximal value of X coordinate of the selected area
%   ROI.Ymin    - minimal value of Y coordinate of the selected area
%   ROI.Ymax    - maximal value of Y coordinate of the selected area
%   ROI.DX      - horizontal size of the selected area
%       ROI.DX = ROI.Xmax - ROI.Xmin + 1
%   ROI.DY      - vertical size of the selected area
%       ROI.DY = ROI.Ymax - ROI.Ymin + 1
%   ROI.Xrange  - same as [ROI.Xmin:ROI.Xmax]
%   ROI.Yrange  - same as [ROI.Ymin:ROI.Ymax]
%
%   Selected part can be retrieved from original image as
%       img( ROI.Xrange, ROI.Yrange, :)
%   This allows to perform selection once and use the same ROI
%   to process series of images (see examples at hte end).
%
% Arguments
% =========
%
% img     Anything that can be passed to IMSHOW as a single parameter.
%         In could be file name or preloaded image.
%         See "help imshow" for more information about the syntaxes.
%
% Parameters
% ==========
%
% AllowedShape  (string): {'Any'} | 'Square' | 'Rectangle'
%
%   This parameter controls shape of the selection.
%   Specifying 'Square' or 'Rectangle' you prevent user from
%   selecting other shape.
%   By specifying 'Any' or omitting 'AllowedShape' at all
%   user is allowed to select any shape.
%
% SelectionMode (string): {'Free'} | 'Centered'
%
%   This parameter controls selection mode.
%   But in this case user still can select other mode.
%
% FastReturn    (string): {'off'} | 'on'
%
%   This parameter controls how the GUI behaves when user finishes
%   seletion. 
%   When 'off' value provided function waits for user to press
%   "DONE" button, allowing user to change selection by
%   "START OVER" button.
%   When 'on' value provided function returns immediately after user
%   makes valid selection of second point. In this case it is also
%   possible to change selection, but only until the second point was
%   NOT selected by user.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Examples
% ======
% ROI = imSelectROI( 'c:\Image.jpg');
% [ROI,SelImage] = imSelectROI( 'c:\Image.jpg', 'AllowedShape','Square');
%
% % FNames is a cell array of image file names
% ROI = imSelectROI( FNames{1} );
% for i=1:length(FNames)
%     image = imread(FNames{i}); %whole image
%     selection = image( ROI.Xrange, ROI.Yrange, :); %selected area
%     ...
% end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Additional info
% ===============
%   help imshow     for additional information on what can be passed
%                   to imSelectROI as first argument.
%==========================================================================

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% GUI parameters
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
LBoxWidth       = 0.1;  % width of the ListBoxes in NORMALIZED units
                        % Change this when width of listboxes is too smal
                        % to accomodate its strings or 
                        % to meet your preferences
LBoxHeight      = 44;   % height of the ListBoxes in PIXELS
ScrMargin       = 0.05; % Screen margin for the whole figure
                        % in NORMALIZED units

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Parsing arguments
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% GP.AllowedShapes    = {'Any','Square','Rectangle'};
GP.AllowedShapes    = {'Square','Rectangle'};
GP.SelectionModes   = {'Free','Centered'};
GP.FastReturns      = {'on','off'};

GP.AllowedShape_i   = GetParameterValue('AllowedShape',varargin, 'Any');
GP.SelectionMode_i  = GetParameterValue('SelectionMode',varargin, 'Free');
GP.FastReturn_i     = GetParameterValue('FastReturn',varargin, 'Off');

if any( strcmpi( GP.AllowedShape_i,  {GP.AllowedShapes{:} 'Any'} ) )
    GP.SelectionMode    = GP.SelectionMode_i;
else
    error('%s: Wrong value of "AllowedShape" parameter ("%s")',mfilename,GP.AllowedShape_i);
end

if any( strcmpi( GP.SelectionMode_i, GP.SelectionModes ) )
    GP.AllowedShape     = GP.AllowedShape_i;
else
    error('%s: Wrong value of "SelectionMode" parameter ("%s")',mfilename,GP.SelectionMode_i);
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Creating GUI
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GP.hFig         = figure(...
    'Name','Select subimage',...
    'NumberTitle','off',...
    'Color',[1 1 1],...
    'WindowStyle','modal',...{normal} | 
    'Pointer','crosshair',... fullcrosshair crosshair
    'Resize','off',...{on} | off
    'Toolbar','none',...
    'Menubar','none');
GP.hImg         = imshow(img);
GP.XLim         = xlim;
GP.YLim         = ylim;
GP.hAxes        = gca;

set(GP.hAxes, 'ActivePositionProperty','OuterPosition');

GP.hPixVal      = impixelinfoval(GP.hFig,GP.hImg);

set(GP.hFig,...
    'Units','normalized',...
    'Position',[ ScrMargin ScrMargin 1-2*ScrMargin 1-2*ScrMargin ]);

GP.hSP          = imscrollpanel(GP.hFig,GP.hImg);

set(GP.hSP,...
    'Units','normalized',...
    'Position',[0 .1 1 .9]);
GP.hSPAPI       = iptgetapi(GP.hSP);
GP.hSPAPI.setMagnification(1);

movegui(GP.hFig, 'east');

GP.hDoneBtn     = uicontrol( 'Style','pushbutton',  'Parent',gcf,   'FontWeight','bold',                'units','normalized',   'position',[1-2.0*LBoxWidth 0 LBoxWidth 0.2], 'string','Done');
GP.hModeLBox    = uicontrol( 'Style','listbox',     'Parent',gcf,   'min',0,    'max',1,    'value',1,  'units','normalized',   'position',[1-3.5*LBoxWidth 0 LBoxWidth 0.2], 'string',GP.SelectionModes);
GP.hShapeLBox   = uicontrol( 'Style','listbox',     'Parent',gcf,   'min',0,    'max',1,    'value',1,  'units','normalized',   'position',[1-4.5*LBoxWidth 0 LBoxWidth 0.2], 'string',GP.AllowedShapes);
GP.hZoomPMenu   = uicontrol( 'Style','popupmenu',   'Parent',gcf,                           'value',5,  'units','normalized',   'position',[1-6.0*LBoxWidth 0 LBoxWidth 0.2], 'string',{'0010%','0025%','0050%','0075%','0100%','0150%','0200%','0250%','0300%','0400%','0500%','0600%','0700%','0800%','0900%','1000%'});
GP.hRedoBtn     = uicontrol( 'Style','pushbutton',  'Parent',gcf,   'FontWeight','bold',                'units','normalized',   'position',[1-7.5*LBoxWidth 0 LBoxWidth 0.2], 'string','Start over');
GP.hStatus      = uicontrol( 'Style','text',        'Parent',gcf,   'FontWeight','bold', 'FontSize',12, 'units','normalized',   'position',[1-9.0*LBoxWidth 0 LBoxWidth 0.2], 'string','');

set(GP.hShapeLBox,  'units','pixels'); p = get(GP.hShapeLBox, 'position'); set(GP.hShapeLBox, 'position',[ p(1)  0               p(3)    LBoxHeight ]);
set(GP.hModeLBox,   'units','pixels'); p = get(GP.hModeLBox,  'position'); set(GP.hModeLBox,  'position',[ p(1)  0               p(3)    LBoxHeight ]);
set(GP.hDoneBtn,    'units','pixels'); p = get(GP.hDoneBtn,   'position'); set(GP.hDoneBtn,   'position',[ p(1)  0               p(3)    LBoxHeight ]);
set(GP.hZoomPMenu,  'units','pixels'); p = get(GP.hZoomPMenu, 'position'); set(GP.hZoomPMenu, 'position',[ p(1)  LBoxHeight-25   p(3)    25         ]);
set(GP.hRedoBtn,    'units','pixels'); p = get(GP.hRedoBtn,   'position'); set(GP.hRedoBtn,   'position',[ p(1)  0               p(3)    LBoxHeight ]);
set(GP.hStatus,     'units','pixels'); q = get(GP.hStatus,    'position'); set(GP.hStatus,    'position',[ q(1)  LBoxHeight+08   p(3)*8  25         ]);

if strcmpi(GP.AllowedShape_i,'Square')
    % Square shape
    set(GP.hShapeLBox, 'Value',1);
    set(GP.hShapeLBox, 'enable','inactive');
    set(GP.hShapeLBox, 'TooltipString','Only square selection allowed');
elseif strcmpi(GP.AllowedShape_i,'Rectangle')
    % Rectangle shape
    set(GP.hShapeLBox, 'Value',2);
    set(GP.hShapeLBox, 'enable','inactive');
    set(GP.hShapeLBox, 'TooltipString','Only rectangular selection allowed');
else
    % Any shape
    set(GP.hShapeLBox, 'Value',2);
    set(GP.hShapeLBox, 'TooltipString','Select shape of your selection');
end

if strcmpi(GP.SelectionMode_i,'Centered')
    set(GP.hModeLBox, 'Value',2);
end

axes(GP.hAxes);
axis image; axis on;

%=========================================================================
% Stroing handles and other data to safe place
%=========================================================================
GP.P1   = [];
GP.P2   = [];
GP.SP1  = [];
GP.SP2  = [];
GP.SW   = [];
GP.SH   = [];
GP.hCrs = [];
GP.hRct = [];
guidata(gcf,GP);

%=========================================================================
% Tuning interface
%=========================================================================
set( gcf,           'WindowButtonUpFcn',    @FigureMouseBtnUp);
set( GP.hZoomPMenu, 'CallBack',             @AdjustZoom);
set( GP.hDoneBtn,   'CallBack',             @SelectionDone);
set( GP.hRedoBtn,   'CallBack',             @StartOver);

set( GP.hShapeLBox, 'CallBack',             @UpdateShapeAndMode);
set( GP.hModeLBox,  'CallBack',             @UpdateShapeAndMode);

iptaddcallback(gcf, 'WindowButtonMotionFcn', @FigureMouseMove);

uiwait;

if ishandle(GP.hFig)
    GP = guidata(gcf);
    delete(gcf);
    ROI.Xmin    = GP.SP1(1);
    ROI.Xmax    = GP.SP2(1);
    ROI.Ymin    = GP.SP1(2);
    ROI.Ymax    = GP.SP2(2);
    ROI.DX      = GP.SW;
    ROI.DY      = GP.SH;
    % fprintf(' nargin = %g\n',nargin);
    % fprintf('nargout = %g\n',nargout);
    switch nargout
        case 0, % No output parameters
            disp(ROI);
            if ischar(img)
                % FileName was provided
                im = imread(img);
                figure;
                imshow( im( ROI.Xmin:ROI.Xmax, ROI.Ymin:ROI.Ymax, : ) );
            else
                % Image matrix was provided
                figure;
                imshow( img( ROI.Xmin:ROI.Xmax, ROI.Ymin:ROI.Ymax, : ) );
            end
            return
        case 1, % 1 output parameter
            ROI.Xrange  = ROI.Xmin:ROI.Xmax;
            ROI.Yrange  = ROI.Ymin:ROI.Ymax;
            varargout{1} = ROI;
        case 2, % 2 output parameters
            ROI.Xrange  = ROI.Xmin:ROI.Xmax;
            ROI.Yrange  = ROI.Ymin:ROI.Ymax;
            varargout{1} = ROI;
            if ischar(img)
                % FileName was provided
                im = imread(img);
                varargout{2} = im( ROI.Xmin:ROI.Xmax, ROI.Ymin:ROI.Ymax, : );
            else
                % Image matrix was provided
                varargout{2} = img( ROI.Xmin:ROI.Xmax, ROI.Ymin:ROI.Ymax, : );
            end
        otherwise
            msgId = 'VarArgOutTest:invalidNumOutputArguments';
            msg = 'Tne number of output arguments is invalid.';
            error(msgId,'%s',msg);
    end

else
    fprintf('%s: Warning! Figure was closed before selection was retrieved! Empty matrix returned.\n',mfilename);
    switch nargout
        case 0,
            return;
        case 1,
            varargout{1} = [];
            return;
        case 2,
            varargout{1} = [];
            varargout{2} = [];
            return;
    end
end

return;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Done button callback
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function SelectionDone(src,evt)
PDelay  = 0.1;
GP = guidata(gcf);
if ~ValidateSelection
    tf = isempty( get(GP.hStatus, 'String') );
    if tf,set(GP.hStatus, 'String','ERROR: Wrong selection!'); end
    for i=1:7
        set(GP.hStatus, 'ForegroundColor',[1 0 0]); pause(PDelay);
        set(GP.hStatus, 'ForegroundColor',[0 0 0]); pause(PDelay);
    end
    if tf, set(GP.hStatus, 'String',''); end
else
    uiresume;
end
return;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% StartOver button callback
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function StartOver(src,evt)
GP = guidata(gcf);
GP.P1 = [];
GP.P2 = [];
GP.P1   = [];
GP.P2   = [];
GP.SP1  = [];
GP.SP2  = [];
GP.SW   = [];
GP.SH   = [];
set(gcf, 'Name',sprintf('[ %06g : %06g ]; P1 = [ %s]; P2 = [ %s]; Width = %06g; Height = %06g;',GP.cx,GP.cy, sprintf('%06g ',GP.P1), sprintf('%06g ',GP.P2), GP.SW, GP.SH)  );
set(GP.hStatus, 'String','');
DeleteHandleSafely(GP.hCrs); GP.hCrs = [];
DeleteHandleSafely(GP.hRct); GP.hRct = [];
guidata(gcf,GP);
return;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Mouse click callback
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function FigureMouseBtnUp(src,evt)
GP = guidata(gcf);
if isnan(GP.cx)||isnan(GP.cy)
    set(gcf, 'Name','MouseUp outside axes' );
else
    %set(gcf, 'Name',sprintf('[ %06g : %06g ]; P1 = [ %s]; P2 = [ %s]; Width = %06g; Height = %06g;',GP.cx,GP.cy, sprintf('%06g ',GP.P1), sprintf('%06g ',GP.P2), GP.SW, GP.SH)  );
    if isempty(GP.P1)
        % P1 is empty
        GP.P1 = [ GP.cx GP.cy ];
        set(gcf, 'Name',sprintf('[ %06g : %06g ]; P1 = [ %s]; P2 = [ %s]; Width = %06g; Height = %06g;',GP.cx,GP.cy, sprintf('%06g ',GP.P1), sprintf('%06g ',GP.P2), GP.SW, GP.SH)  );
        DeleteHandleSafely(GP.hCrs); GP.hCrs = [];
        if strcmpi( GP.SelectionMode, 'Centered' )
            GP.hCrs = caDrawCross(...
                GP.P1(1),GP.P1(2),13,...
                'xor', 1, 'k',':',...
                'k',8,'normal',...
                '','','','');
        end
        guidata(gcf,GP);
        return;
    else
        % P1 is NOT empty
        if isempty(GP.P2)
            % P2 is empty
            GP.P2 = [ GP.cx GP.cy ];
            %set(gcf, 'Name',sprintf('[ %06g : %06g ] P1 = [ %s] P2 = [ %s]',GP.cx,GP.cy, sprintf('%06g ',GP.P1), sprintf('%06g ',GP.P2) )  );
            %set(gcf, 'Name',sprintf('[ %06g : %06g ]; P1 = [ %s]; P2 = [ %s]; Width = %06g; Height = %06g;',GP.cx,GP.cy, sprintf('%06g ',GP.P1), sprintf('%06g ',GP.P2), GP.SW, GP.SH)  );
            %set(gcf, 'Name',sprintf('[ %06g : %06g ]; P1 = [ %s]; P2 = [ %s]; Width = %06g; Height = %06g;',GP.cx,GP.cy, sprintf('%06g ',GP.SP1), sprintf('%06g ',GP.SP2), GP.SW, GP.SH)  );
            set(gcf, 'Name',sprintf('P1 = [ %s]; P2 = [ %s]; Width = %06g; Height = %06g;',sprintf('%06g ',GP.SP1), sprintf('%06g ',GP.SP2), GP.SW, GP.SH)  );
            DeleteHandleSafely(GP.hCrs); GP.hCrs = [];
            DeleteHandleSafely(GP.hRct); GP.hRct = [];
            GP.hRct = caDrawRectangle(...
                GP.SP1(1),GP.SP1(2),...
                GP.SP2(1),GP.SP2(2),...
                'xor', 1, 'k', '-', 'none',...
                'k',8,'normal',...
                'selection','','','');
            guidata(gcf,GP);
            % FastReturn trick
            if strcmpi(GP.FastReturn_i,'on')
                % GP.FastReturn_i
                SelectionDone(src,evt);
            end
        else
            % P2 is NOT empty
            % set(gcf, 'Name',sprintf('P1 = [ %s]; P2 = [ %s]; Width = %06g; Height = %06g;',sprintf('%06g ',GP.SP1), sprintf('%06g ',GP.SP2), GP.SW, GP.SH)  );
        end
    end
end
return;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Mouse move callback
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function FigureMouseMove(src,evt)
GP = guidata(gcf);
% set(gcf, 'Name',get(GP.hPixVal,'String'));
ts = get(GP.hPixVal,'String');
p1 = strfind(ts, '(');
p2 = strfind(ts, ',');
p3 = strfind(ts, ')');
GP.cx   = str2double( ts( p1(1)+1 : p2(1)-1 ) );
GP.cy   = str2double( ts( p2(1)+1 : p3(1)-1 ) );
GP.CP   = [ GP.cx GP.cy ];

if ~isempty( GP.P1 )
    if ~isempty( GP.P2 )
        % P1 - P2
        DeleteHandleSafely(GP.hCrs); GP.hCrs = [];
        %set(gcf, 'Name',sprintf('P1 = [ %s]; P2 = [ %s]; Width = %06g; Height = %06g;', sprintf('%06g ',GP.SP1), sprintf('%06g ',GP.SP2), GP.SW, GP.SH)  );
    else
        % P1 - CP
        if strcmpi( GP.SelectionMode, 'Centered' )
            if isempty(GP.hCrs)
                GP.hCrs = caDrawCross(...
                    GP.P1(1),GP.P1(2),13,...
                    'xor', 1, 'k',':',...
                    'k',8,'normal',...
                    '','','','');
            end
        else
            DeleteHandleSafely(GP.hCrs); GP.hCrs = [];
        end
        set(GP.hStatus, 'String','');
        if isnan(GP.cx)||isnan(GP.cy)
            set(GP.hStatus, 'String','WARNING: Selection is partially outside the image');
        else
            [GP.SP1,GP.SP2] = RecalculateSelection(GP.P1,GP.CP, GP.AllowedShape, GP.SelectionMode);
            GP.SW = GP.SP2(1) - GP.SP1(1) + 1;
            GP.SH = GP.SP2(2) - GP.SP1(2) + 1;
            guidata(gcf,GP);
            if ~ValidateSelection
                set(GP.hStatus, 'String','WARNING: Selection is partially outside the image');
            end
            DeleteHandleSafely(GP.hRct); GP.hRct = [];
            %caDrawRectangle(X1,Y1,X2,Y2, EraseMode, LWidth,LColor,LStyle, FaceColor, TColor,TSize,FontWeight, TopLabel,BottomLabel,RightLabel,LeftLabel)
            GP.hRct = caDrawRectangle(...
                GP.SP1(1),GP.SP1(2),...
                GP.SP2(1),GP.SP2(2),...
                'xor', 1, 'k', ':', 'none',...
                'k',8,'normal',...
                'selection','','','');
            guidata(gcf,GP);
        end
        set(gcf, 'Name',sprintf('[ %06g : %06g ]; P1 = [ %s]; P2 = [ %s]; Width = %06g; Height = %06g;',GP.cx,GP.cy, sprintf('%06g ',GP.P1), sprintf('%06g ',GP.P2), GP.SW, GP.SH)  );
    end
    %set(gcf, 'Name',sprintf('[ %06g : %06g ]; P1 = [ %s]; P2 = [ %s]; Width = %06g; Height = %06g;',GP.cx,GP.cy, sprintf('%06g ',GP.P1), sprintf('%06g ',GP.P2), GP.SW, GP.SH)  );
end
guidata(gcf,GP);
return;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Zoom callback
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function AdjustZoom(src,evt)
GP  = guidata(gcf);
c   = get(gcbo,'String');
GP.hSPAPI.setMagnification( str2double( c{get(gcbo,'Value')}(1:end-1) ) / 100 );
return;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Deleting handle safely
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function DeleteHandleSafely(h)
for i=1:length(h(:))
    if ishandle( h(i) )
        delete ( h(i) );
    end
end
return;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Updating AllowedShape and SelectionMode
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function UpdateShapeAndMode(src,evt)
GP = guidata(gcf);
GP.AllowedShape     = GP.AllowedShapes  { get(GP.hShapeLBox,'Value') };
GP.SelectionMode    = GP.SelectionModes { get(GP.hModeLBox, 'Value') };
guidata(gcf,GP);
return;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Retrieving parameters from varargin
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function res = GetParameterValue(PName,PNameValArray,DefaultValue)
res = DefaultValue;   % in case PName is not present in PNameValArray
for i=1:2:length(PNameValArray)
    if strcmpi(PNameValArray{i},PName)
        if length(PNameValArray)>i
            res = PNameValArray{i+1};
            break;
        else
            error('%s: Parameter "%s" present, but its value absent',mfilename, PName);
        end
    end
end
return;

%==========================================================================
% Validate selection
%==========================================================================
function res = ValidateSelection
GP = guidata(gcf);
res = true;
if ~isfield(GP,'SP1')
    res = false; return;
end
if ~isfield(GP,'SP2')
    res = false; return;
end
res = res & ( GP.SP1(1) >= GP.XLim(1) );
res = res & ( GP.SP1(1) <= GP.XLim(2) );
res = res & ( GP.SP1(2) >= GP.YLim(1) );
res = res & ( GP.SP1(2) <= GP.YLim(2) );
res = res & ( GP.SP2(1) >= GP.XLim(1) );
res = res & ( GP.SP2(1) <= GP.XLim(2) );
res = res & ( GP.SP2(2) >= GP.YLim(1) );
res = res & ( GP.SP2(2) <= GP.YLim(2) );
return;

%==========================================================================
% Recalculate control points
%==========================================================================
function [r1,r2] = RecalculateControlPoints(p1,p2)
% fprintf( 'p1=[ %06g %06g ] p2=[ %06g %06g ]\n',p1,p2 );
r1  = [ min([ p1(1) p2(1) ]) min([ p1(2) p2(2) ]) ];
r2  = [ max([ p1(1) p2(1) ]) max([ p1(2) p2(2) ]) ];
% fprintf( 'r1=[ %06g %06g ] r2=[ %06g %06g ]\n',r1,r2 );
return;

%==========================================================================
% Recalculate selection rectangle
%==========================================================================
function [sp1,sp2] = RecalculateSelection(p1,p2, SelShape, SelMode)
XLen    = abs( p2(1) - p1(1) );
YLen    = abs( p2(2) - p1(2) );
MinLen  = min( [ XLen YLen ] );
Xsgn    = sign( p2(1) - p1(1) );
Ysgn    = sign( p2(2) - p1(2) );
if strcmpi(SelMode,'Centered')
    if strcmpi(SelShape,'Square')
        sp  = p1 - [Xsgn Ysgn]*MinLen;
        ep  = p1 + [Xsgn Ysgn]*MinLen;
    else
        sp  = p1 + ( p1 - p2 );
        ep  = p2;
    end
else
    if strcmpi(SelShape,'Square')
        sp  = p1;
        ep  = p1 + [Xsgn Ysgn]*MinLen;
    else
        sp  = p1;
        ep  = p2;
    end
end
[sp1,sp2] = RecalculateControlPoints(sp,ep);
return;

%==========================================================================
% Drawing cross in current axes
%==========================================================================
function h = caDrawCross(x,y,L, EraseMode, LWidth,LColor,LStyle, TColor,TSize,FontWeight, TLLabel,TRLabel,BLLabel,BRLabel)
%==========================================================================
%   This functions draws cross with four labels in current axes
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% h = caDrawCross(x,y,L, EraseMode, LWidth,LColor,LStyle,...
%                       TColor,TSize,FontWeight, TLLabel,TRLabel,BLLabel,BRLabel)
% 
%       x,y             Coordinates of center of cross
%       L               Cross size
%                           If L=0 this function draws cross trough full
%                           range of the coordinate system (like ginput)
%       EraseMode       EraseMode property of lines ad all text labels
%       LWidth          Line width
%       LColor          Line color
%       LStyle          Line style
%       TColor          Text color
%       TSize           Text size
%       FontWeight      Font weight
%       TLLabel         Top-left label string
%       TRLabel         Top-right label string
%       BLLabel         Bottom-left label string
%       BRLabel         Bottom-right label string
% 
%       h               array of handles of all created elements
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%   Type
%           help line
%   or
%           help text
%   for more information about line and text parameters
%==========================================================================
c   = 1;
if L>0
    h(c)    = line( [x-0 x+0],[y-L y+L+1], 'LineWidth',LWidth, 'LineStyle',LStyle, 'Color',LColor, 'EraseMode',EraseMode );
    c = c + 1;
    h(c)    = line( [x-L x+L+1],[y-0 y+0], 'LineWidth',LWidth, 'LineStyle',LStyle, 'Color',LColor, 'EraseMode',EraseMode );
    c = c + 1;
else
    h(c)    = line( [x-0 x+0],ylim, 'LineWidth',LWidth, 'LineStyle',LStyle, 'Color',LColor, 'EraseMode',EraseMode );
    c = c + 1;
    h(c)    = line( xlim,[y-0 y+0], 'LineWidth',LWidth, 'LineStyle',LStyle, 'Color',LColor, 'EraseMode',EraseMode );
    c = c + 1;
end
if ~strcmp(TLLabel,'')
    h(c) = text(x,y,[TLLabel ' '],...
        'EraseMode',EraseMode,...
        'HorizontalAlignment','right',...
        'VerticalAlignment','bottom',...
        'Color',TColor,...
        'FontSize',TSize,...
        'FontWeight',FontWeight);
    c   = c + 1;
end
if ~strcmp(TRLabel,'')
    h(c) = text(x,y,[' ' TRLabel],...
        'EraseMode',EraseMode,...
        'HorizontalAlignment','left',...
        'VerticalAlignment','bottom',...
        'Color',TColor,...
        'FontSize',TSize,...
        'FontWeight',FontWeight);
    c   = c + 1;
end
if ~strcmp(BLLabel,'')
    h(c) = text(x,y+1,[BLLabel ' '],...
        'EraseMode',EraseMode,...
        'HorizontalAlignment','right',...
        'VerticalAlignment','top',...
        'Color',TColor,...
        'FontSize',TSize,...
        'FontWeight',FontWeight);
    c   = c + 1;
end
if ~strcmp(BRLabel,'')
    h(c) = text(x,y+1,[' ' BRLabel],...
        'EraseMode',EraseMode,...
        'HorizontalAlignment','left',...
        'VerticalAlignment','top',...
        'Color',TColor,...
        'FontSize',TSize,...
        'FontWeight',FontWeight);
    %c   = c + 1;
end
return;

%==========================================================================
% Drawing rectangle in current axes
%==========================================================================
function h = caDrawRectangle(X1,Y1,X2,Y2, EraseMode, LWidth,LColor,LStyle, FaceColor, TColor,TSize,FontWeight, TopLabel,BottomLabel,RightLabel,LeftLabel)
%==========================================================================
%   This functions draws rectangle with four labels in current axes
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% h = caDrawRectangle(X1,Y1,X2,Y2, EraseMode, LWidth,LColor,LStyle, FaceColor,...
%                       TColor,TSize,FontWeight, TopLabel,BottomLabel,RightLabel,LeftLabel)
% 
%       X1,X2,Y1,Y2     Coordinates of the rectangle
%       EraseMode       EraseMode property of rectangle ad all text labels
%       LWidth          Line width
%       LColor          Line color
%       LStyle          Line style
%       FaceColor       Face color
%       TColor          Text color
%       TSize           Text size
%       FontWeight      Font weight
%       TopLabel        Top label string
%       BottomLabel     Bottom label string
%       RightLabel      Right label string
%       LeftLabel       Left label string
% 
%       h               array of handles of all created elements
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%   Type
%           help rectangle
%   or
%           help text
%   for more information about rectangle and text parameters
%==========================================================================
c   = 1;
if (round(X1)~=round(X2))&&(round(Y1)~=round(Y2))
    h(c) = rectangle('Position',[X1,Y1,X2-X1,Y2-Y1],...
        'FaceColor',FaceColor,...
        'EraseMode',EraseMode,...
        'EdgeColor',LColor,...
        'LineWidth',LWidth,...
        'LineStyle',LStyle);
    c   = c + 1;
end
if ~strcmp(TopLabel,'')
    h(c) = text(X1,Y1,TopLabel,...
        'EraseMode',EraseMode,...
        'HorizontalAlignment','Left',...
        'VerticalAlignment','bottom',...
        'Color',TColor,...
        'FontSize',TSize,...
        'FontWeight',FontWeight);
    c   = c + 1;
end
if ~strcmp(BottomLabel,'')
    h(c) = text(X2,Y2+1,BottomLabel,...
        'EraseMode',EraseMode,...
        'HorizontalAlignment','Right',...
        'VerticalAlignment','top',...
        'Color',TColor,...
        'FontSize',TSize,...
        'FontWeight',FontWeight);
    c   = c + 1;
end
if ~strcmp(RightLabel,'')
    h(c) = text(X2,Y1,RightLabel,...
        'Rotation',-90.0,...
        'EraseMode',EraseMode,...
        'HorizontalAlignment','Left',...
        'VerticalAlignment','bottom',...
        'Color',TColor,...
        'FontSize',TSize,...
        'FontWeight',FontWeight);
    c   = c + 1;
end
if ~strcmp(LeftLabel,'')
    h(c) = text(X1,Y2,LeftLabel,...
        'Rotation',+90.0,...
        'EraseMode',EraseMode,...
        'HorizontalAlignment','Left',...
        'VerticalAlignment','bottom',...
        'Color',TColor,...
        'FontSize',TSize,...
        'FontWeight',FontWeight);
    %c   = c + 1;
end
return;
