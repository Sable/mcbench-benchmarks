function varargout = ImageGUI(varargin)
% IMAGEGUI MATLAB code for ImageGUI.fig
%      IMAGEGUI, by itself, creates a new IMAGEGUI or raises the existing
%      singleton*.
%
%      H = IMAGEGUI returns the handle to a new IMAGEGUI or the handle to
%      the existing singleton*.
%
%      IMAGEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEGUI.M with the given input arguments.
%
%      IMAGEGUI('Property','Value',...) creates a new IMAGEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageGUI

% Copyright 2011 The MathWorks, Inc.

% Last Modified by GUIDE v2.5 31-Mar-2011 16:55:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageGUI_OutputFcn, ...
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


% --- Executes just before ImageGUI is made visible.
function ImageGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageGUI (see VARARGIN)

% Choose default command line output for ImageGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImageGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

movegui(handles.figure1, 'center');

% --- Outputs from this function are returned to the command line.
function varargout = ImageGUI_OutputFcn(hObject, eventdata, handles) 
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

findBallFcn(handles.im);

% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile('*.jpg', 'Select image file');

im = imread(fullfile(pathname, filename));

imshow(im);

handles.im = im;

guidata(hObject, handles);
