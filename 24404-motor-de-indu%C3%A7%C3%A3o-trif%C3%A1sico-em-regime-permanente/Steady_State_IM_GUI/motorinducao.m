function varargout = motorinducao(varargin)
% MOTORINDUCAO M-file for motorinducao.fig
%      MOTORINDUCAO, by itself, creates a new MOTORINDUCAO or raises the existing
%      singleton*.
%
%      H = MOTORINDUCAO returns the handle to a new MOTORINDUCAO or the handle to
%      the existing singleton*.
%
%      MOTORINDUCAO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOTORINDUCAO.M with the given input arguments.
%
%      MOTORINDUCAO('Property','Value',...) creates a new MOTORINDUCAO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MotorInduction_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to motorinducao_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help motorinducao

% Last Modified by GUIDE v2.5 26-May-2009 01:11:53

% Begin initialization code - DO NOT EDIT

% Autor:    - Jose Luis Azcue Puma
%      
% Laboratory of Power Electronics
% Faculty of Electrical and Computing Engineering
% University of Campinas – UNICAMP
% Campinas, SP, Brazil
% azcue@ieee.org


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @motorinducao_OpeningFcn, ...
                   'gui_OutputFcn',  @motorinducao_OutputFcn, ...
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

%%
% --- Executes just before motorinducao is made visible.
function motorinducao_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to motorinducao (see VARARGIN)

%Colocar Imagen de fondo
circuito = imread('circuito.jpg'); %Leer imagen
axes(handles.Circuito); %Carga la imagen en Circuito
axis off;
imshow(circuito); %Presenta la imagen


% Choose default command line output for motorinducao
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes motorinducao wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%%
% --- Outputs from this function are returned to the command line.
function varargout = motorinducao_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function ERs_Callback(hObject, eventdata, handles)
% hObject    handle to ERs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ERs as text
%        str2double(get(hObject,'String')) returns contents of ERs as a double


% --- Executes during object creation, after setting all properties.
function ERs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ERs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ERr_Callback(hObject, eventdata, handles)
% hObject    handle to ERr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ERr as text
%        str2double(get(hObject,'String')) returns contents of ERr as a double


% --- Executes during object creation, after setting all properties.
function ERr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ERr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EXs_Callback(hObject, eventdata, handles)
% hObject    handle to EXs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EXs as text
%        str2double(get(hObject,'String')) returns contents of EXs as a double


% --- Executes during object creation, after setting all properties.
function EXs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EXs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EXr_Callback(hObject, eventdata, handles)
% hObject    handle to EXr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EXr as text
%        str2double(get(hObject,'String')) returns contents of EXr as a double


% --- Executes during object creation, after setting all properties.
function EXr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EXr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EXm_Callback(hObject, eventdata, handles)
% hObject    handle to EXm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EXm as text
%        str2double(get(hObject,'String')) returns contents of EXm as a double


% --- Executes during object creation, after setting all properties.
function EXm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EXm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EVlinha_Callback(hObject, eventdata, handles)
% hObject    handle to EVlinha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EVlinha as text
%        str2double(get(hObject,'String')) returns contents of EVlinha as a double


% --- Executes during object creation, after setting all properties.
function EVlinha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EVlinha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EFe_Callback(hObject, eventdata, handles)
% hObject    handle to EFe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EFe as text
%        str2double(get(hObject,'String')) returns contents of EFe as a double


% --- Executes during object creation, after setting all properties.
function EFe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EFe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EPolos_Callback(hObject, eventdata, handles)
% hObject    handle to EPolos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EPolos as text
%        str2double(get(hObject,'String')) returns contents of EPolos as a double


% --- Executes during object creation, after setting all properties.
function EPolos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EPolos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
% --- Executes on button press in BCalcular.
function BCalcular_Callback(hObject, eventdata, handles)
% hObject    handle to BCalcular (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Vlinha =str2num(get(handles.EVlinha, 'String'));
Fe =str2num(get(handles.EFe, 'String'));
p =str2num(get(handles.EPolos, 'String'));
s =str2num(get(handles.ES, 'String'));

Rs =str2num(get(handles.ERs, 'String'));
Rr =str2num(get(handles.ERr, 'String'));
handles.EERr=Rr;

Xs =str2num(get(handles.EXs, 'String'));
Xr =str2num(get(handles.EXr, 'String'));
Xm =str2num(get(handles.EXm, 'String'));
handles.EEXr=Xr;

%calculando tensao de entrada
Vin=Vlinha/sqrt(3);

%%
We=2*pi*Fe;
Ws=2/p*We;          %rad-mec/seg
Ns=Ws*(60/(2*pi));  %conversao rad-mec/seg-->rpm
%set(EWs,'String',num2str(num));
handles.EEWs=Ws;
handles.EENs=Ns;

set(handles.EWs,'String',num2str(Ws));
set(handles.ENs,'String',num2str(Ns));

Wm=(1-s)*Ws;
Nr=(1-s)*Ns;

set(handles.EWm,'String',num2str(Wm));
set(handles.ENr,'String',num2str(Nr));
%% calculo do equivalente thevening
Zth=((Xm*1i)*(Rs+Xs*1i))/((Xs+Xm)*1i+Rs);
[ZthTheta,ZthMag]=cart2pol(real(Zth),imag(Zth));
handles.EEZth=Zth;

%impedancia total do motor (impedancia thevening + impedancia do rotor
%refletido no estator)
Ztotal=Zth+Rr/s+Xr*1i;
[ZtotalTheta,ZtotalMag]=cart2pol(real(Ztotal),imag(Ztotal));

Vth=Vin*(Xm*1i)/((Xm+Xs)*1i+Rs);
[VthTheta,VthMag]=cart2pol(real(Vth),imag(Vth));
handles.EEVthMag=VthMag;
handles.EEVth=Vth;

set(handles.EVth,'String',num2str(Vth));
set(handles.EVthMag,'String',num2str(VthMag));
set(handles.EVthAng,'String',num2str(VthTheta));

set(handles.EZth,'String',num2str(Zth));
set(handles.EZthMag,'String',num2str(ZthMag));
set(handles.EZthAng,'String',num2str(ZthTheta));

%% calculo fator de potencia
%calcular impedancia equivalente vista por o estator (impedancia do estator
% + impedancia rotor // reactancia magnetizante)
ZeqEstator=((Rs+Xs*1i)+(Xm*1i)*(Rr/s+Xr*1i)/(Xm*1i+Rr/s+Xr*1i));
[ZeqEstatorTheta,ZeqEstatorMag]=cart2pol(real(ZeqEstator),imag(ZeqEstator));

cosfi=cos(ZeqEstatorTheta);
set(handles.EFp,'String',num2str(cosfi));

%% calculo das correntes
Ir=VthMag/ZtotalMag;
Is=Vin/ZeqEstatorMag;
set(handles.EIs,'String',num2str(Is));
set(handles.EIr,'String',num2str(Ir));

%% calculo das potencias
% Pgap = Pmech + Protor (Protor são as perdas no cobre do rotor)
Pgap=3*(Ir^2)*Rr/s;
%Protor=3*(Ir^2)*Rr
Protor=s*Pgap;%perdas no rotor
%Pm=Pgap-Protor
Pm=(1-s)*Pgap;
Tm=Pm/Wm;   %olhinho

%Tm=1/Wm*3*Ir^2*Rr*(1-s)/s;


set(handles.EPgap,'String',num2str(Pgap));
set(handles.EProtor,'String',num2str(Protor));
set(handles.EPm,'String',num2str(Pm));
set(handles.ETm,'String',num2str(Tm));

%% calculo do Tmax (torque mecanico maximo)  e Smax (escorregamento maximo)
Smax=Rr/(sqrt(real(Zth)^2+(imag(Zth)+Xr)^2));
Tmax=1/Ws*0.5*3*VthMag^2/(real(Zth)+sqrt(real(Zth)^2+(imag(Zth)+Xr)^2));
handles.EETmax=Tmax;
%Tmax2=3/Ws*VthMag^2*sqrt(real(Zth)^2+(imag(Zth)+Xr)^2)/((real(Zth)+sqrt(real(Zth)^2+(imag(Zth)+Xr)^2))^2+(imag(Zth)+Xr)^2)
NrTmax=(1-Smax)*Ns;
WrTmax=(1-Smax)*Ws;
handles.EENrTmax=NrTmax;

set(handles.ESmax,'String',num2str(Smax));
set(handles.ETmMax,'String',num2str(Tmax));
set(handles.EWrMax,'String',num2str(WrTmax));
set(handles.ENrMax,'String',num2str(NrTmax));

%% calculo das grandezas na partida
% para fazer estas contas simplesmente substituimos s=1 (escorregamento no começo)
ZeqEstatorPartida=((Rs+Xs*1i)+(Xm*1i)*(Rr/1+Xr*1i)/(Xm*1i+Rr/1+Xr*1i));
[ZeqEstatorPartidaTheta,ZeqEstatorPartidaMag]=cart2pol(real(ZeqEstatorPartida),imag(ZeqEstatorPartida));

IpartidaEstator=Vin/ZeqEstatorPartidaMag;

ZtotalPartida=Zth+Rr/1+Xr*1i;
[ZtotalPartidaTheta,ZtotalPartidaMag]=cart2pol(real(ZtotalPartida),imag(ZtotalPartida));
IpartidaRotor=VthMag/ZtotalPartidaMag;

Tpartida=1/Ws*3*IpartidaRotor^2*Rr;

set(handles.EIps,'String',num2str(IpartidaEstator));
set(handles.EIpr,'String',num2str(IpartidaRotor));
set(handles.ETp,'String',num2str(Tpartida));

guidata(hObject,handles);

%%  ********************************************************************

function EWs_Callback(hObject, eventdata, handles)
% hObject    handle to EWs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EWs as text
%        str2double(get(hObject,'String')) returns contents of EWs as a double


% --- Executes during object creation, after setting all properties.
function EWs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EWs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over BCalcular.
function BCalcular_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to BCalcular (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function EWm_Callback(hObject, eventdata, handles)
% hObject    handle to EWm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EWm as text
%        str2double(get(hObject,'String')) returns contents of EWm as a double


% --- Executes during object creation, after setting all properties.
function EWm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EWm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EVthMag_Callback(hObject, eventdata, handles)
% hObject    handle to EVthMag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EVthMag as text
%        str2double(get(hObject,'String')) returns contents of EVthMag as a double


% --- Executes during object creation, after setting all properties.
function EVthMag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EVthMag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EZthMag_Callback(hObject, eventdata, handles)
% hObject    handle to EZthMag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EZthMag as text
%        str2double(get(hObject,'String')) returns contents of EZthMag as a double


% --- Executes during object creation, after setting all properties.
function EZthMag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EZthMag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EFp_Callback(hObject, eventdata, handles)
% hObject    handle to EFp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EFp as text
%        str2double(get(hObject,'String')) returns contents of EFp as a double


% --- Executes during object creation, after setting all properties.
function EFp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EFp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EIs_Callback(hObject, eventdata, handles)
% hObject    handle to EIs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EIs as text
%        str2double(get(hObject,'String')) returns contents of EIs as a double


% --- Executes during object creation, after setting all properties.
function EIs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EIs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EIr_Callback(hObject, eventdata, handles)
% hObject    handle to EIr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EIr as text
%        str2double(get(hObject,'String')) returns contents of EIr as a double


% --- Executes during object creation, after setting all properties.
function EIr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EIr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EPgap_Callback(hObject, eventdata, handles)
% hObject    handle to EPgap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EPgap as text
%        str2double(get(hObject,'String')) returns contents of EPgap as a double


% --- Executes during object creation, after setting all properties.
function EPgap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EPgap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function ENs_Callback(hObject, eventdata, handles)
% hObject    handle to ENs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ENs as text
%        str2double(get(hObject,'String')) returns contents of ENs as a double


% --- Executes during object creation, after setting all properties.
function ENs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ENs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function ES_Callback(hObject, eventdata, handles)
% hObject    handle to ES (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ES as text
%        str2double(get(hObject,'String')) returns contents of ES as a double


% --- Executes during object creation, after setting all properties.
function ES_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ES (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ENr_Callback(hObject, eventdata, handles)
% hObject    handle to ENr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ENr as text
%        str2double(get(hObject,'String')) returns contents of ENr as a double


% --- Executes during object creation, after setting all properties.
function ENr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ENr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%% 
% --- Executes on button press in BDesenhar.
function BDesenhar_Callback(hObject, eventdata, handles)
% hObject    handle to BDesenhar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Ws=handles.EEWs;
VthMag=handles.EEVthMag;
Vth=handles.EEVth;
Rr=handles.EERr;
Zth=handles.EEZth;
Xr=handles.EEXr;
Ns=handles.EENs;

%t = -50:0.5:250;
%hline1 = plot(t,0,'k');
%Next, add a shadow by offsetting the x-coordinates.
%Make the shadow line light gray and wider than the default LineWidth:
%hline2 = line(0,t,'LineWidth',4,'Color',[.8 .8 .8]);
%Finally, pop the first line to the front:
%set(handles.TelaPrincipal,'Children',[hline1 hline2])

%T=1/Ws*Nph*Ir^2*Rr/s

%Wmd=-100:0.5:250;
%Tmd=3./(Ws-Wmd).*Rr.*VthMag^2./((real(Zth)+Rr.*Wmd./(Ws-Wmd)).^2+(imag(Zth)+Xr)^2);
%plot(Wmd,Tmd);
%grid on;
set(handles.TelaPrincipal,'NextPlot','add'); %%permite que a os graficos en plot 
%posan ser somados, para gerar multiplos graficos.

for n=1:200
    s(n) = n/200;
Nri(n)=(1-s(n))*Ns; 
Ir=abs(Vth/(Zth+i*Xr+Rr/s(n)));
Tmd(n)=3/Ws*Ir^2*Rr/s(n);
end

grid on;
plot(handles.TelaPrincipal,Nri,Tmd,'color','blue','LineWidth',1);


%axis([-100 250 -200 200]);

%h2=plot(Wmd,0,'Color','red');
%h3=plot(0,Tmd,'Color','red');
%set(handles.TelaPrincipal,'Children',[h1])
%hold
%h3=plot(0,Tmd,'color','red')
%line(0,Tmd)

%set(handles.TelaPrincipal,'Children',[h1 h2])


%%
function EVthAng_Callback(hObject, eventdata, handles)
% hObject    handle to EVthAng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EVthAng as text
%        str2double(get(hObject,'String')) returns contents of EVthAng as a double


% --- Executes during object creation, after setting all properties.
function EVthAng_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EVthAng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EZthAng_Callback(hObject, eventdata, handles)
% hObject    handle to EZthAng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EZthAng as text
%        str2double(get(hObject,'String')) returns contents of EZthAng as a double


% --- Executes during object creation, after setting all properties.
function EZthAng_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EZthAng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function EProtor_Callback(hObject, eventdata, handles)
% hObject    handle to EProtor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EProtor as text
%        str2double(get(hObject,'String')) returns contents of EProtor as a double


% --- Executes during object creation, after setting all properties.
function EProtor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EProtor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EPm_Callback(hObject, eventdata, handles)
% hObject    handle to EPm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EPm as text
%        str2double(get(hObject,'String')) returns contents of EPm as a double


% --- Executes during object creation, after setting all properties.
function EPm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EPm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function ETm_Callback(hObject, eventdata, handles)
% hObject    handle to ETm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ETm as text
%        str2double(get(hObject,'String')) returns contents of ETm as a double


% --- Executes during object creation, after setting all properties.
function ETm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ETm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function ETmMax_Callback(hObject, eventdata, handles)
% hObject    handle to ETmMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ETmMax as text
%        str2double(get(hObject,'String')) returns contents of ETmMax as a double


% --- Executes during object creation, after setting all properties.
function ETmMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ETmMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ENrMax_Callback(hObject, eventdata, handles)
% hObject    handle to ENrMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ENrMax as text
%        str2double(get(hObject,'String')) returns contents of ENrMax as a double


% --- Executes during object creation, after setting all properties.
function ENrMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ENrMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ESmax_Callback(hObject, eventdata, handles)
% hObject    handle to ESmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ESmax as text
%        str2double(get(hObject,'String')) returns contents of ESmax as a double


% --- Executes during object creation, after setting all properties.
function ESmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ESmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function EWrMax_Callback(hObject, eventdata, handles)
% hObject    handle to EWrMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EWrMax as text
%        str2double(get(hObject,'String')) returns contents of EWrMax as a double


% --- Executes during object creation, after setting all properties.
function EWrMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EWrMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function EIps_Callback(hObject, eventdata, handles)
% hObject    handle to EIps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EIps as text
%        str2double(get(hObject,'String')) returns contents of EIps as a double


% --- Executes during object creation, after setting all properties.
function EIps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EIps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EIpr_Callback(hObject, eventdata, handles)
% hObject    handle to EIpr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EIpr as text
%        str2double(get(hObject,'String')) returns contents of EIpr as a double


% --- Executes during object creation, after setting all properties.
function EIpr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EIpr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function ETp_Callback(hObject, eventdata, handles)
% hObject    handle to ETp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ETp as text
%        str2double(get(hObject,'String')) returns contents of ETp as a double


% --- Executes during object creation, after setting all properties.
function ETp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ETp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function EZth_Callback(hObject, eventdata, handles)
% hObject    handle to EZth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EZth as text
%        str2double(get(hObject,'String')) returns contents of EZth as a double


% --- Executes during object creation, after setting all properties.
function EZth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EZth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function EVth_Callback(hObject, eventdata, handles)
% hObject    handle to EVth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EVth as text
%        str2double(get(hObject,'String')) returns contents of EVth as a double


% --- Executes during object creation, after setting all properties.
function EVth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EVth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in BClear.
function BClear_Callback(hObject, eventdata, handles)
% hObject    handle to BClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Val=get(handles.TelaPrincipal,'NextPlot');

set(handles.TelaPrincipal,'NextPlot','replace');
plot(handles.TelaPrincipal,0,0,'color','white','LineWidth',2);



function EProva_Callback(hObject, eventdata, handles)
% hObject    handle to EProva (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EProva as text
%        str2double(get(hObject,'String')) returns contents of EProva as a double


% --- Executes during object creation, after setting all properties.
function EProva_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EProva (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in EClose.
function EClose_Callback(hObject, eventdata, handles)
% hObject    handle to EClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%  set(handles.EClose, 'CallBack', 'close(gcf)');
close all



% --- Executes on button press in BMax.
function BMax_Callback(hObject, eventdata, handles)
% hObject    handle to BMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NrTmax=handles.EENrTmax;
Tmax=handles.EETmax;
ii=0:NrTmax;
jj=0:Tmax;
plot(handles.TelaPrincipal,ii,Tmax,'-','color','red','LineWidth',1);
plot(handles.TelaPrincipal,NrTmax,jj,'-','color','red','LineWidth',1);










