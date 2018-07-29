function varargout = FA3(varargin)
% FA3 M-file for FA3.fig
%      FA3, by itself, creates a new FA3 or raises the existing
%      singleton*.
%
%      H = FA3 returns the handle to a new FA3 or the handle to
%      the existing singleton*.
%
%      FA3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FA3.M with the given input arguments.
%
%      FA3('Property','Value',...) creates a new FA3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FA3_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FA3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FA3

% Last Modified by GUIDE v2.5 06-Feb-2008 22:10:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FA3_OpeningFcn, ...
                   'gui_OutputFcn',  @FA3_OutputFcn, ...
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


% --- Executes just before FA3 is made visible.
function FA3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FA3 (see VARARGIN)

% Choose default command line output for FA3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FA3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FA3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)


set(handles.panel2,'visible','on');
set(handles.panel3,'visible','on');
set(handles.panel4,'visible','off');

% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)

set(handles.panel2,'visible','on');
set(handles.panel4,'visible','on');
set(handles.panel3,'visible','off');
set(handles.text9,'visible','on');
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)

set(handles.panel4,'visible','off');
global x ;
x=linspace(-10,10,101);
b=zeros(1,4);
v=str2num(get(handles.edit1,'string'));
b=[v];
if isnumeric(b)
     set(handles.text19,'visible','on');
end
if length(b) < 4 || length(b) > 4 
     set(handles.text13,'visible','on');
end

if b(1,1)==b(1,2) && b(1,2)==b(1,3) && b(1,3)==b(1,4)
     set(handles.text12,'visible','on');
end

if b(1,1)==b(1,2) || b(1,1)==b(1,3) || b(1,1)==b(1,4)
    set(handles.text17,'visible','on');
end

if b(1,1) > b(1,2)
    set(handles.text15,'visible','on');
end
if b(1,3) > b(1,4)
    set(handles.text14,'visible','on');
end

if b(1,1) < -10 || b(1,1) > 10 || b(1,2) < -10 || b(1,2) > 10 || b(1,3) < -10 || b(1,3) > 10 || b(1,4) < -10 || b(1,4) > 10
    
  set(handles.text11,'visible','on');
end
global B;
B=trapmf(x,b);

% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
set(handles.edit1,'enable','off');
global x;
x=linspace(-10,10,101);
b=zeros(1,3);
v=str2num(get(handles.edit2,'string'));
b=[v];
if isnumeric(b)
     set(handles.text19,'visible','on');
end
if length(b) < 3 || length(b) > 3 
     set(handles.text16,'visible','on');
end

if b(1,1)==b(1,2) && b(1,2)==b(1,3) 
     set(handles.text11,'visible','on');
end

if b(1,1)==b(1,2) || b(1,1)==b(1,3) 
    set(handles.text17,'visible','on');
end

if b(1,1) > b(1,2)
    set(handles.text15,'visible','on');
end
if b(1,2) > b(1,3)
    set(handles.text18,'visible','on');
end

global B;
B=trimf(x,b);


% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


