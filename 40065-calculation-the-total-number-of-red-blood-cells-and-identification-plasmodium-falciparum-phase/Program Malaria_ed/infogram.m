function varargout = infogram(varargin)
% INFOGRAM M-file for infogram.fig
%      INFOGRAM, by itself, creates a new INFOGRAM or raises the existing
%      singleton*.
%
%      H = INFOGRAM returns the handle to a new INFOGRAM or the handle to
%      the existing singleton*.
%
%      INFOGRAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INFOGRAM.M with the given input arguments.
%
%      INFOGRAM('Property','Value',...) creates a new INFOGRAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before infogram_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to infogram_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help infogram

% Last Modified by GUIDE v2.5 09-Jul-2012 15:10:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @infogram_OpeningFcn, ...
                   'gui_OutputFcn',  @infogram_OutputFcn, ...
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


% --- Executes just before infogram is made visible.
function infogram_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to infogram (see VARARGIN)

% Choose default command line output for infogram
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes infogram wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = infogram_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
axes (hObject);
imshow('infogram.jpg');

