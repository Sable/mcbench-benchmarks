function h = timebar(message,name,update_rate)

% TIMEBAR Progress bar with estimated time remaining
%    H = TIMEBAR('message','name') creates and displays a progress
%    bar with alphanumeric progress percentage and estimated time
%    time remaining.  A user input message ('message') is displayed,
%    typically to distinguish what process is being monitored, and
%    'name' is an optional figure name.  The figure handle H is 
%    returned.
%
%    TIMEBAR(H,X) will update the length of the progress bar, the
%    percentage complete, and the estimated time remaining, where
%    X is a fractional progress between 0 (initial) and 1 (complete).
%    (Note that the order of H,X is opposite to waitbar.)
%
%    TIMEBAR(H,X,RATE) will update the progress bar and information
%    at a rate given by RATE in seconds.  Default is 0.1 seconds.
%
%    The estimated time remaining is linear using the initial time 
%    (when TIMEBAR is first opened), the current time, and the percent 
%    complete.
%
%    TIMEBAR is typically used inside a FOR loop or during numerical
%    simulation.  A sample for loop is shown below:
%
%       h = timebar('Loop counter','Progress')
%       for i = 1:100
%          % computation here %
%          timebar(h,1/100)
%       end
%       close(h)
%
%    A sample for numerical integration is shown below:
%
%       % script file
%       t0 = 0;
%       tf = 60;
%       h = timebar('Simulation integration','Progress')
%       [tt,xx] = ode45('states.m',[t0 tf],initial_conditions);
%       close(h)
%
%       % states.m
%       function xdot = states(t,x)
%       xdot(1) = ...;
%       xdot(2) = ...;
%       ...
%       timebar(h,(t-t0)/(tf-t0))
%
%    Version: 2.0
%    Version History:
%    1.0   2002-01-18   Initial release
%    2.0   2002-01-21   Added update rate option
%
%    Copyright 2002, Chad English
%    cenglish@myrealbox.com

if nargin < 3                                               % If update rate is not input
    update_rate = 0.1;                                      %    set it to 0.1 seconds
end

if ~ishandle(message)                                       % If first input is not a timebar handle, 
                                                            %    treat as new timebar
                                                            
    %%%%%%%%%% SET WINDOW SIZE AND POSITION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    winwidth = 300;                                         % Width of timebar window
    winheight = 75;                                         % Height of timebar window
    screensize = get(0,'screensize');                       % User's screen size [1 1 width height]
    screenwidth = screensize(3);                            % User's screen width
    screenheight = screensize(4);                           % User's screen height
    winpos = [0.5*(screenwidth-winwidth), ...
       0.5*(screenheight-winheight), winwidth, winheight];  % Position of timebar window origin
                                                            
    %%%%%%%% END SET WINDOW SIZE AND POSITION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%% OPEN FIGURE AND SET PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin < 2
        name = '';                                          % If timebar name not input, set blank
    end
    
    wincolor = 0.75*[1 1 1];                                % Define window color
    est_text = 'Estimated time remaining: ';                % Set static estimated time text
    
    h = figure('menubar','none',...                         % Turn figure menu display off
        'numbertitle','off',...                             % Turn figure numbering off
        'name',name,...                                     % Set the figure name to input name
        'position',winpos,...                               % Set the position of the figure as above
        'color',wincolor,...                                % Set the figure color
        'resize','off',...                                  % Turn of figure resizing
        'tag','timebar');                                   % Tag the figure for later checking

    userdata.text(1) = uicontrol(h,'style','text',...       % Prepare message text (set the style to text)
        'pos',[10 winheight-30 winwidth-20 20],...          % Set the textbox position and size
        'hor','center',...                                  % Center the text in the textbox
        'backgroundcolor',wincolor,...                      % Set the textbox background color
        'foregroundcolor',0*[1 1 1],...                     % Set the text color
        'string',message);                                  % Set the text to the input message

    userdata.text(2) = uicontrol(h,'style','text',...       % Prepare static estimated time text
        'pos',[10 5 winwidth-20 20],...                     % Set the textbox position and size
        'hor','left',...                                    % Left align the text in the textbox
        'backgroundcolor',wincolor,...                      % Set the textbox background color
        'foregroundcolor',0*[1 1 1],...                     % Set the text color
        'string',est_text);             % Set the static text for estimated time

    userdata.text(3) = uicontrol(h,'style','text',...       % Prepare estimated time
        'pos',[135 5 winwidth-145 20],...                   % Set the textbox position and size
        'hor','left',...                                    % Left align the text in the textbox
        'backgroundcolor',wincolor,...                      % Set the textbox background color
        'foregroundcolor',0*[1 1 1],...                     % Set the text color
        'string','');                                       % Initialize the estimated time as blank

    userdata.text(4) = uicontrol(h,'style','text',...       % Prepare the percentage progress
        'pos',[winwidth-35 winheight-50 25 20],...          % Set the textbox position and size
        'hor','right',...                                   % Left align the text in the textbox
        'backgroundcolor',wincolor,...                      % Set the textbox background color
        'foregroundcolor',0*[1 1 1],...                     % Set the textbox foreground color
        'string','');                                       % Initialize the progress text as blank
    
    userdata.axes = axes('parent',h,...                     % Set the progress bar parent to the figure
        'units','pixels',...                                % Provide axes units in pixels
        'pos',[10 winheight-45 winwidth-50 15],...          % Set the progress bar position and size
        'xlim',[0 1],...                                    % Set the range from 0 to 1
        'box','on',...                                      % Turn on axes box (to see where 100% is)
        'color',[1 1 1],...                                 % Set plot background color to white
        'xtick',[],'ytick',[]);                             % Turn off axes tick marks and labels
    
    userdata.bar = patch([0 0 0 0 0],[0 1 1 0 0],'r');      % Initialize progress bar to zero area
    userdata.time = clock;                                  % Record the current time
    userdata.inc = clock;                                   % Set incremental clock to current time
    set(h, 'userdata', userdata)                            % Allow access to the text and axes settings 
                                                            %    by including them with the timebar data
    %%%%%%%% END OPEN FIGURE AND SET PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
else                                                        % If first input is a timebar handle, update 
                                                            %    the window
    %%%%%%%%%% GET HANDLE AND PROGRESS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pause(10e-100)                                          % Message, bar, and static text won't display
                                                            %    without arbitrary pause (don't know why)
    h = message;                                            % Set handle to first input      
    progress = name;                                        % Set progress to second input

    if ~strcmp(get(h,'tag'), 'timebar')                     % Check object tag to see if it is a timebar
        error('Handle is not to a timebar window')          % If not a timebar, report error and stop
    end
    %%%%%%%% END GET HANGLE AND PROGRESS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%% CALCULATE ESTIMATED TIME REMAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    userdata = get(h,'userdata');                           % Get the userdata included with the timebar
    inc = clock-userdata.inc;                               % Calculate time increment since last update
    inc_secs = inc(3)*3600*24 + inc(4)*3600 + ...
        inc(5)*60 + inc(6);                                 % Convert the increment to seconds

    if [inc_secs > update_rate] | [progress == 1]           % Only update at update rate or 100% complete 
        userdata.inc = clock;                               % If updating, reset the increment clock
        set(h,'userdata',userdata)                          % Update userdata with the new clock setting
        tpast = clock-userdata.time;                        % Calculate time since timebar initialized
        seconds_past = tpast(3)*3600*24 + tpast(4)*3600 + ...
            tpast(5)*60 + tpast(6);                         % Transform passed time into seconds
        estimated_seconds = seconds_past*(1/progress-1);    % Estimate the time remaining in seconds
        hours = floor(estimated_seconds/3600);              % Calculate integer hours of estimated time
        minutes = floor((estimated_seconds-3600*hours)/60); % Calculate integer minutes of estimated time
        seconds = floor(estimated_seconds-3600*hours- ...
            60*minutes);                                    % Calculate integer seconds of estimated time
        tenths = floor(10*(estimated_seconds - ...
            floor(estimated_seconds)));                     % Calculate tenths of seconds (as integer)
        %%%%%%%% END CALCULATE ESTIMATED TIME REMAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
        %%%%%%%%%% UPDATE ESTIMATED TIME AND PROGRESS TO TIMEBAR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if progress > 1                                     % Check if input progress is > 1
            time_message = ' Error!  Progress > 1!';        % If >1, print error to estimated time
            time_color = 'r';                               %    in red
        else
            if hours < 10; h0 = '0'; else h0 = '';end       % Put leading zero on hours if < 10
            if minutes < 10; m0 = '0'; else m0 = '';end     % Put leading zero on minutes if < 10
            if seconds < 10; s0 = '0'; else s0 = '';end     % Put leading zero on seconds if < 10
            time_message = strcat(h0,num2str(hours),':',m0,...
                num2str(minutes),':',s0,num2str(seconds),...
                '.',num2str(tenths),' (hh:mm:ss.t)');       % Format estimated time as hh:mm:ss.t
            time_color = 'k';                               % Format estimated time text as black
        end

        set(userdata.bar,'xdata',[0 0 progress progress 0]) % Update progress bar
        set(userdata.text(3),'string',time_message,...
            'foregroundcolor',time_color);                  % Update estimated time
        set(userdata.text(4),'string',...
            strcat(num2str(floor(100*progress)),'%'));      % Update progress percentage
    end
    %%%%%%%% END UPDATE ESTIMATED TIME AND PROGRESS TO TIMEBAR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

%%%%%%%%%% TIMEBAR HANDLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargout == 0                                             % If handle not asked for
    clear h                                                 %    do not output it
end
%%%%%%%% END TIMEBAR HANDLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%