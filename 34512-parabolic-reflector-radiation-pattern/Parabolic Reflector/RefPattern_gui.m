%---------------------------------------------------------------------------------
%  This program plots the radaition pattern of a reflector antenna feeding 
%  with half wave dipole. The radiation pattern is given by:  
%  
%  In E-plane (phi=0):

%    E(theta) =[1+cos(theta)]*[fA - fB]

%  In H-plane (phi=pi/2):

%    E(theta) =[1+cos(theta)]*[fA + fB]

% Where:

%    FA(psi,theta)=[1+cos(psi)]*J0[(4*pi*f/Lmda)*tan(psi/2)*sin(theta)]*tan(psi/2);
%    FB(psi,theta)=[1-cos(psi)]*J2[(4*pi*f/Lmda)*tan(psi/2)*sin(theta)]*tan(psi/2);        
%    fA = integral[0,psi0]FA dpsi
%    fB = integral[0,psi0]FB dpsi
%
%   By: Prof. Dr. Hussein Ghouz
%---------------------------------------------------------------------------------

function varargout = RefPattern_gui(varargin)
% REFPATTERN_GUI M-file for RefPattern_gui.fig
%      REFPATTERN_GUI, by itself, creates a new REFPATTERN_GUI or raises the existing
%      singleton*.
%
%      H = REFPATTERN_GUI returns the handle to a new REFPATTERN_GUI or the handle to
%      the existing singleton*.
%
%      REFPATTERN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REFPATTERN_GUI.M with the given input arguments.
%
%      REFPATTERN_GUI('Property','Value',...) creates a new REFPATTERN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RefPattern_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RefPattern_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RefPattern_gui

% Last Modified by GUIDE v2.5 08-Jan-2012 23:15:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RefPattern_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @RefPattern_gui_OutputFcn, ...
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


% --- Executes just before RefPattern_gui is made visible.
function RefPattern_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RefPattern_gui (see VARARGIN)

% Choose default command line output for RefPattern_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RefPattern_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RefPattern_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_fo_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fo as text
%        str2double(get(hObject,'String')) returns contents of edit_fo as a double


% --- Executes during object creation, after setting all properties.
function edit_fo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_f_Callback(hObject, eventdata, handles)
% hObject    handle to edit_f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_f as text
%        str2double(get(hObject,'String')) returns contents of edit_f as a double


% --- Executes during object creation, after setting all properties.
function edit_f_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_d_Callback(hObject, eventdata, handles)
% hObject    handle to edit_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_d as text
%        str2double(get(hObject,'String')) returns contents of edit_d as a double


% --- Executes during object creation, after setting all properties.
function edit_d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_plot.
function pushbutton_plot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clc

Fo=str2num(get(handles.edit_fo,'string'));
f=str2num(get(handles.edit_f,'string'));
d=str2num(get(handles.edit_d,'string'));

Lmda = (3*1e+010)/(Fo*1e+09);
%-------------------- Reflector Parameters  -----------------------
N=628;
psi0=2*acot(4*f/d);
%---------- Lagendre Coefficients of Integrals  ---------
ab=linspace(0,psi0,2);
[w,psi]=quadrs(ab);
y=cos(psi);
t=tan(psi/2);
thet=-pi;
%----------- Radiation Pattern Calculations --------------
for JJ=1:N
             theta(JJ)=thet;
          c =( abs( 1 + cos(theta(JJ)) ) )^2;
       z =(4*pi*f/Lmda)*sin(theta(JJ));
    FA =(1 + y).*besselj(0,z*t).*t;
       FB =(1 - y).*besselj(2,z*t).*t;
         fA = w'*FA;
            fB = w'*FB;
    UE(JJ)= c*((fA-fB)^2);
    UH(JJ)= c*((fA+fB)^2);
    thet=thet+0.01;
end
%-----------  Normalization And dB values  ----------------
Uemax=max(UE);
Uhmax=max(UH);
UE=UE/Uemax;
UH=UH/Uhmax;
for JJ=1:N
    if abs(UE(JJ))> 0.0
        UE1(JJ)=10*log10( abs(UE(JJ)));
        UE2(JJ)=10*log10( abs(UE(JJ)));
    else
        UE1(JJ)= -50.0;
        UE2(JJ)=UE1(JJ);
    end
    if abs(UH(JJ))> 0.0
        UH1(JJ)=10*log10( abs(UH(JJ)));
        UH2(JJ)=10*log10( abs(UH(JJ)));
    else
        UH1(JJ)= -50.0;
        UH2(JJ)=UH1(JJ);
    end
end

for JJ=1:N
    if abs (UE2(JJ))>=40.0
        UE2(JJ)=-40;
    end
    if abs (UH2(JJ))>=40.0
        UH2(JJ)=-40;
    end    
end
UE2=UE2+40;
UH2=UH2+40;

axes(handles.axes1)
plot(theta*(180/pi),UE1,'r',theta*(180/pi),UH1,'b')
title('Normalized radiation pattern in dB')  % Cartesian
xlabel('Elevation angle in degree')
ylabel('Normalized pattern in dB')
axis([-180 180 -40  0])
grid

axes(handles.axes2)
polar(theta,UE2,'r')
title('E-plane Normalized radiation pattern in dB')  % Polar 
ylabel('Normalized pattern in dB')
grid

axes(handles.axes3)
polar(theta,UH2,'b')
title('H-Plane Normalized radiation pattern in dB')   
ylabel('Normalized pattern in dB')
grid

clear all


