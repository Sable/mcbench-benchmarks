function varargout = Tank(varargin)
% TANK M-file for Tank.fig
%      TANK, by itself, creates a new TANK or raises the existing
%      singleton*.
%
%      H = TANK returns the handle to a new TANK or the handle to
%      the existing singleton*.
%
%      TANK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TANK.M with the given input arguments.
%
%      TANK('Property','Value',...) creates a new TANK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Tank_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Tank_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help Tank

% Last Modified by GUIDE v2.5 19-Jun-2005 23:44:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Tank_OpeningFcn, ...
    'gui_OutputFcn',  @Tank_OutputFcn, ...
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


% --- Executes just before Tank is made visible.
function Tank_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Tank (see VARARGIN)

% Choose default command line output for Tank
clc
handles.output = hObject;
handles.h = 20;
handles.R = 15;
handles.r = 2;
handles.tim = 1;

set(handles.Height,'String',handles.h)
set(handles.Base_Radius,'String',handles.R);
set(handles.Hole_Radius,'String',handles.r);
set(handles.Height_Radius,'Value',handles.h)
set(handles.Base_Radius_Slider,'Value',handles.R);
set(handles.Hole_Radius_Slider,'Value',handles.r);
set(handles.popupmenu2,'Value',1);

% Update handles structure
guidata(hObject, handles);
calculation(hObject,handles);

% UIWAIT makes Tank wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Tank_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function Base_Radius_Slider_Callback(hObject, eventdata, handles)
% hObject    handle to Base_Radius_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.R = round(100*get(handles.Base_Radius_Slider,'Value'))/100;
set(handles.Base_Radius,'String',handles.R);
guidata(hObject, handles);
calculation(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Base_Radius_Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Base_Radius_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function Base_Radius_Callback(hObject, eventdata, handles)
% hObject    handle to Base_Radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Base_Radius as text
%        str2double(get(hObject,'String')) returns contents of Base_Radius as a double
handles.R = str2double(get(handles.Base_Radius,'String'));
set(handles.Base_Radius_Slider,'Value',handles.R);
guidata(hObject, handles);
calculation(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Base_Radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Base_Radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Hole_Radius_Slider_Callback(hObject, eventdata, handles)
% hObject    handle to Hole_Radius_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.r = round(100*get(handles.Hole_Radius_Slider,'Value'))/100;
set(handles.Hole_Radius,'String',handles.r);
guidata(hObject, handles);
calculation(hObject,handles);



% --- Executes during object creation, after setting all properties.
function Hole_Radius_Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Hole_Radius_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function Hole_Radius_Callback(hObject, eventdata, handles)
% hObject    handle to Hole_Radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Hole_Radius as text
%        str2double(get(hObject,'String')) returns contents of Hole_Radius as a double
handles.r = str2double(get(handles.Hole_Radius,'String'));
set(handles.Hole_Radius_Slider,'Value',handles.r);
guidata(hObject, handles);
calculation(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Hole_Radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Hole_Radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Height_Radius_Callback(hObject, eventdata, handles)
% hObject    handle to Height_Radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.h = round(100*get(handles.Height_Radius,'Value'))/100;
set(handles.Height,'String',handles.h);
guidata(hObject, handles);
calculation(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Height_Radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Height_Radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function Height_Callback(hObject, eventdata, handles)
% hObject    handle to Height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Height as text
%        str2double(get(hObject,'String')) returns contents of Height as a double
handles.h = str2double(get(handles.Height,'String'));
set(handles.Height_Radius,'Value',handles.h);
guidata(hObject, handles);
calculation(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Plot.
function Plot_Callback(hObject, eventdata, handles)
% hObject    handle to Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
r = [1:0.1:100];
t = handles.R^2./(5*r.^2).*sqrt(2*handles.h/9.81);

switch get(handles.popupmenu2,'Value')
    case 1
        tim = round(1000*t)/1000
    case 2
        tim = round(1000*t/60)/1000;
    case 3
        tim = round(1000*t/3600)/1000;
end

figure, plot(r,tim), title('The Figure of Time Vs. Hole Radius');


% --- Executes on button press in Help.
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = sprintf(['Tank Drain Calculator - Version 1.1.1\n\n',...
    'Implemented with Matlab GUI Environment\n',...
    'Copyright 2004-2006 The Microjects, Inc.\n']);
msgbox(str,'About the Tank Drain Calculator','modal');


function Time_Callback(hObject, eventdata, handles)
% hObject    handle to Time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Time as text
%        str2double(get(hObject,'String')) returns contents of Time as a double


% --- Executes during object creation, after setting all properties.
function Time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
guidata(hObject, handles);
calculation(hObject,handles);


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function calculation(hObject,handles)
handles.t = handles.R^2/(5*handles.r^2)*sqrt(2*handles.h/9.81);
guidata(hObject, handles);

switch get(handles.popupmenu2,'Value')
    case 1
        handles.tim = round(1000*handles.t)/1000
    case 2
        handles.tim = round(1000*handles.t/60)/1000;
    case 3
        handles.tim = round(1000*handles.t/3600)/1000;
end

set(handles.Time,'String',handles.tim)
guidata(hObject, handles);


