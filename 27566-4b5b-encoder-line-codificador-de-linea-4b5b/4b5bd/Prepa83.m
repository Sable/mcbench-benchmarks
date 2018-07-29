function varargout = Prepa83(varargin)
% PREPA83 M-file for Prepa83.fig
%      PREPA83, by itself, creates a new PREPA83 or raises the existing
%      singleton*.
%
%      H = PREPA83 returns the handle to a new PREPA83 or the handle to
%      the existing singleton*.
%
%      PREPA83('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREPA83.M with the given input arguments.
%
%      PREPA83('Property','Value',...) creates a new PREPA83 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Prepa83_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Prepa83_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Prepa83

% Last Modified by GUIDE v2.5 20-May-2008 10:19:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Prepa83_OpeningFcn, ...
                   'gui_OutputFcn',  @Prepa83_OutputFcn, ...
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


% --- Executes just before Prepa83 is made visible.
function Prepa83_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Prepa83 (see VARARGIN)

% Choose default command line output for Prepa83
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Prepa83 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
axes(handles.axes4)
background = imread('blutengelcoverfq1.jpg');
axis off;
imshow(background);
scrsz = get(0, 'ScreenSize');
pos_act=get(gcf,'Position');
xr=scrsz(3) - pos_act(3);
xp=round(xr/2);
yr=scrsz(4) - pos_act(4);
yp=round(yr/2);
set(gcf,'Position',[xp-515 yp-370 pos_act(3) pos_act(4)]);
% --- Outputs from this function are returned to the command line.
function varargout = Prepa83_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% --- Executes on button press in salir4.
function salir4_Callback(hObject, eventdata, handles)
% hObject    handle to salir4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ans=questdlg('¿Desea salir del programa?','SALIR','Si','No','No');
if strcmp(ans,'No')
    return;
end
clear,clc,close all
% --- Executes on button press in graph4.
function graph4_Callback(hObject, eventdata, handles)
% hObject    handle to graph4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(Prepa83,'Visible','off')
set(Prepa82,'Visible','on')
% --- Executes on button press in datos4.
function datos4_Callback(hObject, eventdata, handles)
% hObject    handle to datos4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(Prepa83,'Visible','off')
set(Prepa81,'Visible','on')
% --- Executes on button press in plot.
function plot_Callback(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global yf
global tb
global n
global v
global salida
global tfx
na=str2double(get(handles.input1,'string')); 
%%%%%%%%%%%%%%%%%%%%%%%
N=na;
xx=v;
a=N;
y0 = fft(xx(1:N))/N;
y = fftshift(y0); % Estos son los coeficientes c_k
eje = (-(N-1)/2:(N-1)/2);
axes(handles.axes3)
h=stem(eje,abs(y),'o');
set(h,'MarkerFaceColor','red')
hold on
plot(eje,abs(y),'r--');
set(handles.axes3,'color','green')
hold off
title('ESPECTRO DE SEÑAL DE ENTRADA EN EL CODIFICADOR');
xlabel('Eje del Frecuencia');
ylabel('Eje de Amplitud');
axis([-max(eje)-0.1*max(eje) max(eje)+0.1*max(eje) -.1 max(y)+0.2*max(y)]);
set(handles.axes3,'xminortick','on')
grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=na;
x=salida;
a=N;
y2 = fft(x(1:N))/N;
y1 = fftshift(y2); % Estos son los coeficientes c_k
eje1 = (-(N-1)/2:(N-1)/2);
grid on
axes(handles.axes1)
hh=stem(eje1,abs(y1),'o');
set(hh,'MarkerFaceColor','red','Marker','square')
hold on
plot(eje1,abs(y1),'m--')
set(handles.axes1,'color','yellow')
hold off
title('ESPECTRO DE SEÑAL CODIFICADA EN 4B/5B');
xlabel('Eje del Frecuencia');
ylabel('Eje de Amplitud');
axis([-max(eje1)-0.1*max(eje1) max(eje1)+0.1*max(eje1) -.1 max(y1)+0.2*max(y1)]);
set(handles.axes1,'xminortick','on')
grid on
function input1_Callback(hObject, eventdata, handles)
% hObject    handle to input1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input1 as text
%        str2double(get(hObject,'String')) returns contents of input1 as a double


% --- Executes during object creation, after setting all properties.
function input1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


