function varargout = OregonatorGUI(varargin)
% OREGONATORGUI M-file for OregonatorGUI.fig
%      OREGONATORGUI, by itself, creates a new OREGONATORGUI or raises the existing
%      singleton*.
%
%      H = OREGONATORGUI returns the handle to a new OREGONATORGUI or the handle to
%      the existing singleton*.
%
%      OREGONATORGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OREGONATORGUI.M with the given input arguments.
%
%      OREGONATORGUI('Property','Value',...) creates a new OREGONATORGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OregonatorGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OregonatorGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help OregonatorGUI

% Last Modified by GUIDE v2.5 02-Dec-2005 23:24:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OregonatorGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @OregonatorGUI_OutputFcn, ...
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


% --- Executes just before OregonatorGUI is made visible.
function OregonatorGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OregonatorGUI (see VARARGIN)

% Choose default command line output for OregonatorGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OregonatorGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OregonatorGUI_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x0=[1 1 1];

[t,x]=ode15s(@oregonator,[0 600],x0);

axes(handles.axes1);
plot(t,x(:,1),'r');
axis([300,600,0,100]);
title('figure1');
Xlabel('temps');
Ylabel('x(1)');

axes(handles.axes2);
plot(t,x(:,2),'g');
axis([300,600,0,3]);
title('figure2');
Xlabel('temps');
Ylabel('x(2)');

axes(handles.axes3);
plot(t,x(:,3),'m');
axis([300,600,0,100]);
title('figure3');
Xlabel('temps');
Ylabel('x(3)');

