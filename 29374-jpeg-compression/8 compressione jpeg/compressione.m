function varargout = compressione(varargin)


% COMPRESSIONE M-file for compressione.fig
%      COMPRESSIONE, by itself, creates a new COMPRESSIONE or raises the existing
%      singleton*.
%
%      H = COMPRESSIONE returns the handle to a new COMPRESSIONE or the handle to
%      the existing singleton*.
%
%      COMPRESSIONE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPRESSIONE.M with the given input arguments.
%
%      COMPRESSIONE('Property','Value',...) creates a new COMPRESSIONE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before compressione_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to compressione_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help compressione

% Last Modified by GUIDE v2.5 16-Jun-2010 15:02:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @compressione_OpeningFcn, ...
                   'gui_OutputFcn',  @compressione_OutputFcn, ...
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


% --- Executes just before compressione is made visible.
function compressione_OpeningFcn(hObject, eventdata, handles, varargin)
global flag;                                                                % inizializzo flag=1
flag=1;
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to compressione (see VARARGIN)

% Choose default command line output for compressione
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes compressione wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = compressione_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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
compressione_help                                                           % richiama una schermata di help
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global flag;                                                                % variabili globali
global livello;
global originale_bn
global trasformata_bn
global compressa_bn
global originale_c
global trasformata_c
global compressa_c
livello=cast(str2num(get(handles.edit2, 'string')), 'int8');                % leggo il livello di compressione e lo converto in int
if (isinteger(livello) && (livello<9) && (livello>0))==false                % se esso non è compreso tra 1 e 8 dò errore
    disp('devi inserire un numero intero compreso tra 1 e 8!!!')
else
nome_img=get(handles.edit1, 'String');                                      % altrimenti leggo il nome dell'immagine e la memorizzo
img=imread(nome_img);
T=dctmtx(8);                                                                % matrice di trasformazione 8x8
fun=@(x)(T*x*T');                                                           % trasformata coseno
mask=zeros(8);                                                              % la maschera è inizializzata a zero
invdct=@(x)(T'*x*T);                                                        % antitrasformata
if flag==0                                                                  % se flag==0 comprimo in b/n
    imgbn=0.299.*img(:,:,1)+ 0.587.*img(:,:,2)+ 0.114.*img(:,:,3);
    originale_bn=imgbn;                                                     % estraggo la componente b/n
    B_bn=blkproc(im2double(imgbn), [8 8], fun);                             % la trasformo a blocchi 8x8
    mask(1:livello , 1:livello)=1;                                          % preparo la maschera
    B_bn_jpg_trasf=blkproc(B_bn, [8 8], @(x)(mask.*x));
    trasformata_bn=B_bn_jpg_trasf;                                          % la applico alla trasformata
    B_bn_jpg=blkproc(B_bn_jpg_trasf, [8 8], invdct);
    compressa_bn=B_bn_jpg;                                                  % antitrasformo
    axes(handles.axes1)
    imshow (B_bn_jpg, [])                                                   % mostro l'immagine compressa
elseif flag~=0
    imgc=im2double(img);
    originale_c=imgc;
    for i=1:3                                                               % faccio la stessa cosa però per ogni componente di colore
        B_c(:,:,i)=blkproc(imgc(:,:,i), [8 8], fun);
        mask(1:livello , 1:livello)=1;
        app=B_c(:,:,i);
        B_c_jpg_trasf(:,:,i)=blkproc(app, [8 8], @(x)(mask.*x));
        B_c_jpg(:,:,i)=blkproc(B_c_jpg_trasf(:,:,i), [8 8], invdct);
    end
        trasformata_c=B_c_jpg_trasf;
        compressa_c=B_c_jpg;
        axes(handles.axes1)
        imshow(B_c_jpg)                                                     % mostro l'immagine compressa a colori
end
end

            
    
    
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
global flag;
global livello;
global originale_bn
global trasformata_bn
global compressa_bn
global originale_c
global trasformata_c
global compressa_c

pushbutton3_Callback(hObject, eventdata, handles)                           % voglio una visualizzazione più dettagliata
                                                                            % allora come prima cosa richiamo la funzione che comprime le 
                                                                            % immagini e poi faccio un subplot in cui mostro in ordine
figure                                                                      % IMMAGINE ORIGINALE; 
                                                                            % TRASFORMATA A CUI E' STATA APPLICATA LA MASCHERA;
                                                                            % IMMAGINE COMPRESSA.

subplot(1,3,1)
if flag==0
    imshow(originale_bn,[])
else
    imshow(originale_c)
end
title('immagine originale')


subplot(1,3,2)
if flag==0
    imshow(trasformata_bn)
else 
    imshow(trasformata_c)
end
title('trasformata al livello di compressione desiderato')


subplot(1,3,3)
if flag==0
    imshow(compressa_bn, [])
else
    imshow(compressa_c)
end
title('immagine compressa')

% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
global flag;
flag=0;                                                                     % FLAG==0 : bianco e nero
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
global flag;
flag=1;                                                                     % FLAG==1 : a colori
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


