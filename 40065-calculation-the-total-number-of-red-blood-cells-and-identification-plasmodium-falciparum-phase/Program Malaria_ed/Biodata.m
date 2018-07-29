function varargout = Biodata(varargin)
% BIODATA M-file for Biodata.fig
%      BIODATA, by itself, creates a new BIODATA or raises the existing
%      singleton*.
%
%      H = BIODATA returns the handle to a new BIODATA or the handle to
%      the existing singleton*.
%
%      BIODATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BIODATA.M with the given input arguments.
%
%      BIODATA('Property','Value',...) creates a new BIODATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Biodata_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Biodata_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Biodata

% Last Modified by GUIDE v2.5 23-Apr-2012 21:40:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Biodata_OpeningFcn, ...
                   'gui_OutputFcn',  @Biodata_OutputFcn, ...
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


% --- Executes just before Biodata is made visible.
function Biodata_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Biodata (see VARARGIN)

% Choose default command line output for Biodata
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Biodata wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Biodata_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes8
axes (hObject)
imshow ('Biodata.jpg')

