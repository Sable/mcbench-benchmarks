function varargout = corrector_vocales(varargin)
% corrector_vocales M-file for corrector_vocales.fig
%      corrector_vocales, by itself, creates a new corrector_vocales or raises the existing
%      singleton*.
%
%      H = corrector_vocales returns the handle to a new corrector_vocales or the handle to
%      the existing singleton*.
%
%      corrector_vocales('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in corrector_vocales.M with the given input arguments.
%
%      corrector_vocales('Property','Value',...) creates a new corrector_vocales or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before corrector_vocales_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to corrector_vocales_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help corrector_vocales

% Last Modified by GUIDE v2.5 22-Nov-2011 23:44:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @corrector_vocales_OpeningFcn, ...
                   'gui_OutputFcn',  @corrector_vocales_OutputFcn, ...
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


% --- Executes just before corrector_vocales is made visible.
function corrector_vocales_OpeningFcn(hObject, eventdata, handles, varargin)
imagen=imread('Jade.jpg');
image(imagen)
axis off

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to corrector_vocales (see VARARGIN)

% Choose default command line output for corrector_vocales
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes corrector_vocales wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = corrector_vocales_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function b1_Callback(hObject, eventdata, handles)

% hObject    handle to b1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of b1 as text
%        str2double(get(hObject,'String')) returns contents of b1 as a double


% --- Executes during object creation, after setting all properties.
function b1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in boton.
function boton_Callback(hObject, eventdata, handles)

dig1=get(handles.b1,'string');
dig_1=str2num(dig1);
m=dig_1;
a=m(1); b=m(2); c=m(3); d=m(4); e=m(5); f=m(6); g=m(7);
vector=[a b c d e f g];
datoin=num2str(vector);
set(handles.d1,'string',datoin);

% se definen las posiciones de cada bit ingresado.

d11=a; d10=b; d9=c; d7=d; d6=e; d5=f; d3=g;

% ahora hay que determinar los bits faltantes

d_8=xor(d9,d10);  d8=xor(d_8,d11);
d_4=xor(d5,d6);   d4=xor(d_4,d7);
d_2=xor(d3,d6);   d_21=xor(d7,d10);  d_22=xor(d_2,d_21);  d2=xor(d_22,d11);
d_1=xor(d3,d5);   d_11=xor(d7,d9);   d_12=xor(d_1,d_11);  d1=xor(d_12,d11);

Tx=[d11 d10 d9 d8 d7 d6 d5 d4 d3 d2 d1]; % dato a transmitir
datoTx=num2str(Tx);
set(handles.d2,'string',datoTx);

dig2=get(handles.b2,'string');
dig_2=str2num(dig2);
n=dig_2;

A=n(1); B=n(2); C=n(3); D=n(4); E=n(5); F=n(6); G=n(7); H=n(8); I=n(9); J=n(10); K=n(11);

vector2=[A B C D E F G H I J K];
datoin2=num2str(vector2);
set(handles.d3,'string',datoin2);

% se definen las posiciones de cada bit ingresado
                                             
D11=A; D10=B; D9=C; D8=D; D7=E; D6=F; D5=G; D4=H; D3=I; D2=J; D1=K;

vector2=[A B C D E F G H I J K];
datoin2=num2str(vector2);
set(handles.d3,'string',datoin2);

% se determinan los ¨coeficientes¨ C0, C1, C2, C3 

C_0=xor(D1,D3);  C_01=xor(D5,D7);   C_02=xor(C_0,C_01);  C_03=xor(D9,D11);  C0=xor(C_03,C_02);                           
C_1=xor(D2,D3);  C_11=xor(D6,D7);   C_12=xor(C_1,C_11);  C_13=xor(D10,D11); C1=xor(C_13,C_12);
C_2=xor(D4,D5);  C_21=xor(D6,D7);   C2=xor(C_2,C_21);
C_3=xor(D8,D9);  C_31=xor(D10,D11); C3=xor(C_3,C_31);

% teeniendo en ceunta que se esta trabajando con una paridad par
if (C0~=1 && C1~=1 && C2~=1 && C3~=1)
    set(handles.errorSN,'string','el dato llego sin error');  set(handles.PosicionError,'string',':p'); 
                           set(handles.corregir,'string',':p :p :p :p :p :p'); 
    
% mensaje indicando que el dato ha llegado correctamente
else
posicion= C3*8+C2*4+C1*2+C0*1; % se hay error se determina las posicion
                               
set(handles.errorSN,'string','error en la posicion'); set(handles.PosicionError,'string',posicion);

Rxcor=[A B C D E F G H I J K];
RxCorregido=Rxcor;

for i=1:1:12-posicion
 RxCorregido(12-posicion)=[not(Rxcor(12-posicion))];
end
RxCorregido

Rx=num2str(RxCorregido);
set(handles.corregir,'string',Rx);  % se visuliza mensaje corregido
                                                       
end;

% hObject    handle to boton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function b2_Callback(hObject, eventdata, handles)
% hObject    handle to b2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of b2 as text
%        str2double(get(hObject,'String')) returns contents of b2 as a double


% --- Executes during object creation, after setting all properties.
function b2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in referencia.
function referencia_Callback(hObject, eventdata, handles)

dig1=get(handles.b1,'string');
dig_1=str2num(dig1);
m=dig_1;
a=m(1); b=m(2); c=m(3); d=m(4); e=m(5); f=m(6); g=m(7);

vector=[a b c d e f g];
datoin=num2str(vector);
set(handles.d1,'string',datoin);

d11=a; d10=b; d9=c; d7=d; d6=e; d5=f; d3=g;

d_8=xor(d9,d10);  d8=xor(d_8,d11);
d_4=xor(d5,d6);   d4=xor(d_4,d7);
d_2=xor(d3,d6);   d_21=xor(d7,d10);  d_22=xor(d_2,d_21);  d2=xor(d_22,d11);
d_1=xor(d3,d5);   d_11=xor(d7,d9);   d_12=xor(d_1,d_11);  d1=xor(d_12,d11);

Tx=[d11 d10 d9 d8 d7 d6 d5 d4 d3 d2 d1]; % dato a transmitir
datoTx=num2str(Tx);
set(handles.d2,'string',datoTx);

set(handles.errorSN,'string',' '); set(handles.PosicionError,'string',' ');
set(handles.corregir,'string',' ');  set(handles.d3,'string',' ');

% hObject    handle to referencia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
