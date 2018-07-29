function varargout = Prepa82(varargin)
% PREPA82 M-file for Prepa82.fig
%      PREPA82, by itself, creates a new PREPA82 or raises the existing
%      singleton*.
%
%      H = PREPA82 returns the handle to a new PREPA82 or the handle to
%      the existing singleton*.
%
%      PREPA82('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREPA82.M with the given input arguments.
%
%      PREPA82('Property','Value',...) creates a new PREPA82 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Prepa82_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Prepa82_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Prepa82

% Last Modified by GUIDE v2.5 10-May-2010 22:17:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Prepa82_OpeningFcn, ...
                   'gui_OutputFcn',  @Prepa82_OutputFcn, ...
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


% --- Executes just before Prepa82 is made visible.
function Prepa82_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Prepa82 (see VARARGIN)

% Choose default command line output for Prepa82
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Prepa82 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

axes(handles.axes5)
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
function varargout = Prepa82_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in salir3.
function salir3_Callback(hObject, eventdata, handles)
% hObject    handle to salir3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ans=questdlg('¿Desea salir del programa?','SALIR','Si','No','No');
if strcmp(ans,'No')
    return;
end
clear,clc,close all



% --- Executes on button press in datos3.
function datos3_Callback(hObject, eventdata, handles)
% hObject    handle to datos3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(Prepa82,'Visible','off')
set(Prepa81,'Visible','on')

% --- Executes on button press in espectro3.
function espectro3_Callback(hObject, eventdata, handles)
% hObject    handle to espectro3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(Prepa82,'Visible','off')
set(Prepa83,'Visible','on')



% --- Executes on button press in dibujos.
function dibujos_Callback(hObject, eventdata, handles)
% hObject    handle to dibujos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global v
global tb
global yf
global n
global ys
global tfx
global salida
A=3;
a=v;
tb=(tb);
vt=1/tb;
vs=vt;
ab=vs/2;

n=length(a);
b=ones(1,n+1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function C4B5B

bits=v;
% while length(bits)<20
% bits = input ('ingrese secuencia: ','s') ;
% bits = char(bits);
% bits = str2mat(bits);
% msgbox('Debe ingresar al menos 20 bits!!!','error','error');
% end

Tb = tb;
nn = 8;

while (rem (length(bits),4) ~= 0)
   bits(length(bits)+1)=0;

end
j = 1;

for i = 1:4:length(bits)
suma(j) = 8*bits(i)+4*bits(i+1)+2*bits(i+2)+bits(i+3);
j = j + 1;
end
j = 1;
for i = 1:length(suma)
if suma(i) == 0
    codigo(j) = 1;
    codigo(j+1) = 1;
    codigo(j+2) = 1;
    codigo(j+3) = 1;
    codigo(j+4) = 0;    
end
if suma(i) == 1
    codigo(j) = 0;
    codigo(j+1) = 1;
    codigo(j+2) = 0;
    codigo(j+3) = 0;
    codigo(j+4) = 1; 
end
if suma(i) == 2
    codigo(j) = 1;
    codigo(j+1) = 0;
    codigo(j+2) = 1;
    codigo(j+3) = 0;
    codigo(j+4) = 0; 
end
if suma(i) == 3
    codigo(j) = 1;
    codigo(j+1) = 0;
    codigo(j+2) = 1;
    codigo(j+3) = 0;
    codigo(j+4) = 1; 
end
if suma(i) == 4
   codigo(j) = 0;
    codigo(j+1) = 1;
    codigo(j+2) = 0;
    codigo(j+3) = 1;
    codigo(j+4) = 0; 
end
if suma(i) == 5
    codigo(j) = 0;
    codigo(j+1) = 1;
    codigo(j+2) = 0;
    codigo(j+3) = 1;
    codigo(j+4) = 1; 
end
if suma(i) == 6
    codigo(j) = 0;
    codigo(j+1) = 1;
    codigo(j+2) = 1;
    codigo(j+3) = 1;
    codigo(j+4) = 0; 
end
if suma(i) == 7
    codigo(j) = 0;
    codigo(j+1) = 1;
    codigo(j+2) = 1;
    codigo(j+3) = 1;
    codigo(j+4) = 1; 
end
if suma(i) == 8
    codigo(j) = 1;
    codigo(j+1) = 0;
    codigo(j+2) = 0;
    codigo(j+3) = 1;
    codigo(j+4) = 0; 
end
if suma(i) == 9
    codigo(j) = 1;
    codigo(j+1) = 0;
    codigo(j+2) = 0;
    codigo(j+3) = 1;
    codigo(j+4) = 1; 
end
if suma(i) == 10
    codigo(j) = 1;
    codigo(j+1) = 0;
    codigo(j+2) = 1;
    codigo(j+3) = 1;
    codigo(j+4) = 0; 
end
if suma(i) == 11
    codigo(j) = 1;
    codigo(j+1) = 0;
    codigo(j+2) = 1;
    codigo(j+3) = 1;
    codigo(j+4) = 1; 
end
if suma(i) == 12
  codigo(j) = 1;
    codigo(j+1) = 1;
    codigo(j+2) = 0;
    codigo(j+3) = 1;
    codigo(j+4) = 0; 
end
if suma(i) == 13
    codigo(j) = 1;
    codigo(j+1) = 1;
    codigo(j+2) = 0;
    codigo(j+3) = 1;
    codigo(j+4) = 1; 
end
if suma(i) == 14
  codigo(j) = 1;
    codigo(j+1) = 1;
    codigo(j+2) = 1;
    codigo(j+3) = 0;
    codigo(j+4) = 0; 
end
if suma(i) == 15
    codigo(j) = 1;
    codigo(j+1) = 1;
    codigo(j+2) = 1;
    codigo(j+3) = 0;
    codigo(j+4) = 1; 
end
j=j+5;
end

for i = 1:length(codigo)
    salida(8*i)= codigo(i);
    salida(8*i - 1) = codigo(i);
    salida(8*i - 2) = codigo(i);
    salida(8*i - 3) = codigo(i);
    salida(8*i - 4) = codigo(i);
    salida(8*i - 5) = codigo(i);
    salida(8*i - 6) = codigo(i);
    salida(8*i - 7) = codigo(i);
end
for i = 1:length(bits)
    entrada(10*i)= bits(i);
    entrada(10*i - 1) = bits(i);
    entrada(10*i - 2) = bits(i);
    entrada(10*i - 3) = bits(i);
    entrada(10*i - 4) = bits(i);
    entrada(10*i - 5) = bits(i);
    entrada(10*i - 6) = bits(i);
    entrada(10*i - 7) = bits(i);
    entrada(10*i - 8) = bits(i);
    entrada(10*i - 9) = bits(i);
end

ts = 0:8*(length(codigo))-1;
% subplot(2,1,1),plot(ts,entrada)
% grid on
% subplot(2,1,2),plot(ts,salida)
% grid on
%end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:n
    d(i)=salida(i);
end



%Señal de reloj
fclk=ones(i,110);
for h=1:n
    for k=1:1:50
        fclk(h,k)=1;
    end     
 
    for k=51:1:100
        fclk(h,k)=0;
    end
end
y=ones(1,100);
y2=zeros(1,100);
for k=1:n
    y=fclk(k,1:100);
    y1=y;
    y=[y2 y1];
    y2=y;
end
yclk=y(101:(n+1)*100);

%Señal de Datos
fd=ones(i,110);
for i=1:n
    if a(i)~=0
        for k=1:1:100
            fd(i,k)=1;
        end                        
    else
        for k=1:1:100
             fd(i,k)=0;
        end       
   end
end
y=ones(1,100);
y2=zeros(1,100);
for k=1:n
    y=fd(k,1:100);
    y1=y;
    y=[y2 y1];
    y2=y;
end
yd=y(101:(n+1)*100);

%Señal Codificada
bx=length(salida);
fd=ones(i,110);
for i=1:bx
    if salida(i)~=0
        for k=1:1:100
            fd(i,k)=1;
        end                        
    else
        for k=1:1:100
             fd(i,k)=0;
        end       
   end
end
y=ones(1,100);
y2=zeros(1,100);
for k=1:bx
    y=fd(k,1:100);
    y1=y;
    y=[y2 y1];
    y2=y;
end
ys=y(101:(bx+1)*100);

%Eje del tiempo
tb1=(4/5)*tb;
t=0:tb1/100:bx*tb1;
for i=1:1:(100*bx)
    tfx(i)=t(i);
end


%Eje del tiempo
t=0:tb/100:n*tb;
for i=1:1:(100*n)
    tf(i)=t(i);
end



axes(handles.axes1)

plot(tf,yclk,'r.-');
title('SEÑAL DE RELOJ');
xlabel('Eje del Tiempo');
ylabel('Eje de Amplitud');
axis([-1 n*tb+1 -0.1 1.1]);
set(handles.axes1,'color','green')
set(handles.axes1,'xminortick','on')
grid on
axes(handles.axes2)
plot(tf,yd,'b.-');
title('SEÑAL DE DATOS');
xlabel('Eje del Tiempo');
ylabel('Eje de Amplitud');
axis([-1 n*tb+1 -0.1 1.1]);
set(handles.axes2,'color','yellow')
set(handles.axes2,'xminortick','on')
grid on
axes(handles.axes3)
plot(tfx./10,ys,'m.-');
title('SEÑAL CODIFICADA EN 4B/5B');
xlabel('Eje del Tiempo');
ylabel('Eje de Amplitud');
axis([-1 ((bx*(tb1))./10)+1 -.1 1.1]);
set(handles.axes3,'color','cyan')
set(handles.axes3,'xminortick','on')
grid on
