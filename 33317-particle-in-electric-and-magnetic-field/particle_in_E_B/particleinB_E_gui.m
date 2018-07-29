function varargout = particleinB_E_gui(varargin)
% PARTICLEINB_E_GUI M-file for particleinB_E_gui.fig
%      PARTICLEINB_E_GUI, by itself, creates a new PARTICLEINB_E_GUI or raises the existing
%      singleton*.
%
%      H = PARTICLEINB_E_GUI returns the handle to a new PARTICLEINB_E_GUI or the handle to
%      the existing singleton*.
%
%      PARTICLEINB_E_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARTICLEINB_E_GUI.M with the given input arguments.
%
%      PARTICLEINB_E_GUI('Property','Value',...) creates a new PARTICLEINB_E_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before particleinB_E_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to particleinB_E_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help particleinB_E_gui

% Last Modified by GUIDE v2.5 17-Jun-2011 05:04:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @particleinB_E_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @particleinB_E_gui_OutputFcn, ...
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


% --- Executes just before particleinB_E_gui is made visible.
function particleinB_E_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to particleinB_E_gui (see VARARGIN)

% Choose default command line output for particleinB_E_gui
handles.output = hObject;

%close all;
%clear all;
clc;

set(handles.vx,'Value',0);
set(handles.vy,'Value',0);
set(handles.vz,'Value',0);

set(handles.x,'Value',-10);
set(handles.y,'Value',0);
set(handles.z,'Value',0);

set(handles.Bx,'Value',0);
set(handles.By,'Value',-6);
set(handles.Bz,'Value',0);
set(handles.Ex,'Value',0)
set(handles.Ey,'Value',0)
set(handles.Ez,'Value',2)

set(handles.q,'Value',1);
set(handles.m,'Value',5);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes particleinB_E_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = particleinB_E_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.stop,'String','Stop!!');
guidata(hObject, handles);

v0 = [get(handles.vx,'Value'), get(handles.vy,'Value'), get(handles.vz,'Value') ]';   %initial velocity
B = [get(handles.Bx,'Value'), get(handles.By,'Value'), get(handles.Bz,'Value') ]';                                                %magnitude of B
E = [get(handles.Ex,'Value'), get(handles.Ey,'Value'), get(handles.Ez,'Value') ]';                                                %magnitude of B
m = get(handles.m,'Value');                                                        % mass
q = get(handles.q,'Value');                                                         % charge on particle
r0 = [get(handles.x,'Value'), get(handles.y,'Value'), get(handles.z,'Value') ]';    % initial position of particle
tspan = [0 70];

%to show B's direction
[x_q,y_q] = meshgrid(-15:12:15,-15:12:15);
z_q=10*ones(size(x_q));

u_q=B(1)*ones(size(x_q));
v_q=B(2)*ones(size(x_q));
w_q=B(3)*ones(size(x_q));
quiver3(x_q,y_q,z_q,u_q,v_q,w_q);
hold all;

% TO show electric field lines
z_q=-10*ones(size(x_q));

u_q=E(1)*ones(size(x_q));
v_q=E(2)*ones(size(x_q));
w_q=E(3)*ones(size(x_q));
quiver3(x_q,y_q,z_q,u_q,v_q,w_q);

legend('B','E');

% To draw axis and all
a_a = -15:0.1:15;
z_a = zeros(size(a_a));
plot3(a_a,z_a,z_a,'k','LineWidth',2);
plot3(z_a,a_a,z_a,'k','LineWidth',2);
plot3(z_a,z_a,a_a,'k','LineWidth',2);

% To set axis limits
%xlim([-15 15]);
%ylim([-15 15]);
%zlim([-15 15])

xlabel ('x axis');
ylabel ('y axis');
zlabel ('z axis');
title ('Particle in a magnetic field');

rotate3d(handles.axes,'on');

plot3(r0(1),r0(2),r0(3),'*m','MarkerSize',9,'LineWidth',2);

y0 = [r0; v0];
f = @(t,y) [y(4:6); (q/m)*cross(y(4:6),B)+E];
[t,y] = ode23t(f,tspan,y0);

%To show animation
for n=1:length(y)
    plot3(y(n,1),y(n,2),y(n,3),'--.r');
    pause(0.00001);
    
    z_z = get(handles.stop,'String');
    if z_z == 'Stoped'
        break;
    end

end

guidata(hObject, handles);

% --- Executes on slider movement.
function B_Callback(hObject, eventdata, handles)
% hObject    handle to B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function m_Callback(hObject, eventdata, handles)
% hObject    handle to m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a = get (handles.m,'Value');
set(handles.m_text,'String',num2str(a));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function m_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function q_Callback(hObject, eventdata, handles)
% hObject    handle to q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a = get (handles.q,'Value');
set(handles.q_text,'String',num2str(a));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function q_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes);

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.stop,'String','Stoped');
guidata(hObject, handles);

% --- Executes on slider movement.
function x_Callback(hObject, eventdata, handles)
% hObject    handle to x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a = get (handles.x,'Value');
set(handles.x_text,'String',num2str(a));
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function y_Callback(hObject, eventdata, handles)
% hObject    handle to y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a = get (handles.y,'Value');
set(handles.y_text,'String',num2str(a));
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function z_Callback(hObject, eventdata, handles)
% hObject    handle to z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a = get (handles.z,'Value');
set(handles.z_text,'String',num2str(a));
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function vx_Callback(hObject, eventdata, handles)
% hObject    handle to vx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a = get (handles.vx,'Value');
set(handles.vx_text,'String',num2str(a));
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function vx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function vy_Callback(hObject, eventdata, handles)
% hObject    handle to vy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a = get (handles.vy,'Value');
set(handles.vy_text,'String',num2str(a));
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function vy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function vz_Callback(hObject, eventdata, handles)
% hObject    handle to vz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a = get (handles.vz,'Value');
set(handles.vz_text,'String',num2str(a));
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function vz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function E_Callback(hObject, eventdata, handles)
% hObject    handle to E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Ex_Callback(hObject, eventdata, handles)
% hObject    handle to Ex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a = get (handles.Ex,'Value');
set(handles.Ex_text,'String',num2str(a));
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function Ex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Ey_Callback(hObject, eventdata, handles)
% hObject    handle to Ey (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a = get (handles.Ey,'Value');
set(handles.Ey_text,'String',num2str(a));
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function Ey_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ey (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Ez_Callback(hObject, eventdata, handles)
% hObject    handle to Ez (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a = get (handles.Ez,'Value');
set(handles.Ez_text,'String',num2str(a));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Ez_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ez (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Bx_Callback(hObject, eventdata, handles)
% hObject    handle to Bx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a = get (handles.Bx,'Value');
set(handles.Bx_text,'String',num2str(a));
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function Bx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function By_Callback(hObject, eventdata, handles)
% hObject    handle to By (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a = get (handles.By,'Value');
set(handles.By_text,'String',num2str(a));
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function By_CreateFcn(hObject, eventdata, handles)
% hObject    handle to By (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Bz_Callback(hObject, eventdata, handles)
% hObject    handle to Bz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a = get (handles.Bz,'Value');
set(handles.Bz_text,'String',num2str(a));
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function Bz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
