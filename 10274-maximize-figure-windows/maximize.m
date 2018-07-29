function maximize(h)

% MAXIMIZE   maximize figure windows
% ====================================================================
%
%        Berne University of Applied Sciences
%
%        School of Engineering and Information Technology
%        Division of Electrical- and Communication Engineering
%
% ====================================================================
%                       maximize figure windows
% ====================================================================
%
% Author:    Alain Trostel
% e-mail:    alain.trostel@bfh.ch
% Date:      June 2007
% Version:   4.1
%
% ====================================================================
%
% function maximize(h)
%
% Input parameters
% -----------------
%   h             handle(s) of the figure window
%
%
% Output parameters
% ------------------
%   The function has no output parameters.
%
%
% Used files
% -----------
%   - windowMaximize.dll
%
%
% Examples
% ---------
%   % maximize the current figure
%   ------------------------------
%   maximize;
%
%
%   % maximize the current figure
%   ------------------------------
%   maximize(gcf);
%
%
%   % maximize the specified figure
%   --------------------------------
%   h = figure;
%   maximize(h);
%
%
%   % maximize the application window
%   ----------------------------------
%   maximize(0);
%
%
%   % maximize more than one figure
%   --------------------------------
%   h(1) = figure;
%   h(2) = figure;
%   maximize(h);
%
%
%   % maximize all figures
%   -----------------------
%   maximize('all');
%
%
%   % maximize a GUI in the OpeningFcn
%   -----------------------------------
%
%   % --- Executes just before untitled is made visible.
%   function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
%   % This function has no output args, see OutputFcn.
%   % hObject    handle to figure
%   % eventdata  reserved - to be defined in a future version of MATLAB
%   % handles    structure with handles and user data (see GUIDATA)
%   % varargin   command line arguments to untitled (see VARARGIN)
%
%   % Choose default command line output for untitled
%   handles.output = hObject;
%
%   % Update handles structure
%   guidata(hObject, handles);
%
%   % UIWAIT makes untitled wait for user response (see UIRESUME)
%   % uiwait(handles.figure1);
%
%   % maximize the GUI
%   set(hObject,'Visible','on');
%   maximize(hObject);



% check if dll-file exists
if ~exist('windowMaximize.dll','file')
    error('windowMaximize.dll not found.');
end

% if no input parameters, get handle of the current figure
if nargin == 0
    h = gcf;
end

% if one input parameter, check the input parameter
if ischar(h)
    % check the string
    if strcmpi(h,'all')
        % get all figure handles
        h = findobj('Type','figure');            
    else
        % incorrect string argument
        error('Argument must be the correct string.');
    end
else
    % check each handle
    for n=1:length(h)
        % it must be a handle and of type 'root' or 'figure'
        if ~ishandle(h(n)) || (~strcmp(get(h(n),'Type'),'root') && ...
                               ~strcmp(get(h(n),'Type'),'figure'))
            % incorrect handle
            error('Argument(s) must be a correct handle(s).');
        end
    end
end

% if handle is not the root
if h ~= 0
    % for each handle
    for n=length(h):-1:1
        % create the temporary window name
        windowname = ['maximize_',num2str(h(n))];

        % save current window name
        numTitle = get(h(n),'NumberTitle');
        figName = get(h(n),'Name');

        % set the temporary window name
        set(h(n),'Name',windowname,'NumberTitle','off');

        % draw figure now
        drawnow;
        % maximize the window with the C function
        windowMaximize(windowname,get(h(n),'Resize'));

        % reset the window name
        set(h(n),'Name',figName,'NumberTitle',numTitle);
    end
else
    % maximize the application window "MATLAB"
    windowMaximize('MATLAB');
end