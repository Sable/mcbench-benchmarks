function varargout = PPort(varargin)
% PPORT M-file for PPort.fig
%      PPORT, by itself, creates a new PPORT or raises the existing
%      singleton*.
%
%      H = PPORT returns the handle to a new PPORT or the handle to
%      the existing singleton*.
%
%      PPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PPORT.M with the given input arguments.
%
%      PPORT('Property','Value',...) creates a new PPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PPort_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PPort_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PPort

% Last Modified by GUIDE v2.5 12-Mar-2009 15:52:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PPort_OpeningFcn, ...
                   'gui_OutputFcn',  @PPort_OutputFcn, ...
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


% --- Executes just before PPort is made visible.
function PPort_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PPort (see VARARGIN)

% Choose default command line output for PPort
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PPort wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PPort_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in PP_pop.
function PP_pop_Callback(hObject, eventdata, handles)
% hObject    handle to PP_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns PP_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PP_pop


% --- Executes during object creation, after setting all properties.
function PP_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PP_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ch_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ch_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch_edit as text
%        str2double(get(hObject,'String')) returns contents of ch_edit as a double


% --- Executes during object creation, after setting all properties.
function ch_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in DL_popupmenu.
function DL_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to DL_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns DL_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DL_popupmenu


% --- Executes during object creation, after setting all properties.
function DL_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DL_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function in_edit_Callback(hObject, eventdata, handles)
% hObject    handle to in_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of in_edit as text
%        str2double(get(hObject,'String')) returns contents of in_edit as a double


% --- Executes during object creation, after setting all properties.
function in_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to in_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = get(handles.PP_pop,'value');

if value ==1
    dio = digitalio ('Parallel','LPT1');
elseif value ==2
    dio = digitalio ('Parallel','LPT2');
else 
    dio = digitalio ('Parallel','LPT3');
end

ch = get(handles.ch_edit,'String');
chann = str2double (ch) - 1;

direction = get (handles.DL_popupmenu,'value');

if direction == 1
    addline (dio,0:chann,'in');
    data = getvalue (dio);
    set(handles.text9,'String',num2str(data));
elseif direction == 2
    addline (dio,0:chann,'out');
    d = get(handles.in_edit,'String');
    data = str2double (d);
    if data > 255 || data < 0
        errordlg ('Enter Values between 0-255');
    else
        putvalue (dio,data);
    end
end


delete (dio);
clear all

