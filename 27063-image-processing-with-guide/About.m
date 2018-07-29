function varargout = About(varargin)
% ABOUT M-file for About.fig
%      ABOUT, by itself, creates a new ABOUT or raises the existing
%      singleton*.
%
%      H = ABOUT returns the handle to a new ABOUT or the handle to
%      the existing singleton*.
%
%      ABOUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ABOUT.M with the given input arguments.
%
%      ABOUT('Property','Value',...) creates a new ABOUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before About_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to About_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help About

% Last Modified by GUIDE v2.5 08-Jun-2009 20:35:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @About_OpeningFcn, ...
                   'gui_OutputFcn',  @About_OutputFcn, ...
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


% --- Executes just before About is made visible.
function About_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to About (see VARARGIN)

% Choose default command line output for About
handles.output = hObject;
% Update handles structure
movegui(hObject,'onscreen')% To display application onscreen
movegui(hObject,'center')  % To display application in the center of screen
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes About wait for user response (see UIRESUME)
% uiwait(handles.About);

function varargout = About_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function Fermer_Callback(hObject, eventdata, handles)
% hObject    handle to Fermer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

function About_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);

function About_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function logo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to logo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
a=imread('im3.png');
imshow(a);
% Hint: place code in OpeningFcn to populate logo


