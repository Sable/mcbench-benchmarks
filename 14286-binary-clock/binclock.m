function binclock(color)
%BINCLOCK  Binary Clock - Displays the clock time in binary representation
% BINCLOCK(COLOR) Displays the LEDs with the specified color
%     where COLOR is a 1x3 vector with values in the range [0,1]
%
% Time is displayed as 6 columns of LEDs in the form HH:MM:SS
%   Thus,the following display would represent 09:15:24
%        o   -   -   (8)
%        - - o - o   (4)        For this example
%      - - - - o -   (2)            o represents ON
%      - o o o - -   (1)            - represents OFF
%     (0 9 1 5 2 4)
%
% Controls:
%   Change the color of the LEDs by using the 'Color' menu or use shortcut keys:
%       [CTRL+R] - Red        [CTRL+O] - Orange
%       [CTRL+Y] - Yellow     [CTRL+G] - Green
%       [CTRL+B] - Blue       [CTRL+P] - Purple
%       [CTRL+W] - White      [CTRL+A] - Random
%       [CTRL+U] - Custom...
%   Also:
%       [CTRL+M] - Toggle between military (24 hour) and civilian (12 hour) time
%                  or use the 'Display' -> 'Military Time' menu 
%       [CTRL+H] - View the help notes in the Command Window
%                  or use the 'Help' -> 'Help Notes' menu 
%       [CTRL+X] - Close the clock window
%                  or use the 'File' -> 'Exit' menu 
%
% Example:
%     binclock;  % starts the clock with blue LEDs (default)
%
% Example:
%     binclock([0 1 0]);  % starts the clock with green LEDs
%
% Example:
%     binclock(rand(1,3));  % starts the clock with random colored LEDs
%
% Author: Joseph Kirk
% Email: jdkirk630 at gmail dot com
% Release: 1.5
% Release Date: 7/26/07

% process input
if ~nargin
    color = [0 0 1];
elseif length(color) < 3
    error('Invalid input: COLOR must be a 1x3 vector ');
else
    color = max(0,min(1,color(1:3)));
end

% create the figure window
figure('Name','Binary Clock', ...
    'NumberTitle','off', ...
    'MenuBar','none', ...
    'Color','k', ...
    'DoubleBuffer','on', ...
    'CloseRequestFcn',@closeRequestFcn);
axes('Units','normalized','Position',[0.1 0.1 0.8 0.8]);

% create menus
filemenu = uimenu('Label','File');
colormenu = uimenu('Label','Color');
displaymenu = uimenu('Label','Display');
helpmenu = uimenu('Label','Help');
uimenu(filemenu,'Label','Exit','Callback',@closeRequestFcn,'Accel','X');
uimenu(colormenu,'Label','Red','Callback',@clr2red,'Accel','R');
uimenu(colormenu,'Label','Orange','Callback',@clr2orange,'Accel','O');
uimenu(colormenu,'Label','Yellow','Callback',@clr2yellow,'Accel','Y');
uimenu(colormenu,'Label','Green','Callback',@clr2green,'Accel','G');
uimenu(colormenu,'Label','Blue','Callback',@clr2blue,'Accel','B');
uimenu(colormenu,'Label','Purple','Callback',@clr2purple,'Accel','P');
uimenu(colormenu,'Label','White','Callback',@clr2white,'Accel','W');
uimenu(colormenu,'Label','Random','Callback',@clr2random,'Accel','A');
uimenu(colormenu,'Label','Custom...','Separator','on','Callback',@clr2custom,'Accel','U');
mil = uimenu(displaymenu,'Label','Military Time','Callback',@milTimeFcn,'Accel','M');
uimenu(helpmenu,'Label','Help Notes','Callback',['clc;help ',mfilename],'Accel','H');
uimenu(helpmenu,'Label','About','Callback',@displayHelp);

% initializations
mil_flag = 0;
t = linspace(0,2*pi,100);
xcir = cos(t)/4;
ycir = sin(t)/4;
dec = zeros(1,6);
LEDs = zeros(6,4);
flag = ones(6,4);
flag([1 3 5],1) = 0;
flag(1,2) = 0;

% create the LED handles
time = clock;
getBinValues(time);
hold on;
for col = 1:6
    for row = 1:4
        if flag(col,row)
            LEDs(col,row) = patch(xcir+col,ycir-row,[0 0 0],'EdgeColor','none');
        end
    end
end
axis equal off
hold off;
set(gcf,'HandleVisibility','off');

% start the timer
htimer = timer('TimerFcn',@timerFcn,'Period',0.1,'ExecutionMode','FixedRate');
start(htimer);

    function timerFcn(varargin)
        % update the clock time
        time = clock;
        getBinValues(time);
        for b = 1:6
            bin = dec2bin(dec(b),4);
            for s = 1:4
                if flag(b,s)
                    if strcmp(bin(s),'1')
                        c = color;
                    else
                        c = 0.25*color;
                    end
                    set(LEDs(b,s),'FaceColor',c);
                end
            end
        end
    end

    function getBinValues(time)
        % parse the time vector
        hh = time(4);
        mm = time(5);
        ss = floor(time(6));
        if ~mil_flag
            hh = mod(hh-1,12)+1;
        end
        % calculate the HH:MM:SS values
        dec(1) = floor(hh/10);
        dec(2) = hh - 10*dec(1);
        dec(3) = floor(mm/10);
        dec(4) = mm - 10*dec(3);
        dec(5) = floor(ss/10);
        dec(6) = ss - 10*dec(5);
    end

    function milTimeFcn(varargin)
        % toggle the time display
        mil_flag = ~mil_flag;
        if mil_flag
            set(mil,'Checked','on');
        else
            set(mil,'Checked','off');
        end
    end

    % functions to clr the color of the LEDs
    function clr2red(varargin),color = [1 0 0]; end
    function clr2orange(varargin),color = [1 0.5 0]; end
    function clr2yellow(varargin),color = [1 1 0]; end
    function clr2green(varargin),color = [0 1 0]; end
    function clr2blue(varargin),color = [0 0 1]; end
    function clr2purple(varargin),color = [0.67 0 1]; end
    function clr2white(varargin),color = [1 1 1]; end
    function clr2random(varargin),color = rand(1,3); end
    function clr2custom(varargin)
        try
            custom_color = [uisetcolor 0 0];
            color = custom_color(1:3);
        catch
            prompt = {' Red: [0, 1]',' Green: [0, 1]',' Blue: [0, 1]'};
            answer = inputdlg(prompt,'Custom Color',1,{'0','1','1'});
            if ~isempty(answer)
                r = str2double(answer{1});
                g = str2double(answer{2});
                b = str2double(answer{3});
                color = max(0,min(1,[r(1) g(1) b(1)]));
            end
        end
    end

    function displayHelp(varargin)
        % display a message box
        msgbox({' Binary Clock (v1.5) ',' ',' by Joseph Kirk ', ...
            ' jdkirk630@gmail.com '},'binclock');
    end

    function closeRequestFcn(varargin)
        % stop the timer
        try
            stop(htimer)
            delete(htimer)
        catch
        end
        % close the figure window
        closereq
    end
end
