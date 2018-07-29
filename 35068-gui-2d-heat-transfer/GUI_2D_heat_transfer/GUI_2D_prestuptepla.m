function varargout = GUI_2D_prestuptepla(varargin)

% Last Modified by GUIDE v2.5 06-Mar-2011 12:28:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_2D_prestuptepla_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_2D_prestuptepla_OutputFcn, ...
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


% --- Executes just before GUI_2D_prestuptepla is made visible.
function GUI_2D_prestuptepla_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_2D_prestuptepla (see VARARGIN)

% Choose default command line output for GUI_2D_prestuptepla
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_2D_prestuptepla wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_2D_prestuptepla_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
clear global
clc

global tkon t

% inputs
ro=str2double(get(handles.hustota,'String'));
vod=str2double(get(handles.vodivost,'String'));
Cp=str2double(get(handles.kapacita,'String'));
T0=str2double(get(handles.T0,'String'));
TH=str2double(get(handles.TH,'String'));
TD=str2double(get(handles.TD,'String'));
TP=str2double(get(handles.TP,'String'));
TL=str2double(get(handles.TL,'String'));
L=str2double(get(handles.L,'String'));
M=str2double(get(handles.M,'String'));
N=str2double(get(handles.n,'String'));
tkon=str2double(get(handles.tkon,'String'));

% calculation ===================================================
a=vod/ro/Cp;
% length step
dx=L/(N-1);
% time step
dt=((dx)^2)/M/a;
t=dt;

% =======================================================
% inicialy temperatures
Tpoc=zeros(N,N);
for i=1:1:N
    for j=1:1:N
        Tpoc(i,j)=T0;
    end
end

while t<tkon
      
% ============================================================
j=1;
i=1;
Tpoc(i,j)=(Tpoc(i+1,j)+TL+TD+Tpoc(i,j+1)+(M-4)*Tpoc(i,j))/M;

j=N;
i=1;
Tpoc(i,j)=(Tpoc(i+1,j)+TD+Tpoc(i,j-1)+TP+(M-4)*Tpoc(i,j))/M;

j=1;
i=N;
Tpoc(i,j)=(TH+Tpoc(i-1,j)+TL+Tpoc(i,j+1)+(M-4)*Tpoc(i,j))/M;

   
j=N;
i=N;
Tpoc(i,j)=(TP+Tpoc(i-1,j)+Tpoc(i,j-1)+TP+(M-4)*Tpoc(i,j))/M;

% ==========================================================
i=1;
for j=2:1:N-1
Tpoc(i,j)=(Tpoc(i+1,j)+TD+Tpoc(i,j-1)+Tpoc(i,j+1)+(M-4)*Tpoc(i,j))/M;
end

i=N;
for j=2:1:N-1
    Tpoc(i,j)=(TH+Tpoc(i-1,j)+Tpoc(i,j-1)+Tpoc(i,j+1)+(M-4)*Tpoc(i,j))/M;
end
j=1;
for i=2:1:N-1
    Tpoc(i,j)=(Tpoc(i+1,j)+Tpoc(i-1,j)+TL+Tpoc(i,j+1)+(M-4)*Tpoc(i,j))/M;
end

j=N;
for i=2:1:N-1
    Tpoc(i,j)=(Tpoc(i+1,j)+Tpoc(i-1,j)+Tpoc(i,j-1)+TP+(M-4)*Tpoc(i,j))/M;
end

% ===========================================================
for i=2:1:N-1
    for j=2:1:N-1
        Tpoc(i,j)=(Tpoc(i+1,j)+Tpoc(i-1,j)+Tpoc(i,j-1)+Tpoc(i,j+1)+(M-4)*Tpoc(i,j))/M;
    end
end



% ===========================================================
% graph
pause(0.02)
%axes(handles.graf);
pcolor(Tpoc)
retazec=sprintf('Time=%g s',t);
title(retazec)
colorbar
shading interp

% --------
t=t+dt;
end




function hustota_Callback(hObject, eventdata, handles)
% hObject    handle to hustota (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hustota as text
%        str2double(get(hObject,'String')) returns contents of hustota as a double


% --- Executes during object creation, after setting all properties.
function hustota_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hustota (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function kapacita_Callback(hObject, eventdata, handles)
% hObject    handle to kapacita (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kapacita as text
%        str2double(get(hObject,'String')) returns contents of kapacita as a double


% --- Executes during object creation, after setting all properties.
function kapacita_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kapacita (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function vodivost_Callback(hObject, eventdata, handles)
% hObject    handle to vodivost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vodivost as text
%        str2double(get(hObject,'String')) returns contents of vodivost as a double


% --- Executes during object creation, after setting all properties.
function vodivost_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vodivost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function T0_Callback(hObject, eventdata, handles)
% hObject    handle to T0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T0 as text
%        str2double(get(hObject,'String')) returns contents of T0 as a double


% --- Executes during object creation, after setting all properties.
function T0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function TD_Callback(hObject, eventdata, handles)
% hObject    handle to TD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TD as text
%        str2double(get(hObject,'String')) returns contents of TD as a double


% --- Executes during object creation, after setting all properties.
function TD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function TP_Callback(hObject, eventdata, handles)
% hObject    handle to TP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TP as text
%        str2double(get(hObject,'String')) returns contents of TP as a double


% --- Executes during object creation, after setting all properties.
function TP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function TL_Callback(hObject, eventdata, handles)
% hObject    handle to TL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TL as text
%        str2double(get(hObject,'String')) returns contents of TL as a double


% --- Executes during object creation, after setting all properties.
function TL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function TH_Callback(hObject, eventdata, handles)
% hObject    handle to TH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TH as text
%        str2double(get(hObject,'String')) returns contents of TH as a double


% --- Executes during object creation, after setting all properties.
function TH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function M_Callback(hObject, eventdata, handles)
% hObject    handle to M (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of M as text
%        str2double(get(hObject,'String')) returns contents of M as a double


% --- Executes during object creation, after setting all properties.
function M_CreateFcn(hObject, eventdata, handles)
% hObject    handle to M (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function n_Callback(hObject, eventdata, handles)
% hObject    handle to n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n as text
%        str2double(get(hObject,'String')) returns contents of n as a double


% --- Executes during object creation, after setting all properties.
function n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function L_Callback(hObject, eventdata, handles)
% hObject    handle to L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of L as text
%        str2double(get(hObject,'String')) returns contents of L as a double


% --- Executes during object creation, after setting all properties.
function L_CreateFcn(hObject, eventdata, handles)
% hObject    handle to L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function tkon_Callback(hObject, eventdata, handles)
% hObject    handle to tkon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tkon as text
%        str2double(get(hObject,'String')) returns contents of tkon as a double


% --- Executes during object creation, after setting all properties.
function tkon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tkon (see GCBO)
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
global t tkon
t=tkon;
pause(0.02)
clc
