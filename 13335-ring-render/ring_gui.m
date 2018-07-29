function varargout = ring_gui(varargin)
% RING_GUI M-file for ring_gui.fig
%      RING_GUI, by itself, creates a new RING_GUI or raises the existing
%      singleton*.
%
%      H = RING_GUI returns the handle to a new RING_GUI or the handle to
%      the existing singleton*.
%
%      RING_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RING_GUI.M with the given input arguments.
%
%      RING_GUI('Property','Value',...) creates a new RING_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ring_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ring_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ring_gui

% Last Modified by GUIDE v2.5 08-Dec-2006 16:17:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ring_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @ring_gui_OutputFcn, ...
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


% --- Executes just before ring_gui is made visible.
function ring_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ring_gui (see VARARGIN)

% Choose default command line output for ring_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.figure1,'Name','Step 1: Ring Design Parameters')

modulation_freq=0;
ring_id=10;
ring_thickness=1;
ring_length=10;

set(handles.modulation_freq,'String',num2str(modulation_freq))
set(handles.ring_id,'String',num2str(ring_id))
set(handles.ring_thickness,'String',num2str(ring_thickness))
set(handles.ring_length,'String',num2str(ring_length))

set(handles.ring_id_text,'String',{'Ring Inner Diameter','(mm)'})
set(handles.ring_length_text,'String',{'Ring Length','(mm)'})
set(handles.ring_thickness_text,'String',{'Ring Modution','Thickness (mm)'})
set(handles.modulation_freq_text,'String',{'Modulation Frequency','(Hz)'})

set(handles.slider1,'Value',.5)
set(handles.slider2,'Value',.5)
set(handles.slider3,'Value',.5)

fill_color=[get(handles.slider1,'Value') get(handles.slider2,'Value') get(handles.slider3,'Value')];
axes(handles.axes1);
hf=fill([0 1 1 0 0],[0 0 1 1 0],fill_color);
set(gca,'Xtick',[],'Ytick',[])

set(handles.red_lvl,'String',{'Red',num2str(round(fill_color(1)*255))})
set(handles.green_lvl,'String',{'Green',num2str(round(fill_color(2)*255))})
set(handles.blue_lvl,'String',{'Blue',num2str(round(fill_color(3)*255))})

% UIWAIT makes ring_gui wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = ring_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if strcmp(handles.output,'Ok')
    ring_param{1}=str2num(get(handles.modulation_freq,'String'));
    ring_param{2}=str2num(get(handles.ring_id,'String'));
    ring_param{3}=str2num(get(handles.ring_thickness,'String'));
    ring_param{4}=str2num(get(handles.ring_length,'String'));
    param_temp1=(get(handles.red_lvl,'String'));
    param_temp2=(get(handles.green_lvl,'String'));
    param_temp3=(get(handles.blue_lvl,'String'));
    param_temp=[str2num(param_temp1{2}),str2num(param_temp2{2}),str2num(param_temp3{2})];
    ring_param{5}=param_temp;    
    delete(handles.figure1);
    ring_gui_plot(ring_param);
end

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
slider1_value = get(hObject,'Value');
set(handles.slider1,'Value',slider1_value)
guidata(hObject, handles);
update_color(hObject, eventdata, handles);

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
slider2_value = get(hObject,'Value');
set(handles.slider2,'Value',slider2_value)
guidata(hObject, handles);
update_color(hObject, eventdata, handles);

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
slider3_value = get(hObject,'Value');
set(handles.slider3,'Value',slider3_value)
guidata(hObject, handles);
update_color(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in done_flag.
function done_flag_Callback(hObject, eventdata, handles)
% hObject    handle to done_flag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);

function ring_length_Callback(hObject, eventdata, handles)
% hObject    handle to ring_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ring_length as text
%        str2double(get(hObject,'String')) returns contents of ring_length as a double

handles.ring_length=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function ring_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ring_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ring_id_Callback(hObject, eventdata, handles)
% hObject    handle to ring_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ring_id as text
%        str2double(get(hObject,'String')) returns contents of ring_id as a double

handles.ring_id=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function ring_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ring_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ring_thickness_Callback(hObject, eventdata, handles)
% hObject    handle to ring_thickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ring_thickness as text
%        str2double(get(hObject,'String')) returns contents of ring_thickness as a double

handles.ring_thickness=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function ring_thickness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ring_thickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function modulation_freq_Callback(hObject, eventdata, handles)
% hObject    handle to modulation_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of modulation_freq as text
%        str2double(get(hObject,'String')) returns contents of modulation_freq as a double

handles.modulation_freq=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function modulation_freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modulation_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function update_color(hObject, eventdata, handles);
fill_color=[get(handles.slider1,'Value') get(handles.slider2,'Value') get(handles.slider3,'Value')];
axes(handles.axes1);
hf=fill([0 1 1 0 0],[0 0 1 1 0],fill_color);
set(gca,'Xtick',[],'Ytick',[])
set(handles.red_lvl,'String',{'Red',num2str(round(fill_color(1)*255))})
set(handles.green_lvl,'String',{'Green',num2str(round(fill_color(2)*255))})
set(handles.blue_lvl,'String',{'Blue',num2str(round(fill_color(3)*255))})
