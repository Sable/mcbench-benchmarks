function varargout = buttons(varargin)
% BUTTONS M-file for buttons.fig
%      BUTTONS, by itself, creates a new BUTTONS or raises the existing
%      singleton*.
%
%      H = BUTTONS returns the handle to a new BUTTONS or the handle to
%      the existing singleton*.
%
%      BUTTONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BUTTONS.M with the given input arguments.
%
%      BUTTONS('Property','Value',...) creates a new BUTTONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before buttons_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to buttons_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help buttons

% Last Modified by GUIDE v2.5 10-Sep-2002 16:54:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @buttons_OpeningFcn, ...
                   'gui_OutputFcn',  @buttons_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before buttons is made visible.
function buttons_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to buttons (see VARARGIN)

% Choose default command line output for buttons
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Set the icons of the buttons. These functions are defined later in the
% M-code. The 'playbutton' and the 'stopbutton' functions read in image
% files and then extracts enough data from them to form a small icons. The
% 'fasterbutton' and 'slowerbutton' function do not do anything at this
% point.
set(handles.play,'cdata',playbutton);
set(handles.stop,'cdata',stopbutton);
set(handles.faster,'cdata',fasterbutton);
set(handles.slower,'cdata',slowerbutton);

% Set graphics parameters.
set(handles.figure1,'color','k')

% UIWAIT makes buttons wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = buttons_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Eigenvalues.
lambda = [9.6397238445, 15.19725192, 2*pi^2, ...
    29.5214811, 31.9126360, 41.4745099, 44.948488, ...
    5*pi^2, 5*pi^2, 56.709610, 65.376535, 71.057755];

% Eigenfunctions
for k = 1:12
   L{k} = membrane(k);
end

% Get coefficients from eigenfunctions.
for k = 1:12
    c(k) = L{k}(25,23)/3;
end
 
% Set graphics parameters.
x = (-15:15)/15;
h = surf(x,x,L{1});
[a,e] = view; view(a+270,e);
axis([-1 1 -1 1 -1 1]);
caxis(26.9*[-1.5 1]);
colormap(hot);
axis off

% Run
t = 0;
dt = 0.025;
set(handles.figure1,'userdata',dt);
set(handles.play,'enable','off');
while ishandle(handles.figure1) & get(handles.play,'value') == 1
    % Coefficients
    dt = get(handles.figure1,'userdata');
    t = t + dt;
    s = c.*sin(sqrt(lambda)*t);

    % Amplitude
    A = zeros(size(L{1}));
    for k = 1:12
      A = A + s(k)*L{k};
    end

    % Velocity
    s = lambda .*s;
    V = zeros(size(L{1}));
    for k = 1:12
      V = V + s(k)*L{k};
    end
    V(16:31,1:15) = NaN;

    % Surface plot of height, colored by velocity.
    set(h,'zdata',A,'cdata',V);
    drawnow
end;


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.play,'value',0);
set(handles.play,'enable','on');


% --- Executes on button press in faster.
function faster_Callback(hObject, eventdata, handles)
% hObject    handle to faster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.figure1,'userdata',sqrt(2.0)*get(handles.figure1,'userdata'))


% --- Executes on button press in slower.
function slower_Callback(hObject, eventdata, handles)
% hObject    handle to slower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.figure1,'userdata',sqrt(0.5)*get(handles.figure1,'userdata'))


% --- Hand-written callback 
% --- Used to return 'CData' for the Stop icon on the Record\Stop toggle button
function stop = stopbutton

stop = iconize(imread('stop.jpg'));
stop(stop==255) = .8*255;


% --- Hand-written callback 
% --- Used to return 'CData' for the Play icon on the Play button
function play = playbutton

play = iconize(imread('play.jpg'));
play(play==255) = .8*255;


% --- Hand-written callback 
% --- Used to return 'CData' for the Faster icon on the Faster button
function faster = fasterbutton

faster = [];


% --- Hand-written callback 
% --- Used to return 'CData' for the Slower icon on the Slower button
function slower = slowerbutton

slower = [];


% --- Hand-written callback 
% --- Used to create icon data from an image, a
function out = iconize(a)

% Find the size of the acquired image and determine how much data will need
% to be lost in order to form a 18x18 icon
[r,c,d] = size(a);
r_skip = ceil(r/18);
c_skip = ceil(c/18);

% Create the 18x18 icon (RGB data)
out = a(1:r_skip:end,1:c_skip:end,:);