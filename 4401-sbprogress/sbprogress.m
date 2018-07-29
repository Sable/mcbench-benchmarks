function [nph,nfh] = sbprogress(varargin)
%SBPROGRESS Creates a progress bar in the "status-bar section" of the figure
%[nph,nfh] = sbprogress(varargin)
%   sbprogress creates or updates a progress bar that is created at the
%   status-bar section of a figure. It can either be created on an existing
%   figure or raised along with a newly created figure. At least 2
%   parameters are
%   required (or zero for demo).
%
%   Syntax:
%       sbprogres
%       sbprogress(ph,x)
%       sbprogress([],x)
%       sbprogress(ph,'Close')
%       sbprogress(ph,'Redraw')
%       sbprogress(ph,x,'PropertyName',PropertyValue,...)
%       sbprogress(ph,'PropertyName',PropertyValue,...)
%       sbprogress([],x,'PropertyName',PropertyValue,...)
%       sbprogress([],'PropertyName',PropertyValue,...)
%       [nph,nfh] = sbprogress(...)
%
%   Description:
%       sbprogress runs a demo
%       sbprogress([],x) creates a NEW figure and a NEW progress bar on it with progress being set to x
%       sbprogress(ph,x) updates the progress bar at handles ph with progress being set/changed to x; this also redraws the progress bar
%       sbprogress(ph,'Close') closes an existing progress bar and also a figure if figure was created together with a progress bar otherwise only the progress bar will be removed from the figure
%       sbprogress(ph,'Redraw') redraws an existing progress bar; e.g., when figure is resized
%       sbprogress(...'PropertyName',PropertyValue,...) sets/resets some properties of the progress bar and the newly cretaed figure
%       [nph,nfh] = sbprogress(...) returns handles to newly created progress bar and figure if figure is created along with the progress bar
%
%   Properties:
%       'Parent':   a figure handle on which the progress is to be created
%                   (if empty or not given a new figure will also be raised)
%       'Msg':      a string message that is displayed on the left of a progress bar
%       'Color':    a color of the progress bar and the percentage text (defaults to blue)
%       'Visible':  'on'/'off'; shows/hides the progress bar and its bevel; if a figure is also created then this affect the figure too
%       'Title':    a string title that is displayed in the figure when the
%                   progress bar is created in a new figure; defaults to an empty string
%       'Size':     height of the progress bar; 1..12 (defaults to 1)
%       'Modal':    1 for newly created figure to be modal and 0 to be
%                   non-modal (default)
%       'DisplayMode': 1 (default) percentage and the remaining time are added
%                   to the title string (only when a new figure is raised);
%                   0 - no time info is displayed; 2 - the remaining time is
%                   added to the progress bar (shown only when x > 0);
%                   creating the sbprogress and/or setting the progress (x)
%                   to zero resets the timer
%
%   Notes:
%       X can be a value between -100..100; given x as a negative value
%       means that the percentage number will not be shown.
%       'Modal' and 'Title' are considered only in cases when a new figure is created alogn with the
%       progress bar.
%
%   EXAMPLES:   
%   sbprogress
%           Runs a demo
%   sbprogress([],10,'Msg','Progress:','Title','Test progress')
%           Creates a new figure with a progress bar...
%   ph = sbprogress([],-10,'Msg','Progress:','Title','Test progress')
%           Creates a new figure with a progress bar where the percentage
%           number is not shown; a handle array to the progress-bar axis is also returned
%   sbprogress(ph,'Redraw')
%           Redraws the ph progress bar
%   sbprogress(ph,20)
%           Re-sets the progress-bar's progress
%   ph = sbprogress([],20,'Msg','Test','Parent',fh)
%           Creates a progress bar on an existing figure whose handle is fh
%           and returns its handle array for further manipulation
%           (updating, changing,...)
%   set(fh,'UserData',ph,'ResizeFcn','sbprogress(get(gcf,''UserData''),''redraw'')')
%           Sets figure's (the one with the ph handle) resize function to
%           resize progress bar automatically
%
%   See also: STSBAR, ASCIIPROGRESS
%
%   Primoz Cermelj, 08.12.2003
%   (c) Primoz Cermelj, primoz.cermelj@email.si
%
%   Version: 1.1.0
%   Last revision: 19.02.2005
%--------------------------------------------------------------------------

%----------------
% SBPROGRESS history
%----------------
%
% [v.1.1.0] 19.02.2005
% - NEW: DisplayMode option added to display the remaining time
% - FIX: A bug relating to the Size property fixed
%
% [v.1.0.1] 05.09.2004
% - FIX: Minor update for error-checking
%
% [v.1.0.0] 28.05.2004
% - NEW: First official release

global W border

W = 400;        % Width of a newly created figure
border = 3;

% ---------------------
% First parameter-check and demo run
% ---------------------
if nargin == 0
    % Run a demo
    fh = figure;
    uicontrol('Style','text','String','Try to resize the figure...','Position',[150,200,200,25]);
    [nph,nfh] = sbprogress([],48.5,'Msg','Test:','Title','SBPROGRESS demo','Parent',fh);
    set(fh,'UserData',nph,'ResizeFcn','sbprogress(get(gcf,''UserData''),''redraw'')');
    [nph2,nfh2] = sbprogress([],-0.001,'Msg','Test 2:','Title','SBPROGRESS demo 2','Modal',0,'DisplayMode',1,'Color','r','Size',10);
    for ii=1:10
        sbprogress(nph2,-100*ii/10);
        pause(0.2);
    end
    return
elseif nargin < 2
    error('At least progress length should be given or ''Close'' or ''Redraw'' string');
end

ph = varargin{1};
x = varargin{2};
if ~ishandle(ph)
    error('ph is not a handle');
end

% Default properties
Props.Parent = [];
Props.Msg = '';
Props.Color = 'b';
Props.Title = '';
Props.Visible = 'on';
Props.DisplayMode = 1;
Props.Modal = 0;
Props.Size = 23;     % Default height of a newly created figure; this is aslo related to a progress bar height
propChanged = 0;     % if any property is being changed
phExists = ~isempty(ph);
fhExists = 1;
if phExists
    Data = get(ph,'UserData');
    if ~isfield(Data,'Props')
        error('Props field was not found in progress''s user data. Something was either removed or improper progress-bar handle was given.');
    else
        %%%%%%%%%%%%%%
        Props = Data.Props; % read props from current props
        %%%%%%%%%%%%%%
    end
end

% ---------------------
% Either 'Redraw' or 'Close' is assumed given in the second parameter x
% ---------------------
if ischar(x) & (strcmpi(x,'close') | strcmpi(x,'redraw'))
    if strcmpi(x,'close')
        Data = get(ph,'UserData');
        if ~isempty(Data) && isfield(Data,'fhCreated') && isfield(Data,'fh')
            if Data.fhCreated
                delete(Data.fh);
            else
                delete(ph);
            end
        else
            error('Wrong ph handle given');
        end        
    elseif strcmpi(x,'redraw')
        Data = get(ph,'UserData');
        if ~isempty(Data) && isfield(Data,'fhCreated') && isfield(Data,'fh')
            progress(ph,Data.x,Props,propChanged,Data.fh,Data.fhCreated,'update');
        else
            error('Wrong ph handle given');
        end        
    else
        error('Use sbprogress(ph,''redraw'') or sbprogress(ph,''close'')');
    end
    return
end
  
% ---------------------
% x might be ommited, empty, numeric value or a property name
% Sets any default values and any given ones given under properties
% ---------------------
if ischar(x)    % x is assumed being ommited (property is given)
    start = 2;
else
    start = 3;
end
if ~isnumeric(x) | isempty(x)
    if phExists
        x = Data.x;
    else
        x = 0;
    end
end
if nargin > 2       % additional properties are being passed
    nProps = nargin - start + 1;
    propChanged = 1;
    if ~logical( 2*floor(nProps/2)==nProps ), error('Additional properties must be given in pairs'), end;
    for ii=start:2:start+nProps-2
        if strcmpi(varargin{ii},'parent')
            Props.Parent = varargin{ii+1};
        elseif strcmpi(varargin{ii},'msg')
            Props.Msg = varargin{ii+1};
        elseif strcmpi(varargin{ii},'color')
            Props.Color = varargin{ii+1};            
        elseif strcmpi(varargin{ii},'title')
            Props.Title = varargin{ii+1};
        elseif strcmpi(varargin{ii},'visible')
            Props.Visible = varargin{ii+1};            
        elseif strcmpi(varargin{ii},'modal')
            Props.Modal = logical(varargin{ii+1});
        elseif strcmpi(varargin{ii},'size')
            Props.Size = varargin{ii+1};
        elseif strcmpi(varargin{ii},'displaymode')
            Props.DisplayMode = varargin{ii+1};
        else
            error('Unknown property given');
        end            
    end
    if (Props.Size < 1) | (Props.Size > 12)
        Props.Size = 23;
    else
        Props.Size = round(Props.Size) + 22;
    end
end

if isempty(Props.Parent) || ~ishandle(Props.Parent)
    fhExists = 0;
else
    if ~ishandle(ph)
        phExists = 0;
    end     
end
if ~phExists    % new progress bar is to be created
    fhCreated = 0;
    if ~fhExists
       nfh = createnewfig(Props); 
       fh = nfh;
       Props.Parent = fh;
       fhCreated = 1;
    else
       fh = Props.Parent;
    end
    nph = progress([],x,Props,1,fh,fhCreated,'new');
    ph = nph;
else
    progress(ph,x,Props,propChanged,Data.fh,Data.fhCreated,'update');
end

if nargout > 0
    nph = ph;
    if nargout > 1
        nfh = fh;
    end
end
%-------------------------------------


%-------------------------------------
function fh = createnewfig(Props)
global W
H = Props.Size;
if isempty(Props.Title); Props.Title = ''; end;
set(0,'Units','Pixels');
scr = get(0,'ScreenSize');
fh = figure('Visible','off');
set(fh,'Units','Pixels',...
       'Tag','progressBarFigure',...
       'Position',[scr(3)/2-W/2 scr(4)/2-H/2 W H],...
       'MenuBar','none',...
       'Resize','off',...
       'NumberTitle','off',...
       'Name',Props.Title);
if Props.Modal
    set(fh,'WindowStyle','modal');
end
if strcmpi(Props.Visible,'on')
    set(fh,'Visible','On');
end
%-------------------------------------

%-------------------------------------
function [ph,hMsg] = progress(ph,x,Props,propChanged,fh,fhCreated,state)
% Creates a new progress or updates an existing one
global border

H = Props.Size;
[fPos,pPos] = getcoords(fh,H);
w = pPos(3);
if x < -100; x = 0; end;
if x > 100; x = 100; end;
if propChanged
    if isempty(Props.Msg); Props.Msg = ''; end;
    if isempty(Props.Title); Props.Title = ''; end;
    if isempty(Props.Msg)
        Data.xMsgPos = 0;
    else
        Data.xMsgPos = 2*border;
    end
end
timeStr = '';
if nargin < 5 || strcmpi(state,'new')
    Data.startTime = clock;
    if Props.DisplayMode ~= 0
        timeStr = '?? remaining';
    end
    ph = axes;
    set(ph,'Tag','progressBarAxes','Units','Pixels','Position',pPos,'Box','off','Visible','off');      
    Data.hMsg = text(Data.xMsgPos,0.55*H,Props.Msg,'Units','Pixels','Tag','progressBarMsg','Visible','off');    
else            % update
    Data = get(ph,'UserData');
    if x == 0
        Data.startTime = clock;
    end
    if Props.DisplayMode ~= 0
        remTime = (100/abs(x+0.00000001)-1)*etime(clock,Data.startTime);        
        timeStr = sec2timestr(abs(remTime));
    end
    fh = Data.fh;
    set(ph,'Position',pPos);
    set(Data.hMsg,'String',Props.Msg,'Position',[Data.xMsgPos 0.55*H]);    
end
%-----
set(ph,'XLim',[0 w],'YLim',[0 H]);
%-----
tPos = get(Data.hMsg,'Extent');
if (tPos(3)+tPos(1)) > 0.5*w;  pStart = 0.5*w; else;  pStart = (tPos(3)+tPos(1)+2*border); end;
pEnd = pStart + abs(x)/100*abs(w-border-pStart);
%-----
if nargin < 5 || strcmpi(state,'new')    
    Data.hRec = rectangle('Position',[pStart border w-border-pStart-1 H-2*border-1],'Tag','progressBarRec','Visible','off');
    Data.hPatch = patch([pStart; pEnd; pEnd; pStart],[border; border; H-border-1; H-border-1],Props.Color,'Tag','progressBarPatch','Visible','off');
    if Props.DisplayMode == 2
        addStr = ['   ' timeStr];
    else
        addStr = '';
    end
    Data.hPercTxt = text( (pStart+w-border-1)/2,0.55*H,[num2str(abs(x),'%2.2f') '%' addStr],'Color',Props.Color,'Units','Pixels','FontWeight','bold','Tag','progressBarPercTxt','Visible','Off','EraseMode','xor','HorizontalAlignment','Center');
    Data.hFrame = panel(fh,ph,'new');
else                   
    set(Data.hRec,'Position',[pStart border w-border-pStart-1 H-2*border-1]);
    set(Data.hPatch,'XData',[pStart; pEnd; pEnd; pStart],'YData',[border; border; H-border-1; H-border-1],'FaceColor',Props.Color);
    if Props.DisplayMode == 2
        addStr = ['   ' timeStr];
    else
        addStr = '';
    end
    set(Data.hPercTxt,'Position',[(pStart+w-border-1)/2 0.55*H],'String',[num2str(abs(x),'%2.2f') '%' addStr],'Color',Props.Color);
    Data.hFrame = panel(fh,ph,'update');
end
%-----
if fhCreated
    fPos = get(fh,'Position');
    fPos(4) = H;
    if Props.DisplayMode == 1
        addStr = ['[' num2str(abs(x),'%2.2f') '%  ' timeStr ']'];
    else
        addStr = '';
    end
    set(fh,'Name',[Props.Title '  ' addStr],'Position',fPos);
    if propChanged
        if Props.Modal
            set(fh,'WindowStyle','modal');
        else
            set(fh,'WindowStyle','normal');
        end
        if strcmpi(Props.Visible,'on')
            set(fh,'Visible','on');
        else
            set(fh,'Visible','off');
        end
    end
end
%-----
if x >= 0 & strcmpi(Props.Visible,'on')
    set(Data.hPercTxt,'Visible','On');
else
    set(Data.hPercTxt,'Visible','Off');
end
if propChanged
    if strcmpi(Props.Visible,'on')
        set(Data.hRec,'Visible','On');
        set(Data.hMsg,'Visible','On');
        set(Data.hPatch,'Visible','On');
        set(Data.hFrame,'Visible','On');
    else
        set(Data.hRec,'Visible','Off');
        set(Data.hMsg,'Visible','Off');
        set(Data.hPatch,'Visible','Off');
        set(Data.hFrame,'Visible','Off');
    end
end
Data.Props = Props;
Data.pStart = pStart;
Data.fh = fh;
Data.fhCreated = fhCreated;
Data.x = x;
Data.msg = Props.Msg;
set(ph,'UserData',Data);
drawnow;
%-------------------------------------


%-------------------------------------
function frame = panel(fh,ph,state);
% Creates a virtual panel surrounding the progress bar.
% fh is the figure's handdle, ph is the progress' handle (axes).
% It returns a handle array designating the frame.
% See also the self-contained function BEVEL.
pos = get(ph,'Position');
x = pos(1);
y = pos(2);
w = pos(3);
h = pos(4);
col = rgb2hsv(get(fh,'Color'));
downColor = col;   downColor(2) = 0.5*downColor(2);  downColor(3) = 0.9; downColor = hsv2rgb(downColor);
upColor = col;    upColor(3) = 0.4;  upColor = hsv2rgb(upColor);
frame = zeros(4,1);
if nargin < 3 || strcmpi(state,'new')
    frame(1) = line([1 w],[h-1 h-1],[0 0],'Color',upColor,'Visible','off');
    frame(2) = line([1 1],[1 h-1],'Color',upColor,'Visible','off');
    frame(3) = line([2 w-1],[1 1],'Color',downColor,'Visible','off');
    frame(4) = line([w-1 w-1],[1 h-1],'Color',downColor,'Visible','off');
else
    Data = get(ph,'UserData');
    frame = Data.hFrame;
    set(frame(1),'XData',[1 w],'YData',[h-1 h-1]);
    set(frame(2),'XData',[1 1],'YData',[1 h-1]);
    set(frame(3),'XData',[2 w-1],'YData',[1 1]);
    set(frame(4),'XData',[w-1 w-1],'YData',[1 h-1]);
end
%-------------------------------------


%-------------------------------------
function [fPos,pPos] = getcoords(fh,H)
% Returns coordinates for axis, frame, and msg for our sbprogress (for
% creation or updating purposes). fPos is figure's position, pPos is
% progress-bar's position, framPos is frame's position
%
% Progress-bar axis
fUnits = get(fh,'Units');
set(fh,'Units','Pixels');
fPos = get(fh,'Position');
set(fh,'Units',fUnits);
pPos = fPos;
pPos(1) = 1;
pPos(2) = 2;
pPos(3) = pPos(3)-2;
pPos(4) = H-1;
%-------------------------------------


%-------------------------------------
function timeStr = sec2timestr(sec)
% Convert a time measurement from seconds into a human readable string.
dd = floor(sec/86400);
hh = floor((sec-dd*86400)/3600);
mm = floor((sec-dd*86400-hh*3600)/60);
ss = ceil(sec-dd*86400-hh*3600-mm*60);
timeStr = '';
if dd
    timeStr = sprintf('%d days, %d hr remaining',dd,hh);
elseif hh
    timeStr = sprintf('%d hr, %d min remaining',hh,mm);
elseif mm
    timeStr = sprintf('%d min, %d sec remaining',mm,ss);
else
    if sec < 0.01
        timeStr = 'completed';
    else
        timeStr = sprintf('%d seconds remaining',ss);
    end
end
%-------------------------------------