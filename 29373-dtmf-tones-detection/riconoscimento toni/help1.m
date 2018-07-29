function varargout = help1(varargin)
% HELP1 M-file for help1.fig
%      HELP1, by itself, creates a new HELP1 or raises the existing
%      singleton*.
%
%      H = HELP1 returns the handle to a new HELP1 or the handle to
%      the existing singleton*.
%
%      HELP1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HELP1.M with the given input arguments.
%
%      HELP1('Property','Value',...) creates a new HELP1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before help1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to help1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help help1

% Last Modified by GUIDE v2.5 16-Jul-2010 19:35:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @help1_OpeningFcn, ...
                   'gui_OutputFcn',  @help1_OutputFcn, ...
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


% --- Executes just before help1 is made visible.
function help1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to help1 (see VARARGIN)

% Choose default command line output for help1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes help1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = help1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
imshow(imread('telefono.jpg'))
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


