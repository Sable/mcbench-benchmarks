function varargout = mytemp(varargin)
% MYTEMP M-file for mytemp.fig
%      MYTEMP, by itself, creates a new MYTEMP or raises the existing
%      singleton*.
%
%      H = MYTEMP returns the handle to a new MYTEMP or the handle to
%      the existing singleton*.
%
%      MYTEMP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYTEMP.M with the given input arguments.
%
%      MYTEMP('Property','Value',...) creates a new MYTEMP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mytemp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mytemp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mytemp

% Last Modified by GUIDE v2.5 14-Apr-2012 09:44:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mytemp_OpeningFcn, ...
                   'gui_OutputFcn',  @mytemp_OutputFcn, ...
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


% --- Executes just before mytemp is made visible.
function mytemp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mytemp (see VARARGIN)

% Choose default command line output for mytemp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mytemp wait for user response (see UIRESUME)
% uiwait(handles.figure1);
reset_Callback(hObject, eventdata, handles);%% I added

% --- Outputs from this function are returned to the command line.
function varargout = mytemp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CF=str2double(get(handles.Input,'String')); %% I added
if strcmp(get(handles.FC1,'String'),'C')
  OUT=CF*9/5+32;
else
  OUT=(CF-32)*5/9;
end
OUT=num2str(OUT);
set(handles.Output,'String',OUT);
% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Input, 'String', '0');%% I added
c2f_Callback(hObject, eventdata, handles); %% I added

% --- Executes on button press in c2f.
function c2f_Callback(hObject, eventdata, handles)
% hObject    handle to c2f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c2f
set(handles.FC2, 'String', 'F');  %% I added
set(handles.FC1, 'String', 'C');
set(handles.CeF2, 'String', 'Fahrenheight');
set(handles.CeF1, 'String', 'Celsius');
set(handles.c2f,'Value',1);
set(handles.f2c,'Value',0);
calculate_Callback(hObject, eventdata, handles);%% I added


% --- Executes on button press in f2c.
function f2c_Callback(hObject, eventdata, handles)
% hObject    handle to f2c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of f2c
set(handles.FC1, 'String', 'F'); %% I added
set(handles.FC2, 'String', 'C');
set(handles.CeF1, 'String', 'Fahrenheight');
set(handles.CeF2, 'String', 'Celsius');
set(handles.c2f,'Value',0);
set(handles.f2c,'Value',1);
calculate_Callback(hObject, eventdata, handles);%% I added



function Input_Callback(hObject, eventdata, handles)
% hObject    handle to Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input as text
%        str2double(get(hObject,'String')) returns contents of Input as a double


% --- Executes during object creation, after setting all properties.
function Input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
