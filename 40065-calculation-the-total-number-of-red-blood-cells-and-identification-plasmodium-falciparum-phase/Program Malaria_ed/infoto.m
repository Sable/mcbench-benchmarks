function varargout = infoto(varargin)
% INFOTO M-file for infoto.fig
%      INFOTO, by itself, creates a new INFOTO or raises the existing
%      singleton*.
%
%      H = INFOTO returns the handle to a new INFOTO or the handle to
%      the existing singleton*.
%
%      INFOTO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INFOTO.M with the given input arguments.
%
%      INFOTO('Property','Value',...) creates a new INFOTO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before infoto_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to infoto_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help infoto

% Last Modified by GUIDE v2.5 09-Jul-2012 15:08:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @infoto_OpeningFcn, ...
                   'gui_OutputFcn',  @infoto_OutputFcn, ...
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


% --- Executes just before infoto is made visible.
function infoto_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to infoto (see VARARGIN)

% Choose default command line output for infoto
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes infoto wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = infoto_OutputFcn(hObject, eventdata, handles) 
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
axes (hObject)
imshow('infoto.jpg')

