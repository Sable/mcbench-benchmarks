function varargout = rescal(varargin)
% RESCAL M-file for rescal.fig
%      RESCAL, by itself, creates a new RESCAL or raises the existing
%      singleton*.
%
%      H = RESCAL returns the handle to a new RESCAL or the handle to
%      the existing singleton*.
%
%      RESCAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESCAL.M with the given input arguments.
%
%      RESCAL('Property','Value',...) creates a new RESCAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rescal_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rescal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rescal

% Last Modified by GUIDE v2.5 12-Nov-2008 20:22:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rescal_OpeningFcn, ...
                   'gui_OutputFcn',  @rescal_OutputFcn, ...
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


% --- Executes just before rescal is made visible.
function rescal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rescal (see VARARGIN)

% Choose default command line output for rescal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rescal wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rescal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function varargout = popupmenu1_Callback(h, eventdata, handles, varargin)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

fb=get(handles.popupmenu1,'value');

switch fb
    case 1
        units='0'
    case 2
        units='1'
    case 3
        units='2'
    case 4
        units='3'
    case 5
        units='4'
    case 6
        units='5'
    case 7
        units='6'
    case 8
        units='7'
    case 9
        units='8'
    case 10
        units='9'
end
set(handles.text2,'string',units)
% handles.data=units;
% guidata(handles.popupmenu1,handles)
        


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function varargout = popupmenu2_Callback(h, eventdata, handles, varargin)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

sb=get(handles.popupmenu2,'value');

switch sb
    case 1
        tens='0'
    case 2
        tens='1'
    case 3
        tens='2'
    case 4
        tens='3'
    case 5
        tens='4'
    case 6
        tens='5'
    case 7
        tens='6'
    case 8
        tens='7'
    case 9
        tens='8'
    case 10
        tens='9'
end
set(handles.text3,'string',tens)
% handles.data=tens;
% guidata(handles.popupmenu2,handles)

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


% --- Executes on selection change in popupmenu3.
function varargout = popupmenu3_Callback(h, eventdata, handles, varargin)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3

tb=get(handles.popupmenu3,'value');

switch tb
    case 1
        hundreds='1'
    case 2
        hundreds='10'
    case 3
        hundreds='100'
    case 4
        hundreds='1000'
    case 5
        hundreds='10000'
    case 6
        hundreds='100000'
    case 7
        hundreds='1000000'
    case 8
        hundreds='10000000'
    case 9
        hundreds='100000000'
    case 10
        hundreds='1000000000'
end
set(handles.text4,'string',hundreds)
% handles.data=hundreds;
% guidata(handles.popupmenu3,handles)

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function varargout = popupmenu4_Callback(h, eventdata, handles, varargin)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4

fthb=get(handles.popupmenu4,'value');

switch fthb
    case 1
        thousand='±10%'
    case 2
        thousand='±5%'
end
set(handles.text6,'string',thousand)
% handles.data=thousand;
% guidata(handles.popupmenu4,handles)

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text2,'string',' ')
set(handles.text3,'string',' ')
set(handles.text4,'string',' ')
set(handles.text5,'string',' ')
set(handles.text6,'string',' ')
set(handles.text7,'string',' ')

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % units=handles.data;
% % tens=handles.data;
% % hundreds=handles.data;
% % thousand=handles.data;

a=get(handles.text2,'string')
b=get(handles.text3,'string')
c=get(handles.text4,'string')
d=get(handles.text6,'string')
code=strcat(a,b);
code=str2num(code);
c=str2num(c)
resistance=code*c;
%resistance=strcat(resistance,d)
set(handles.text5,'string',resistance)
% tolerance=strcat('±',d)
set(handles.text7,'string',d)

%hundreds=str2num(hundreds);
%resistance=code1*hundreds;
%resistance1=num2str(resistance)
% set(handles.text2,'string',code);
%set(handles.text3,'string',thousand);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

help

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close('rescal');
close('help');
close('credits')


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close('rescal')
select_rescal

% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close('rescal')
close('help')
close('credits')

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

help

% --------------------------------------------------------------------
function Untitled_7_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

credits

% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


