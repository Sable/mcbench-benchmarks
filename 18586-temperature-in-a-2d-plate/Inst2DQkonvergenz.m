function varargout = Inst2DQkonvergenz(varargin)
% INST2DQKONVERGENZ M-file for Inst2DQkonvergenz.fig
%      INST2DQKONVERGENZ, by itself, creates a new INST2DQKONVERGENZ or raises the existing
%      singleton*.
%
%      H = INST2DQKONVERGENZ returns the handle to a new INST2DQKONVERGENZ or the handle to
%      the existing singleton*.
%
%      INST2DQKONVERGENZ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INST2DQKONVERGENZ.M with the given input arguments.
%
%      INST2DQKONVERGENZ('Property','Value',...) creates a new INST2DQKONVERGENZ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Inst2DQkonvergenz_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Inst2DQkonvergenz_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Inst2DQkonvergenz

% Last Modified by GUIDE v2.5 02-Feb-2008 17:03:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Inst2DQkonvergenz_OpeningFcn, ...
                   'gui_OutputFcn',  @Inst2DQkonvergenz_OutputFcn, ...
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



% --- Executes just before Inst2DQkonvergenz is made visible.
function Inst2DQkonvergenz_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Inst2DQkonvergenz (see VARARGIN)

% Choose default command line output for Inst2DQkonvergenz
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Inst2DQkonvergenz wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Inst2DQkonvergenz_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function edit_laenge_Callback(hObject, eventdata, handles)
% hObject    handle to edit_laenge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_laenge as text
%        str2double(get(hObject,'String')) returns contents of edit_laenge as a double

% --- Executes during object creation, after setting all properties.
function edit_laenge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_laenge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_breite_Callback(hObject, eventdata, handles)
% hObject    handle to edit_breite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_breite as text
%        str2double(get(hObject,'String')) returns contents of edit_breite as a double

% --- Executes during object creation, after setting all properties.
function edit_breite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_breite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tu_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tu as text
%        str2double(get(hObject,'String')) returns contents of edit_tu as a double

% --- Executes during object creation, after setting all properties.
function edit_tu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_to_Callback(hObject, eventdata, handles)
% hObject    handle to edit_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_to as text
%        str2double(get(hObject,'String')) returns contents of edit_to as a double

% --- Executes during object creation, after setting all properties.
function edit_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tl_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tl as text
%        str2double(get(hObject,'String')) returns contents of edit_tl as a double

% --- Executes during object creation, after setting all properties.
function edit_tl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tr as text
%        str2double(get(hObject,'String')) returns contents of edit_tr as a double

% --- Executes during object creation, after setting all properties.
function edit_tr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_dx_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dx as text
%        str2double(get(hObject,'String')) returns contents of edit_dx as a double

% --- Executes during object creation, after setting all properties.
function edit_dx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tanfang_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tanfang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tanfang as text
%        str2double(get(hObject,'String')) returns contents of edit_tanfang as a double


% --- Executes during object creation, after setting all properties.
function edit_tanfang_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tanfang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_dt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dt as text
%        str2double(get(hObject,'String')) returns contents of edit_dt as a double


% --- Executes during object creation, after setting all properties.
function edit_dt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Zeit_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Zeit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Zeit as text
%        str2double(get(hObject,'String')) returns contents of edit_Zeit as a double


% --- Executes during object creation, after setting all properties.
function edit_Zeit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Zeit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1_Qu_Callback(hObject, eventdata, handles)
% hObject    handle to edit1_Qu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1_Qu as text
%        str2double(get(hObject,'String')) returns contents of edit1_Qu as a double


% --- Executes during object creation, after setting all properties.
function edit1_Qu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1_Qu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Qo_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Qo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Qo as text
%        str2double(get(hObject,'String')) returns contents of edit_Qo as a double


% --- Executes during object creation, after setting all properties.
function edit_Qo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Qo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Ql_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Ql (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Ql as text
%        str2double(get(hObject,'String')) returns contents of edit_Ql as a double


% --- Executes during object creation, after setting all properties.
function edit_Ql_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Ql (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Qr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Qr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Qr as text
%        str2double(get(hObject,'String')) returns contents of edit_Qr as a double


% --- Executes during object creation, after setting all properties.
function edit_Qr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Qr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_D_Callback(hObject, eventdata, handles)
% hObject    handle to edit_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_D as text
%        str2double(get(hObject,'String')) returns contents of edit_D as a double


% --- Executes during object creation, after setting all properties.
function edit_D_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_Tmax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Tmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Tmax as text
%        str2double(get(hObject,'String')) returns contents of edit_Tmax as a double


% --- Executes during object creation, after setting all properties.
function edit_Tmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Tmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Tmin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Tmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Tmin as text
%        str2double(get(hObject,'String')) returns contents of edit_Tmin as a double


% --- Executes during object creation, after setting all properties.
function edit_Tmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Tmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_konv_Callback(hObject, eventdata, handles)
% hObject    handle to edit_konv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_konv as text
%        str2double(get(hObject,'String')) returns contents of edit_konv as a double


% --- Executes during object creation, after setting all properties.
function edit_konv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_konv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

if get(handles.popupmenu1,'Value')==1
    set(handles.edit_konv,'String',500);
else set(handles.edit_konv,'String',1e-3);
end

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



% --- Executes on button press in pushbutton_start.
function pushbutton_start_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

L=str2num(get(handles.edit_laenge,'String'));
B=str2num(get(handles.edit_breite,'String'));
T_u=str2num(get(handles.edit_tu,'String'));
T_o=str2num(get(handles.edit_to,'String'));
T_l=str2num(get(handles.edit_tl,'String'));
T_r=str2num(get(handles.edit_tr,'String'));
T_anfang=str2num(get(handles.edit_tanfang,'String'));
dx=str2num(get(handles.edit_dx,'String'));
dt=str2num(get(handles.edit_dt,'String'));
%Zeit=str2num(get(handles.edit_konv,'String'));
D=str2num(get(handles.edit_D,'String'));
Q_u=str2num(get(handles.edit1_Qu,'String'));
Q_o=str2num(get(handles.edit_Qo,'String'));
Q_r=str2num(get(handles.edit_Qr,'String'));
Q_l=str2num(get(handles.edit_Ql,'String'));
Tmin=str2num(get(handles.edit_Tmin,'String'));
Tmax=str2num(get(handles.edit_Tmax,'String'));
index=get(handles.popupmenu1,'Value');
konv=str2num(get(handles.edit_konv,'String'));
%-------------------Berechnung---------------------------------------------
%Materialkonstanten
aAl=98.8e-6;           %Aluminium [m^2/s]
aFe=22.8e-6;           %Eisen [m^2/s]
aB=0.54e-6;            %Beton [m^2/s]
%Wärmeleitwerte        [W/(m*K)]
lamAl=237;             %Aluminium
lamFe=80.2;            %Eisen
lamB=2.1;              %Beton
lam=lamAl;             %Lamda für gewähltes Material  
%----------------Stabilitäts-Berechnungen-----------
%Stabilitätsbedingung: CFL < oder = 0.25
CFLAL=aAl*dt/dx^2;
CFLFE=aFe*dt/dx^2;
CFLB=aB*dt/dx^2;

if CFLAL<0.25
%     ('stabil für Al')
else
    dt=floor(0.25*dx^2/aAl);
    CFLAL=aAl*dt/dx^2;
    set(handles.edit_dt,'String',num2str(dt));
%     ('instabil für Alu, Zeitschritt wurde auf dtmin gesetzt')
end

%if CFLFE<0.25
%    ('stabil für Fe')
%else
%    dt=floor(0.25*dx^2/aFe);
%    CFLFE=aFe*dt/dx^2;
%    ('instabil für Eisen, Zeitschritt wurde auf dtmin gesetzt')
%end
%
%if CFLB<0.25
%    ('stabil für B')
%else
%    dt=floor(0.25*dx^2/aB);
%    CFLB=aB*dt/dx^2;
%    ('instabil für Beton, Zeitschritt wurde auf dtmin gesetzt')
%end  
%----------------------------------------------------
if index==1

%Bereich
x=0:dx:L;      %Längenvektor
y=0:dx:B;      %Breitenvektor
t=0:dt:konv;   %Zeitvektor

M=round(L/dx);          %Anzahl Intervalle: x-Richtung
N=round(B/dx);          %Anzahl Intervalle: y-Richtung
O=konv/dt;              %Anzahl Intervalle: Zeit

%Nullmatrix
T=zeros(N+1,M+1,O+1);   %(Ort,Zeit)

%Anfangsbedingungen
T(:,:,1)=T_anfang;

%Wärmestromdichten
q_o=Q_o/(L*D);
q_u=Q_u/(L*D);
q_l=Q_l/(B*D);
q_r=Q_r/(B*D);

for n=1:O               %Zeit-Schleife
    for i=2:N           %Ort-Schleife
        for j=2:M
        T(i,j,n+1)=aAl*dt/dx^2*(T(i-1,j,n)-4*T(i,j,n)+T(i+1,j,n)+T(i,j-1,n)+T(i,j+1,n))+T(i,j,n);
        end
    end
        if q_o==0
           T(N+1,:,n+1)=T_o;
        else
           T(N+1,:,n+1)=T(N,:,n)+dx*q_o/lam;
        end
        if q_u==0
           T(1,:,n+1)=T_u;
        else
           T(1,:,n+1)=T(2,:,n)+dx*q_u/lam;
        end
        if q_l==0
           T(:,1,n+1)=T_l;
        else
           T(:,1,n+1)=T(:,2,n)+dx*q_l/lam;
        end
        if q_r==0
           T(:,M+1,n+1)=T_r;
        else
           T(:,M+1,n+1)=T(:,M,n)+dx*q_r/lam;
        end

    %-----Plot-------------------------------------------------------------
    axes(handles.axes1);
    set(handles.axes1,'Position',[71.28571428571428 19.900000000000006 57.285714285714285 20.05]);
    contourf(T(:,:,n),25)
    title('2D-Temperaturverteilung')
    caxis([Tmin Tmax])
    colorbar
    axes(handles.axes_yschnitt);
    plot(T(:,ceil((M+1)/2),n))
    title('Schnitt y-Achse')
    axis([1 N+1 Tmin Tmax])
    axes(handles.axes_xschnitt);
    plot(T(ceil((N+1)/2),:,n))
    title('Schnitt x-Achse')
    axis([1 M+1 Tmin Tmax])
    set(handles.edit_Zeit,'String',num2str(n*dt));
    pause(0.01)
end

%-----------------------------------------------------------------
%Bereich
x=0:dx:L;      %Längenvektor
y=0:dx:B;      %Breitenvektor

else

M=round(L/dx);          %Anzahl Intervalle: x-Richtung
N=round(B/dx);          %Anzahl Intervalle: y-Richtung


%Nullmatrix
T=zeros(N+1,M+1,2);   %(Ort,Zeit)

%Anfangsbedingungen
T(:,:,1)=T_anfang;

%Wärmestromdichten
q_o=Q_o/(L*D);
q_u=Q_u/(L*D);
q_l=Q_l/(B*D);
q_r=Q_r/(B*D);




for n=1:2
    for i=2:N           %Ort-Schleife
        for j=2:M
        T(i,j,n+1)=aAl*dt/dx^2*(T(i-1,j,n)-4*T(i,j,n)+T(i+1,j,n)+T(i,j-1,n)+T(i,j+1,n))+T(i,j,n);
        end
    end
        if q_o==0
           T(N+1,:,n+1)=T_o;
        else
           T(N+1,:,n+1)=T(N,:,n)+dx*q_o/lam;
        end
        if q_u==0
           T(1,:,n+1)=T_u;
        else
           T(1,:,n+1)=T(2,:,n)+dx*q_u/lam;
        end
        if q_l==0
           T(:,1,n+1)=T_l;
        else
           T(:,1,n+1)=T(:,2,n)+dx*q_l/lam;
        end
        if q_r==0
           T(:,M+1,n+1)=T_r;
        else
           T(:,M+1,n+1)=T(:,M,n)+dx*q_r/lam;
        end
    
    %-----Plot-------------------------------------------------------------
    
    axes(handles.axes1);
    set(handles.axes1,'Position',[71.28571428571428 19.900000000000006 57.285714285714285 20.05]);
    contourf(T(:,:,n),25)
    title('2D-Temperaturverteilung')
    caxis([Tmin Tmax])
    colorbar
    axes(handles.axes_yschnitt);
    plot(T(:,ceil((M+1)/2),n))
    title('Schnitt y-Achse')
    axis([1 N+1 Tmin Tmax])
    axes(handles.axes_xschnitt);
    plot(T(ceil((N+1)/2),:,n))
    title('Schnitt x-Achse')
    axis([1 M+1 Tmin Tmax])
    set(handles.edit_Zeit,'String',num2str(n*dt));
    pause(0.01)
end

n=2;
while abs(max(max(T(:,:,n)-T(:,:,n-1))))>konv
    T(:,:,n+1)=zeros(N+1,M+1);
    for i=2:N           %Ort-Schleife
        for j=2:M
        T(i,j,n+1)=aAl*dt/dx^2*(T(i-1,j,n)-4*T(i,j,n)+T(i+1,j,n)+T(i,j-1,n)+T(i,j+1,n))+T(i,j,n);
        end
    end
        if q_o==0
           T(N+1,:,n+1)=T_o;
        else
           T(N+1,:,n+1)=T(N,:,n)+dx*q_o/lam;
        end
        if q_u==0
           T(1,:,n+1)=T_u;
        else
           T(1,:,n+1)=T(2,:,n)+dx*q_u/lam;
        end
        if q_l==0
           T(:,1,n+1)=T_l;
        else
           T(:,1,n+1)=T(:,2,n)+dx*q_l/lam;
        end
        if q_r==0
           T(:,M+1,n+1)=T_r;
        else
           T(:,M+1,n+1)=T(:,M,n)+dx*q_r/lam;
        end
    
    %-----Plot-------------------------------------------------------------
    
    axes(handles.axes1);
    set(handles.axes1,'Position',[71.28571428571428 19.900000000000006 57.285714285714285 20.05]);
    contourf(T(:,:,n),25)
    title('2D-Temperaturverteilung')
    caxis([Tmin Tmax])
    colorbar
    axes(handles.axes_yschnitt);
    plot(T(:,ceil((M+1)/2),n))
    title('Schnitt y-Achse')
    axis([1 N+1 Tmin Tmax])
    axes(handles.axes_xschnitt);
    plot(T(ceil((N+1)/2),:,n))
    title('Schnitt x-Achse')
    axis([1 M+1 Tmin Tmax])
    set(handles.edit_Zeit,'String',num2str(n*dt));
    pause(0.01)
    n=n+1;
end
end

% --- Executes on button press in pushbutton_exit.
function pushbutton_exit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear all
close


function edit_printcounter_Callback(hObject, eventdata, handles)
% hObject    handle to edit_printcounter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_printcounter as text
%        str2double(get(hObject,'String')) returns contents of edit_printcounter as a double


% --- Executes during object creation, after setting all properties.
function edit_printcounter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_printcounter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_print.
function pushbutton_print_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=str2num(get(handles.edit_printcounter,'String'));
set(gcf,'PaperPositionMode','auto')
name=['Printout',num2str(a)];
print(name,'-djpeg','-r300')
set(handles.edit_printcounter,'String',num2str(a+1));







