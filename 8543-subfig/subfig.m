function theFigHandle = subfig(varargin)
%SUBFIG Create figures in tiled positions.
%   SUBFIG is an obvious parallel to SUBPLOT.  SUBFIG allows you to create
%   a figure in a specified tiled position, or resize an existing figure to
%   a specified tiled position.  
%  
%   SUBFIG(m,n,p), or SUBFIG(mnp), creates a figure in the p-th location of
%   an m-by-n matrix of figure locations.  (See SUBPLOT for more details)
%
%   SUBFIG(m,n,P), where P is a vector, creates a figure having a position
%   that covers all the subfig positions listed in P.  P can have
%   fractional components.
%
%   SUBFIG(H,m,n,P), or SUBFIG(H,mnp), where H is a figure handle, resizes
%   figure H as specified.  If figure H does not exist, it is created.  If
%   H already exists, it will become the "current figure".
%
%   SUBFIG(H), where H is a figure handle, will maximize figure H.  If
%   figure H does not exist, it is created.  If H already exists, it will 
%   become the "current figure".
%   Note: if H>100, use SUBFIG(H,111) to maximize H.  Otherwise SUBFIG
%   will interpret H as "mnp".
%
%   SUBFIG, with no arguments, creates a maximized figure.
%
%   H=SUBFIG(...) returns the figure handle.
%
%   SUBFIG('calibrate'), or SUBFIG('calib'), is used to calibrate the
%   sizing of the figure grid.  Without calling a .dll, I know of no way
%   to get the location and size of the windows taskbar within Matlab.  So,
%   to avoid having the taskbar cover part of a figure, the user may want 
%   to re-calibrate SUBFIG based on their own desktop settings.  Running
%   SUBFIG('calibrate') will tell the user how to modify SUBFIG.M
%   appropriately.
%
%   Example:
%     subfig(1, 233); plot(rand(5));           % Fig 1, upper right
%     subfig(2, 2,3,6); plot(rand(5));         % Fig 2, lower right
%     subfig(3, 2,3,[1 2 4 5]); plot(rand(5)); % Fig 3, left two-thirds
%
%   See also  SUBPLOT
%
%   Author:  Jeff Barton, 
%            The Johns Hopkins University Applied Physics Laboratory
%   Date:    September 23, 2005
%   Version: 1.0

%   Acknowledgments:  MathWorks (subplot.m)
%                     Yuval Cohen, Be4 Ltd. (maximize.m on MatlabCentral)
%                     Bill Finger, Creare Inc. (maximize.m on MatlabCentral)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define screen borders (normalized units).
% Setting all the borders to 0.0 may result in some figures
% being covered up by the windows taskbar.
% Use subfig('calibrate') to calibrate these values to your screen.
%
left_border  = 0;         % \ These settings are based on the author's
right_border = 0;         % | desktop preferences, which has a stacked
bottom_border= 0.088542;  % | taskbar on the bottom of the screen.
top_border   = 0;         % / Change values to your liking.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parse inputs
% (much of this code was borrowed from subplot.m)
%
if nargin == 0 
    % No inputs: create a new maximized figure
    nrows   = 1;  % \
    ncols   = 1;  %  ) default sizing: maximize
    thisFig = 1;  % /
    hfig    = -1; % will create a figure later
    
elseif nargin == 1
    
    % The argument could be one of 3 things:
    % 1) a 3-digit number 100 < num < 1000, of the format mnp: subfig(mnp)
    % 2) a figure handle (0 < num < 101 or 1000 < num): subfig(hfig)
    % 3) the string 'calibrate' (or 'calib') for setting screen size
    
    % Check if calibration is desired
    if ischar(varargin{1})
        if strcmp(lower(varargin{1}),'calibrate') | strcmp(lower(varargin{1}),'calib')
            % 3) the string 'calibrate' (or 'calib') for setting screen size
            calibrate_subfig
            return
        end
    end
    
    % Non-numeric is not accepted
    if ~isa(varargin{1},'numeric')
        error('Unrecognized input 1: Non-numeric (Did you mean ''calibrate''?)');
    end
    
    % Non-integer is not accepted
    if rem(varargin{1},1) > 0
        error('Unrecognized input 1: Non-integer');
    end
        
    % Input is either a figure handle or a 3-digit code
    if varargin{1} > 100 & varargin{1} < 1000
        % 1) a 3-digit number 100 < num < 1000, of the format mnp
        hfig = -1; % will create a figure later
        code = varargin{1};
        thisFig = rem(code, 10);
        ncols = rem( fix(code-thisFig)/10,10);
        nrows = fix(code/100);
        if nrows*ncols < thisFig
            error('Index exceeds number of subfigs.');
        end
    else
        % 2) a figure handle (0 < num < 101 or 1000 < num)
        nrows   = 1;  % \
        ncols   = 1;  %  ) default sizing: maximize
        thisFig = 1;  % /
        hfig    = varargin{1};
    end
    
elseif nargin == 2
    
    % Inputs must be of the form: subfig(hfig,mnp)

    % Non-numeric is not accepted
    if ~isa(varargin{1},'numeric')
        error('Unrecognized input 1: Non-numeric');
    end
    if ~isa(varargin{2},'numeric')
        error('Unrecognized input 2: Non-numeric');
    end
    
    % Non-integer is not accepted
    if rem(varargin{1},1) > 0
        error('Unrecognized input 1: Non-integer');
    end
    if rem(varargin{2},1) > 0
        error('Unrecognized input 2: Non-integer');
    end
        
    % Get figure handle and decipher 3-digit code
    hfig = varargin{1};   
    code = varargin{2};
    thisFig = rem(code, 10);
    ncols = rem( fix(code-thisFig)/10,10);
    nrows = fix(code/100);
    if nrows*ncols < thisFig
        error('Index exceeds number of subfigs.');
    end
    
elseif nargin == 3
    
    % Inputs must be of the form: subfig(m,n,p)
    
    hfig = -1; % will create a figure later
    nrows = varargin{1};
    ncols = varargin{2};
    thisFig = varargin{3};
    
elseif nargin == 4
        
    % Inputs must be of the form: subfig(hfig,m,n,p)
    
    hfig = varargin{1};
    nrows = varargin{2};
    ncols = varargin{3};
    thisFig = varargin{4};
    
else
    error('Too many inputs');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Determine figure outerposition
% (much of this code was borrowed from subplot.m)
%
   
% Determine row & column index
row = (nrows-1) -fix((thisFig-1)/ncols);
col = rem (thisFig-1, ncols);

% Determine the outer frame of the grid of figures, based on the borders
frame_pos = [left_border bottom_border (1-right_border-left_border) (1-top_border-bottom_border)];

% compute outerposition relative to screen bounds
rw = max(row)-min(row)+1;
cw = max(col)-min(col)+1;
width = frame_pos(3)/(ncols);
height = frame_pos(4)/(nrows);
outerpos = [frame_pos(1) + min(col)*width, ...
            frame_pos(2) + min(row)*height, ...
            width*cw height*rw];
              
% If necessary, create the figure            
if hfig<0, hfig=figure; end 

% If figure doesn't exist, create it
if ~ishandle(hfig), figure(hfig); end

% Undock the figure, if applicable
if isfield(get(hfig),'WindowStyle')
    if ~strcmp(get(hfig,'WindowStyle'),'normal')
        % Undock
        set(hfig,'WindowStyle','normal');
        % Apparently the undocking process takes a moment, so I needed to
        % pause for fraction of a second.  Not happy about this kludge, but
        % it works for me.
        pause(0.1); 
    end
end

% Set outerposition of figure
% (Much thanks to Bill Finger, Creare Inc., from whom I borrowed some of this code.)
units=get(hfig,'units');
set(hfig,'units','normalized','outerposition',outerpos);
set(hfig,'units',units);

% Make sure that hfig is the current figure when this routine exits
set(0,'currentfigure',hfig)
              
% Set output
if nargout>0
    theFigHandle = hfig;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% SUBFUNCTION: calibrate_subfig
%   Bring up a window to help calibrate this routine to the user's screen
%   size, accounting for the windows taskbar.
%
function calibrate_subfig

% Bring up a calibration window
% (Much thanks to Yuval Cohen, Be4 Ltd., from whom I borrowed some of this code.)
hfig=figure;
hT=text(0,0,{'Calibrating window size.','Please maximize this window','then press any key'}, ...
                'HorizontalAlignment','Center','FontSize',20,'Color','r');
axis([-1 1 -1 1]); axis off
set(hfig,'units','normalized');
pause

% Get maximized outer position
outerpos = get(hfig,'outerposition');
close(hfig);

% Define borders
left_border  = max(0,min(1,outerpos(1)));
right_border = max(0,min(1,1-left_border-outerpos(3)));
bottom_border= max(0,min(1,outerpos(2)));
top_border   = max(0,min(1,1-bottom_border-outerpos(4)));

% Display borders so that use can cut-n-paste into subfig.m
disp('Replace (cut-n-paste) the border definitions in subfig.m with the following:');
disp(['left_border  = ' num2str(left_border) ';']);
disp(['right_border = ' num2str(right_border) ';']);
disp(['bottom_border= ' num2str(bottom_border) ';']);
disp(['top_border   = ' num2str(top_border) ';']);
 


