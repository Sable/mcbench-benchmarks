function varargout = Simulation(varargin)
% SIMULATION M-file for Simulation.fig
%      SIMULATION, by itself, creates a new SIMULATION or raises the existing
%      singleton*.
%
%      H = SIMULATION returns the handle to a new SIMULATION or the handle to
%      the existing singleton*.
%
%      SIMULATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMULATION.M with the given input arguments.
%
%      SIMULATION('Property','Value',...) creates a new SIMULATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Simulation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Simulation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Simulation

% Last Modified by GUIDE v2.5 25-Oct-2010 01:07:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Simulation_OpeningFcn, ...
                   'gui_OutputFcn',  @Simulation_OutputFcn, ...
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


% --- Executes just before Simulation is made visible.
function Simulation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Simulation (see VARARGIN)

% Choose default command line output for Simulation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Simulation wait for user response (see UIRESUME)
% uiwait(handles.simulationfig);


% --- Outputs from this function are returned to the command line.
function varargout = Simulation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function f0Edit_Callback(hObject, eventdata, handles)
% hObject    handle to f0Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f0Edit as text
%        str2double(get(hObject,'String')) returns contents of f0Edit as a double


% --- Executes during object creation, after setting all properties.
function f0Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f0Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bEdit_Callback(hObject, eventdata, handles)
% hObject    handle to bEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bEdit as text
%        str2double(get(hObject,'String')) returns contents of bEdit as a double


% --- Executes during object creation, after setting all properties.
function bEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on button press in fskpush.
function fskpush_Callback(hObject, eventdata, handles)
% hObject    handle to fskpush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.tsEdit,'string','2');

%===================================================================
freq0 = get(handles.f0Edit,'string');
freq1 = get(handles.f1Edit,'string');
bin = get(handles.bEdit,'string');
amp = get(handles.aEdit,'string');

set(handles.Group,'title',' Frequency-shift keying (FSK) ');

a = str2double(amp);
f0 = str2double(freq0);
f1 = str2double(freq1);
g = str2num(bin);
%======================================================================

%=========================================
z=100;
y=[0:1:(z-1)*length(g)];
cw0=a*sin(2*pi*f0*y/z);
cw1=a*sin(2*pi*f1*y/z);
%=========================================

t=0:2*pi/99:2*pi;
cp=[];sp=[];
mod=[];mod1=[];bit=[];

for n=1:length(g);
    if g(n)==0;
        die=ones(1,100);
        c=a*sin(f0*t);
        
        se=zeros(1,100);
    else g(n)==1;
        die=ones(1,100);
        c=a*sin(f1*t);
        se=ones(1,100);
    end
    cp=[cp die];
    mod=[mod c];
    bit=[bit se];
end

fsk=cp.*mod;
subplot(4,1,1);plot(bit,'LineWidth',1.5);grid on;
title('Binary Signal');
axis([0 100*length(g) -2 2]);

subplot(4,1,2);plot(cw0,'LineWidth',1.5);grid on;
title('FSK Carrier Wave 1 ');
axis([0 100*length(g) -2*a 2*a]);

subplot(4,1,3);plot(cw1,'LineWidth',1.5);grid on;
title('FSK Carrier Wave 2 ');
axis([0 100*length(g) -2*a 2*a]);

subplot(4,1,4);plot(fsk,'LineWidth',1.5);grid on;
title('FSK modulation');
axis([0 100*length(g) -2*a 2*a]);

%#######################################
set(handles.infoE,'visible','off');
set(handles.infoV,'visible','off');


% --- Executes on button press in bpskpush.
function bpskpush_Callback(hObject, eventdata, handles)
% hObject    handle to bpskpush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.tsEdit,'string','5');

%==================================================================
freq0 = get(handles.f0Edit,'string');
%freq1 = get(handles.f1Edit,'string');
bin = get(handles.bEdit,'string');
amp = get(handles.aEdit,'string');

set(handles.Group,'title',' Binary phase-shift keying (BPSK) ');

a = str2double(amp);
f = str2double(freq0);
%f1 = str2double(freq1);
g = str2num(bin);
%==================================================================

%=========================================
z=100;
y=[0:1:(z-1)*length(g)];
cw0=a*sin(2*pi*f*y/z);
%cw1=a*sin(2*pi*f1*y/z);
%=========================================

t=0:2*pi/99:2*pi;
cp=[];sp=[];
mod=[];mod1=[];bit=[];

for n=1:length(g);
    if g(n)==0;
        die=-ones(1,100);   
        se=zeros(1,100);    
    else g(n)==1;
        die=ones(1,100);    
        se=ones(1,100);     
    end
    c=a*sin(f*t);
    cp=[cp die];
    mod=[mod c];
    bit=[bit se];
end

bpsk=cp.*mod;

subplot(3,1,1);plot(bit,'LineWidth',1.5);grid on;
title('Binary Signal');
axis([0 100*length(g) -2 2]);

subplot(3,1,2);plot(cw0,'LineWidth',1.5);grid on;
title('BPSK Carrier Wave');
axis([0 100*length(g) -2*a 2*a]);

subplot(3,1,3);plot(bpsk,'LineWidth',1.5);grid on;
title('BPSK modulation');
axis([0 100*length(g) -2*a 2*a]);


%#######################################
set(handles.infoE,'visible','off');
set(handles.infoV,'visible','off');

% --- Executes on button press in qpskpush.
function qpskpush_Callback(hObject, eventdata, handles)
% hObject    handle to qpskpush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.tsEdit,'string','7');

%==================================================================
freq0 = get(handles.f0Edit,'string');
%freq1 = get(handles.f1Edit,'string');
bin = get(handles.bEdit,'string');
amp = get(handles.aEdit,'string');

set(handles.Group,'title','Quadrature phase-shift keying (QPSK)');

a = str2double(amp);
f = str2double(freq0);
%f1 = str2double(freq1);
g = str2num(bin);
%==================================================================

%=========================================
z=100;
y=[0:1:(z-1)*length(g)];
cw0=a*sin(2*pi*f*y/z);
%cw1=a*sin(2*pi*f1*y/z);
%=========================================

%*-*-*-*-*-*
l=length(g);
r=l/2;
re=ceil(r);
val=re-r;

if val~=0;
    
    set(handles.infoE,'visible','on');
    set(handles.infoV,'visible','on');
    set(handles.infoE,'string','Please insert a vector divisible for 2');
    set(handles.infoV,'string','"Binary String" phaûi coù ñoä daøi chia heát cho 2');
end
%*-*-*-*-*-*

t=0:2*pi/99:2*pi;
cp=[];sp=[];
mod=[];mod1=[];bit=[];
for n=1:2:length(g);
    if g(n)==0 && g(n+1)==1;
        die=-sqrt(2)/2*ones(1,100);
        die1=sqrt(2)/2*ones(1,100);
        se=[zeros(1,50) ones(1,50)];
    elseif g(n)==0 && g(n+1)==0;
        die=-sqrt(2)/2*ones(1,100);
        die1=-sqrt(2)/2*ones(1,100);
        se=[zeros(1,50) zeros(1,50)];
    elseif g(n)==1 && g(n+1)==0;
        die=sqrt(2)/2*ones(1,100);
        die1=-sqrt(2)/2*ones(1,100);
        se=[ones(1,50) zeros(1,50)];
    elseif g(n)==1 && g(n+1)==1;
        die=sqrt(2)/2*ones(1,100);
        die1=sqrt(2)/2*ones(1,100);
        se=[ones(1,50) ones(1,50)];
    end
    c=a*cos(f*t);
    s=a*sin(f*t);
    cp=[cp die];    %Amplitude cosino
    sp=[sp die1];   %Amplitude sino
    mod=[mod c];    %cosino carrier (Q)
    mod1=[mod1 s];  %sino carrier   (I)
    bit=[bit se];
end
bpsk=cp.*mod1+sp.*mod;

subplot(3,1,1);plot(bit,'LineWidth',1.5);grid on;
title('Binary Signal')
axis([0 50*length(g) -2 2]);

subplot(3,1,2);plot(cw0,'LineWidth',1.5);grid on;
title('QPSK Carrier Wave')
axis([0 50*length(g) -2*a 2*a]);

subplot(3,1,3);plot(bpsk,'LineWidth',1.5);grid on;
title('QPSK modulation')
axis([0 50*length(g) -2*a 2*a]);

%#######################################
set(handles.infoE,'visible','off');
set(handles.infoV,'visible','off');


% --- Executes on button press in ookpush.
function ookpush_Callback(hObject, eventdata, handles)
% hObject    handle to ookpush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.tsEdit,'string','3');

%==================================================================
freq0 = get(handles.f0Edit,'string');
%freq1 = get(handles.f1Edit,'string');
bin = get(handles.bEdit,'string');
amp = get(handles.aEdit,'string');

set(handles.Group,'title',' On-Off keying (OOK) ');

a = str2double(amp);
f = str2double(freq0);
%f1 = str2double(freq1);
g = str2num(bin);
%==================================================================

%=========================================
z=100;
y=[0:1:(z-1)*length(g)];
cw0=a*sin(2*pi*f*y/z);
%cw1=a*sin(2*pi*f1*y/z);
%=========================================

t=0:2*pi/99:2*pi;
cp=[];sp=[];
mod=[];mod1=[];bit=[];

for n=1:length(g);
    if g(n)==0;
        die=zeros(1,100);   
        se=zeros(1,100);    
    else g(n)==1;
        die=ones(1,100);    
        se=ones(1,100);     
    end
    c=a*sin(f*t);
    cp=[cp die];
    mod=[mod c];
    bit=[bit se];
end

ook=cp.*mod;
subplot(3,1,1);plot(bit,'LineWidth',1.5);grid on;
title('Binary Signal');
axis([0 100*length(g) -2 2]);

subplot(3,1,2);plot(cw0,'LineWidth',1.5);grid on;
title('OOK Carrier Wave');
axis([0 100*length(g) -2*a 2*a]);


subplot(3,1,3);plot(ook,'LineWidth',1.5);grid on;
title('OOK modulation');
axis([0 100*length(g) -2*a 2*a]);

%#######################################
set(handles.infoE,'visible','off');
set(handles.infoV,'visible','off');


% --- Executes on button press in mpskpush.
function mpskpush_Callback(hObject, eventdata, handles)
% hObject    handle to mpskpush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.tsEdit,'string','4');

%==================================================================
freq0 = get(handles.f0Edit,'string');
%freq1 = get(handles.f1Edit,'string');
bin = get(handles.bEdit,'string');
amp = get(handles.aEdit,'string');

set(handles.Group,'title',' 8-Phase-shift keying (8-PSK)');

a = str2double(amp);
f = str2double(freq0);
%f1 = str2double(freq1);
g = str2num(bin);

%==================================================================

%=========================================
z=150;
y=[0:1:(z-1)*length(g)];
cw0=a*sin(2*pi*f*y/z);
%cw1=a*sin(2*pi*f1*y/z);
%=========================================

%***********************************************************************
if nargin > 2
    set(handles.infoE,'visible','on');
    set(handles.infoV,'visible','on');
    set(handles.infoE,'string','Too many input arguments');
    set(handles.infoV,'string','Doi so vao qua lon');
elseif nargin==1
    f=1;
end

if f<1;
    set(handles.infoE,'visible','on');
    set(handles.infoV,'visible','on');
    set(handles.infoE,'string','Frequency must be bigger than 1');
    set(handles.infoV,'string','Tan so phai lon hon 1');
end
%************************************************************************

l=length(g);
r=l/3;
re=ceil(r);
val=re-r;

if val~=0;
    set(handles.infoE,'visible','on');
    set(handles.infoV,'visible','on');
    set(handles.infoE,'string','Please insert a vector divisible for 3');
    set(handles.infoV,'string',' "Binary String" phaûi coù ñoä daøi chia heát cho 3');
end


t=0:2*pi/149:2*pi;
cp=[];sp=[];
mod=[];mod1=[];bit=[];

for n=1:3:length(g);
    if g(n)==0 && g(n+1)==1 && g(n+2)==1
        die=cos(3*pi/4)*ones(1,150);
        die1=sin(3*pi/4)*ones(1,150);
        se=[zeros(1,50) ones(1,50) ones(1,50)];

    elseif g(n)==0 && g(n+1)==1 && g(n+2)==0
        die=cos(pi/2)*ones(1,150);
        die1=sin(pi/2)*ones(1,150);
        se=[zeros(1,50) ones(1,50) zeros(1,50)];

    elseif g(n)==0 && g(n+1)==0  && g(n+2)==0
        die=cos(5*pi/4)*ones(1,150);
        die1=sin(5*pi/4)*ones(1,150);
        se=[zeros(1,50) zeros(1,50) zeros(1,50)];

    elseif g(n)==0 && g(n+1)==0  && g(n+2)==1
        die=cos(pi)*ones(1,150);
        die1=sin(pi)*ones(1,150);
        se=[zeros(1,50) zeros(1,50) ones(1,50)];

    elseif g(n)==1 && g(n+1)==0  && g(n+2)==1
        die=cos(7*pi/4)*ones(1,150);
        die1=sin(7*pi/4)*ones(1,150);
        se=[ones(1,50) zeros(1,50) ones(1,50)];

    elseif g(n)==1 && g(n+1)==0  && g(n+2)==0
        die=cos(3*pi/2)*ones(1,150);
        die1=sin(3*pi/2)*ones(1,150);
        se=[ones(1,50) zeros(1,50) zeros(1,50)];

    elseif g(n)==1 && g(n+1)==1  && g(n+2)==0
        die=cos(pi/4)*ones(1,150);
        die1=sin(pi/4)*ones(1,150);
        se=[ones(1,50) ones(1,50) zeros(1,50)];

    elseif g(n)==1 && g(n+1)==1  && g(n+2)==1
        die=cos(0)*ones(1,150);
        die1=sin(0)*ones(1,150);
        se=[ones(1,50) ones(1,50) ones(1,50)];

    end
    c=a*cos(f*t);
    s=a*sin(f*t);
    cp=[cp die];    %Amplitude cosino
    sp=[sp die1];  %Amplitude sino
    mod=[mod c];    %cosino carrier (Q)
    mod1=[mod1 s];  %sino carrier   (I)
    bit=[bit se];
end
opsk=cp.*mod1+sp.*mod;
subplot(3,1,1);plot(bit,'LineWidth',1.5);grid on;
title('Binary Signal')
axis([0 50*length(g) -2 2]);

subplot(3,1,2);plot(cw0,'LineWidth',1.5);grid on;
title('8PSK Carrier Wave')
axis([0 50*length(g) -2*a 2*a]);

subplot(3,1,3);plot(opsk,'LineWidth',1.5);grid on;
title('8PSK modulation')
axis([0 50*length(g) -2*a 2*a]);

%#######################################
set(handles.infoE,'visible','off');
set(handles.infoV,'visible','off');
   

function closepush_Callback(hObject, eventdata, handles)
% hObject    handle to closepush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close

% --- Executes on button press in askpush.
function askpush_Callback(hObject, eventdata, handles)
% hObject    handle to askpush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.tsEdit,'string','1');

freq0 = get(handles.f0Edit,'string');
bin = get(handles.bEdit,'string');
amp = get(handles.aEdit,'string');
ampi = get(handles.iEdit,'string');

set(handles.Group,'title',' Amplitude-shift keying (ASK) ');
ai = str2double(ampi);
a = str2double(amp);
f = str2double(freq0);
g = str2num(bin);

%=========================================
z=100;
y=[0:1:(z-1)*length(g)];
cw0=a*sin(2*pi*f*y/z);
%cw1=ai*sin(2*pi*f*y/z);
%=========================================

t=0:2*pi/99:2*pi;
cp=[];sp=[];
mod=[];mod1=[];bit=[];
ni = ai/a;
for n=1:length(g);
    if g(n)==0;
        die=ones(1,100);
        se=zeros(1,100);
    else g(n)==1;
        die=ni*ones(1,100);
        se=ones(1,100);
    end
    c=a*sin(f*t);
    cp=[cp die];
    mod=[mod c];
    bit=[bit se];
end

ask=cp.*mod;

subplot(3,1,1);plot(bit,'LineWidth',1.5);grid on;
title('Binary Signal');
axis([0 100*length(g) -2 2]);

subplot(3,1,2);plot(cw0,'LineWidth',1.5);grid on;
title('ASK Carrier Wave1');
axis([0 100*length(g) -2*a 2*a]);

subplot(3,1,3);plot(ask,'LineWidth',1.5);grid on;
title('ASK modulation');
axis([0 100*length(g) -2*a*ni 2.5*a*ni]);

%#######################################
set(handles.infoE,'visible','off');
set(handles.infoV,'visible','off');



function aEdit_Callback(hObject, eventdata, handles)
% hObject    handle to aEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aEdit as text
%        str2double(get(hObject,'String')) returns contents of aEdit as a double


% --- Executes during object creation, after setting all properties.
function aEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f1Edit_Callback(hObject, eventdata, handles)
% hObject    handle to f1Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f1Edit as text
%        str2double(get(hObject,'String')) returns contents of f1Edit as a double


% --- Executes during object creation, after setting all properties.
function f1Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f1Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in dpskpush.
function dpskpush_Callback(hObject, eventdata, handles)
% hObject    handle to dpskpush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.tsEdit,'string','6');

%==================================================================
freq0 = get(handles.f0Edit,'string');
%freq1 = get(handles.f1Edit,'string');
bin = get(handles.bEdit,'string');
amp = get(handles.aEdit,'string');

set(handles.Group,'title',' Differential phase-shift keying (DPSK)');

amp = str2double(amp);
f1 = str2double(freq0);
%f1 = str2double(freq1);
g = str2num(bin);
%==================================================================

%=========================================
z=100;
y=[0:1:(z-1)*length(g)];
%cw0=a*sin(2*pi*f1*y/z);
cw1=amp*sin(2*pi*f1*y/z);
%=========================================

clc;
K=length(g);
g3=g;
g2=g;
for j=[2:1:K]
    if g(j)==g(j-1)
       g2(j)=0;
    else
       g2(j)=1;
    end
end
%g;
g=g2;
%g;
%initial_phase=pi;

N=100;

i=[0:1:N-1];
sin2=amp*sin(2*pi*f1*i/N);
sin1=amp*sin(2*pi*f1*i/N+pi);

for j=[1:1:K]
    for i=[1:1:N]
        yout(N*(j-1)+i)=g(j)*sin1(i)+(1-g(j))*sin2(i);
    end
end

%sin22=sin2;
%sin11=sin1;

%for j=[1:1:K-1]
  %  sin22=[sin22 sin2];
   % sin11=[sin11 sin1];
%end

g=g3;
for j=[1:1:K]
    for i=[1:1:N]
        g1(N*(j-1)+i)=g(j);
    end
end

subplot(3,1,1);plot(g1,'LineWidth',1.5); grid on;
title('Binary signal');
axis([0 100*K -2 2]);

subplot(3,1,2);plot(cw1,'LineWidth',1.5); grid on;
title('DPSK Carrier Wave');
axis([0 100*K -2*amp 2*amp]);

subplot(3,1,3);plot(yout,'LineWidth',1.5); grid on;
title('DPSK modulation');
axis([0 100*K -2*amp 2*amp]);

%#######################################
set(handles.infoE,'visible','off');
set(handles.infoV,'visible','off');



function tsEdit_Callback(hObject, eventdata, handles)
% hObject    handle to tsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tsEdit as text
%        str2double(get(hObject,'String')) returns contents of tsEdit as a double


% --- Executes during object creation, after setting all properties.
function tsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showfigpush.
function showfigpush_Callback(hObject, eventdata, handles)
% hObject    handle to showfigpush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(1);
ts =get(handles.tsEdit,'string');
ts = str2double(ts);

if ts==1
    %## ASK ################################################
    freq0 = get(handles.f0Edit,'string');
bin = get(handles.bEdit,'string');
amp = get(handles.aEdit,'string');
ampi = get(handles.iEdit,'string');

set(handles.Group,'title',' Amplitude-shift keying (ASK) ');
ai = str2double(ampi);
a = str2double(amp);
f = str2double(freq0);
g = str2num(bin);

%=========================================
z=100;
y=[0:1:(z-1)*length(g)];
cw0=a*sin(2*pi*f*y/z);
cw1=a*sin(2*pi*f*y/z);
%=========================================
if ai > a
    aaxis = ai;
elseif a > ai
    aaxis = a;
else
    aasix =a;
end

t=0:2*pi/99:2*pi;
cp=[];sp=[];
mod=[];mod1=[];bit=[];
ni = ai/a;
for n=1:length(g);
    if g(n)==0;
        die=ones(1,100);
        se=zeros(1,100);
    else g(n)==1;
        die=ni*ones(1,100);
        se=ones(1,100);
    end
    c=a*sin(f*t);
    cp=[cp die];
    mod=[mod c];
    bit=[bit se];
end

ask=cp.*mod;

subplot(4,1,1);plot(bit,'LineWidth',1.5);grid on;
title('Binary Signal');
axis([0 100*length(g) -2 2]);

subplot(4,1,2);plot(cw0,'LineWidth',1.5);grid on;
title('ASK Carrier Wave1');
axis([0 100*length(g) -2*a 2*a]);

subplot(4,1,3);plot(cw1,'LineWidth',1.5);grid on;
title('ASK Carrier Wave2');
axis([0 100*length(g) -2*ai 2*ai]);   

subplot(4,1,4);plot(ask,'LineWidth',1.5);grid on;
title('ASK modulation');
axis([0 100*length(g) -2*aaxis 2.5*aaxis]);
   
elseif ts==2
    %## FSK ################################################
 freq0 = get(handles.f0Edit,'string');
freq1 = get(handles.f1Edit,'string');
bin = get(handles.bEdit,'string');
amp = get(handles.aEdit,'string');

set(handles.Group,'title',' Frequency-shift keying (FSK) ');

a = str2double(amp);
f0 = str2double(freq0);
f1 = str2double(freq1);
g = str2num(bin);
%======================================================================

%=========================================
z=100;
y=[0:1:(z-1)*length(g)];
cw0=a*sin(2*pi*f0*y/z);
cw1=a*sin(2*pi*f1*y/z);
%=========================================

t=0:2*pi/99:2*pi;
cp=[];sp=[];
mod=[];mod1=[];bit=[];

for n=1:length(g);
    if g(n)==0;
        die=ones(1,100);
        c=a*sin(f0*t);
        
        se=zeros(1,100);
    else g(n)==1;
        die=ones(1,100);
        c=a*sin(f1*t);
        se=ones(1,100);
    end
    cp=[cp die];
    mod=[mod c];
    bit=[bit se];
end

fsk=cp.*mod;
subplot(4,1,1);plot(bit,'LineWidth',1.5);grid on;
title('Binary Signal');
axis([0 100*length(g) -2 2]);

subplot(4,1,2);plot(cw0,'LineWidth',1.5);grid on;
title('FSK Carrier Wave 1 ');
axis([0 100*length(g) -2*a 2*a]);

subplot(4,1,3);plot(cw1,'LineWidth',1.5);grid on;
title('FSK Carrier Wave 2 ');
axis([0 100*length(g) -2*a 2*a]);

subplot(4,1,4);plot(fsk,'LineWidth',1.5);grid on;
title('FSK modulation');
axis([0 100*length(g) -2*a 2*a]);
    
elseif ts==3
    %## OOK ################################################
    
freq0 = get(handles.f0Edit,'string');
%freq1 = get(handles.f1Edit,'string');
bin = get(handles.bEdit,'string');
amp = get(handles.aEdit,'string');

set(handles.Group,'title',' On-Off keying (OOK) ');

a = str2double(amp);
f = str2double(freq0);
%f1 = str2double(freq1);
g = str2num(bin);
%==================================================================

%=========================================
z=100;
y=[0:1:(z-1)*length(g)];
cw0=a*sin(2*pi*f*y/z);
%cw1=a*sin(2*pi*f1*y/z);
%=========================================

t=0:2*pi/99:2*pi;
cp=[];sp=[];
mod=[];mod1=[];bit=[];

for n=1:length(g);
    if g(n)==0;
        die=zeros(1,100);   
        se=zeros(1,100);    
    else g(n)==1;
        die=ones(1,100);    
        se=ones(1,100);     
    end
    c=a*sin(f*t);
    cp=[cp die];
    mod=[mod c];
    bit=[bit se];
end

ook=cp.*mod;
subplot(3,1,1);plot(bit,'LineWidth',1.5);grid on;
title('Binary Signal');
axis([0 100*length(g) -2 2]);

subplot(3,1,2);plot(cw0,'LineWidth',1.5);grid on;
title('OOK Carrier Wave');
axis([0 100*length(g) -2*a 2*a]);


subplot(3,1,3);plot(ook,'LineWidth',1.5);grid on;
title('OOK modulation');
axis([0 100*length(g) -2*a 2*a]);
    
elseif ts==4
    %## 8PSK ################################################
  
freq0 = get(handles.f0Edit,'string');
%freq1 = get(handles.f1Edit,'string');
bin = get(handles.bEdit,'string');
amp = get(handles.aEdit,'string');

set(handles.Group,'title',' 8-Phase-shift keying (M-PSK)');

a = str2double(amp);
f = str2double(freq0);
%f1 = str2double(freq1);
g = str2num(bin);

%==================================================================

%=========================================
z=150;
y=[0:1:(z-1)*length(g)];
cw0=a*sin(2*pi*f*y/z);
%cw1=a*sin(2*pi*f1*y/z);
%=========================================

%***********************************************************************
if nargin > 2
    set(handles.infoE,'visible','on');
    set(handles.infoV,'visible','on');
    set(handles.infoE,'string','Too many input arguments');
    set(handles.infoV,'string','Doi so vao qua lon');
elseif nargin==1
    f=1;
end

if f<1;
    set(handles.infoE,'visible','on');
    set(handles.infoV,'visible','on');
    set(handles.infoE,'string','Frequency must be bigger than 1');
    set(handles.infoV,'string','Tan so phai lon hon 1');
end
%************************************************************************

l=length(g);
r=l/3;
re=ceil(r);
val=re-r;

if val~=0;
    set(handles.infoE,'visible','on');
    set(handles.infoV,'visible','on');
    set(handles.infoE,'string','Please insert a vector divisible for 3');
    set(handles.infoV,'string','Nhaäp chuoãi nhò phaân coù ñoä daøi chia heát cho 3');
end


t=0:2*pi/149:2*pi;
cp=[];sp=[];
mod=[];mod1=[];bit=[];

for n=1:3:length(g);
    if g(n)==0 && g(n+1)==1 && g(n+2)==1
        die=cos(3*pi/4)*ones(1,150);
        die1=sin(3*pi/4)*ones(1,150);
        se=[zeros(1,50) ones(1,50) ones(1,50)];

    elseif g(n)==0 && g(n+1)==1 && g(n+2)==0
        die=cos(pi/2)*ones(1,150);
        die1=sin(pi/2)*ones(1,150);
        se=[zeros(1,50) ones(1,50) zeros(1,50)];

    elseif g(n)==0 && g(n+1)==0  && g(n+2)==0
        die=cos(5*pi/4)*ones(1,150);
        die1=sin(5*pi/4)*ones(1,150);
        se=[zeros(1,50) zeros(1,50) zeros(1,50)];

    elseif g(n)==0 && g(n+1)==0  && g(n+2)==1
        die=cos(pi)*ones(1,150);
        die1=sin(pi)*ones(1,150);
        se=[zeros(1,50) zeros(1,50) ones(1,50)];

    elseif g(n)==1 && g(n+1)==0  && g(n+2)==1
        die=cos(7*pi/4)*ones(1,150);
        die1=sin(7*pi/4)*ones(1,150);
        se=[ones(1,50) zeros(1,50) ones(1,50)];

    elseif g(n)==1 && g(n+1)==0  && g(n+2)==0
        die=cos(3*pi/2)*ones(1,150);
        die1=sin(3*pi/2)*ones(1,150);
        se=[ones(1,50) zeros(1,50) zeros(1,50)];

    elseif g(n)==1 && g(n+1)==1  && g(n+2)==0
        die=cos(pi/4)*ones(1,150);
        die1=sin(pi/4)*ones(1,150);
        se=[ones(1,50) ones(1,50) zeros(1,50)];

    elseif g(n)==1 && g(n+1)==1  && g(n+2)==1
        die=cos(0)*ones(1,150);
        die1=sin(0)*ones(1,150);
        se=[ones(1,50) ones(1,50) ones(1,50)];

    end
    c=a*cos(f*t);
    s=a*sin(f*t);
    cp=[cp die];    %Amplitude cosino
    sp=[sp die1];  %Amplitude sino
    mod=[mod c];    %cosino carrier (Q)
    mod1=[mod1 s];  %sino carrier   (I)
    bit=[bit se];
end
opsk=cp.*mod1+sp.*mod;
subplot(3,1,1);plot(bit,'LineWidth',1.5);grid on;
title('Binary Signal')
axis([0 50*length(g) -2 2]);

subplot(3,1,2);plot(cw0,'LineWidth',1.5);grid on;
title('8PSK Carrier Wave')
axis([0 50*length(g) -2*a 2*a]);

subplot(3,1,3);plot(opsk,'LineWidth',1.5);grid on;
title('8PSK modulation')
axis([0 50*length(g) -2*a 2*a]);

set(handles.infoE,'visible','off');
set(handles.infoV,'visible','off');

elseif ts==5
    %## BPSK ################################################
       freq0 = get(handles.f0Edit,'string');
%freq1 = get(handles.f1Edit,'string');
bin = get(handles.bEdit,'string');
amp = get(handles.aEdit,'string');

set(handles.Group,'title',' Binary phase-shift keying (BPSK) ');

a = str2double(amp);
f = str2double(freq0);
%f1 = str2double(freq1);
g = str2num(bin);
%==================================================================

%=========================================
z=100;
y=[0:1:(z-1)*length(g)];
cw0=a*sin(2*pi*f*y/z);
%cw1=a*sin(2*pi*f1*y/z);
%=========================================

t=0:2*pi/99:2*pi;
cp=[];sp=[];
mod=[];mod1=[];bit=[];

for n=1:length(g);
    if g(n)==0;
        die=-ones(1,100);   
        se=zeros(1,100);    
    else g(n)==1;
        die=ones(1,100);    
        se=ones(1,100);     
    end
    c=a*sin(f*t);
    cp=[cp die];
    mod=[mod c];
    bit=[bit se];
end

bpsk=cp.*mod;

subplot(3,1,1);plot(bit,'LineWidth',1.5);grid on;
title('Binary Signal');
axis([0 100*length(g) -2 2]);

subplot(3,1,2);plot(cw0,'LineWidth',1.5);grid on;
title('BPSK Carrier Wave');
axis([0 100*length(g) -2*a 2*a]);

subplot(3,1,3);plot(bpsk,'LineWidth',1.5);grid on;
title('BPSK modulation');
axis([0 100*length(g) -2*a 2*a]);
    
elseif ts==6
    %## DPSK ################################################
 
freq0 = get(handles.f0Edit,'string');
%freq1 = get(handles.f1Edit,'string');
bin = get(handles.bEdit,'string');
amp = get(handles.aEdit,'string');

set(handles.Group,'title',' Differential phase-shift keying (DPSK)');

amp = str2double(amp);
f1 = str2double(freq0);
%f1 = str2double(freq1);
g = str2num(bin);
%==================================================================

%=========================================
z=100;
y=[0:1:(z-1)*length(g)];
%cw0=a*sin(2*pi*f1*y/z);
cw1=amp*sin(2*pi*f1*y/z);
%=========================================

clc;
K=length(g);
g3=g;
g2=g;
for j=[2:1:K]
    if g(j)==g(j-1)
       g2(j)=0;
    else
       g2(j)=1;
    end
end
g;
g=g2;
g;
initial_phase=pi;

N=100;

i=[0:1:N-1];
sin2=amp*sin(2*pi*f1*i/N);
sin1=amp*sin(2*pi*f1*i/N+pi);

for j=[1:1:K]
    for i=[1:1:N]
        yout(N*(j-1)+i)=g(j)*sin1(i)+(1-g(j))*sin2(i);
    end
end

sin22=sin2;
sin11=sin1;

for j=[1:1:K-1]
    sin22=[sin22 sin2];
    sin11=[sin11 sin1];
end

g=g3;
for j=[1:1:K]
    for i=[1:1:N]
        g1(N*(j-1)+i)=g(j);
    end
end

subplot(3,1,1);plot(g1,'LineWidth',1.5); grid on;
title('Binary signal');
axis([0 100*K -2 2]);

subplot(3,1,2);plot(cw1,'LineWidth',1.5); grid on;
title('DPSK Carrier Wave');
axis([0 100*K -2*amp 2*amp]);

subplot(3,1,3);plot(yout,'LineWidth',1.5); grid on;
title('DPSK modulation');
axis([0 100*K -2*amp 2*amp]);
    
elseif ts==7
    %## QPSK ################################################
 
freq0 = get(handles.f0Edit,'string');
%freq1 = get(handles.f1Edit,'string');
bin = get(handles.bEdit,'string');
amp = get(handles.aEdit,'string');

set(handles.Group,'title','Quadrature phase-shift keying (QPSK)');

a = str2double(amp);
f = str2double(freq0);
%f1 = str2double(freq1);
g = str2num(bin);
%==================================================================

%=========================================
z=100;
y=[0:1:(z-1)*length(g)];
cw0=a*sin(2*pi*f*y/z);
%cw1=a*sin(2*pi*f1*y/z);
%=========================================

%*-*-*-*-*-*
l=length(g);
r=l/2;
re=ceil(r);
val=re-r;

if val~=0;
    
    set(handles.infoE,'visible','on');
    set(handles.infoV,'visible','on');
    set(handles.infoE,'string','Please insert a vector divisible for 2');
    set(handles.infoV,'string','Nhaäp chuoãi nhò phaân coù ñoä daøi chia heát cho 2');
end
%*-*-*-*-*-*

t=0:2*pi/99:2*pi;
cp=[];sp=[];
mod=[];mod1=[];bit=[];
for n=1:2:length(g);
    if g(n)==0 && g(n+1)==1;
        die=sqrt(2)/2*ones(1,100);
        die1=-sqrt(2)/2*ones(1,100);
        se=[zeros(1,50) ones(1,50)];
    elseif g(n)==0 && g(n+1)==0;
        die=-sqrt(2)/2*ones(1,100);
        die1=-sqrt(2)/2*ones(1,100);
        se=[zeros(1,50) zeros(1,50)];
    elseif g(n)==1 && g(n+1)==0;
        die=-sqrt(2)/2*ones(1,100);
        die1=sqrt(2)/2*ones(1,100);
        se=[ones(1,50) zeros(1,50)];
    elseif g(n)==1 && g(n+1)==1;
        die=sqrt(2)/2*ones(1,100);
        die1=sqrt(2)/2*ones(1,100);
        se=[ones(1,50) ones(1,50)];
    end
    c=a*cos(f*t);
    s=a*sin(f*t);
    cp=[cp die];    %Amplitude cosino
    sp=[sp die1];   %Amplitude sino
    mod=[mod c];    %cosino carrier (Q)
    mod1=[mod1 s];  %sino carrier   (I)
    bit=[bit se];
end
bpsk=cp.*mod+sp.*mod1;

subplot(3,1,1);plot(bit,'LineWidth',1.5);grid on;
title('Binary Signal')
axis([0 50*length(g) -2 2]);

subplot(3,1,2);plot(cw0,'LineWidth',1.5);grid on;
title('QPSK Carrier Wave')
axis([0 50*length(g) -2*a 2*a]);

subplot(3,1,3);plot(bpsk,'LineWidth',1.5);grid on;
title('QPSK modulation')
axis([0 50*length(g) -2*a 2*a]);

set(handles.infoE,'visible','off');
set(handles.infoV,'visible','off');

elseif ts==8
       %##QAM#############################################
       freq0 = get(handles.f0Edit,'string');
freq1 = get(handles.f1Edit,'string');
bin = get(handles.bEdit,'string');
amp = get(handles.aEdit,'string');
ampi = get(handles.iEdit,'string');

set(handles.Group,'title',' Quadrature Amplitude Modulation-QAM');

a = str2double(amp);
ai= str2double(ampi);
f = str2double(freq0);
f1 = str2double(freq1);
g = str2num(bin);
%===========================
if ai > a
    aaxis = ai;
elseif a > ai
    aaxis = a;
else
    aasix =a;
end

%==================================================================
ni=ai/a;
%=========================================
z=150;
y=[0:1:(z-1)*length(g)];
cw0=a*sin(2*pi*f*y/z);
cw1=ai*sin(2*pi*f*y/z);
%=========================================

%***********************************************************************
if nargin > 2
    set(handles.infoE,'visible','on');
    set(handles.infoV,'visible','on');
    set(handles.infoE,'string','Too many input arguments');
    set(handles.infoV,'string','Doi so vao qua lon');
elseif nargin==1
    f=1;
end

if f<1;
    set(handles.infoE,'visible','on');
    set(handles.infoV,'visible','on');
    set(handles.infoE,'string','Frequency must be bigger than 1');
    set(handles.infoV,'string','Tan so phai lon hon 1');
end
%************************************************************************

l=length(g);
r=l/3;
re=ceil(r);
val=re-r;

if val~=0;
    set(handles.infoE,'visible','on');
    set(handles.infoV,'visible','on');
    set(handles.infoE,'string','Please insert a vector divisible for 3');
    set(handles.infoV,'string','Nhaäp chuoãi nhò phaân coù ñoä daøi chia heát cho 3');
end


t=0:2*pi/149:2*pi;
cp=[];sp=[];
mod=[];mod1=[];bit=[];

for n=1:3:length(g);
    if g(n)==0 && g(n+1)==1 && g(n+2)==1
        die=ni*cos(pi/2)*ones(1,150);
        die1=ni*sin(pi/2)*ones(1,150);
        se=[zeros(1,50) ones(1,50) ones(1,50)];

    elseif g(n)==0 && g(n+1)==1 && g(n+2)==0
        die=cos(pi/2)*ones(1,150);
        die1=sin(pi/2)*ones(1,150);
        se=[zeros(1,50) ones(1,50) zeros(1,50)];

    elseif g(n)==0 && g(n+1)==0  && g(n+2)==0
        die=cos(2*pi)*ones(1,150);
        die1=sin(2*pi)*ones(1,150);
        se=[zeros(1,50) zeros(1,50) zeros(1,50)];

    elseif g(n)==0 && g(n+1)==0  && g(n+2)==1
        die=ni*cos(2*pi)*ones(1,150);
        die1=ni*sin(2*pi)*ones(1,150);
        se=[zeros(1,50) zeros(1,50) ones(1,50)];

    elseif g(n)==1 && g(n+1)==0  && g(n+2)==1
        die=ni*cos(pi)*ones(1,150);
        die1=ni*sin(pi)*ones(1,150);
        se=[ones(1,50) zeros(1,50) ones(1,50)];

    elseif g(n)==1 && g(n+1)==0  && g(n+2)==0
        die=cos(pi)*ones(1,150);
        die1=sin(pi)*ones(1,150);
        se=[ones(1,50) zeros(1,50) zeros(1,50)];

    elseif g(n)==1 && g(n+1)==1  && g(n+2)==0
        die=cos(3*pi/2)*ones(1,150);
        die1=sin(3*pi/2)*ones(1,150);
        se=[ones(1,50) ones(1,50) zeros(1,50)];

    elseif g(n)==1 && g(n+1)==1  && g(n+2)==1
        die=ni*cos(3*pi/2)*ones(1,150);
        die1=ni*sin(3*pi/2)*ones(1,150);
        se=[ones(1,50) ones(1,50) ones(1,50)];

    end
   c=a*cos(f*t);
   s=a*sin(f*t);
   cp=[cp die];    %Amplitude cosino
   sp=[sp die1];  %Amplitude sino
   mod=[mod c];    %cosino carrier (Q)
   mod1=[mod1 s];  %sino carrier   (I)
   bit = [bit se];
   end
qam=cp.*mod1+sp.*mod;

subplot(4,1,1);plot(bit,'LineWidth',1.5);grid on;
title('Binary Signal')
axis([0 50*length(g) -2 2]);

subplot(4,1,2);plot(cw0,'LineWidth',1.5);grid on;
title('QAM Carrier Wave1')
axis([0 50*length(g) -2*a 2*a]);

subplot(4,1,3);plot(cw1,'LineWidth',1.5);grid on;
title('QAM Carrier Wave2')
axis([0 50*length(g) -2*ai 2*ai]);

subplot(4,1,4);plot(qam,'LineWidth',1.5);grid on;
title('QAM modulation')
axis([0 50*length(g) -2*aaxis 2*aaxis]);

set(handles.infoE,'visible','off');
set(handles.infoV,'visible','off');
      
else
    set(handles.infoE,'visible','on');
    set(handles.infoV,'visible','on');
    set(handles.infoE,'string','Please select a kind of signal modulation');
    set(handles.infoV,'string','Haõy choïn moät loaïi tín hieäu ñieàu cheá ');
end



function iEdit_Callback(hObject, eventdata, handles)
% hObject    handle to iEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iEdit as text
%        str2double(get(hObject,'String')) returns contents of iEdit as a double


% --- Executes during object creation, after setting all properties.
function iEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in qampusk.
function qampusk_Callback(hObject, eventdata, handles)
% hObject    handle to qampusk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.tsEdit,'string','8');
%==================================================================
freq0 = get(handles.f0Edit,'string');
freq1 = get(handles.f1Edit,'string');
bin = get(handles.bEdit,'string');
amp = get(handles.aEdit,'string');
ampi = get(handles.iEdit,'string');

set(handles.Group,'title',' Quadrature Amplitude Modulation-QAM');

a = str2double(amp);
ai= str2double(ampi);
f = str2double(freq0);
f1 = str2double(freq1);
g = str2num(bin);
%===========================
if ai > a
    aaxis = ai;
elseif a > ai
    aaxis = a;
else
    aasix =a;
end

%==================================================================
ni=ai/a;
%=========================================
z=150;
y=[0:1:(z-1)*length(g)];
cw0=a*sin(2*pi*f*y/z);
cw1=ai*sin(2*pi*f*y/z);
%=========================================

%***********************************************************************
if nargin > 2
    set(handles.infoE,'visible','on');
    set(handles.infoV,'visible','on');
    set(handles.infoE,'string','Too many input arguments');
    set(handles.infoV,'string','Doi so vao qua lon');
elseif nargin==1
    f=1;
end

if f<1;
    set(handles.infoE,'visible','on');
    set(handles.infoV,'visible','on');
    set(handles.infoE,'string','Frequency must be bigger than 1');
    set(handles.infoV,'string','Tan so phai lon hon 1');
end
%************************************************************************

l=length(g);
r=l/3;
re=ceil(r);
val=re-r;

if val~=0;
    set(handles.infoE,'visible','on');
    set(handles.infoV,'visible','on');
    set(handles.infoE,'string','Please insert a vector divisible for 3');
    set(handles.infoV,'string','"Binary String" phaûi coù ñoä daøi chia heát cho 3');
end


t=0:2*pi/149:2*pi;
cp=[];sp=[];
mod=[];mod1=[];bit=[];

for n=1:3:length(g);
    if g(n)==0 && g(n+1)==1 && g(n+2)==1
        die=ni*cos(pi/2)*ones(1,150);
        die1=ni*sin(pi/2)*ones(1,150);
        se=[zeros(1,50) ones(1,50) ones(1,50)];

    elseif g(n)==0 && g(n+1)==1 && g(n+2)==0
        die=cos(pi/2)*ones(1,150);
        die1=sin(pi/2)*ones(1,150);
        se=[zeros(1,50) ones(1,50) zeros(1,50)];

    elseif g(n)==0 && g(n+1)==0  && g(n+2)==0
        die=cos(2*pi)*ones(1,150);
        die1=sin(2*pi)*ones(1,150);
        se=[zeros(1,50) zeros(1,50) zeros(1,50)];

    elseif g(n)==0 && g(n+1)==0  && g(n+2)==1
        die=ni*cos(2*pi)*ones(1,150);
        die1=ni*sin(2*pi)*ones(1,150);
        se=[zeros(1,50) zeros(1,50) ones(1,50)];

    elseif g(n)==1 && g(n+1)==0  && g(n+2)==1
        die=ni*cos(pi)*ones(1,150);
        die1=ni*sin(pi)*ones(1,150);
        se=[ones(1,50) zeros(1,50) ones(1,50)];

    elseif g(n)==1 && g(n+1)==0  && g(n+2)==0
        die=cos(pi)*ones(1,150);
        die1=sin(pi)*ones(1,150);
        se=[ones(1,50) zeros(1,50) zeros(1,50)];

    elseif g(n)==1 && g(n+1)==1  && g(n+2)==0
        die=cos(3*pi/2)*ones(1,150);
        die1=sin(3*pi/2)*ones(1,150);
        se=[ones(1,50) ones(1,50) zeros(1,50)];

    elseif g(n)==1 && g(n+1)==1  && g(n+2)==1
        die=ni*cos(3*pi/2)*ones(1,150);
        die1=ni*sin(3*pi/2)*ones(1,150);
        se=[ones(1,50) ones(1,50) ones(1,50)];

    end
   c=a*cos(f*t);
   s=a*sin(f*t);
   cp=[cp die];    %Amplitude cosino
   sp=[sp die1];  %Amplitude sino
   mod=[mod c];    %cosino carrier (Q)
   mod1=[mod1 s];  %sino carrier   (I)
   bit = [bit se];
   end
qam=cp.*mod1+sp.*mod;

subplot(3,1,1);plot(bit,'LineWidth',1.5);grid on;
title('Binary Signal')
axis([0 50*length(g) -2 2]);

subplot(3,1,2);plot(cw0,'LineWidth',1.5);grid on;
title('QAM Carrier Wave1')
axis([0 50*length(g) -2*a 2*a]);

%subplot(4,1,3);plot(cw1,'LineWidth',1.5);grid on;
%title('QAM Carrier Wave2')
%axis([0 50*length(g) -2*ai 2*ai]);

subplot(3,1,3);plot(qam,'LineWidth',1.5);grid on;
title('QAM modulation')
axis([0 50*length(g) -2*aaxis 2*aaxis]);

%#######################################
set(handles.infoE,'visible','off');
set(handles.infoV,'visible','off');
