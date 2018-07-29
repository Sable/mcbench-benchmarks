function varargout = casio(varargin)
% CASIO MATLAB code for casio.fig
%      CASIO, by itself, creates a new CASIO or raises the existing
%      singleton*.
%
%      H = CASIO returns the handle to a new CASIO or the handle to
%      the existing singleton*.
%
%      CASIO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CASIO.M with the given input arguments.
%
%      CASIO('Property','Value',...) creates a new CASIO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before casio_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to casio_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help casio

% Last Modified by GUIDE v2.5 11-Sep-2012 05:22:06
% Created by Oren Berkovitch

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @casio_OpeningFcn, ...
                   'gui_OutputFcn',  @casio_OutputFcn, ...
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


% --- Executes just before casio is made visible.
function casio_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to casio (see VARARGIN)

% Choose default command line output for casio
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes casio wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = casio_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(~, ~, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.edit1,'string');
set(handles.edit1,'string',strcat(a,'1'));


function edit1_Callback(~, ~, ~)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, ~, ~)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(~, ~, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.edit1,'string');
set(handles.edit1,'string',strcat(a,'2'));


% --- Executes on button press in equle.
function pushbutton4_Callback(~, ~, handles)
% hObject    handle to equle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.edit1,'string');
set(handles.edit1,'string',strcat(a,'4'));


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(~, ~, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.edit1,'string');
set(handles.edit1,'string',strcat(a,'5'));


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(~, ~, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.edit1,'string');
set(handles.edit1,'string',strcat(a,'6'));


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(~, ~, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.edit1,'string');
set(handles.edit1,'string',strcat(a,'7'));


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(~, ~, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.edit1,'string');
set(handles.edit1,'string',strcat(a,'8'));


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(~, ~, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.edit1,'string');
set(handles.edit1,'string',strcat(a,'9'));


% --- Executes on button press in pluse.
function equle_Callback(~, ~, handles)
% hObject    handle to pluse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.edit1,'string');

set(handles.text1,'string',str2num(a));


% --- Executes on button press in pluse.
function pluse_Callback(~, ~, handles)
% hObject    handle to pluse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.edit1,'string');
set(handles.edit1,'string',strcat(a,'+'));


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(~, ~, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.edit1,'string');
set(handles.edit1,'string',strcat(a,'3'));


% --- Executes on button press in pushbutton0.
function pushbutton0_Callback(~, ~, handles)
% hObject    handle to pushbutton0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.edit1,'string');
set(handles.edit1,'string',strcat(a,'0'));

% --- Executes on button press in pixel.
function pixel_Callback(~, ~, handles)
% hObject    handle to pixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.edit1,'string');
set(handles.edit1,'string',strcat(a,'.'));

% --- Executes on button press in EXP.
function EXP_Callback(~, ~, handles)
% hObject    handle to EXP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.edit1,'string');
E='*10^';
set(handles.edit1,'string',strcat(a,'E'));

% --- Executes on button press in divisor.
function divisor_Callback(~, ~, handles)
% hObject    handle to divisor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.edit1,'string');
set(handles.edit1,'string',strcat(a,'/'));

% --- Executes on button press in multiple.
function multiple_Callback(~, ~, handles)
% hObject    handle to multiple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.edit1,'string');
set(handles.edit1,'string',strcat(a,'*'));

% --- Executes on button press in minus.
function minus_Callback(~, ~, handles)
% hObject    handle to minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.edit1,'string');
set(handles.edit1,'string',strcat(a,'-'));


% --- Executes on button press in ans.
function ans_Callback(~, ~, handles)
% hObject    handle to ans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.edit1,'string');
Ans=get(handles.text1,'string');
set(handles.edit1,'string',strcat(a,Ans));


% --- Executes on button press in del.
function del_Callback(~, ~, handles)
% hObject    handle to del (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.edit1,'string');
a=a(:,1:length(a)-1);
set(handles.edit1,'string',a);

% --- Executes on button press in ac.
function ac_Callback(~, ~, handles)
% hObject    handle to ac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.edit1,'string','');
set(handles.text1,'string','0.');
