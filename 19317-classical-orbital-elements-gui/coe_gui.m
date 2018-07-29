function varargout = coe_gui(varargin)
% COE_GUI M-file for coe_gui.fig
%      COE_GUI, by itself, creates a new COE_GUI or raises the existing
%      singleton*.
%
%      H = COE_GUI returns the handle to a new COE_GUI or the handle to
%      the existing singleton*.
%
%      COE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COE_GUI.M with the given input arguments.
%
%      COE_GUI('Property','Value',...) creates a new COE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before coe_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to coe_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help coe_gui

% Last Modified by GUIDE v2.5 12-Oct-2010 22:29:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @coe_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @coe_gui_OutputFcn, ...
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
end


% --- Executes just before coe_gui is made visible.
function coe_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to coe_gui (see VARARGIN)

% Choose default command line output for coe_gui
handles.output = hObject;

% Default values
handles.coe.a = 36000;
handles.coe.e = 0.8;
handles.coe.inc = 0;
handles.coe.omega = 0;
handles.coe.w = 0;
handles.coe.v = 0;
handles.coe.r = 6378;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes coe_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = coe_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


function edit_a_Callback(hObject, eventdata, handles)
% hObject    handle to edit_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_a as text
%        str2double(get(hObject,'String')) returns contents of edit_a as a double

a = str2double(get(hObject,'String'));

if isnan(a)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new density value
handles.coe.a = a;
guidata(hObject,handles)
end

% --- Executes during object creation, after setting all properties.
function edit_a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit_e_Callback(hObject, eventdata, handles)
% hObject    handle to edit_e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_e as text
%        str2double(get(hObject,'String')) returns contents of edit_e as a double
e = str2double(get(hObject,'String'));

if isnan(e)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new density value
handles.coe.e = e;
guidata(hObject,handles)
end

% --- Executes during object creation, after setting all properties.
function edit_e_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit_i_Callback(hObject, eventdata, handles)
% hObject    handle to edit_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_i as text
%        str2double(get(hObject,'String')) returns contents of edit_i as a double
inc = str2double(get(hObject,'String'));

if isnan(inc)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new density value
handles.coe.inc = inc;
guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function edit_i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit_omega_Callback(hObject, eventdata, handles)
% hObject    handle to edit_omega (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_omega as text
%        str2double(get(hObject,'String')) returns contents of edit_omega as a double
omega = str2double(get(hObject,'String'));

if isnan(omega)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new density value
handles.coe.omega = omega;
guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function edit_omega_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_omega (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit_w_Callback(hObject, eventdata, handles)
% hObject    handle to edit_w (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_w as text
%        str2double(get(hObject,'String')) returns contents of edit_w as a double
w = str2double(get(hObject,'String'));

if isnan(w)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new density value
handles.coe.w = w;
guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function edit_w_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_w (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function edit_v_Callback(hObject, eventdata, handles)
% hObject    handle to edit_v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_v as text
%        str2double(get(hObject,'String')) returns contents of edit_v as a double
v = str2double(get(hObject,'String'));
if isnan(v)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new density value
handles.coe.v = v;
guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function edit_v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in plot_orbit.
function plot_orbit_Callback(hObject, eventdata, handles)
% hObject    handle to plot_orbit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Author: Anders Edfors
% Date: 2008-03-23
% Version: 1.0
% Email: anders.edfors@ssc.se
%
% Orbit is blue if it is a direct orbit and red if its retrograded
%
a = handles.coe.a;
e = handles.coe.e;
inc = handles.coe.inc;
omega = handles.coe.omega;
w = handles.coe.w;
v = handles.coe.v;
r = handles.coe.r;

[x,y,z] = orbit(a, e, omega*pi/180, inc*pi/180, w*pi/180);
[xv,yv,zv] = trueanomaly(a,e,omega*pi/180,inc*pi/180,w*pi/180,v*pi/180);
[xp,yp,zp] = planet(r,20); % earth radius ( km )

if( inc > 90 )
    orbit_color = 'red'; % retrograde
elseif (inc == 90 || inc == 180 )
    orbit_color = 'black'; % polar
else 
    orbit_color = 'blue'; % direct
end

plot3(x,y,z,orbit_color,'Linewidth',2); % direct

axis equal
hold on

plot3(xv,yv,zv,'blacko','Linewidth',2); % plot true anomaly
surf(xp,yp,zp,'EdgeAlpha',0.4);   % plot the planet
colormap([0  0.5  0.8]);

scale = 2;
axis([-scale*a scale*a -scale*a scale*a -scale*a scale*a])


% Get Axis properties 
axis_data = get(gca);
xmin = axis_data.XLim(1);
xmax = axis_data.XLim(2);
ymin = axis_data.YLim(1);
ymax = axis_data.YLim(2);
zmin = axis_data.ZLim(1);
zmax = axis_data.ZLim(2);

% I, J ,K vectors
plot3([xmin,xmax],[0 0],[0 0],'black','Linewidth',1); plot3(xmax,0,0,'black>','Linewidth',1.5);
plot3([0 0],[ymin,ymax],[0 0],'black','Linewidth',1); plot3(0,ymax,0,'blue>','Linewidth',1.5);
plot3([0 0],[0 0],[zmin,zmax],'black','Linewidth',1); plot3(0,0,zmax,'red^','Linewidth',1.5);

% right ascending node line plot
xomega_max = xmax*cos(omega*pi/180);
xomega_min = xmin*cos(omega*pi/180);
yomega_max = ymax*sin(omega*pi/180);
yomega_min = ymin*sin(omega*pi/180);

xlabel('I');
ylabel('J');
zlabel('K');

plot3([xomega_min xomega_max], [yomega_min yomega_max], [0 0], 'g','Linewidth',1.5);

% add equatorial plan
xe = [xmin xmax;xmin xmax]; ye = [ymax ymax;ymin ymin]; ze = [0 0; 0 0];
eq_alpha = 0.3; % transparancy 
mesh(xe,ye,ze,'FaceAlpha',eq_alpha,'FaceColor',[0.753,0.753,0.753]);

grid on
hold off
end


function edit_r_Callback(hObject, eventdata, handles)
% hObject    handle to edit_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_r as text
%        str2double(get(hObject,'String')) returns contents of edit_r as a double
r = str2double(get(hObject,'String'));
if isnan(r)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new density value
handles.coe.r = r;
guidata(hObject,handles)
end

% --- Executes during object creation, after setting all properties.
function edit_r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%
% Utility function
% Anders Edfors
%
function [x,y,z] = trueanomaly(a,e,omega,inc,w,v)
%
% a: semimajor axis
% e: excentricity
% i: inclination
% w: argument of perigee
% v: true anomaly
%
% 2-body problem orbit determination

r = a*(1-e^2)./(1+e*cos(v));

x = r.*cos(v);
y = r.*sin(v);
z = zeros(1,length(x));

[x,y,z] = pointrot_oiw(x,y,z,omega,inc,w);
end
function [x,y,z] = orbit(a,e,omega,inc,w,n)
%
% orbit(a,e,i)
%
% a: semimajor axis
% e: excentricity
% i: inclination
% w: argument of perigee
% n: number of points [optional]

if (nargin == 5 )
    n = 100; % Default
end

if (nargin == 0 || nargin > 6)
    fprintf(1,'error -> wrong number of arguments\n');
    return;
end

% v = true anomaly
v = 0:2*pi/n:2*pi;

% 2-body problem orbit determination
r = a*(1-e^2)./(1+e*cos(v));

x = r.*cos(v);
y = r.*sin(v);
z = zeros(1,length(x));

[x,y,z] = pointrot_oiw(x,y,z,omega,inc,w);
end
function [x2,y2,z2] = pointrot_oiw(x1,y1,z1,omega,inc,w)
%
% pointrot_oiw(omega,inc,w)
%
% omega: right ascension angle
% inc : inclination angle
% w : argument of perigee angle
%
% point rotation in the plane ( frame fixed )
%
%  Rz(omega)*Rx(inc)*Rz(w)
%

Mrot = [cos(omega) * cos(w) - sin(omega) * cos(inc) * sin(w) -cos(omega) * sin(w) - sin(omega) * cos(inc) * cos(w) sin(omega) * sin(inc); 
        sin(omega) * cos(w) + cos(omega) * cos(inc) * sin(w) -sin(omega) * sin(w) + cos(omega) * cos(inc) * cos(w) -cos(omega) * sin(inc); 
        sin(inc) * sin(w) sin(inc) * cos(w) cos(inc);];


RotResult = Mrot*[x1;y1;z1];

    
x2 = RotResult(1,:);
y2 = RotResult(2,:);
z2 = RotResult(3,:);

end
function [x,y,z] = planet(r,n)
%
% planet_sphere(r,[n])
% 
% r = radius
% n = number of points ( optional )
%
% author: Anders Edfors Vannevik
%

if (nargin == 1 )
    n = 20; % Default
end

if (nargin == 0 || nargin > 2)
    fprintf(1,'error -> wrong number of arguments\n');
    return;
end

[x1,y1,z1] = sphere(n);

x = r.*x1;
y = r.*y1;
z = r.*z1;

end


% --- Executes on button press in zoom_button.
function zoom_button_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom on;
end


% --- Executes on button press in rotate_button.
function rotate_button_Callback(hObject, eventdata, handles)
% hObject    handle to rotate_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rotate3d on;
end


% --- Executes on button press in hold_button.
function hold_button_Callback(hObject, eventdata, handles)
% hObject    handle to hold_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hold on;
end
