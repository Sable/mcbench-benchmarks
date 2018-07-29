function varargout = gui_ver(varargin)
% GUI_VER M-file for gui_ver.fig
%      GUI_VER, by itself, creates a new GUI_VER or raises the existing
%      singleton*.
%
%      H = GUI_VER returns the handle to a new GUI_VER or the handle to
%      the existing singleton*.
%
%      GUI_VER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_VER.M with the given input arguments.
%
%      GUI_VER('Property','Value',...) creates a new GUI_VER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_ver_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_ver_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_ver

% Last Modified by GUIDE v2.5 08-May-2005 16:40:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_ver_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_ver_OutputFcn, ...
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


% --- Executes just before gui_ver is made visible.
function gui_ver_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_ver (see VARARGIN)

% Choose default command line output for gui_ver
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_ver wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_ver_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h_timer;
h_timer = timer('TimerFcn',{@worker,handles}, 'Period',0.1, 'ExecutionMode', 'fixedRate', 'TasksToExecute' , inf);
start(h_timer);
set(handles.pushbutton1,'Enable','off');
set(handles.pushbutton2,'Enable','on');

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h_timer;
stop(h_timer);
drawnow;
set(handles.pushbutton1,'Enable','on');
set(handles.pushbutton2,'Enable','off');


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
h_timer = timerfind;
if ~isempty(h_timer)
delete(h_timer);
end
open('appendix.txt');


function worker(arg1, arg2, handles)
global data;
buffersize = 500;                          % buffer for listbox
data = keyinfo;
tmp = get(handles.listbox1,'String');
tmp = str2num(tmp);
tmp = [tmp; data'];
len = size(tmp,1);

%% reset listbox
if len > buffersize
set(handles.listbox1,'String', [] ); % reset
tmp =[];
end
tmp = num2str(tmp);
%% show in the listbox
set(handles.figure1,'Name', [num2str(len) '/' num2str(buffersize) ]);
set(handles.listbox1,'String',tmp);
set(handles.listbox1,'Value', len);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
h_timer = timerfind;
if ~isempty(h_timer)
stop(h_timer);
delete(h_timer);
end
delete(hObject);




% --- Executes on selection change in listbox1.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


