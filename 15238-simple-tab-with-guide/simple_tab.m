function varargout = simple_tab(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simple_tab_OpeningFcn, ...
                   'gui_OutputFcn',  @simple_tab_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before simple_tab is made visible.
function simple_tab_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for simple_tab

global color1
global color2

color1 = [0.3569,0.502,0.6588];
color2 = [0.55,0.66,0.77];


handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simple_tab wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simple_tab_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;

% =================================
% ==========  my code   ===========
% =================================


function uipanel1_ButtonDownFcn(hObject, eventdata, handles)
choice1(handles)

function uipanel2_ButtonDownFcn(hObject, eventdata, handles)
choice2(handles)

function text3_ButtonDownFcn(hObject, eventdata, handles)       % the trick is to have 'enable' set to 'inactive'
choice1(handles)

function text4_ButtonDownFcn(hObject, eventdata, handles)
choice2(handles)


function choice1(handles)
global color1
global color2

set(handles.uipanel1,'BackgroundColor',color1);
set(handles.uipanel1,'BorderType','line');

set(handles.uipanel2,'BackgroundColor',color2);
set(handles.uipanel2,'BorderType','none');

set(handles.text3,'BackgroundColor',color1);
set(handles.text4,'BackgroundColor',color2);

set(handles.uipanel4,'Visible','on');
set(handles.uipanel7,'Visible','on');
set(handles.uipanel5,'Visible','off');
set(handles.uipanel9,'Visible','off');

function choice2(handles)
global color1
global color2

set(handles.uipanel2,'BackgroundColor',color1);
set(handles.uipanel2,'BorderType','line');

set(handles.uipanel1,'BackgroundColor',color2);
set(handles.uipanel1,'BorderType','none');

set(handles.text4,'BackgroundColor',color1);
set(handles.text3,'BackgroundColor',color2);

set(handles.uipanel4,'Visible','off');
set(handles.uipanel7,'Visible','off');
set(handles.uipanel5,'Visible','on');
set(handles.uipanel9,'Visible','on');

