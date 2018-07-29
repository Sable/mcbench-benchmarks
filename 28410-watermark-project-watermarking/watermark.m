function varargout = watermark(varargin)
% WATERMARK M-file for watermark.fig
%      WATERMARK, by itself, creates a new WATERMARK or raises the existing
%      singleton*.
%
%      H = WATERMARK returns the handle to a new WATERMARK or the handle to
%      the existing singleton*.
%
%      WATERMARK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WATERMARK.M with the given input arguments.
%
%      WATERMARK('Property','Value',...) creates a new WATERMARK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before watermark_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to watermark_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help watermark

% Last Modified by GUIDE v2.5 15-Jul-2010 19:31:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @watermark_OpeningFcn, ...
                   'gui_OutputFcn',  @watermark_OutputFcn, ...
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


% --- Executes just before watermark is made visible.
function watermark_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to watermark (see VARARGIN)

% Choose default command line output for watermark
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global key          %Fisso una variabile globale key
if isempty(key)     %Controllo se sono già state inizializzate le variabili globali
key=0;              %La inizializzo a 0 (nessuna key)
global ext_out      %Fisso una variabile globale ext_out che conterrà l'estensione del file di output
ext_out='bmp';      %La fisso a bmp (file bitmap)
global w_type       %Fisso una variabile globale per il tipo di watermark
w_type=0;           %La inizializzo a 0 (type: text)
end
% UIWAIT makes watermark wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = watermark_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text8,'String','Watermarking..');                                %Notifico l'inizio delle operazioni di watermarking
img_in=get(handles.edit1,'String');                                          %Acquisisco il nome o il path del file di input
if isempty(img_in)                                                           %Controllo se è vuoto
    set(handles.text8,'String','Nessun file Immagine specificato!');         %Notifico l'evento
    return                                                                   %Esco dalla funzione
end
img=imread(img_in);                                                          %Leggo l'immagine di input
st='';                                                                       %Creo una variabile stringa vuota
watermark=get(handles.edit5,'String');                                       %Leggo la stringa che rappresenta il watermark
global key                                                                   %Utilizzo la variabile globale key
global ext_out                                                               %Utilizzo la variabile globale ext_out
global w_type                                                                %Utilizzo la variabile globale w_type
imgw=0;                                                                      %Creo un contenitore per l'immagine watermarked
k_plot=1;                                                                       

if key==0                                                                    %Controllo se si vole utilizzare una key
    if w_type==0                                                             %Type: Text
        [imgw st]=watermark_k(img,watermark);                                %Richiamo la function watermark_k senza key
    else
        [imgw st]=watermark_img(img,imread(watermark));                      %Richiamo la function watermark_img senza key 
        k_plot=2;
    end
else
    if w_type==0 
        [imgw st]=watermark_k(img,watermark,str2num(get(handles.edit8,'String')));            %Richiamo la function watermark_k con key
    else
        [imgw st]=watermark_img(img,imread(watermark),str2num(get(handles.edit8,'String')));  %Richiamo la function watermark_img con key
        k_plot=2;
    end
end

img_out=get(handles.edit3,'String');                                         %Acquisisco il nome del file output
imwrite(imgw,[img_out '.' ext_out],ext_out);                                 %Scrivo l'immagine watermarked su disco
set(handles.text8,'String',st);                                              %Notifico lo stato delle operazioni

figure                                                                       %Apro una nuova figure
subplot(k_plot,2,1)                                                          %Effettuo un subplot
imshow(img)                                                                  %Mostro l'immagine originale
title(['Immagine Originale: "' img_in '"'])                                  %Fisso il titolo
subplot(k_plot,2,2)                                                          %Seleziono la seconda finestra di subplot
imshow(imgw)                                                                 %Mostro l'immagine watermarked       
title(['Immagine Watermarked: "' img_out '.' ext_out '"'])                   %Fisso il titolo

if w_type==1                                                                 %Se il watermark è di tipo image 
    subplot(2,2,3)                                                           %Effettuo un subplot
    imshow(watermark)                                                        %Mostro l'immagine watermark
    title(['Watermark: "' watermark '"'])                                    %Fisso il titolo
end

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global key
key=1-key;                  %Aggiorno la variabile globale key, a 1 se era 0 e viceversa
% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ext_out
ext_out='bmp';              %Aggiorno la variabile globale ext_out a bmp (bitmap)
% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ext_out
ext_out='png';              %Aggiorno la variabile globale ext_out a png
% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ext_out
ext_out='tiff';             %Aggiorno la variabile globale ext_out a tiff
% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global w_type
w_type=0;     %Type: Text
% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global w_type
w_type=1;     %Type: Image
% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)      

%Elimino le variabili globali
clear global key
clear global ext_out
clear global w_type
% Hint: delete(hObject) closes the figure
delete(hObject);


