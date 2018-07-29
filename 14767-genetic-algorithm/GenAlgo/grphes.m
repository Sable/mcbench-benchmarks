function varargout = grphes(varargin)
% GRPHES M-file for grphes.fig
%      GRPHES, by itself, creates a new GRPHES or raises the existing
%      singleton*.
%
%      H = GRPHES returns the handle to a new GRPHES or the handle to
%      the existing singleton*.
%
%      GRPHES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRPHES.M with the given input arguments.
%
%      GRPHES('Property','Value',...) creates a new GRPHES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before grphes_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to grphes_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help grphes

% Last Modified by GUIDE v2.5 24-Jun-2006 17:19:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @grphes_OpeningFcn, ...
                   'gui_OutputFcn',  @grphes_OutputFcn, ...
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


% --- Executes just before grphes is made visible.
function grphes_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to grphes (see VARARGIN)

% Choose default command line output for grphes
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes grphes wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = grphes_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
