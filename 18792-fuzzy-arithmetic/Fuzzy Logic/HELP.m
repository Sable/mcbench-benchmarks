function varargout = HELP(varargin)
% HELP M-file for HELP.fig
%      HELP, by itself, creates a new HELP or raises the existing
%      singleton*.
%
%      H = HELP returns the handle to a new HELP or the handle to
%      the existing singleton*.
%
%      HELP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HELP.M with the given input arguments.
%
%      HELP('Property','Value',...) creates a new HELP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HELP_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HELP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HELP

% Last Modified by GUIDE v2.5 06-Feb-2008 22:52:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HELP_OpeningFcn, ...
                   'gui_OutputFcn',  @HELP_OutputFcn, ...
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


% --- Executes just before HELP is made visible.
function HELP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HELP (see VARARGIN)

% Choose default command line output for HELP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HELP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HELP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
