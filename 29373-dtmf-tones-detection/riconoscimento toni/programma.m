function varargout = programma(varargin)
% PROGRAMMA M-file for programma.fig
%      PROGRAMMA, by itself, creates a new PROGRAMMA or raises the existing
%      singleton*.
%
%      H = PROGRAMMA returns the handle to a new PROGRAMMA or the handle to
%      the existing singleton*.
%
%      PROGRAMMA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROGRAMMA.M with the given input arguments.
%
%      PROGRAMMA('Property','Value',...) creates a new PROGRAMMA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before programma_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to programma_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help programma

% Last Modified by GUIDE v2.5 16-Jul-2010 18:05:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @programma_OpeningFcn, ...
                   'gui_OutputFcn',  @programma_OutputFcn, ...
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


% --- Executes just before programma is made visible.
function programma_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to programma (see VARARGIN)

% Choose default command line output for programma
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes programma wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = programma_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
help1
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
global f
global modulo
figure
plot(f,modulo)
title('FFT')
xlabel('frequenza [Hz]')
ylabel('ampiezza')
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global f
global modulo
suono=wavrecord(8000*3,8000,1);                         % registro suono di 3 secondi a 8000 Hz
[f,modulo]=transform(suono);                            % elaboro la fft
num=detection_final(f,modulo);                          % rilevamento toni. Restituisce il nome dell'immagine relativa al tasto premuto o in alternativa il nome di un messaggio di errore
% VISUALIZZAZIONE A VIDEO
nome_img_display=strcat(num,'.bmp');                    % compongo il nome dell'immagine da visualizzare
display=imread(nome_img_display);                       % leggo immagine
imshow(display)                                         % mostro l'immagine
% MODIFICA DELL'EDIT TEXT
stringa=get(handles.edit1,'String');                    % prendo la stringa nell'edit text
if (strcmp(num,'cancelletto') || strcmp(num,'asterisco') || strcmp(num,'errore'))==false      % creo la nuova stringa
    stringa=strcat(stringa,num);
elseif strcmp(num,'cancelletto')
    stringa=strcat(stringa,'#');
elseif strcmp(num,'asterisco')
    stringa=strcat(stringa,'*');
end
set(handles.edit1,'String',stringa);                    % aggiungo la nuova stringa nell'edit text

% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
set(handles.edit1,'String', '')
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


