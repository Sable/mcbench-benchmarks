function h = waitbar(X,varargin)
%  WAITBAR a modified version of MATLAB's waitbar function.
%__________________________________________________________________________
%     H = WAITBAR(X,'message') creates and displays a waitbar of fractional 
%           length X.  The handle to the waitbar figure is returned in H.
%           X should be between 0 and 1. 
%  
%     WAITBAR(X) will set the length of the bar in the most recently
%           created waitbar window to the fractional length X.
%  
%     WAITBAR(X,H) will set the length of the bar in waitbar H
%           to the fractional length X.
%  
%     WAITBAR(X,H,'message') will update the message text in
%           the waitbar figure, in addition to setting the fractional
%           length to X.
%  
%     WAITBAR is typically used inside a FOR loop that performs a
%           lengthy computation.  
%  
%     Example:
%         h = waitbar(0,'Please wait...');
%         for i=1:1000,
%             % computation here %
%             waitbar(i/1000,h)
%         end
%
% NOTES:
% - This progarm produced with heavy modification of Chad English's timebar
% function.  The update was designed to recieve input identically to
% MATLAB's waitbar function to allow for interchangability.
%
% - This program does not apply the property values that the traditional
% waitbar allows.
%
%__________________________________________________________________________

% 1 - GATHER THE INPUT
    if nargin == 1;
        h = findobj(allchild(0),'flat','Tag','waitbar');
        message = '';
    elseif isnumeric(X) & ishandle(varargin{1}) & nargin == 2;
        h = varargin{1}; message = '';
    elseif isnumeric(X) & ischar(varargin{1}) & nargin == 2;
        h = []; message = varargin{1}; 
    elseif isnumeric(X) & ishandle(varargin{1}) & nargin == 3;
        h = varargin{1}; message = varargin{2};
    else
        disp('Error defnining waitbar'); return;
    end

% 2 - BUILD/UPDATE THE MESSAGE BAR
    if  isempty(h) || ~ishandle(h(1)); h = buildwaitbar(X,message);       
    else updatewaitbar(h,X,message); end     

%--------------------------------------------------------------------------
% SUBFUNCTION: buildwaitbar
function h = buildwaitbar(X,message)
% BUILDWAITBAR constructs the figure containing the waitbar

 % 1 - SET WINDOW SIZE AND POSITION 
    % 1.1 - Gather screen information
        screensize = get(0,'screensize');  % User's screen size 
        screenwidth = screensize(3);       % User's screen width
        screenheight = screensize(4);      % User's screen height

    % 1.2 - Define the waitbar position
        winwidth = 300;           % Width of timebar window
        winheight = 85;           % Height of timebar window
        winpos = [0.5*(screenwidth-winwidth), ...
            0.5*(screenheight-winheight), winwidth, winheight];  % Position
                                                            
% 2 - OPEN FIGURE AND SET PROPERTIES  
    wincolor = 0.85*[1 1 1]; % Define window color
  
    % 2.1 - Define the main waitbar figure
    h = figure('menubar','none','numbertitle','off',...
        'name','0% Complete','position',winpos,'color',wincolor,...                                
        'tag','waitbar','IntegerHandle','off');                               

    % 2.2 - Define the message textbox
    userdata.text(1) = uicontrol(h,'style','text','hor','left',...     
        'pos',[10 winheight-30 winwidth-20 20], 'string',message,...                                            
        'backgroundcolor',wincolor,'tag','message');                                 

    % 2.3 - Build estimated remaining static text textbox
    est_text = 'Estimated time remaining: ';                
    userdata.text(2) = uicontrol(h,'style','text','string',est_text,...       
        'pos',[10 15 winwidth/2 20],'FontSize',7,...
        'backgroundcolor',wincolor,'HorizontalAlignment','right');                                

    % 2.4 - Build estimated time textbox
    userdata.remain = uicontrol(h,'style','text','string','',...
        'FontSize',7,'HorizontalAlignment','left',...   
        'pos',[winwidth/2+10 14.5 winwidth-25 20], ...                                  
        'backgroundcolor',wincolor);     
                                 
    % 2.5 - Build elapsed static text textbox
    est_text = 'Total elapsed time: ';                
    userdata.text(3) = uicontrol(h,'style','text','string',est_text,...       
        'pos',[10 3 winwidth/2 20],'FontSize',7,...
        'backgroundcolor',wincolor,'HorizontalAlignment','right');                                

    % 2.6 - Build elapsed time textbox
    userdata.elapse = uicontrol(h,'style','text','string','',...   
        'pos',[winwidth/2+10 3.5 winwidth-25 20],'FontSize',7, ...                                  
        'backgroundcolor',wincolor,'HorizontalAlignment','left');     
                                 
    % 2.7 - Build percent progress textbox
    userdata.percent = uicontrol(h,'style','text','hor','right',...     
        'pos',[winwidth-35 winheight-52 28 20],'string','',...                                       
        'backgroundcolor',wincolor);                                      
    
    % 2.8 - Build progress bar axis
    userdata.axes = axes('parent',h,'units','pixels','xlim',[0 1],...                                
        'pos',[10 winheight-45 winwidth-50 15],'box','on',...                                     
        'color',[1 1 1],'xtick',[],'ytick',[]);                             
    
% 3 - INITILIZE THE PROGESS BAR
    userdata.bar = ...
        patch([0 0 0 0 0],[0 1 1 0 0],'r');  % Initialize  bar to zero area
    userdata.time = clock;                   % Record the current time
    userdata.inc = clock;                    % Set incremental clock 
    set(h,'userdata',userdata)               % Store data in thefigure
    updatewaitbar(h,X,message);              % Updates waitbar if X~=0
  
%--------------------------------------------------------------------------
% SUBFUNCTION: updatewaitbar
function updatewaitbar(h,progress,message)
% UPDATEWAITBAR changes the status of the waitbar progress

% 1 - GATHER WAITBAR INFORMATION
    drawnow;                        % Needed for window to appear
    h = h(1);                       % Only allow newest waitbar to update                                                 
    userdata = get(h,'userdata');   % Get userdata from waitbar figure

    % Check object tag to see if it is a timebar
    if ~strcmp(get(h,'tag'), 'waitbar')                     
        error('Handle is not for a waitbar window')          
    end

    % Update the message
        if ~isempty(message);
            hh = guihandles(h);
            set(hh.message,'String',message);
        end

% 2 - UPDATE THE GUI (only update if more tha 1 sec has passed)
    if etime(clock,userdata.inc) > 1 || progress == 1

    % 2.1 - Compute the elapsed time and incremental time 
        elap = etime(clock,userdata.time);  % the total elapsed time
        userdata.inc = clock; set(h,'Userdata',userdata); % store current

    % 2.2 - Calculate the estimated time remaining
        sec_remain = elap*(1/progress-1);
        e_mes = datestr(elap/86400,'HH:MM:SS');
        r_mes = datestr(sec_remain/86400,'HH:MM:SS');

    % 2.3 - Produce error if progress is > 1
        if progress > 1; r_mes = 'Error, progress > 1'; end

    % 2.4 - Update information
        set(userdata.bar,'xdata',[0 0 progress progress 0]) % Update bar
        set(userdata.remain,'string',r_mes); % Update remaining time string   
        set(userdata.elapse,'string',e_mes); % Update elapsed time string                
        set(userdata.percent,'string',...                   
            strcat(num2str(floor(100*progress)),'%')); % Update progress %
        set(h,'Name',[num2str(floor(100*progress)),...
            '% Complete']); % Update figure name
       
    end