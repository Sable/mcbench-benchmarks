function varargout = Lotka_VolterraGUI(varargin)
% LOTKA_VOLTERRAGUI M-file for Lotka_VolterraGUI.fig
%      LOTKA_VOLTERRAGUI, by itself, creates a new LOTKA_VOLTERRAGUI or raises the existing
%      singleton*.
%
%      H = LOTKA_VOLTERRAGUI returns the handle to a new LOTKA_VOLTERRAGUI or the handle to
%      the existing singleton*.
%
%      LOTKA_VOLTERRAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOTKA_VOLTERRAGUI.M with the given input arguments.
%
%      LOTKA_VOLTERRAGUI('Property','Value',...) creates a new LOTKA_VOLTERRAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Lotka_VolterraGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Lotka_VolterraGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help Lotka_VolterraGUI

% Last Modified by GUIDE v2.5 02-Dec-2005 23:18:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Lotka_VolterraGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Lotka_VolterraGUI_OutputFcn, ...
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


% --- Executes just before Lotka_VolterraGUI is made visible.
function Lotka_VolterraGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Lotka_VolterraGUI (see VARARGIN)

% Choose default command line output for Lotka_VolterraGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Lotka_VolterraGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Lotka_VolterraGUI_OutputFcn(hObject, eventdata, handles) 
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
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x0=[0.85 3.2];
[t,x]=ode45(@LV,[0 10],x0);
axes(handles.axes1);
plot(t,x(:,1),'r');hold on
plot(t,x(:,2),'g');
axis([0,10,0,5]);
Xlabel('temps');
Ylabel('X et Y');
hold off
axes(handles.axes2);
plot(x(:,1),x(:,2),'b');hold on
axis([0.5,1,2.5,3.5]);
Xlabel('X');
Ylabel('Y');
hold off




