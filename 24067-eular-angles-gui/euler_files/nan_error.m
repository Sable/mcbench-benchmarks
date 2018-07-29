function varargout = nan_error(varargin)
% NAN_ERROR M-file for nan_error.fig
%      NAN_ERROR, by itself, creates a new NAN_ERROR or raises the existing
%      singleton*.
%
%      H = NAN_ERROR returns the handle to a new NAN_ERROR or the handle to
%      the existing singleton*.
%
%      NAN_ERROR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NAN_ERROR.M with the given input arguments.
%
%      NAN_ERROR('Property','Value',...) creates a new NAN_ERROR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nan_error_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nan_error_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nan_error

% Last Modified by GUIDE v2.5 07-Jan-2008 11:34:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nan_error_OpeningFcn, ...
                   'gui_OutputFcn',  @nan_error_OutputFcn, ...
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


% --- Executes just before nan_error is made visible.
function nan_error_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nan_error (see VARARGIN)

% Choose default command line output for nan_error
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes nan_error wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nan_error_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
delete(handles.figure1);




% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


