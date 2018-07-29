function varargout = demarrerapplication(varargin)
% DEMARRERAPPLICATION M-file for demarrerapplication.fig
%      DEMARRERAPPLICATION, by itself, creates a new DEMARRERAPPLICATION or raises the existing
%      singleton*.
%
%      H = DEMARRERAPPLICATION returns the handle to a new DEMARRERAPPLICATION or the handle to
%      the existing singleton*.
%
%      DEMARRERAPPLICATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEMARRERAPPLICATION.M with the given input arguments.
%
%      DEMARRERAPPLICATION('Property','Value',...) creates a new DEMARRERAPPLICATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before demarrerapplication_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to demarrerapplication_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help demarrerapplication

% Last Modified by GUIDE v2.5 02-Jul-2006 19:04:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @demarrerapplication_OpeningFcn, ...
                   'gui_OutputFcn',  @demarrerapplication_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before demarrerapplication is made visible.
function demarrerapplication_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to demarrerapplication (see VARARGIN)

% Choose default command line output for demarrerapplication
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes demarrerapplication wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = demarrerapplication_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function ng_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ng_Callback(hObject, eventdata, handles)
% hObject    handle to ng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ng as text
%        str2double(get(hObject,'String')) returns contents of ng as a double
ng = str2double(get(hObject, 'String'));
if isnan(ng)
    set(hObject, 'String', 0);
    errordlg('Entrer un nombre SVP','Error');
end

data = getappdata(gcbf, 'metricdata');
data.ng = ng;
setappdata(gcbf, 'metricdata', data);

% --- Executes during object creation, after setting all properties.
function ni_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ni (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ni_Callback(hObject, eventdata, handles)
% hObject    handle to ni (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ni as text
%        str2double(get(hObject,'String')) returns contents of ni as a double
ni= str2double(get(hObject, 'String'));
if isnan(ni)
    set(hObject, 'String', 0);
    errordlg('Entrer un nombre SVP','Error');
end

data = getappdata(gcbf, 'metricdata');
data.ni = ni;
setappdata(gcbf, 'metricdata', data);

% --- Executes during object creation, after setting all properties.
function pc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function pc_Callback(hObject, eventdata, handles)
% hObject    handle to pc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pc as text
%        str2double(get(hObject,'String')) returns contents of pc as a double
pc = str2double(get(hObject, 'String'));
if isnan(pc)
    set(hObject, 'String', 0);
    errordlg('Entrer un nombre SVP','Error');
end

data = getappdata(gcbf, 'metricdata');
data.pc = pc;
setappdata(gcbf, 'metricdata', data);

% --- Executes during object creation, after setting all properties.
function pm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function pm_Callback(hObject, eventdata, handles)
% hObject    handle to pm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pm as text
%        str2double(get(hObject,'String')) returns contents of pm as a double
pm = str2double(get(hObject, 'String'));
if isnan(pm)
    set(hObject, 'String', 0);
    errordlg('Entrer un nombre SVP','Error');
end

data = getappdata(gcbf, 'metricdata');
data.pm = pm;
setappdata(gcbf, 'metricdata', data);

% --- Executes during object creation, after setting all properties.
function nb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function nb_Callback(hObject, eventdata, handles)
% hObject    handle to nb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nb as text
%        str2double(get(hObject,'String')) returns contents of nb as a double
nb = str2double(get(hObject, 'String'));
if isnan(nb)
    set(hObject, 'String', 0);
    errordlg('Entrer un nombre SVP','Error');
end

data = getappdata(gcbf, 'metricdata');
data.nb = nb;
setappdata(gcbf, 'metricdata', data);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(gcbf, 'metricdata');
ng=data.ng;
ni=data.ni;
pc=data.pc;
pm=data.pm;
nb=data.nb;

savefile = 'parametres.mat';

save(savefile,'ng','ni','pc','pm','nb')

ag;




% Update handles structure



% --- Executes during object creation, after setting all properties.
function result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --------------------------------------------------------------------
function result_Callback(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load resultats;
X=[xopt yopt]';
set(handles.result,'string',X);
%set(handles.result,'string',yopt);
set(handles.fxy,'string',meilleur);

% --- Executes during object creation, after setting all properties.
function fxy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fxy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function fxy_Callback(hObject, eventdata, handles)
% hObject    handle to fxy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fxy as text
%        str2double(get(hObject,'String')) returns contents of fxy as a double


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

