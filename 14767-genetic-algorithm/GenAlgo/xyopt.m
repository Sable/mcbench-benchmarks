function varargout = xyopt(varargin)
% XYOPT M-file for xyopt.fig
%      XYOPT, by itself, creates a new XYOPT or raises the existing
%      singleton*.
%
%      H = XYOPT returns the handle to a new XYOPT or the handle to
%      the existing singleton*.
%
%      XYOPT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in XYOPT.M with the given input arguments.
%
%      XYOPT('Property','Value',...) creates a new XYOPT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before xyopt_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to xyopt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help xyopt

% Last Modified by GUIDE v2.5 03-Jul-2006 19:02:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @xyopt_OpeningFcn, ...
                   'gui_OutputFcn',  @xyopt_OutputFcn, ...
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


% --- Executes just before xyopt is made visible.
function xyopt_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to xyopt (see VARARGIN)

% Choose default command line output for xyopt
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes xyopt wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = xyopt_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function afficher_CreateFcn(hObject, eventdata, handles)
% hObject    handle to afficher (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function afficher_Callback(hObject, eventdata, handles)
% hObject    handle to afficher (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load parametres;
load xopts(i);
load yopts(i);
h=guidata(gcbo);
for i=1:ng
X(i,:)=xopts(i);
Y(i,:)=yopts(i);
end
set(h.afficher,'string',X);
set(h.affichery,'string',Y);



% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


