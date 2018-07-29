function varargout = URBANPATHLOSSMODELS(varargin)
%% GUI Developed By Mansi S. and Gajanan B.
%%
% URBANPATHLOSSMODELS M-file for URBANPATHLOSSMODELS.fig
%      URBANPATHLOSSMODELS, by itself, creates a new URBANPATHLOSSMODELS or raises the existing
%      singleton*.
%
%      H = URBANPATHLOSSMODELS returns the handle to a new URBANPATHLOSSMODELS or the handle to
%      the existing singleton*.
%
%      URBANPATHLOSSMODELS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in URBANPATHLOSSMODELS.M with the given input arguments.
%
%      URBANPATHLOSSMODELS('Property','Value',...) creates a new URBANPATHLOSSMODELS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before URBANPATHLOSSMODELS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to URBANPATHLOSSMODELS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help URBANPATHLOSSMODELS

% Last Modified by GUIDE v2.5 05-Apr-2011 11:44:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @URBANPATHLOSSMODELS_OpeningFcn, ...
                   'gui_OutputFcn',  @URBANPATHLOSSMODELS_OutputFcn, ...
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


% --- Executes just before URBANPATHLOSSMODELS is made visible.
function URBANPATHLOSSMODELS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to URBANPATHLOSSMODELS (see VARARGIN)

% Choose default command line output for URBANPATHLOSSMODELS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes URBANPATHLOSSMODELS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = URBANPATHLOSSMODELS_OutputFcn(hObject, eventdata, handles) 
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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Free Space Model Simulation
% clear figure;
Dist=get(handles.edit1,'string');% Get Distance in Km
Dist= str2num(Dist);
Dist_m=Dist*1000;              % Convert it into meters
Dist_Log_Km= log10(Dist);       % Distance in Log Scale (for Km)
Dist_Log_Meter=log10(Dist_m);   % Distance in Log Scale (FOr meters)
% disp(Dist)
% disp(Dist_m)
% disp(Dist_Log_Km)
% disp(Dist_Log_Meter)
c=3*1e8;   
Freq=get(handles.edit2,'string'); % Get Carrier Frequency in MHz
Freq= str2num(Freq);
% disp(Freq)
lamda=c/(Freq*1e6);             % Calculate Wavelength
% disp(lamda)
TX_Ht=get(handles.edit3,'string'); % Get Carrier Frequency in MHz
TX_Ht= str2num(TX_Ht);
% disp(TX_Ht)
RX_Ht=get(handles.edit4,'string'); % Get Carrier Frequency in MHz
RX_Ht= str2num(RX_Ht);
% disp(RX_Ht)
% The Path Loss for the free space when the antennas are unity gain is given by,

FreeSpace=10*log10((Dist_m*pi*4).^2/lamda^2); 

% disp(FreeSpace)
axes(handles.axes1);
handles.axes1=min(Dist_Log_Km):max(Dist_Log_Km);
plot(Dist_Log_Km,FreeSpace,'g-*');
% Equation (4.6) From "Wireless COmmunication, Principles and Practice" By Theodore Rappaport 

title('Pathloss prediction by Free space model for Urban Area');
xlabel('Distance log10(d)');
ylabel('Path loss (dB)');
legend('Free Space Loss');
% hold on
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Okumura Model
% clear figure;
Dist=get(handles.edit1,'string');% Get Distance in Km
Dist= str2num(Dist);
Dist_m=Dist*1000;              % Convert it into meters
Dist_Log_Km= log10(Dist);       % Distance in Log Scale (for Km)
Dist_Log_Meter=log10(Dist_m);   % Distance in Log Scale (FOr meters)
% disp(Dist)
% disp(Dist_m)
% disp(Dist_Log_Km)
% disp(Dist_Log_Meter)
c=3*1e8;   
Freq=get(handles.edit2,'string'); % Get Carrier Frequency in MHz
Freq= str2num(Freq);
% disp(Freq)
lamda=c/(Freq*1e6);             % Calculate Wavelength
% disp(lamda)
TX_Ht=get(handles.edit3,'string'); % Get Carrier Frequency in MHz
TX_Ht= str2num(TX_Ht);
% disp(TX_Ht)
RX_Ht=get(handles.edit4,'string'); % Get Carrier Frequency in MHz
RX_Ht= str2num(RX_Ht);

OKU_LOSS=20*log10(lamda^2/(4*pi)^2*Dist_m)+5-20*log10(TX_Ht/200)-10*log10(RX_Ht/3)-9;
% Okumura Loss Model Equation
axes(handles.axes1);
handles.axes1=min(Dist_Log_Km):max(Dist_Log_Km);
plot(Dist_Log_Km,OKU_LOSS,'-*');
% Equation (4.6) From "Wireless COmmunication, Principles and Practice" By Theodore Rappaport 

title('Pathloss prediction by Okumura model for Urban Area');
xlabel('Distance log10(d)');
ylabel('Path loss (dB)');
legend('Okumura Model');
% hold on
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% HATA's model:
Dist=get(handles.edit1,'string');% Get Distance in Km
Dist= str2num(Dist);
Dist_m=Dist*1000;              % Convert it into meters
Dist_Log_Km= log10(Dist);       % Distance in Log Scale (for Km)
Dist_Log_Meter=log10(Dist_m);   % Distance in Log Scale (FOr meters)
% disp(Dist)
% disp(Dist_m)
% disp(Dist_Log_Km)
% disp(Dist_Log_Meter)
c=3*1e8;   
Freq=get(handles.edit2,'string'); % Get Carrier Frequency in MHz
Freq= str2num(Freq);
% disp(Freq)
lamda=c/(Freq*1e6);             % Calculate Wavelength
% disp(lamda)
TX_Ht=get(handles.edit3,'string'); % Get Carrier Frequency in MHz
TX_Ht= str2num(TX_Ht);
% disp(TX_Ht)
RX_Ht=get(handles.edit4,'string'); % Get Carrier Frequency in MHz
RX_Ht= str2num(RX_Ht);

% Hata Model Equation
PAR_H=3.2*((log10(11.75*RX_Ht))^2)-4.97;
Hata_MOD=69.55+26.16*log10(Freq)-13.82*log10(TX_Ht)-PAR_H+((44.9-6.55*log10(TX_Ht)))*(Dist_Log_Km);

axes(handles.axes1);
handles.axes1=min(Dist_Log_Km):max(Dist_Log_Km);
plot(Dist_Log_Km,Hata_MOD,'r-*');
% Equation (4.6) From "Wireless COmmunication, Principles and Practice" By Theodore Rappaport 

title('Pathloss prediction by Hata model for Urban Area');
xlabel('Distance log10(d)');
ylabel('Path loss (dB)');
legend('Hata Model');
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Dist=get(handles.edit1,'string');% Get Distance in Km
Dist= str2num(Dist);
Dist_m=Dist*1000;              % Convert it into meters
Dist_Log_Km= log10(Dist);       % Distance in Log Scale (for Km)
Dist_Log_Meter=log10(Dist_m);   % Distance in Log Scale (FOr meters)
% disp(Dist)
% disp(Dist_m)
% disp(Dist_Log_Km)
% disp(Dist_Log_Meter)
c=3*1e8;   
Freq=get(handles.edit2,'string'); % Get Carrier Frequency in MHz
Freq= str2num(Freq);
% disp(Freq)
lamda=c/(Freq*1e6);             % Calculate Wavelength
% disp(lamda)
TX_Ht=get(handles.edit3,'string'); % Get Carrier Frequency in MHz
TX_Ht= str2num(TX_Ht);
% disp(TX_Ht)
RX_Ht=get(handles.edit4,'string'); % Get Carrier Frequency in MHz
RX_Ht= str2num(RX_Ht);

% Lee's Urnab Model for Philadenphia,Newark and Tokyo cities
ALPH1=(TX_Ht/30.48)^2;
ALPH2=(RX_Ht/3);
ALPH3=1;
ALPH4=10^(6/40); % Base Statino antenna gain is 6/4 dB corresponding to 10^(6/40) actual value
ALPH5=0.25; % alpha5=-6dB corresponding to 0.25 actual value

ALPH0=ALPH1*ALPH2*ALPH3*ALPH4*ALPH5;

Lee_Philadenphia=108.49+36.8*(log10(Dist_Log_Km/1.6))+10*3*log10(Freq/900)-ALPH0;

Lee_Newark=101.20+43.1*(log10(Dist_Log_Km/1.6))+10*3*log10(Freq/900)-ALPH0;

Lee_Tokyo=123.77+30.5*(log10(Dist_Log_Km/1.6))+10*3*log10(Freq/900)-ALPH0;

axes(handles.axes1);
handles.axes1=min(Dist_Log_Km):max(Dist_Log_Km);
plot(Dist_Log_Km,Lee_Philadenphia,'r-*');
hold on;

plot(Dist_Log_Km,Lee_Newark,'g-*');
hold on;

plot(Dist_Log_Km,Lee_Tokyo,'b-*');
hold off;

title('Pathloss prediction by Lee model for Urban Area');
xlabel('Distance log10(d)');
ylabel('Path loss (dB)');
legend('Lee Philadenphia','Lee Newark','Lee Tokyo');



% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
