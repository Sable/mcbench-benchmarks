function varargout = oscillator(varargin)
% OSCILLATOR M-file for oscillator.fig
%      OSCILLATOR, by itself, creates a new OSCILLATOR or raises the existing
%      singleton*.
%
%      H = OSCILLATOR returns the handle to a new OSCILLATOR or the handle to
%      the existing singleton*.
%
%      OSCILLATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OSCILLATOR.M with the given input arguments.
%
%      OSCILLATOR('Property','Value',...) creates a new OSCILLATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before oscillator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to oscillator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help oscillator

% Last Modified by GUIDE v2.5 05-Sep-2009 14:39:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @oscillator_OpeningFcn, ...
                   'gui_OutputFcn',  @oscillator_OutputFcn, ...
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
end % function end
% End initialization code - DO NOT EDIT


% --- Executes just before oscillator is made visible.
function oscillator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to oscillator (see VARARGIN)

% Choose default command line output for oscillator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes oscillator wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%     ???   slider1_Callback(hObject, eventdata, handles) % first screen
end % function end

% --- Outputs from this function are returned to the command line.
function varargout = oscillator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end % function end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close  %zamyka okno
end % function end

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
beta=get(hObject,'Value') 
set(handles.edit1,'String',['beta=',num2str(beta)]); % napis
t0=0; t2=12*pi; % tspan=[t0,t2]
x0= [1.5 0];           % warto/sci dla t=0

%[t,x] = ode23 (mech_ode, [t0, t2] , x0); %Runge-Kutta
[t,x]=nested_ode([t0,t2], x0,beta,handles);
plot(handles.axes1,t,x)  % (t,x)
plot(handles.axes2,x(:,1),x(:,2))  % (x,dx/dt)
title(handles.axes1,'Equation/Równanie d^2x/dt^2 +\beta*dx/dt +x =0,   x(0)=1.5,  dx/dt(0)=0')
title(handles.axes2,'Phase/fazowy diagram: dx/dt=f(x)')
% ylabel(handles.axes2,'dx/dt')
end % function end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end % function end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
end % function end

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
end % function end

function [t,x]=nested_ode(tspan, x0,beta,handles);

[t,x] = ode23 (@mech_ode, tspan , x0); %Runge-Kutta
txt='in nested_ode(tspan, x0,beta);'
beta=get(handles.slider1,'Value') 

function xdot=mech_ode(t,x); %nested in..
% mech_ode.m  zawiera model uk³adu drugiego rzêdu (masa drgaj¹ca)
% dx2/dt2 + beta*x' + x = 0
% mech_ode jest wo³ane przez funkcjê ode23 z M-pliku

xdot=zeros(2,1);            %zerowy wektor dwuelementowy
xdot(1)=x(2);               % x(1)= x   x(2)= dx/dt
xdot(2)= -1*x(1) -beta*x(2);
end % nested function end
end % nested function end
