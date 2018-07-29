function varargout = caesarcipher(varargin)
% CAESARCIPHER M-file for caesarcipher.fig
%      CAESARCIPHER, by itself, creates a new CAESARCIPHER or raises the existing
%      singleton*.
%
%      H = CAESARCIPHER returns the handle to a new CAESARCIPHER or the handle to
%      the existing singleton*.
%
%      CAESARCIPHER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAESARCIPHER.M with the given input arguments.
%
%      CAESARCIPHER('Property','Value',...) creates a new CAESARCIPHER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before caesarcipher_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to caesarcipher_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help caesarcipher

% Last Modified by GUIDE v2.5 24-Dec-2012 02:54:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @caesarcipher_OpeningFcn, ...
                   'gui_OutputFcn',  @caesarcipher_OutputFcn, ...
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


% --- Executes just before caesarcipher is made visible.
function caesarcipher_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to caesarcipher (see VARARGIN)

% Choose default command line output for caesarcipher
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes caesarcipher wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = caesarcipher_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function pl_Callback(hObject, eventdata, handles)
% hObject    handle to pl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pl as text
%        str2double(get(hObject,'String')) returns contents of pl as a double

% --- Executes during object creation, after setting all properties.
function pl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in encrypt.
function encrypt_Callback(hObject, eventdata, handles)
% hObject    handle to encrypt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ke.
function ke_Callback(hObject, eventdata, handles)
% hObject    handle to ke (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ke contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ke
str = get(hObject,'String');


% --- Executes during object creation, after setting all properties.
function ke_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ke (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function en_Callback(hObject, eventdata, handles)
% hObject    handle to en (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of en as text
%        str2double(get(hObject,'String')) returns contents of en as a double


% --- Executes during object creation, after setting all properties.
function en_CreateFcn(hObject, eventdata, handles)
% hObject    handle to en (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in decrypt.
function decrypt_Callback(hObject, eventdata, handles)
% hObject    handle to decrypt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in kd.
function kd_Callback(hObject, eventdata, handles)
% hObject    handle to kd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns kd contents as cell array
%        contents{get(hObject,'Value')} returns selected item from kd


% --- Executes during object creation, after setting all properties.
function kd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
