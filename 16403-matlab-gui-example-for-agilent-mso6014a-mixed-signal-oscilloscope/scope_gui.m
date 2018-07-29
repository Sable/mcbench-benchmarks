function varargout = scope_gui(varargin)
% SCOPE_GUI M-file for scope_gui.fig
%      SCOPE_GUI, by itself, creates a new SCOPE_GUI or raises the existing
%      singleton*.
%
%      H = SCOPE_GUI returns the handle to a new SCOPE_GUI or the handle to
%      the existing singleton*.
%
%      SCOPE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCOPE_GUI.M with the given input arguments.
%
%      SCOPE_GUI('Property','Value',...) creates a new SCOPE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before scope_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to scope_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help scope_gui

% Last Modified by GUIDE v2.5 24-Sep-2008 14:10:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @scope_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @scope_gui_OutputFcn, ...
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


% --- Executes just before scope_gui is made visible.
function scope_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to scope_gui (see VARARGIN)

% Choose default command line output for scope_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes scope_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = scope_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in autoscaleButton.
function autoscaleButton_Callback(hObject, eventdata, handles)
% hObject    handle to autoscaleButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function timeBaseEdit_Callback(hObject, eventdata, handles)
% hObject    handle to timeBaseEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeBaseEdit as text
%        str2double(get(hObject,'String')) returns contents of timeBaseEdit as a double


% --- Executes during object creation, after setting all properties.
function timeBaseEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeBaseEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vscaleEdit_Callback(hObject, eventdata, handles)
% hObject    handle to vscaleEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vscaleEdit as text
%        str2double(get(hObject,'String')) returns contents of vscaleEdit as a double


% --- Executes during object creation, after setting all properties.
function vscaleEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vscaleEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function timeBaseSlider_Callback(hObject, eventdata, handles)
% hObject    handle to timeBaseSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function timeBaseSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeBaseSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function vscaleSlider_Callback(hObject, eventdata, handles)
% hObject    handle to vscaleSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function vscaleSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vscaleSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function updateIntervalEdit_Callback(hObject, eventdata, handles)
% hObject    handle to updateIntervalEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of updateIntervalEdit as text
%        str2double(get(hObject,'String')) returns contents of updateIntervalEdit as a double


% --- Executes during object creation, after setting all properties.
function updateIntervalEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to updateIntervalEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
