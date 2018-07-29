function varargout = Phasors(varargin)
% PHASORS M-file for Phasors.fig
%      PHASORS, by itself, creates a new PHASORS or raises the existing
%      singleton*.
%
%      H = PHASORS returns the handle to a new PHASORS or the handle to
%      the existing singleton*.
%
%      PHASORS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PHASORS.M with the given input arguments.
%
%      PHASORS('Property','Value',...) creates a new PHASORS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Phasors_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Phasors_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Phasors

% Last Modified by GUIDE v2.5 14-May-2003 18:50:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Phasors_OpeningFcn, ...
    'gui_OutputFcn',  @Phasors_OutputFcn, ...
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


% --- Executes just before Phasors is made visible.
function Phasors_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Phasors (see VARARGIN)

% Choose default command line output for Phasors
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
DrawStatic(handles);
set(handles.PauseToggle,'Value',get(handles.PauseToggle,'Min'));
set(handles.PauseToggle,'String','Pause');
set(handles.HaltToggle,'Value',get(handles.HaltToggle,'Min'));
axes(handles.RotatingPhasor);
cla;
axes(handles.TimePhasor);
cla;



% UIWAIT makes Phasors wait for user response (see UIRESUME)
% uiwait(handles.PhasorView);


% --- Outputs from this function are returned to the command line.
function varargout = Phasors_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function Frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Frequency_Callback(hObject, eventdata, handles)
% hObject    handle to Frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Frequency as text
%        str2double(get(hObject,'String')) returns contents of Frequency as a double
x= str2double(get(hObject,'String'));
if ((x<0.1) | (x>1)),
    warndlg('Frequency of phasor must be between 0.1 and 1.  Frequency set to 0.5','Input Error')
    set(hObject,'String','0.5');
end


% --- Executes on button press in halt.
function halt_Callback(hObject, eventdata, handles)
% hObject    handle to halt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Halt.
function Halt_Callback(hObject, eventdata, handles)
% hObject    handle to Halt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.DoHalt=1;
guidata(handles.PhasorView, handles);  %save changes to handles.


% --- Executes on button press in WebButton.
function WebButton_Callback(hObject, eventdata, handles)
% hObject    handle to WebButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web('http://www.swarthmore.edu/NatSci/echeeve1/Ref/phasors/phasors.html','-browser')


% --- Executes during object creation, after setting all properties.
function ZPhase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZPhase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ZPhase_Callback(hObject, eventdata, handles)
% hObject    handle to ZPhase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ZPhase as text
%        str2double(get(hObject,'String')) returns contents of ZPhase as a double



% --- Executes during object creation, after setting all properties.
function IPhase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IPhase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function IPhase_Callback(hObject, eventdata, handles)
% hObject    handle to IPhase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IPhase as text
%        str2double(get(hObject,'String')) returns contents of IPhase as a double

% --- Executes during object creation, after setting all properties.
function VPhase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VPhase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function VPhase_Callback(hObject, eventdata, handles)
% hObject    handle to VPhase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VPhase as text
%        str2double(get(hObject,'String')) returns contents of VPhase as a double


% --- Executes during object creation, after setting all properties.
function VMag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VMag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function VMag_Callback(hObject, eventdata, handles)
% hObject    handle to VMag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VMag as text
%        str2double(get(hObject,'String')) returns contents of VMag as a double
x= str2double(get(hObject,'String'));
if (x==0),
    warndlg('Amplitude of phasor may not be zero.  Amplitude set to 1.0','Input Error')
    set(hObject,'String','1.0');
end



% --- Executes during object creation, after setting all properties.
function IMag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IMag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function IMag_Callback(hObject, eventdata, handles)
% hObject    handle to IMag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IMag as text
%        str2double(get(hObject,'String')) returns contents of IMag as a double
x= str2double(get(hObject,'String'));
if (x==0),
    warndlg('Amplitude of phasor may not be zero.  Amplitude set to 1.0','Input Error')
    set(hObject,'String','1.0');
end


% --- Executes during object creation, after setting all properties.
function ZMag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZMag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
x= str2double(get(hObject,'String'));
if (x==0),
    warndlg('Amplitude of phasor may not be zero.  Amplitude set to 1.0','Input Error')
    set(hObject,'String','1.0');
end



function ZMag_Callback(hObject, eventdata, handles)
% hObject    handle to ZMag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ZMag as text
%        str2double(get(hObject,'String')) returns contents of ZMag as a double


% --- Executes on button press in CalcI.
function CalcI_Callback(hObject, eventdata, handles)
% hObject    handle to CalcI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
VMag=str2double(get(handles.VMag,'String'));
VPhase=str2double(get(handles.VPhase,'String'));
ZMag=str2double(get(handles.ZMag,'String'));
ZPhase=str2double(get(handles.ZPhase,'String'));
IMag=VMag/ZMag;
IPhase=VPhase-ZPhase;
set(handles.IMag,'String',num2str(IMag));
set(handles.IPhase,'String',num2str(IPhase));
DrawStatic(handles);
DrawRotating(handles);


% --- Executes on button press in CalcZ.
function CalcZ_Callback(hObject, eventdata, handles)
% hObject    handle to CalcZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
IMag=str2double(get(handles.IMag,'String'));
IPhase=str2double(get(handles.IPhase,'String'));
VMag=str2double(get(handles.VMag,'String'));
VPhase=str2double(get(handles.VPhase,'String'));
ZMag=VMag/IMag;
ZPhase=VPhase-IPhase;
set(handles.ZMag,'String',num2str(ZMag));
set(handles.ZPhase,'String',num2str(ZPhase));
DrawStatic(handles);
DrawRotating(handles);

% --- Executes on button press in CalcV.
function CalcV_Callback(hObject, eventdata, handles)
% hObject    handle to CalcV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
IMag=str2double(get(handles.IMag,'String'));
IPhase=str2double(get(handles.IPhase,'String'));
ZMag=str2double(get(handles.ZMag,'String'));
ZPhase=str2double(get(handles.ZPhase,'String'));
VMag=IMag*ZMag;
VPhase=IPhase+ZPhase;
set(handles.VMag,'String',num2str(VMag));
set(handles.VPhase,'String',num2str(VPhase));
DrawStatic(handles);
DrawRotating(handles);

function DrawStatic(handles);
IMag=str2double(get(handles.IMag,'String'));
IPhase=str2double(get(handles.IPhase,'String'))*pi/180;
ZMag=str2double(get(handles.ZMag,'String'));
ZPhase=str2double(get(handles.ZPhase,'String'))*pi/180;
VMag=str2double(get(handles.VMag,'String'));
VPhase=str2double(get(handles.VPhase,'String'))*pi/180;
axes(handles.StaticPhasor);
cla;
Gmax=max(max(VMag,ZMag),IMag);
axis(Gmax*[-1 1 -1 1]);
plotArrow(IMag,IPhase,'b');
plotArrow(ZMag,ZPhase,'m');
plotArrow(VMag,VPhase,'r');


%Draw an Arrowhead and a small circle to show the x-axis intercept).
function plotArrow(A,phi,c)
hold on
%Define Arrow.
x=[0 A A-0.2 A A-0.2]';
y=[0 0 0.2 0 -0.2]';
%Rotate Arrow.
x1=x*cos(phi)-y*sin(phi);
y1=x*sin(phi)+y*cos(phi);
%Plot Arrow.
plot(x1,y1,c,'LineWidth',2)

%Define small circle and plot it on x axis.
theta=0:pi/4:2*pi;
xp=A*cos(phi)+0.1*cos(theta);
yp=0.1*sin(theta);
fill(xp,yp,c,'EdgeColor',c);

%Draw dotted circle to show magnitude of error.
theta=0:0.1:2*pi;
plot(A*cos(theta),A*sin(theta),strvcat(c,':'));


function DrawRotating(handles)
IMag=str2double(get(handles.IMag,'String'));
IPhase=str2double(get(handles.IPhase,'String'))*pi/180;
VMag=str2double(get(handles.VMag,'String'));
VPhase=str2double(get(handles.VPhase,'String'))*pi/180;
ZMag=str2double(get(handles.ZMag,'String'));        %ZMag is needed below for scaling figure.

f=str2double(get(handles.Frequency,'String'));
omega=2*pi*f;

t=0:0.1:10;

set(handles.PauseToggle,'Value',get(handles.PauseToggle,'Min'));
set(handles.PauseToggle,'String','Pause');

theta=0:pi/4:2*pi;
for i=1:length(t),
    axes(handles.RotatingPhasor);
    cla;
    grid on;
    Gmax=max(max(VMag,ZMag),IMag);
    axis(Gmax*[-1 1 -1 1]);
    
    plotArrow(IMag,IPhase+omega*t(i),'b');
    plotArrow(VMag,VPhase+omega*t(i),'r');
    text(-0.8*Gmax, 0.8*Gmax, sprintf('t=%g  ',t(i)));
    
    axes(handles.TimePhasor);
    cla;
    grid on;
    hold on;
    axis([0 10 -Gmax Gmax]);
    x=t(1:i);
    y=IMag*cos(IPhase+omega*x);
    plot(x,y,'b');
    xp=x(end)+0.03*Gmax*cos(theta);
    yp=y(end)+0.04*Gmax*sin(theta);
    fill(xp,yp,'b','EdgeColor','b');
    y=VMag*cos(VPhase+omega*x);
    plot(x,y,'r');
    xp=x(end)+0.03*Gmax*cos(theta);
    yp=y(end)+0.04*Gmax*sin(theta);
    fill(xp,yp,'r','EdgeColor','r');
    xlabel('Time');
    ylabel('Function value');
    handles=guidata(handles.PhasorView);  %Reload handles (may change on halt or pause button).
    while (get(handles.PauseToggle,'Value')==get(handles.PauseToggle,'Max')),
        pause(0.2);
        if (get(handles.HaltToggle,'Value')==get(handles.HaltToggle,'Max')),
            break
        end
    end
    if (get(handles.HaltToggle,'Value')==get(handles.HaltToggle,'Max')),
        break
    end
   
    pause(0.05);
end

set(handles.HaltToggle,'Value',get(handles.HaltToggle,'Min'));
set(handles.PauseToggle,'Value',get(handles.PauseToggle,'Min'));
set(handles.PauseToggle,'String','Pause');



% --- Executes on button press in PauseToggle.
function PauseToggle_Callback(hObject, eventdata, handles)
% hObject    handle to PauseToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PauseToggle
% --- Executes on button press in PauseButton.
beep
if (get(handles.PauseToggle,'Value')==get(handles.PauseToggle,'Max')),
    set(handles.PauseToggle,'String','Continue');
else
    set(handles.PauseToggle,'String','Pause');
end


% --- Executes on button press in HaltToggle.
function HaltToggle_Callback(hObject, eventdata, handles)
% hObject    handle to HaltToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HaltToggle


