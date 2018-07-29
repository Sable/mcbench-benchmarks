function varargout = HELP3(varargin)
% HELP3 M-file for HELP3.fig
%      HELP3, by itself, creates a new HELP3 or raises the existing
%      singleton*.
%
%      H = HELP3 returns the handle to a new HELP3 or the handle to
%      the existing singleton*.
%
%      HELP3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HELP3.M with the given input arguments.
%
%      HELP3('Property','Value',...) creates a new HELP3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HELP3_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HELP3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HELP3

% Last Modified by GUIDE v2.5 06-Feb-2008 23:04:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HELP3_OpeningFcn, ...
                   'gui_OutputFcn',  @HELP3_OutputFcn, ...
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


% --- Executes just before HELP3 is made visible.
function HELP3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HELP3 (see VARARGIN)

% Choose default command line output for HELP3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HELP3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HELP3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
