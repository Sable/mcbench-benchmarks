function varargout = transport(varargin)
% TRANSPORT M-file for transport.fig
%      TRANSPORT, by itself, creates a new TRANSPORT or raises the existing
%      singleton*.
%
%      H = TRANSPORT returns the handle to a new TRANSPORT or the handle to
%      the existing singleton*.
%
%      TRANSPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRANSPORT.M with the given input arguments.
%
%      TRANSPORT('Property','Value',...) creates a new TRANSPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before transport_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to transport_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help transport

% Last Modified by GUIDE v2.5 29-Sep-2006 10:29:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @transport_OpeningFcn, ...
                   'gui_OutputFcn',  @transport_OutputFcn, ...
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


% --- Executes just before transport is made visible.
function transport_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to transport (see VARARGIN)

% Choose default command line output for transport
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes transport wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = transport_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function D_edit_Callback(hObject, eventdata, handles)
% hObject    handle to D_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of D_edit as text
%        str2double(get(hObject,'String')) returns contents of D_edit as a double


% --- Executes during object creation, after setting all properties.
function D_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to D_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function v_edit_Callback(hObject, eventdata, handles)
% hObject    handle to v_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v_edit as text
%        str2double(get(hObject,'String')) returns contents of v_edit as a double


% --- Executes during object creation, after setting all properties.


function v_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function R_edit_Callback(hObject, eventdata, handles)
% hObject    handle to R_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R_edit as text
%        str2double(get(hObject,'String')) returns contents of R_edit as a double


% --- Executes during object creation, after setting all properties.
function R_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function T_edit_Callback(hObject, eventdata, handles)
% hObject    handle to T_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_edit as text
%        str2double(get(hObject,'String')) returns contents of T_edit as a double


% --- Executes during object creation, after setting all properties.
function T_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function lambda_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lambda_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lambda_edit as text
%        str2double(get(hObject,'String')) returns contents of lambda_edit as a double


% --- Executes during object creation, after setting all properties.
function lambda_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lambda_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function L_edit_Callback(hObject, eventdata, handles)
% hObject    handle to L_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of L_edit as text
%        str2double(get(hObject,'String')) returns contents of L_edit as a double


% --- Executes during object creation, after setting all properties.
function L_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to L_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in runbutton.
function runbutton_Callback(hObject, eventdata, handles)
% hObject    handle to runbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get user input from GUI
D = str2double(get(handles.D_edit,'String'));
v = str2double(get(handles.v_edit,'String'));
R = str2double(get(handles.R_edit,'String'));
lambda = str2double(get(handles.lambda_edit,'String'));
T = str2double(get(handles.T_edit,'String'));
L = str2double(get(handles.L_edit,'String'));
c0 = 0;   % initial concentration
cin = 1;   % inflow concentration

%Calculate data
y ='rgbcmyk';
e = ones (1,100);
u = sqrt(v*v+4*lambda*R*D);

% Create space plot

t = linspace (T/10,T,10);
axes(handles.xaxes);
x = linspace(0,L,100); 
for i = 1:size(t,2)
    h = 1./(2.*sqrt(D*R*t(i)));  
    hh = plot (x,c0*exp(-lambda*t(i))*(e-0.5*erfc(h*(R*x-e*v*t(i)))-...
        0.5*exp((v/D)*x).*erfc(h*(R*x+e*v*t(i)))) +...
        (cin-c0)*0.5*(exp((v-u)/(D+D)*x).*erfc(h*(R*x-e*u*t(i)))+...
        exp((v+u)/(D+D)*x).*erfc(h*(R*x+e*u*t(i)))),y(mod(i,7)+1));
    set (hh,'LineWidth',2)
    hold on;     
end
ylim ([0 1]);
grid on
hold off

% Create time plot
x = linspace (L/10,L,10);
axes(handles.taxes);
t = linspace (T/100,T,100);
h = 1./(2.*sqrt(D*R*t));
for i = 1:size(x,2)
    hh = plot(t,c0*exp(-lambda*t).*(e-0.5*erfc(h.*(e*R*x(i)-v*t)))-...
        0.5*exp((v/D)*x(i))*erfc(h.*(e*R*x(i)+v*t))+...
        (cin-c0)*0.5*(exp((v-u)/(D+D)*x(i))*erfc(h.*(e*R*x(i)-u*t))+...
        exp((v+u)/(D+D)*x(i))*erfc(h.*(e*R*x(i)+u*t))),y(mod(i,7)+1)); 
    set (hh,'LineWidth',2)
    hold on; 
end
ylim ([0 1]);
grid on
hold off


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
val = get(hObject,'Value');
switch val
case 1
    msgbox('E. Holzbecher, WIAS, Mohrenstr. 39, 10117 Berlin, GERMANY, E-mail: holzbecher@wias-berlin.de','Info','none'); 
    web http://www.igb-berlin.de/abt1/mitarbeiter/holzbecher/index_e.shtml;
    uiwait;
case 2
    msgbox('Environmental Modelling using MATLAB, Springer Publ.','Info','none');
case 3
    msgbox('For selected transport parameters (diffusivity, velocity, degradation, retardation) normalized concentrations are plotted as function of space (at 10 equidistant time instants) and as function of time (at 10 equidistant locations).');
case 4    
    msgbox('Springer Publ., Heidelberg','Info','none');
    web www.springer.com;
    uiwait;
case 5
    msgbox('MATLAB, MathWorks Inc, see: www.mathworks.com', 'Info','none'); 
    web www.mathworks.com;
    uiwait;        
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


