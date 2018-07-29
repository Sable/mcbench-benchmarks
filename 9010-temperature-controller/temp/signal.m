function varargout = signal(varargin)
% SIGNAL M-file for signal.fig
%      SIGNAL, by itself, creates a new SIGNAL or raises the existing
%      singleton*.
%
%      H = SIGNAL returns the handle to a new SIGNAL or the handle to
%      the existing singleton*.
%
%      SIGNAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGNAL.M with the given input arguments.
%
%      SIGNAL('Property','Value',...) creates a new SIGNAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before signal_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to signal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help signal

% Last Modified by GUIDE v2.5 14-Sep-2005 17:42:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @signal_OpeningFcn, ...
                   'gui_OutputFcn',  @signal_OutputFcn, ...
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


% --- Executes just before signal is made visible.
function signal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to signal (see VARARGIN)

% Choose default command line output for signal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes signal wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global Am1 Ph1
Am1='1';
Ph1='0';
% --- Outputs from this function are returned to the command line.
function varargout = signal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
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
global C_signal
global Am1 Ph Am
C_signal=1;
hs = inputdlg({'Am'},'',1,{Am1});
hs=str2double(hs);
Am=hs;
Am1=num2str(Am)
Ph=0;
run('.\templot')
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global C_signal
C_signal=2;
global Am1 Ph Am
hs = inputdlg({'Am'},'',1,{Am1});
hs=str2double(hs);
Am=hs;
Am1=num2str(Am)
Ph=0;
run('.\templot')
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global C_signal  Am1 Ph1 Am Ph
C_signal=3;
hs = inputdlg({'Am' 'Ph'},'',1,{Am1,Ph1});
hs=str2double(hs);
Am=hs(1);
Ph=hs(2);
Am1=num2str(Am);
Ph1=num2str(Ph);
run('.\templot')