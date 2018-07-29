function stopwatch(varargin)
%STOPWATCH  Displays elapsed time from keyboard or button inputs
% STOPWATCH(TIME) Initializes the stopwatch with a time offset
%     TIME should be a real (positive or negative) scalar in units of seconds
% STOPWATCH(CLK) Starts the stopwatch running in clock mode
%     CLK should be a 6 element vector in CLOCK format
%
%   Controls:
%     Press the START button to begin the timer (or press any key except L, R, or X)
%         If the timer has already been activated, press the PAUSE button to
%           stop the timer (or press any key except L, R, or X)
%         If the timer has been paused, press the RESUME button to continue from
%           the paused time (or press any key except L, R, or X)
%         If the timer is in lap mode, press the RESUME button to continue as though
%           the lap time had not been activated (or press any key except L, R, or X)
%     Press the LAP button to view lap times (or press the L key)
%         The LAP button can be pressed successively to view mulitple laps
%     Press the RESET button to restore the timer (or press the R key)
%     Press the EXIT button to close the timer window (or press the X key)
%
%   Example:
%     % start the stopwatch
%     stopwatch;
%
%   Example:
%     % start the stopwatch with a positive offset
%     stopwatch(3598.765);
%
%   Example:
%     % count down from one hour
%     stopwatch(-3600);
%
%   Example:
%     % start the stopwatch with time already running
%     stopwatch(clock);
%
%   Example:
%     % start the stopwatch with running time since the day began
%     time = clock;
%     time(4:6) = 0;
%     stopwatch(time);
%
%   Example:
%     % count down the time until midnight
%     time = clock;
%     time(3:6) = [time(3)+1 0 0 0];
%     stopwatch(time);
%
% See also: clock, etime, binclock, circlock
%
% Author: Joseph Kirk
% Email: jdkirk630@gmail.com
% Release: 3.1
% Release Date: 4/23/08

T1 = clock;
STOPPED = 1;
LAPFLAG = 0;
TIME = 0;

% Figure Window
hfig = figure('Name','Stopwatch',...
    'Numbertitle','off',...
    'Position',[600 500 350 100],...
    'Menubar','none',...
    'Resize','off',...
    'KeyPressFcn',@keyPressFcn,...
    'CloseRequestFcn',@closeRequestFcn);

% Menus
filemenu = uimenu('Label','File');
uimenu(filemenu,'Label','Exit','Callback',@closeRequestFcn);
helpmenu = uimenu('Label','Help');
uimenu(helpmenu,'Label','Help Notes','Callback',['help ' mfilename]);
uimenu(helpmenu,'Label','About','Separator','on','Callback',@aboutFcn);

% Buttons
START = uicontrol(hfig,'Style','PushButton',...
    'Position',[10 10 75 25],...
    'String','START',...
    'Callback',@startFcn);
LAP = uicontrol(hfig,'Style','PushButton',...
    'Position',[95 10 75 25],...
    'String','LAP (L)',...
    'Enable','off',...
    'Callback',@lapFcn);
uicontrol(hfig,'Style','PushButton',...
    'Position',[180 10 75 25],...
    'String','RESET (R)',...
    'Callback',@resetFcn);
uicontrol(hfig,'Style','PushButton',...
    'Position',[265 10 75 25],...
    'String','EXIT (X)',...
    'Callback',@closeRequestFcn);

% Stopwatch Time Display
DISPLAY = uicontrol(hfig,'Style','text',...
    'Position',[10 45 330 55],...
    'BackgroundColor',[0.8 0.8 0.8],...
    'FontSize',35);

set(hfig,'HandleVisibility','off');

% Process Inputs
for var = varargin
    input = var{1};
    if isscalar(input)
        TIME = input;
    elseif length(var{1}) == 6
        target_time = var{1};
        TIME = etime(T1,target_time);
        STOPPED = 0;
        set(START,'String','PAUSE','Callback',@pauseFcn);
        set(LAP,'Enable','on');
    end
end
str = formatTimeFcn(TIME);
set(DISPLAY,'String',str);

% Start the Timer
htimer = timer('TimerFcn',@timerFcn,'Period',0.001,'ExecutionMode','FixedRate');
start(htimer);

    function timerFcn(varargin)
        if ~STOPPED
            time_elapsed = etime(clock,T1);
            str = formatTimeFcn(TIME + time_elapsed);
            set(DISPLAY,'String',str);
        end
    end

    function keyPressFcn(varargin)
        % Parse Keyboard Inputs
        switch upper(get(hfig,'CurrentCharacter'))
            case 'L'
                if isequal(get(LAP,'Enable'),'on')
                    lapFcn;
                end
            case 'R', resetFcn;
            case 'X', closeRequestFcn;
            otherwise
                if STOPPED
                    startFcn;
                else
                    pauseFcn;
                end
        end
    end

    function startFcn(varargin)
        % Start the Stopwatch
        if LAPFLAG
            T2 = clock;
            time_elapsed = etime(T2,T1);
            T1 = T2;
            TIME = TIME + time_elapsed;
        else
            T1 = clock;
        end
        STOPPED = 0;
        set(START,'String','PAUSE','Callback',@pauseFcn);
        set(LAP,'Enable','on');
    end

    function pauseFcn(varargin)
        % Pause the Stopwatch
        STOPPED = 1;
        LAPFLAG = 0;
        time_elapsed = etime(clock,T1);
        TIME = TIME + time_elapsed;
        str = formatTimeFcn(TIME);
        set(DISPLAY,'String',str);
        set(START,'String','RESUME','Callback',@startFcn);
        set(LAP,'Enable','off');
    end

    function lapFcn(varargin)
        % Display the Lap Time
        STOPPED = 1;
        LAPFLAG = 1;
        time_elapsed = etime(clock,T1);
        str = formatTimeFcn(TIME + time_elapsed);
        set(DISPLAY,'String',str);
        set(START,'String','RESUME','Callback',@startFcn);
    end

    function resetFcn(varargin)
        % Reset the Stopwatch
        STOPPED = 1;
        LAPFLAG = 0;
        TIME = 0;
        str = formatTimeFcn(TIME);
        set(DISPLAY,'String',str);
        set(START,'String','START','Callback',@startFcn);
        set(LAP,'Enable','off');
    end

    function str = formatTimeFcn(float_time)
        % Format the Time String
        float_time = abs(float_time);
        hrs = floor(float_time/3600);
        mins = floor(float_time/60 - 60*hrs);
        secs = float_time - 60*(mins + 60*hrs);
        h = sprintf('%1.0f:',hrs);
        m = sprintf('%1.0f:',mins);
        s = sprintf('%1.3f',secs);
        if hrs < 10
            h = sprintf('0%1.0f:',hrs);
        end
        if mins < 10
            m = sprintf('0%1.0f:',mins);
        end
        if secs < 9.9995
            s = sprintf('0%1.3f',secs);
        end
        str = [h m s];
    end

    function aboutFcn(varargin)
        msgbox({' Stopwatch GUI',' Version 3.1  (4/23/08)','',...
            ' by Joseph Kirk  <jdkirk630@gmail.com>'},'About');
    end

    function closeRequestFcn(varargin)
        % Stop the Timer
        try
            stop(htimer)
            delete(htimer)
        catch errmsg
            rethrow(errmsg);
        end
        % Close the Figure Window
        closereq;
    end
end
