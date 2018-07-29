%By Manas ranjan Das%
function varargout = untitled(varargin)
% UNTITLED M-file for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v7.5 01-Dec-2010 02:35:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
freq=str2double(get(handles.edit1,'String'));
er=str2double(get(handles.edit2,'String'));
h=str2double(get(handles.edit3,'String'));
height = h/1000*2.54;   
Width=30.0/(2.0*freq)*sqrt(2.0/(er+1.0))*10;
ereff=(er+1.0)/2.0+(er-1)/(2.0*sqrt(1.0+12.0*height/Width));
dl=0.412*height*((ereff+0.3)*(Width/height+0.264))/((ereff-0.258)*(Width/...
    height+0.8));
lamda=30.0/(freq*sqrt(ereff));
lamda0=30.0/freq;
Leff=lamda/2;
L=Leff-2*dl;
Length = L*10;
k0=2*pi*freq/30;
phi1=0:360;
theta1=0:180;
phi=phi1./180.*pi;
theta=theta1./180.*pi;
 

Rr=120*lamda0/(1-k0^2*height^2/24);
Radiation_resistance = Rr;

set(handles.text4,'String',Length);
set(handles.text5,'String',Width);
set(handles.text11,'String',Radiation_resistance);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Radiation patterns
% Plotting of radiation patterns on polar and rectangular co-ordinate  system
 
 
% Calculating the normalized field values for polar plot
Etheta=sin(k0*height/2.*cos(theta)).*cos(k0*L/2.*cos(theta))/k0/height*...
    2./cos(theta);
Ethetamax=max(Etheta);
Ethetanor=Etheta./Ethetamax;
 
 
Ephi=sin(k0*Width/2.*cos(phi)).*sin(phi)/k0/Width*2./cos(phi);
Ephimax=max(Ephi);
Ephinor=Ephi./Ephimax;
axes(handles.axes1);
cla;

polar(theta,Ethetanor,'-r')
hold on;
polar(phi,Ephinor,'-b')
title('Radiation plot of E and H plane patterns');
% title('E- and H-plane Patterns of Rectangular Microstrip Antenna',...
%     'fontsize',[12]);
legend('E plane','H plane');

% Space wave, surface wave and gain calculations
 
 
k0d=k0*height;


%Space wave power
Psp = 377*k0^2*k0d^2/3/pi*(1-1/ereff+2/5/ereff^2);
 
 
%Surface wave power
s=sqrt(ereff-1);
k0ds=k0d*s;
alpha0=s*tan(k0ds);
alpha1=-[tan(k0ds)+k0ds/(cos(k0ds))^2];
x0d=ereff^2-alpha1^2;
x0n=-ereff^2+alpha0*alpha1+ereff*sqrt(ereff^2-2*alpha0*alpha1+alpha0^2);
x0 = 1+x0n/x0d;
 
 
Psur = 377*k0^2/4*ereff*(x0^2-1)/[ereff*[1/sqrt(x0^2-1)+sqrt(x0^2-1)/(...
    ereff-x0^2)]+k0d*[1+ereff^2*(x0^2-1)/(ereff-x0^2)]];
 
Efficiency=Psp/(Psp+Psur);
 
Gain=10*log10(Efficiency*2*pi*Leff*Width/lamda0);

set(handles.text14,'String',Efficiency);
set(handles.text15,'String',Gain);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% recessed feedline width
% characteristic impedance
 
x=30*pi/sqrt(er)/50-0.441;
 
if sqrt(er)*50 <= 120
    W0=height*x;
else
    W0=height*(0.85-sqrt(0.6-x));
end 
% Width_of_microstrip_feed=W0;
    
if W0/height <= 1
    Z0=60/sqrt(ereff)*log(8*height/W0+W0/4/height);
else
    Z0=120*pi/sqrt(ereff)*inv(W0/height+1.393+.667*log(W0/height+1.444));
end
% characteristic_Impedance = Z0
set(handles.text17,'String',Z0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called






