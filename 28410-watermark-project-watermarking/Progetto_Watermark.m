function varargout = Progetto_Watermark(varargin)
% PROGETTO_WATERMARK M-file for Progetto_Watermark.fig
%      PROGETTO_WATERMARK, by itself, creates a new PROGETTO_WATERMARK or raises the existing
%      singleton*.
%
%      H = PROGETTO_WATERMARK returns the handle to a new PROGETTO_WATERMARK or the handle to
%      the existing singleton*.
%
%      PROGETTO_WATERMARK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROGETTO_WATERMARK.M with the given input arguments.
%
%      PROGETTO_WATERMARK('Property','Value',...) creates a new PROGETTO_WATERMARK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Progetto_Watermark_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Progetto_Watermark_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Progetto_Watermark

% Last Modified by GUIDE v2.5 21-Jun-2010 19:18:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Progetto_Watermark_OpeningFcn, ...
                   'gui_OutputFcn',  @Progetto_Watermark_OutputFcn, ...
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


% --- Executes just before Progetto_Watermark is made visible.
function Progetto_Watermark_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Progetto_Watermark (see VARARGIN)

% Choose default command line output for Progetto_Watermark
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
img=imread('logosun.png');      %Carico il logo SUN
axes(handles.axes1)             %Fisso l'axes per il plot
imshow(img)                     %Mostro il logo
% UIWAIT makes Progetto_Watermark wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Progetto_Watermark_OutputFcn(hObject, eventdata, handles) 
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
watermark       %Richiama la GUI di "watermark"

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dewatermark     %Richiamo la GUI di "dewatermark"

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ascii           %Richiamo la GUI che mostra la tabella ascii

