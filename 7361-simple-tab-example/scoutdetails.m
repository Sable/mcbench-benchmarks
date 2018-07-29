function varargout = scoutdetails(varargin)
% SCOUTDETAILS M-file for scoutdetails.fig
%      SCOUTDETAILS, by itself, creates a new SCOUTDETAILS or raises the existing
%      singleton*.
%
%      H = SCOUTDETAILS returns the handle to a new SCOUTDETAILS or the handle to
%      the existing singleton*.
%
%      SCOUTDETAILS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCOUTDETAILS.M with the given input arguments.
%
%      SCOUTDETAILS('Property','Value',...) creates a new SCOUTDETAILS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before scoutdetails_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to scoutdetails_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help scoutdetails

% Last Modified by GUIDE v2.5 24-Mar-2005 13:43:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @scoutdetails_OpeningFcn, ...
                   'gui_OutputFcn',  @scoutdetails_OutputFcn, ...
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


% --- Executes just before scoutdetails is made visible.
function scoutdetails_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to scoutdetails (see VARARGIN)


% Choose default command line output for scoutdetails
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes scoutdetails wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%Plot helicopter pictures on startup
scout = imread('scout.bmp');
axes(handles.axes1);
image(scout);
axis off;

yaw_pedals = imread('Yaw Pedals.jpg');
axes(handles.axes3);
image(yaw_pedals);
axis off;

collective_lever = imread('Collective Stick.jpg');
axes(handles.axes4);
image(collective_lever);
axis off;

cyclic_stick = imread('Cockpit Instruments.jpg');
axes(handles.axes5);
image(cyclic_stick);
axis off;

% --- Outputs from this function are returned to the command line.
function varargout = scoutdetails_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%Scout Details
function tab1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Control Details
function tab2_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Control Details
function tab3_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close scoutdetails;

% --- Executes on button press in scoutinfo.
function scoutinfo_Callback(hObject, eventdata, handles)
% hObject    handle to scoutinfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(scoutdetails);

set(handles.tab1,'Visible','on');
set(handles.tab2,'Visible','off');
set(handles.tab3,'Visible','off');

% --- Executes on button press in controlinfo.
function controlinfo_Callback(hObject, eventdata, handles)
% hObject    handle to controlinfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(scoutdetails);

set(handles.tab1,'Visible','off');
set(handles.tab2,'Visible','on');
set(handles.tab3,'Visible','off');

% --- Executes on button press in program.
function program_Callback(hObject, eventdata, handles)
% hObject    handle to program (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.tab1,'Visible','off');
set(handles.tab2,'Visible','off');
set(handles.tab3,'Visible','on');

