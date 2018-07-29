function varargout = SCARA_GUI(varargin)
% SCARA_GUI M-file for SCARA_GUI.fig
%      SCARA_GUI, by itself, creates a new SCARA_GUI or raises the existing
%      singleton*.
%
%      H = SCARA_GUI returns the handle to a new SCARA_GUI or the handle to
%      the existing singleton*.
%
%      SCARA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCARA_GUI.M with the given input arguments.
%
%      SCARA_GUI('Property','Value',...) creates a new SCARA_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SCARA_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SCARA_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SCARA_GUI

% Last Modified by GUIDE v2.5 26-Aug-2012 15:11:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SCARA_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SCARA_GUI_OutputFcn, ...
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


% --- Executes just before SCARA_GUI is made visible.
function SCARA_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SCARA_GUI (see VARARGIN)

% Choose default command line output for SCARA_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SCARA_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
SCARA28 = vrworld('SCARA28.wrl');
open(SCARA28)
view(SCARA28);


dist=-get(handles.slider5,'value');
y1=-.5*dist;
y2=.5*dist;
SCARA28.EndV1.translation = [-.35, y1, 0];
SCARA28.EndV2.translation = [-.35, y2, 0];



d4=-get(handles.slider4,'value');
SCARA28.d4b.translation=[0,d4,0];

T4=get(handles.slider3,'value');
SCARA28.d4b.rotation = [0, 1, 0,T4*pi/180];


T2=-get(handles.slider2,'value');
SCARA28.a2.rotation = [1, 0, 0, T2*pi/180];

T1=get(handles.slider1,'value');
SCARA28.d1.rotation = [0, 1, 0, T1*pi/180];
clc
% --- Outputs from this function are returned to the command line.
function varargout = SCARA_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

SCARA28 = vrworld('SCARA28.wrl');
open(SCARA28)
T1=get(handles.slider1,'value');
if T1==360
   set(handles.slider1,'value',0);
end
SCARA28.d1.rotation = [0, 1, 0, T1*pi/180];

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
SCARA28 = vrworld('SCARA28.wrl');
open(SCARA28)
T2=-get(handles.slider2,'value');
SCARA28.a2.rotation = [1, 0, 0, T2*pi/180];

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
SCARA28 = vrworld('SCARA28.wrl');
open(SCARA28)
T4=get(handles.slider3,'value');
if T4==360
   set(handles.slider3,'value',0);
end
SCARA28.d4b.rotation = [0, 1, 0,T4*pi/180];

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
SCARA28 = vrworld('SCARA28.wrl');
open(SCARA28)
d4=-get(handles.slider4,'value');
SCARA28.d4b.translation=[0,d4,0];

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
SCARA28 = vrworld('SCARA28.wrl');
open(SCARA28)
dist=-get(handles.slider5,'value');
y1=-.5*dist;
y2=.5*dist;
SCARA28.EndV1.translation = [-.35, y1, 0];
SCARA28.EndV2.translation = [-.35, y2, 0];

% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --------------------------------------------------------------------
function File_tag_Callback(hObject, eventdata, handles)
% hObject    handle to File_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Edit_tag_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Reset_tag_Callback(hObject, eventdata, handles)
% hObject    handle to Reset_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SCARA28 = vrworld('SCARA28.wrl');
open(SCARA28)
dist=-1.3;
y1=-.5*dist;
y2=.5*dist;
SCARA28.EndV1.translation = [-.35, y1, 0];
SCARA28.EndV2.translation = [-.35, y2, 0];
d4=0;
SCARA28.d4b.translation=[0,d4,0];
T4=0;
SCARA28.d4b.rotation = [0, 1, 0,T4*pi/180];
T2=0;
SCARA28.a2.rotation = [1, 0, 0, T2*pi/180];
T1=0;
SCARA28.d1.rotation = [0, 1, 0, T1*pi/180];
clc





set(handles.slider5,'value',-dist);
set(handles.slider4,'value',0);
set(handles.slider3,'value',0);
set(handles.slider2,'value',0);
set(handles.slider1,'value',0);


% --------------------------------------------------------------------
function About_us_tag_Callback(hObject, eventdata, handles)
% hObject    handle to About_us_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

about_us


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function Exit_Tag_Callback(hObject, eventdata, handles)
% hObject    handle to Exit_Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




