function varargout = pidtuning(varargin)
% PIDTUNING M-file for pidtuning.fig
%      PIDTUNING, by itself, creates a new PIDTUNING or raises the existing
%      singleton*.
%
%      H = PIDTUNING returns the handle to a new PIDTUNING or the handle to
%      the existing singleton*.
%
%      PIDTUNING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PIDTUNING.M with the given input arguments.
%
%      PIDTUNING('Property','Value',...) creates a new PIDTUNING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pidtuning_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pidtuning_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help pidtuning

% Last Modified by GUIDE v2.5 04-Jun-2008 23:38:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pidtuning_OpeningFcn, ...
                   'gui_OutputFcn',  @pidtuning_OutputFcn, ...
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


% --- Executes just before pidtuning is made visible.
function pidtuning_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pidtuning (see VARARGIN)

% Choose default command line output for pidtuning
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pidtuning wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = pidtuning_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% ......................................the following code edited by user
% the proportional controller slider
set(handles.slider1,'value',17);
set(handles.slider1,'max',20);
set(handles.slider1,'min',0.0001);
% the integrater controller slider
set(handles.slider2,'value',200);
set(handles.slider2,'max',300);
set(handles.slider2,'min',0);
% the differentiater controller slider
set(handles.slider3,'value',0.15);
set(handles.slider3,'max',4);
set(handles.slider3,'min',0);

set(handles.pushbutton1,'string','Plot');
set(handles.pushbutton2,'string','Reset');
set(handles.pushbutton3,'string','plot without PID');

rr=get(handles.slider1,'value');
set(handles.text9,'string',num2str(rr)); %display the value of the proportional controller
rr=get(handles.slider2,'value');
set(handles.text10,'string',num2str(rr));%display the value of the integrater controller
rr=get(handles.slider3,'value');
set(handles.text11,'string',num2str(rr));%display the value of the differentiater controller

rr=[0.0274]; % the defult value for numenator of G(s)
set(handles.edit1,'string',num2str(rr));
rr=[0.00001299,0.0007648,0];% the defult value for denomenator of G(s)
set(handles.edit2,'string',num2str(rr));

set(handles.edit3,'string',num2str(1));% the defult value for numenator of H(s)
set(handles.edit4,'string',num2str(1));% the defult value for denomenator of H(s)

stepplot %call back stepplot function with the above parameters
% ......................................the end of the code edited by user
% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% .......................................the following code edited by user
rr=get(hObject,'Value');%get position of slider
set(handles.text9,'string',num2str(rr));
stepplot
% ......................................the end of the code edited by user

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% .......................................the following code edited by user
rr=get(hObject,'Value');
set(handles.text10,'string',num2str(rr));
stepplot
% ......................................the end of the code edited by user

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% .......................................the following code edited by user
rr=get(hObject,'Value');
set(handles.text11,'string',num2str(rr));
stepplot
% ......................................the end of the code edited by user

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stepplot

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)% reset the plot
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% .......................................the following code edited by user
% the proportional controller slider
set(handles.slider1,'value',17);
% the integrater controller slider
set(handles.slider2,'value',200);
% the differentiater controller slider
set(handles.slider3,'value',0.15);

rr=get(handles.slider1,'value');
set(handles.text9,'string',num2str(rr));
rr=get(handles.slider2,'value');
set(handles.text10,'string',num2str(rr));
rr=get(handles.slider3,'value');
set(handles.text11,'string',num2str(rr));

rr=[0.0274];
set(handles.edit1,'string',num2str(rr));
rr=[0.00001299,0.0007648,0];
set(handles.edit2,'string',num2str(rr));
set(handles.edit3,'string',num2str(1));
set(handles.edit4,'string',num2str(1));

stepplot
% ......................................the end of the code edited by user



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)% plot the system without PID controller
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ..........the following code edited by user
% the proportional controller slider
set(handles.slider1,'value',1);
% the integrater controller slider
set(handles.slider2,'value',0);
% the differentiater controller slider
set(handles.slider3,'value',0);

rr=get(handles.slider1,'value');
set(handles.text9,'string',num2str(rr));
rr=get(handles.slider2,'value');
set(handles.text10,'string',num2str(rr));
rr=get(handles.slider3,'value');
set(handles.text11,'string',num2str(rr));

stepplot
% ......................................the end of the code edited by user

