function varargout = Isotropic_Arraye_Antenna(varargin)
% ISOTROPIC_ARRAYE_ANTENNA M-file for Isotropic_Arraye_Antenna.fig
%      ISOTROPIC_ARRAYE_ANTENNA, by itself, creates a new ISOTROPIC_ARRAYE_ANTENNA or raises the existing
%      singleton*.
%
%      H = ISOTROPIC_ARRAYE_ANTENNA returns the handle to a new ISOTROPIC_ARRAYE_ANTENNA or the handle to
%      the existing singleton*.
%
%      ISOTROPIC_ARRAYE_ANTENNA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ISOTROPIC_ARRAYE_ANTENNA.M with the given input arguments.
%
%      ISOTROPIC_ARRAYE_ANTENNA('Property','Value',...) creates a new ISOTROPIC_ARRAYE_ANTENNA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Isotropic_Arraye_Antenna_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Isotropic_Arraye_Antenna_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help Isotropic_Arraye_Antenna
% Last Modified by GUIDE v2.5 01-Jan-2011 12:42:00
% Begin initialization code - DO NOT EDIT
%%%________________________________________________________________________
%%%_____        DESIGNED AND PROGRAMMED BY SALAHEDDIN HOSSEINZADEH. %%%%%
%%%_____________             ANTENNA COURSE DR.A.GHAEDI      ______________

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Isotropic_Arraye_Antenna_OpeningFcn, ...
                   'gui_OutputFcn',  @Isotropic_Arraye_Antenna_OutputFcn, ...
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


% --- Executes just before Isotropic_Arraye_Antenna is made visible.
function Isotropic_Arraye_Antenna_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Isotropic_Arraye_Antenna (see VARARGIN)

% Choose default command line output for Isotropic_Arraye_Antenna
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global phi;
global theta;
global d; %spaceshift , distance between the elements
global elemNum;
phi = linspace(0,2*pi,900);
theta = linspace(0,pi,900);


% UIWAIT makes Isotropic_Arraye_Antenna wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Isotropic_Arraye_Antenna_OutputFcn(hObject, eventdata, handles) 
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
global elemNum;
% Hints: get(hObject,'String') returns contents of edit1 as text
elemNum = floor(str2double(get(hObject,'String')));% returns contents of edit1 as a double


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
global d;
% Hints: get(hObject,'String') returns contents of edit2 as text
d = str2double(get(hObject,'String'));% returns contents of edit2 as a double


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
global phase;
%phase = str2double(get(hObject,'String'))% returns contents of edit3 as a double
phase = str2num(get(hObject,'String'));
phase = phase .*pi./180;

% THIS EDIT BOX IS FOR PHASESHIFT WICH IS NOT ACTIVATED AT THE MOMENT.
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


% --- Executes on button press in pushbutton1. % MESH
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global phi;
global theta;
global d;
global elemNum;
global phase;
[Phi,Theta]=meshgrid(phi,theta);
Bd = 2*pi*d;
%phase=0;
psi = inline('Bd.*cos(Theta)+(phase)','Theta','phase','Bd');
AF=1/elemNum.*sin(elemNum.*psi(Theta,phase,Bd)./2)./sin(psi(Theta,phase,Bd)./2);
 x =AF.*cos(Phi).*sin(Theta);
 y =AF.*sin(Phi).*sin(Theta);
 z =AF.*cos(Theta);
figure('Name','Isotropic Array Antenna 3D Pattern.')
mesh(x,y,z)
title('Isotropic Array Antenna 3D Pattern.');
xlabel('Axis X');
ylabel('Axis Y');
zlabel('Axis Z');

% --- Executes on button press in pushbutton3. % POLAR
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global phi;

%global theta;
global d;
global elemNum;
global phase;
Bd = 2*pi*d;
%phase=0;
psi = inline('Bd.*cos(phi)+(phase)','phi','phase','Bd');
af=1/elemNum.*sin(elemNum.*psi(phi,phase,Bd)./2)./sin(psi(phi,phase,Bd)./2);
figure('Name','Isotropic Array Antenna 2D Polar Pattern.');
polar(phi,af);
title('Isotropic Array Antenna 2D Polar Pattern.');
xlabel('Axis X');
ylabel('Axis Y');
zlabel('Axis Z');
