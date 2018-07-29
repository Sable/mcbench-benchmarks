%TIXCLOCK Displays Clock Time Using Randomly Lit LEDs
%
% Time is displayed as 6 blocks of LEDs in the form HH:MM:SS
%   Thus,the following display would represent 12:48:37
%
%      o   - - -   o -   o o o   - o   o o o       For this example
%      -   - - o   - o   o o o   o o   - o o           o represents ON
%      -   o - -   o o   - o o   - -   o - o           - represents OFF
%     (1     2      4      8      3      7)
%
% Controls:
%   Change the background color:
%       [CTRL+K] - Change the background color to BLACK
%                  or use the 'View' -> 'Background Color ...' -> 'Black' menu
%       [CTRL+G] - Change the background color to GRAY
%                  or use the 'View' -> 'Background Color ...' -> 'Gray' menu
%       [CTRL+S] - Change the background color to SILVER
%                  or use the 'View' -> 'Background Color ...' -> 'Silver' menu
%        CUSTOM  - Choose your own background color by selecting
%                  the 'View' -> 'Background Color ...' -> 'Custom ...' menu
%   Change the update rate for the clock:
%       [CTRL+1] - Change the update rate to 1 update per second
%                  or use the 'View' -> 'Updates Per Second ...' -> '1' menu
%       [CTRL+2] - Change the update rate to 2 updates per second
%                  or use the 'View' -> 'Updates Per Second ...' -> '2' menu
%       [CTRL+5] - Change the update rate to 5 updates per second
%                  or use the 'View' -> 'Updates Per Second ...' -> '5' menu
%            10  - Choose an update rate of 10 by selecting
%                  the 'View' -> 'Updates Per Second ...' -> '10' menu
%        CUSTOM  - Choose your own update rate by selecting
%                  the 'View' -> 'Updates Per Second ...' -> 'Custom ...' menu
%   Also:
%       [CTRL+X] - Close the clock window
%                  or use the 'File' -> 'Exit' menu
%       [CTRL+M] - Toggle between military (24 hour) and civilian (12 hour) time
%                  or use the 'View' -> 'Military Time' menu
%       [CTRL+V] - Toggle between full screen and normal window views
%                  or use the 'View' -> 'Full Screen' menu
%       [CTRL+H] - View the help notes in the Command Window
%                  or use the 'Help' -> 'Help Notes' menu
%         ABOUT  - View the file version information by selecting
%                  the 'Help' -> 'About' menu
%
% Example:
%     tixclock;
%
% See also: binclock, circlock, stopwatch
%
% Author: Joseph Kirk
% Email: jdkirk630@gmail.com
% Release: 1.0
% Release Date: 10/10/10
function tixclock

% Figure Properties
screenSize = get(0,'ScreenSize');
figSize = [800 200];
figPos = [(screenSize(3:4)-figSize-[3 50]) figSize];
figColor = 0.0*[1 1 1];
offColor = 0.3*[1 1 1];
isFullScreen = 0;
prevWindowSize = figPos;

% Clock Properties
militaryFlag = 1;
timerPeriod = 1;
nSlices = 64;
clockLayout = [
    3 1 1 0 0
    3 3 0 1 0
    3 2 0 0 1
    3 3 1 0 0
    3 2 0 1 0
    3 3 0 0 1];

hFig = figure('Name','Tix Clock',...
    'Position',figPos,...
    'Color',figColor,...
    'NumberTitle','off', ...
    'MenuBar','none', ...
    'ToolBar','none',...
    'ResizeFcn',@resizeFcn,...
    'CloseRequest',@closeRequestFcn);

hAx = axes('Units','normalized',...
    'Position',[0.05 0.05 0.9 0.9],...
    'Visible','off');

% Create Menus
hFileMenu = uimenu('Label','File');
uimenu(hFileMenu,...
    'Label','Exit',...
    'Accelerator','X',...
    'Callback',@closeRequestFcn);
hViewMenu = uimenu('Label','View');
hUpdatePeriod = uimenu(hViewMenu,...
    'Label','Updates Per Second ...');
uimenu(hUpdatePeriod,...
    'Label','1',...
    'Accelerator','1',...
    'Callback',{@changeUpdate,1});
uimenu(hUpdatePeriod,...
    'Label','2',...
    'Accelerator','2',...
    'Callback',{@changeUpdate,0.5});
uimenu(hUpdatePeriod,...
    'Label','5',...
    'Accelerator','5',...
    'Callback',{@changeUpdate,0.2});
uimenu(hUpdatePeriod,...
    'Label','10',...
    'Callback',{@changeUpdate,0.1});
uimenu(hUpdatePeriod,...
    'Label','Custom ...',...
    'Callback',{@changeUpdate,'custom'});
hColorMenu = uimenu(hViewMenu,...
    'Label','Background Color ...');
uimenu(hColorMenu,...
    'Label','Black',...
    'Accelerator','K',...
    'Callback',{@changeBackground,[0 0 0]});
uimenu(hColorMenu,...
    'Label','Gray',...
    'Accelerator','G',...
    'Callback',{@changeBackground,[0.5 0.5 0.5]});
uimenu(hColorMenu,...
    'Label','Silver',...
    'Accelerator','S',...
    'Callback',{@changeBackground,[0.9 0.9 0.9]});
uimenu(hColorMenu,...
    'Label','Custom ...',...
    'Callback',{@changeBackground,'custom'});
hWin = uimenu(hViewMenu,...
    'Label','Full Screen',...
    'Accelerator','V',...
    'Separator','on',...
    'Callback',@windowFcn);
hMil = uimenu(hViewMenu,...
    'Label','Military Time',...
    'Accelerator','M',...
    'Checked','on',...
    'Callback',@milTimeFcn);
hHelpMenu = uimenu('Label','Help');
uimenu(hHelpMenu,...
    'Label','Help Notes',...
    'Accelerator','H',...
    'Callback',@helpFcn);
uimenu(hHelpMenu,...
    'Label','About',...
    'Separator','on',...
    'Callback',@aboutFcn);


% Initializations
hhmmss = zeros(6,1);
nRows = clockLayout(:,1);
nCols = clockLayout(:,2);
nBlocks = size(clockLayout,1);
inColor = ones(nBlocks,3);
outColor = clockLayout(:,3:5);
iLights = nRows .* nCols;
nLights = sum(iLights);
indexShift = [0; cumsum(iLights(1:nBlocks-1))];
t = 2*pi*(0.5:nSlices+0.5)/nSlices;
x = sin(t);
y = -cos(t);
pX = [zeros(1,nSlices+1); x; x([2:nSlices+1 1])];
pY = [zeros(1,nSlices+1); y; y([2:nSlices+1 1])];
u = [-1 1 1 -1 -1];
v = [-1 -1 1 1 -1];
maskX = [u/sqrt(2) v];
maskY = [v/sqrt(2) u];
cMap = cell(1,nBlocks);
for i = 1:nBlocks
    sliceColor = [inColor(i,:);outColor(i,:);outColor(i,:)];
    cMap{i} = repmat(sliceColor,nSlices+1,1);
end

% Draw the LEDs
hLEDs = zeros(nLights,1);
hMask = zeros(nLights,1);
iIndex = 1;
iCol = 1;
iColShift = 0;
for i = 1:nBlocks
    for k = 1:nCols(i)
        for iRow = 1:nRows(i)
            xShift = 2*(iCol+iColShift);
            yShift = 2*iRow;
            hLEDs(iIndex) = patch(pX+xShift,pY+yShift,...
                offColor,'EdgeColor','none');
            hMask(iIndex) = patch(maskX+xShift,maskY+yShift,...
                figColor,'EdgeColor','none');
            iIndex = iIndex + 1;
        end
        iCol = iCol + 1;
    end
    iColShift = iColShift + 1;
end
axis(hAx,'equal')
set(hAx,'Visible','off');
set(hFig,'HandleVisibility','off');

% Start the Timer
hTimer = timer('TimerFcn',@timerFcn,'Period',timerPeriod,'ExecutionMode','FixedRate');
start(hTimer);


    % Function to Callback at Every Update
    function timerFcn(varargin)
        % Update the Clock Time
        hhmmss = getTime(clock);
        for iBlock = 1:nBlocks
            mLights = randperm(iLights(iBlock));
            onIndex = mLights(1:hhmmss(iBlock)) + indexShift(iBlock);
            offIndex = setxor(mLights,mLights(1:hhmmss(iBlock))) + indexShift(iBlock);
            set(hLEDs(onIndex),'FaceVertexCData',cMap{iBlock},'FaceColor','interp');
            set(hLEDs(offIndex),'FaceColor',offColor);
        end
    end

    % Function to Convert Clock Time to HH:MM:SS
    function hhmmss = getTime(t)
        % Parse the Clock Vector
        hh = t(4);
        mm = t(5);
        ss = floor(t(6));
        if ~militaryFlag, hh = mod(hh-1,12)+1; end
        % Extract the HH:MM:SS Values
        hhmmss(1) = floor(hh/10);
        hhmmss(2) = hh - 10*hhmmss(1);
        hhmmss(3) = floor(mm/10);
        hhmmss(4) = mm - 10*hhmmss(3);
        hhmmss(5) = floor(ss/10);
        hhmmss(6) = ss - 10*hhmmss(5);
    end

    % Function to Change Clock Update Period
    function changeUpdate(varargin)
        tmp = varargin{3};
        if isnumeric(tmp)
            timerPeriod = tmp;
        elseif strcmpi(tmp,'custom')
            answer = inputdlg('New Updates Per Second:','Customizer',1,{'1'});
            if ~isempty(answer)
                tmpAnswer = str2double(answer{1});
                if ~isnan(tmpAnswer)
                    timerPeriod = 0.001*round(1000./tmpAnswer);
                end
            end
        end
        stop(hTimer)
        set(hTimer,'Period',timerPeriod);
        start(hTimer)
    end

    % Function to Change the Background Color
    function changeBackground(varargin)
        tmp = varargin{3};
        if isnumeric(tmp)
            figColor = varargin{3};
        elseif strcmpi(tmp,'custom')
            tmpColor = uisetcolor;
            if length(tmpColor) == 3
                figColor = tmpColor;
            end
        end
        set(hFig,'Color',figColor);
        set(hMask,'FaceColor',figColor);
    end

    % Function to Toggle the Time Display between Military and Civilian
    function milTimeFcn(varargin)
        militaryFlag = ~militaryFlag;
        if militaryFlag
            set(hMil,'Checked','on');
        else
            set(hMil,'Checked','off');
        end
        timerFcn();
    end

    % Function to Toggle Between Full Screen and Normal Window Views
    function windowFcn(varargin)
        if isFullScreen
            set(hFig,'Position',prevWindowSize);
            set(hWin,'Label','Full Screen');
        else
            prevWindowSize = get(hFig,'Position');
            set(hFig,'Position',get(0,'ScreenSize')+[5 35 -10 -57]);
            set(hWin,'Label','Restore');
        end
        isFullScreen = ~isFullScreen;
    end

    % Function to Display Help Notes in Command Window
    function helpFcn(varargin)
        eval(['help ' mfilename]);
    end

    % Function to Display File Info
    function aboutFcn(varargin)
        X = ones(51);
        X([1:18 35:51],:) = 2;
        IJ = [175 179 183 583 587 591 787 791 795 991 995 999 1399 1403 ...
            1407 1603 1607 1611 2011 2015 2019 2215 2219 2223 2419 2423 2427];
        ijColor = 3*ones(1,27);
        ijColor(4:12) = 4;
        ijColor(13:18) = 5;
        for kk = 1:length(IJ)
            I = mod(IJ(kk)-1,51)+1;
            J = ceil(IJ(kk)/51);
            X(I:I+1,J:J+1) = ijColor(kk);
        end
        map = [0 0 0;224 223 227;255 0 0;0 255 0;0 0 255]/255;
        % Display a Message Box
        msgbox({' Tix Clock',' Version 1.0 (10/10/10) ',' ',' by Joseph Kirk ',...
            ' <jdkirk630@gmail.com> '},'tixclock','Custom',X,map);
    end

    % Function to Callback when Figure is Resized
    function resizeFcn(varargin)
        axis(hAx,'equal','tight');
    end

    % Function to Callback when Figure is Closed
    function closeRequestFcn(varargin)
        % Stop the Timer
        try
            stop(hTimer)
            delete(hTimer)
        catch errmsg
            disp(errmsg.message);
        end
        % Close the Figure Window
        closereq
    end
end
