function varargout = plotgraf(varargin)
% Simple graphic calculator allows to perform the following:
% 
% Draw functions.
% Develop the Taylor series function.
% Integrate the given function.
% Derive the function.
% Simplify the mathematical expressions.
% 
% Using the calculator is simple: to enter the function if we would like to draw the function, press Enter.
% To perform any of the above mentioned
% Enter the function and click the appropriate button
% 
% This software was created by oren berkovtich
% Last Modified by GUIDE v2.5 17-Oct-2012 16:15:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotgraf_OpeningFcn, ...
                   'gui_OutputFcn',  @plotgraf_OutputFcn, ...
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


% --- Executes just before plotgraf is made visible.
function plotgraf_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotgraf (see VARARGIN)

% Choose default command line output for plotgraf
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plotgraf wait for user response (see UIRESUME)
% uiwait(handles.figure1);
uimenu('label','l')

% --- Outputs from this function are returned to the command line.
function varargout = plotgraf_OutputFcn(hObject, eventdata, handles) 
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
g=(get(hObject,'string')) ;
r= '@(x)' ;
a=strcat(r,g);
f=str2func(a);
ezplot(f)
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








% --- Executes on button press in pushbutton5.
function ac_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit1,'string','0');




% --- Executes on button press in Differentiate.
function Differentiate_Callback(hObject, eventdata, handles)
% hObject    handle to Differentiate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
g=get(handles.edit1,'string');
syms('x');
d=diff(sym(g));
ezplot(d);
set(handles.edit1,'string',char(d));


% --- Executes on button press in Simple.
function Simple_Callback(hObject, eventdata, handles)
% hObject    handle to Simple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
g=get(handles.edit1,'string');
syms('x');
s=simple(sym(g));
set(handles.edit1,'string',char(s));


% --- Executes on button press in Taylor.
function Taylor_Callback(hObject, eventdata, handles)
% hObject    handle to Taylor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
g=get(handles.edit1,'string');
if strcmp(g,'0')==0;
syms('x');
t=taylor(sym(g));
set(handles.edit1,'string',char(t));
ezplot(t);
else;
end;


% --- Executes on button press in Integrate.
function Integrate_Callback(hObject, eventdata, handles)
% hObject    handle to Integrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
g=get(handles.edit1,'string');

    
syms x ;
i=int(sym(g));
ezplot(i);
set(handles.edit1,'string',char(i));


