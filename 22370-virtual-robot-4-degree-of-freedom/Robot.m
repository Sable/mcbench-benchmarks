function varargout = Robot(varargin)
% ROBOT M-file for Robot.fig
%      ROBOT, by itself, creates a new ROBOT or raises the existing
%      singleton*.
%
%      H = ROBOT returns the handle to a new ROBOT or the handle to
%      the existing singleton*.
%
%      ROBOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROBOT.M with the given input arguments.
%
%      ROBOT('Property','Value',...) creates a new ROBOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Robot_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Robot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help Robot

% Last Modified by GUIDE v2.5 27-May-2007 17:17:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Robot_OpeningFcn, ...
                   'gui_OutputFcn',  @Robot_OutputFcn, ...
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


% --- Executes just before Robot is made visible.
function Robot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Robot (see VARARGIN)

% Choose default command line output for Robot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Robot wait for user response (see UIRESUME)

%global variable for switching specification.jpg
global h; 
h=0;
global p; 
p=1;
%end global

%Intializing and ploting home position of robot
z=get(handles.edit_z,'String');
l1=get(handles.edit_l1,'String');
l2=get(handles.edit_l2,'String');
z=str2double(z);
l1=str2double(l1);
l2=str2double(l2);
xo=[0 0 0 0];
yo=[0 0 0 0];
zo=[0 z z+l1 z+l1+l2];
set(handles.edit_ze,'String',(z+l1+l2));
axes(handles.axes2)
imshow('projsymbol.jpg')
axes(handles.axes1)
grid on;
plot3(xo,yo,zo, 'LineWidth', 8, 'Marker','o'), axis([-z*1.5 z*1.5 -z*1.5 z*1.5 0 z*3]), grid on, xlabel('x'), ylabel('y'), zlabel('z'); 
hold off;
cameratoolbar('NoReset');
%end homepos

% --- Outputs from this function are returned to the command line.
function varargout = Robot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function edit_z_Callback(hObject, eventdata, handles)
% hObject    handle to edit_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_z as text
%        str2double(get(hObject,'String')) returns contents of edit_z as a double
rob_posf;

% --- Executes during object creation, after setting all properties.
function edit_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit_l1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_l1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_l1 as text
%        str2double(get(hObject,'String')) returns contents of edit_l1 as a double
rob_posf;

% --- Executes during object creation, after setting all properties.
function edit_l1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_l1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_l2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_l2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_l2 as text
%        str2double(get(hObject,'String')) returns contents of edit_l2 as a double
rob_posf;

% --- Executes during object creation, after setting all properties.
function edit_l2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_l2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_th1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_th1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_th1 as text
%        str2double(get(hObject,'String')) returns contents of edit_th1 as a double
NewStrTh = get(hObject, 'String');
NewTh = str2double(NewStrTh);
set(handles.slider_th1,'Value',NewTh);
rob_posf;

% --- Executes during object creation, after setting all properties.
function edit_th1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_th1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit_th2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_th2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_th2 as text
%        str2double(get(hObject,'String')) returns contents of edit_th2 as a double
NewStrTh = get(hObject, 'String');
NewTh = str2double(NewStrTh);
set(handles.slider_th2,'Value',NewTh);
rob_posf;

% --- Executes during object creation, after setting all properties.
function edit_th2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_th2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_phi1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_phi1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_phi1 as text
%        str2double(get(hObject,'String')) returns contents of edit_phi1 as a double

NewStrPhi = get(hObject, 'String');
NewPhi = str2double(NewStrPhi);
set(handles.slider_phi1,'Value',NewPhi);
rob_posf;

% --- Executes during object creation, after setting all properties.
function edit_phi1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_phi1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit_phi2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_phi2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_phi2 as text
%        str2double(get(hObject,'String')) returns contents of edit_phi2 as a double
NewStrPhi = get(hObject, 'String');
NewPhi = str2double(NewStrPhi);
set(handles.slider_phi2,'Value',NewPhi);
rob_posf;

% --- Executes during object creation, after setting all properties.
function edit_phi2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_phi2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function slider_th1_Callback(hObject, eventdata, handles)
% hObject    handle to slider_th1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
th = get(hObject, 'Value');
set(handles.edit_th1,'String',th);
rob_posf;


% --- Executes during object creation, after setting all properties.
function slider_th1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_th1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on slider movement.
function slider_th2_Callback(hObject, eventdata, handles)
% hObject    handle to slider_th2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
th = get(hObject, 'Value');
set(handles.edit_th2,'String',th);
rob_posf;

% --- Executes during object creation, after setting all properties.
function slider_th2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_th2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on slider movement.
function slider_phi1_Callback(hObject, eventdata, handles)
% hObject    handle to slider_phi1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
phi = get(hObject, 'Value');
set(handles.edit_phi1,'String',phi);
rob_posf;

% --- Executes during object creation, after setting all properties.
function slider_phi1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_phi1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on slider movement.
function slider_phi2_Callback(hObject, eventdata, handles)
% hObject    handle to slider_phi2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
phi = get(hObject, 'Value');
set(handles.edit_phi2,'String',phi);
rob_posf;


% --- Executes during object creation, after setting all properties.
function slider_phi2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_phi2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in button_example.
function button_example_Callback(hObject, eventdata, handles)
% hObject    handle to button_example (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h;
if h~=0
    rob_posf;
    h=0;
else
    imshow('Specification.jpg');
    h=1;
end

% --- Executes on button press in button_workvol.
function button_workvol_Callback(hObject, eventdata, handles)
% hObject    handle to button_workvol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global p;
if p~=0
    handles = guidata(gcbo);
    z=get(handles.edit_z,'String');
    z=str2double(z);
    l1=get(handles.edit_l1,'String');
    l1=str2double(l1);
    l2=get(handles.edit_l2,'String');
    l2=str2double(l2);

    %Calculating and ploting work volume
    wth1=0:5:360;
    wphi1=wth1;
    lt=length(wth1);

    xw3=zeros(1,lt*lt);
    yw3=zeros(1,lt*lt);
    zw3=zeros(1,lt*lt);

    xt3=zeros(1,lt);
    yt3=zeros(1,lt);
    zt3=zeros(1,lt);

    for i=1:lt
        for j=1:lt
            x2=l1*sin(wphi1(i)*pi/180).*cos(wth1(j)*pi/180);
            y2=l1*sin(wphi1(i)*pi/180).*sin(wth1(j)*pi/180);
            z2=z+l1*cos(wphi1(i)*pi/180);
            xt3(j)=x2+l2*sin(wphi1(i)*pi/180).*cos(wth1(j)*pi/180);
            yt3(j)=y2+l2*sin(wphi1(i)*pi/180).*sin(wth1(j)*pi/180);
            zt3(j)=z2+l2*cos(wphi1(i)*pi/180);
        end
        x3(i*lt-(lt-1):lt*i)=xt3;
        y3(i*lt-(lt-1):lt*i)=yt3;
        z3(i*lt-(lt-1):lt*i)=zt3;
    end
    rob_posf;
    hold on
    plot3(x3,y3,z3, 'Color', [.8 .8 .8]), axis([-z*1.5 z*1.5 -z*1.5 z*1.5 0 z*3]), grid on, xlabel('x'), ylabel('y'), zlabel('z');
    hold off
     ;
    %end workvolume
    p=0;
else
    rob_posf;
    p=1;
end

% --- Executes on button press in button_rotate.
function button_rotate_Callback(hObject, eventdata, handles)
% hObject    handle to button_rotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rotate3d(handles.axes1);

function rob_posf()
%This function fetches edit box of all values and plots robot and shadow
%after computation
handles = guidata(gcbo);
%Data fetch
z=get(handles.edit_z,'String');
z=str2double(z);
l1=get(handles.edit_l1,'String');
l1=str2double(l1);
th1=get(handles.edit_th1,'String');
th1=str2double(th1);
phi1=get(handles.edit_phi1,'String');
phi1=str2double(phi1);
l2=get(handles.edit_l2,'String');
l2=str2double(l2);
th2=get(handles.edit_th2,'String');
th2=str2double(th2);
phi2=get(handles.edit_phi2,'String');
phi2=str2double(phi2);
%Computing part
x1=0;
y1=0;
z1=z;

x2=l1*sin(phi1*pi/180)*cos(th1*pi/180);
y2=l1*sin(phi1*pi/180)*sin(th1*pi/180);
z2=z+l1*cos(phi1*pi/180);

x3=x2+l2*sin(phi2*pi/180)*cos((th1+th2)*pi/180);
y3=y2+l2*sin(phi2*pi/180)*sin((th1+th2)*pi/180);
z3=z2+l2*cos(phi2*pi/180);

xo=[0 x1 x2 x3];
yo=[0 y1 y2 y3];
zo=[0 z1 z2 z3];
%Ploting shadow first and overlaping robot over it
axes(handles.axes1)
plot3(xo,yo,[0 0 0 0], 'LineWidth', 8, 'Marker','o', 'Color', [.8 .8 .8]), axis([-z*1.5 z*1.5 -z*1.5 z*1.5 0 z*3]), grid on, xlabel('x'), ylabel('y'), zlabel('z'); 
hold on
plot3(xo,[z*1.5 z*1.5 z*1.5 z*1.5],zo, 'LineWidth', 8, 'Marker','o', 'Color', [.8 .8 .8]), axis([-z*1.5 z*1.5 -z*1.5 z*1.5 0 z*3]), grid on, xlabel('x'), ylabel('y'), zlabel('z'); 
plot3([z*1.5 z*1.5 z*1.5 z*1.5],yo,zo, 'LineWidth', 8, 'Marker','o', 'Color', [.8 .8 .8]), axis([-z*1.5 z*1.5 -z*1.5 z*1.5 0 z*3]), grid on, xlabel('x'), ylabel('y'), zlabel('z'); 
plot3(xo,yo,zo, 'LineWidth', 8, 'Marker','o'), axis([-z*1.5 z*1.5 -z*1.5 z*1.5 0 z*3]), grid on, xlabel('x'), ylabel('y'), zlabel('z'); 
hold off
set(handles.edit_xe,'String',x3);
set(handles.edit_ye,'String',y3);
set(handles.edit_ze,'String',z3);


function rob_posi()
%This function fetches edit box of all values and plots robot and shadow
%after computation
handles = guidata(gcbo);
%Data fetch
xe=get(handles.edit_xe,'String');
xe=str2double(xe);
ye=get(handles.edit_ye,'String');
ye=str2double(ye);
ze=get(handles.edit_ze,'String');
ze=str2double(ze);
z=get(handles.edit_z,'String');
z=str2double(z);
l1=get(handles.edit_l1,'String');
l1=str2double(l1);
l2=get(handles.edit_l2,'String');
l2=str2double(l2);
ze=ze-z;
th2=acos((xe^2+ze^2-l1^2-l2^2)/(2*l1*l2));
th1=atan((ze*l1+ze*l2*cos(th2)-xe*l2*sin(th2))/(xe*l1+xe*l2*cos(th2)+ze*l2*sin(th2)))
th1=180*th1/pi;
th2=180*th2/pi;
;
function edit_xe_Callback(hObject, eventdata, handles)
% hObject    handle to edit_xe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_xe as text
%        str2double(get(hObject,'String')) returns contents of edit_xe as a double
rob_posi;

% --- Executes during object creation, after setting all properties.
function edit_xe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_xe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_ye_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ye as text
%        str2double(get(hObject,'String')) returns contents of edit_ye as a double
rob_posi;

% --- Executes during object creation, after setting all properties.
function edit_ye_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_ze_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ze as text
%        str2double(get(hObject,'String')) returns contents of edit_ze as a double
rob_posi;

% --- Executes during object creation, after setting all properties.
function edit_ze_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



