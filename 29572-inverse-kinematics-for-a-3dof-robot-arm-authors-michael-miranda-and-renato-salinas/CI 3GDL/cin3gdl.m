function varargout = cin3gdl(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cin3gdl_OpeningFcn, ...
                   'gui_OutputFcn',  @cin3gdl_OutputFcn, ...
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

% --- Executes just before cin3gdl is made visible.
function cin3gdl_OpeningFcn(hObject, eventdata, handles, varargin)
global x x3 y3 ini_vector l1 l2 l3 ;

% Valores iniciales
x = [0 0 0 0];
ini_vector = [0 0 0 0];
l1 = 30; 
l2 = 20;
l3 = 10;
x3 = 40;
y3 = 20;

handles.output = hObject;
guidata(hObject, handles);

function varargout = cin3gdl_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% --- Executes on button press in optimizar.
function optimizar_Callback(hObject, eventdata, handles)
global x x x1 y1 x2 y2 x3 y3 theta0 theta1 theta2 ini_vector l1 l2 l3;
warning off all;

% Funcion que itera hasta encontrar el óptimo__________________________
[x, fval] = fsolve(@funopt,ini_vector);

% Definición de puntos_________________________________________________
x1 = x(1); y1 = x(2);
x2 = x(3); y2 = x(4);

% Cálculo de traslación de origen______________________________________
x11 = 0; y11 = 0;
x21 = (x2 - x1); y21 = (y2 - y1);

x22 = 0; y22 = 0;
x31 = (x3 - x2); y31 = (y3 - y2);

assignin('base', 'x', x); 

% Cálculo de angulos de apertura______________________________________
theta0  =   asind(y1/l1);
            theta11 = asind(x1/l1);
            theta12 = asind(y21/l2);
theta1  =   theta11 + theta12 + 90;
            theta21 = 180 - (theta12 + 90);
            theta22 = asind(y31/l3);
theta2  =   theta21 + theta22 + 90;

% Muestra de datos
set(handles.x1, 'String', num2str(x1));
set(handles.y1, 'String', num2str(y1));
set(handles.x2, 'String', num2str(x2));
set(handles.y2, 'String', num2str(y2));
set(handles.theta0, 'String', num2str(theta0));
set(handles.theta1, 'String', num2str(theta1));
set(handles.theta2, 'String', num2str(theta2));

% assignin('base', 'x11', x11); assignin('base', 'y11', y11);
% assignin('base', 'x21', x21); assignin('base', 'y21', y21);
% assignin('base', 'x22', x22); assignin('base', 'y22', y22);
% assignin('base', 'x31', x31); assignin('base', 'y31', y31);
assignin('base', 'theta0', theta0); 
% assignin('base', 'theta11', theta11); 
% assignin('base', 'theta12', theta12); 
assignin('base', 'theta1', theta1); 
% assignin('base', 'theta21', theta21); 
% assignin('base', 'theta22', theta22); 
assignin('base', 'theta2', theta2); 



function vectgraf_Callback(hObject, eventdata, handles)
global x x1 y1 x2 y2 x3 y3 theta0 theta1 theta2 ini_vector l1 l2 l3 ;
axes(handles.axes1);
line([0 x1; x1 x2; x2 x3],[0 y1; y1 y2; y2 y3]);

p0 = impoint(gca,0,0); setString(p0,'P0');
text(1,1,['Theta0 = ' num2str(round(theta0)) '°'])

p1 = impoint(gca,x1,y1); setString(p1,'P1');
text(x1-3,y1-2,['Theta1 = ' num2str(round(theta1)) '°'])

p2 = impoint(gca,x(3),x(4)); setString(p2,'P2');
text(x2-3,y2-2,['Theta2 = ' num2str(round(theta2)) '°'])
p3 = impoint(gca,x3,y3); setString(p3,'P3');

%_________________________________________________________________
%FUNCIONES QUE OBTIENEN VALORES INICIALES PARA OPTIMIZACIÓN
function X1_Callback(hObject, eventdata, handles)
global X1 ini_vector;
X1 = str2num(get(handles.X1, 'String'));
ini_vector(1) = X1;
function X1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Y1_Callback(hObject, eventdata, handles)
global Y1 ini_vector;
Y1 = str2num(get(handles.Y1, 'String'));
ini_vector(2) = Y1;
function Y1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function X2_Callback(hObject, eventdata, handles)
global X2 ini_vector;
X2 = str2num(get(handles.X2, 'String'));
ini_vector(3) = X2;
function X2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Y2_Callback(hObject, eventdata, handles)
global Y2 ini_vector;
Y2 = str2num(get(handles.Y2, 'String'));
ini_vector(4) = Y2;
function Y2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%_________________________________________________________________


% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
cla reset;

% --- Executes on button press in salir.
function salir_Callback(hObject, eventdata, handles)
close;

function x1_Callback(hObject, eventdata, handles)
function x1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function y1_Callback(hObject, eventdata, handles)
function y1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function x2_Callback(hObject, eventdata, handles)
function x2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function y2_Callback(hObject, eventdata, handles)
function y2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function theta0_Callback(hObject, eventdata, handles)
function theta0_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function theta1_Callback(hObject, eventdata, handles)
function theta1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function theta2_Callback(hObject, eventdata, handles)
function theta2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
