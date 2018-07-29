function varargout = SpSpj(varargin)
%example of using buttons to start and stop events created by Paulo Silva
%SPSPJ M-file for SpSpj.fig
%      SPSPJ, by itself, creates a new SPSPJ or raises the existing
%      singleton*.
%
%      H = SPSPJ returns the handle to a new SPSPJ or the handle to
%      the existing singleton*.
%
%      SPSPJ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPSPJ.M with the given input arguments.
%
%      SPSPJ('Property','Value',...) creates a new SPSPJ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SpSpj_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SpSpj_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SpSpj

% Last Modified by GUIDE v2.5 04-Dec-2010 01:32:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SpSpj_OpeningFcn, ...
                   'gui_OutputFcn',  @SpSpj_OutputFcn, ...
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


% --- Executes just before SpSpj is made visible.
function SpSpj_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SpSpj (see VARARGIN)

% Choose default command line output for SpSpj
handles.output = hObject;
global CountValue;
global KeepRunning;
CountValue=0;
KeepRunning=1;
set(handles.pushbutton1,'Enable','on');
set(handles.pushbutton2,'Enable','off');
set(handles.pushbutton3,'Enable','off');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SpSpj wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SpSpj_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%start

global CountValue;
global KeepRunning;
KeepRunning=1;

set(handles.pushbutton1,'Enable','off');
set(handles.pushbutton2,'Enable','on');
set(handles.pushbutton3,'Enable','on');

while (KeepRunning)
CountValue=CountValue+1;
set(handles.text1,'String',num2str(CountValue));
pause(0.5);
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CountValue;
global KeepRunning;
KeepRunning=0;
set(handles.pushbutton1,'Enable','on');
set(handles.pushbutton2,'Enable','off');
set(handles.pushbutton3,'Enable','off');

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CountValue;
global KeepRunning;
CountValue=0;
KeepRunning=0;
set(handles.pushbutton1,'Enable','on');
set(handles.pushbutton2,'Enable','off');
set(handles.pushbutton3,'Enable','off');
set(handles.text1,'String','0');


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global KeepRunning;
KeepRunning=0;
pause(1);

% Hint: delete(hObject) closes the figure
delete(hObject);