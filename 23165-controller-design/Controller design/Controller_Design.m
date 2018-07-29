function varargout = Controller_Design(varargin)
% CONTROLLER_DESIGN M-file for Controller_Design.fig
%      CONTROLLER_DESIGN, by itself, creates a new CONTROLLER_DESIGN or raises the existing
%      singleton*.
%
%      H = CONTROLLER_DESIGN returns the handle to a new CONTROLLER_DESIGN or the handle to
%      the existing singleton*.
%
%      CONTROLLER_DESIGN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONTROLLER_DESIGN.M with the given input arguments.
%
%      CONTROLLER_DESIGN('Property','Value',...) creates a new CONTROLLER_DESIGN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Controller_Design_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Controller_Design_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Controller_Design

% Last Modified by GUIDE v2.5 30-Jul-2008 12:47:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Controller_Design_OpeningFcn, ...
                   'gui_OutputFcn',  @Controller_Design_OutputFcn, ...
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


% --- Executes just before Controller_Design is made visible.
function Controller_Design_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Controller_Design (see VARARGIN)

% Choose default command line output for Controller_Design
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Controller_Design wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Controller_Design_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in PID_pushb.
function PID_pushb_Callback(hObject, eventdata, handles)
% hObject    handle to PID_pushb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PID_Controller

% --- Executes on button press in SFB_pushb.
function SFB_pushb_Callback(hObject, eventdata, handles)
% hObject    handle to SFB_pushb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

state_feedback_gui
