function varargout = Parasit(varargin)
% PARASIT M-file for Parasit.fig
%      PARASIT, by itself, creates a new PARASIT or raises the existing
%      singleton*.
%
%      H = PARASIT returns the handle to a new PARASIT or the handle to
%      the existing singleton*.
%
%      PARASIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARASIT.M with the given input arguments.
%
%      PARASIT('Property','Value',...) creates a new PARASIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Parasit_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Parasit_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Parasit

% Last Modified by GUIDE v2.5 06-Jul-2012 05:48:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Parasit_OpeningFcn, ...
                   'gui_OutputFcn',  @Parasit_OutputFcn, ...
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


% --- Executes just before Parasit is made visible.
function Parasit_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Parasit (see VARARGIN)

% Choose default command line output for Parasit
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Parasit wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Parasit_OutputFcn(hObject, eventdata, handles) 
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
imshow('Parasit.jpg');

