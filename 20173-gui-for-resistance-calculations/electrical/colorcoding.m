function varargout = colorcoding(varargin)
% COLORCODING M-file for colorcoding.fig
%      COLORCODING, by itself, creates a new COLORCODING or raises the existing
%      singleton*.
%
%      H = COLORCODING returns the handle to a new COLORCODING or the handle to
%      the existing singleton*.
%
%      COLORCODING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COLORCODING.M with the given input arguments.
%
%      COLORCODING('Property','Value',...) creates a new COLORCODING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before colorcoding_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to colorcoding_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help colorcoding

% Last Modified by GUIDE v2.5 28-Jun-2007 14:25:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @colorcoding_OpeningFcn, ...
                   'gui_OutputFcn',  @colorcoding_OutputFcn, ...
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


% --- Executes just before colorcoding is made visible.
function colorcoding_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to colorcoding (see VARARGIN)

% Choose default command line output for colorcoding
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes colorcoding wait for user response (see UIRESUME)
% uiwait(handles.figure1);
im=imread('res.jpg');
axes(handles.axes1)
imshow(im);
axis off

% --- Outputs from this function are returned to the command line.
function varargout = colorcoding_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
unts=get(handles.edit1,'string');
tns=get(handles.edit2,'string');
hndrts=get(handles.edit3,'string');
tol=get(handles.edit4,'string');

%--------------------------------------------
switch unts
    case 'black'
        value1='0';
    case 'brown'
        value1='1';
    case 'red'
        value1='2';
    case 'orange'
        value1='3';
    case 'yellow'
        value1='4';
    case 'green'
        value1='5';
    case 'blue'
        value1='6';
    case 'violet'
        value1='7';
    case 'grey'
        value1='8';
    case 'white'
        value1='9';
end
%----------------------------------------------
switch tns
     case 'black'
        value2='0';
    case 'brown'
        value2='1';
    case 'red'
        value2='2';
    case 'orange'
        value2='3';
    case 'yellow'
        value2='4';
    case 'green'
        value2='5';
    case 'blue'
        value2='6';
    case 'violet'
        value2='7';
    case 'grey'
        value2='8';
    case 'white'
        value2='9';
end
%--------------------------------------------
switch hndrts
     case 'black'
        value3=1;
    case 'brown'
        value3=10;
    case 'red'
        value3=100;
    case 'orange'
        value3=1000;
    case 'yellow'
        value3=10000;
    case 'green'
        value3=100000;
    case 'blue'
        value3=1000000;
    case 'violet'
        value3=10000000;
    case 'grey'
        value3=100000000;
    case 'white'
        value3=1000000000;
end
%--------------------------------------------
switch tol
    case 'silver'
        value4='10%';
    case 'gold'
        value4='5%';
end
%--------------------------------------------
value1=strcat(value1,value2);
value1=str2num(value1);
resistance=value1*value3;
set(handles.text1,'String',resistance)
set(handles.text8,'string',value4)



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




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text12,'string','Idea and Programming By Imtiaz Hussain Kalwar. Thanks to ITA')
pause(5)
set(handles.text12,'string',' ')


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.edit1,'string','')
set(handles.edit2,'string','')
set(handles.edit3,'string','')
set(handles.edit4,'string','')
set(handles.text1,'string','')
set(handles.text8,'string','')




% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text13,'string','HINT:  Write Down color name in small letters in the box. For example write Down red for Red')
pause(5)
set(handles.text13,'string','')



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ohmslaw
