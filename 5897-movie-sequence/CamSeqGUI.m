function varargout = CamSeqGUI(varargin)
% CAMSEQGUI M-file for CamSeqGUI.fig
%      CAMSEQGUI, by itself, creates a new CAMSEQGUI or raises the existing
%      singleton*.
%
%      H = CAMSEQGUI returns the handle to a new CAMSEQGUI or the handle to
%      the existing singleton*.
%
%      CAMSEQGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAMSEQGUI.M with the given input arguments.
%
%      CAMSEQGUI('Property','Value',...) creates a new CAMSEQGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CamSeqGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CamSeqGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help CamSeqGUI

% Last Modified by GUIDE v2.5 19-Sep-2004 12:05:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CamSeqGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @CamSeqGUI_OutputFcn, ...
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


% --- Executes just before CamSeqGUI is made visible.
function CamSeqGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CamSeqGUI (see VARARGIN)

% Choose default command line output for CamSeqGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CamSeqGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CamSeqGUI_OutputFcn(hObject, eventdata, handles) 
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
set(handles.figure1,'Visible','off');
period = input(' Period in seconde between this view and the previous? > ');
set(handles.figure1,'Visible','on');
figure(1)
if isempty(period),
    period = 2;
end
handles.cam = CamSeqUpdate(handles.cam,period);
guidata(hObject,handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.figure1,'Visible','off');
handles.fps = input(' Number of Frame per second? > ');
set(handles.figure1,'Visible','on');
figure(1)
if isempty(handles.fps),
    handles.fps = 20;
end
handles.seq = CamSeqGen(handles.cam,handles.fps);
guidata(hObject,handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.figure1,'Visible','off');
handles.filename = input(' File name for the avi? > ','s');
set(handles.figure1,'Visible','on');
figure(1)
CamSeqPlay(handles.seq,handles.fps,handles.filename);
guidata(hObject,handles);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(1)
handles.cam = CamSeqUpdate([]);
guidata(hObject,handles);


