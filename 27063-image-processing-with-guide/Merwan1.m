function varargout = Merwan1(varargin)
% MERWAN1 M-file for Merwan1.fig
%      MERWAN1, by itself, creates a new MERWAN1 or raises the existing
%      singleton*.
%
%      H = MERWAN1 returns the handle to a new MERWAN1 or the handle to
%      the existing singleton*.
%
%      MERWAN1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MERWAN1.M with the given input arguments.
%
%      MERWAN1('Property','Value',...) creates a new MERWAN1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Merwan1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Merwan1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Merwan1

% Last Modified by GUIDE v2.5 13-Jun-2009 10:01:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Merwan1_OpeningFcn, ...
                   'gui_OutputFcn',  @Merwan1_OutputFcn, ...
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


% --- Executes just before Merwan1 is made visible.
function Merwan1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Merwan1 (see VARARGIN)

% Choose default command line output for Merwan1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
movegui(hObject,'onscreen')% To display application onscreen
movegui(hObject,'center')  % To display application in the center of screen
subplot(1,1,1);
a=imread('intro.jpg');
imshow(a);

% UIWAIT makes Merwan1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
clear all
clc
axis off
hold off

% --- Outputs from this function are returned to the command line.
function varargout = Merwan1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%**************************************************************************
%******************************* Bouton ************************************
function Browsebutton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function Browsebutton_Callback(hObject, eventdata, handles)
% hObject    handle to Browsebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Charger une image.');
set(handles.param,'string','Parametre de la méthode utiliser.');
global IMG ORI_IMG M N m1 m2 IMGM alpha segma beta valn choix filename
alpha=0.2; segma=0.5; beta=0.5; valn=0.3; choix=0;
% Loading the Image
[filename, pathname, filterindex]=uigetfile( ...
    {'*.jpg','JPEG File (*.jpg)'; ...
     '*.*','Any Image file (*.*)'}, ...
     'Pick an image file');
if (filename~=0)
    var=strcat(pathname,filename);
    ORI_IMG=imread(var);
    [M,N,t]=size(ORI_IMG);
    IMG=ORI_IMG;
    IMGM=IMG;
    if (t~=1)
        IMG=rgb2gray(ORI_IMG);
    end
    IMGM=IMG;
    % Showing the origional image
    subplot(1,1,1);   % Deleting all subplots present
    imshow(ORI_IMG);
    %Affichage des propreuites de l'image:
    Moy=(sum(sum(IMG)))/(M*N);
    m1=max(max(IMG));   m2=min(min(IMG));
    set(handles.calcul_de_moyenne,'string',Moy);
    set(handles.taille1,'string',M);
    set(handles.taille2,'string',N);
end
set(handles.methode,'string','rien.');
set(handles.timel,'string',toc);   % Displaying elapsed time


function Savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to Savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Enregistrement de la vouvel image.');
global IMGM
image=uint8(IMGM);
% Saving the rotated image
[filename,pathname] = uiputfile( ...
       {'*.jpg', 'JPEG Image File'; ...
        '*.*',   'All Files (*.*)'}, ...
        'Save current image as');
    
if (filename~=0)
        var=strcat(pathname,filename);
        imwrite(image,var);
end
set(handles.methode,'string','rien');
set(handles.timel,'string',toc);   % Displaying elapsed time

%**************************************************************************
%******************************* Checkbox **********************************
function ShowOrigional_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to ShowOrigional_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ShowOrigional_checkbox
tic   % Starting Stopwatch Timer
global IMG IMGM choix M N
if (get(handles.ShowOrigional_checkbox,'Value') == 0),
    subplot(1,1,1);   % Deleting all subplots present
    imshow(IMG);title('Image originale.');
    set(handles.methode,'string','Voir l image originale.');
else
    subplot(1,2,1), imshow(IMG); title('Image originale.'); % Displaying origional image
    if choix~=15
        subplot(1,2,2), imshow(IMGM); title('Image apres traitement.');  % Displaying the rotated image
    else
        subplot(1,2,2), imshow(IMGM,[]); axis([1 N 1 M]);
        title('Image apres traitement.');  % Displaying the rotated image
    end
   set(handles.methode,'string','Voir limage avans et apres modification.');
end
set(handles.timel,'string',toc);   % Displaying elapsed time

%**************************************************************************
%******************************* Slide bar ***********************************
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global val valn choix
val = get(hObject,'Value');
valn=val;
set(handles.valeur,'string',valn);
%set(handles.taille1,'string',val); seilement pour verifier.
switch choix
        case 0 
            % ne rien fair 
end

function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%**************************************************************************
%******************************* zone de texte ******************************
function calcul_de_moyenne_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Moyenne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));

function calcul_de_moyenne_Callback(hObject, eventdata, handles)
% hObject    handle to ElpasedTime_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of ElpasedTime_edit as text
%        str2double(get(hObject,'String')) returns contents of ElpasedTime_edit as a double

function taille1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ElpasedTime_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));

function taille2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ElpasedTime_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));

function valeur_Callback(hObject, eventdata, handles)
% hObject    handle to valeur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of valeur as text
%        str2double(get(hObject,'String')) returns contents of valeur as a double
global val valn
val = get(handles.valeur,'String');
valn=str2num(val);
if valn<0
    valn=0.3;
elseif valn>1
    valn=0.3;
end
set(handles.slider1,'Value',valn);

function valeur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valeur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function timel_Callback(hObject, eventdata, handles)
% hObject    handle to ElpasedTime_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function timel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
%**************************************************************************
%******************************* File ***************************************
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Charger une image.');
global IMG ORI_IMG M N m1 m2 IMGM alpha segma beta valn choix
alpha=0.2; segma=0.5; beta=0.5; valn=0.3; choix=0;
% Loading the Image
[filename, pathname, filterindex]=uigetfile( ...
    {'*.jpg','JPEG File (*.jpg)'; ...
     '*.*','Any Image file (*.*)'}, ...
     'Pick an image file');
if (filename~=0)
    var=strcat(pathname,filename);
    ORI_IMG=imread(var);
    [M,N,t]=size(ORI_IMG);
    IMG=ORI_IMG;
    if (t~=1)
        IMG=rgb2gray(ORI_IMG);
    end
    IMGM =IMG;
    % Showing the origional image
    subplot(1,1,1);   % Deleting all subplots present
    imshow(ORI_IMG);
    %Affichage des propreuites de l'image:
    Moy=(sum(sum(IMG)))/(M*N);
    m1=max(max(IMG));   m2=min(min(IMG));
    set(handles.calcul_de_moyenne,'string',Moy);
    set(handles.taille1,'string',M);
    set(handles.taille2,'string',N);
end
set(handles.methode,'string','rien');
set(handles.timel,'string',toc);   % Displaying elapsed time

function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Enregistrement de la vouvel image.');
global IMGM 
image=uint8(IMGM);
% Saving the rotated image
[filename,pathname] = uiputfile( ...
       {'*.jpg', 'JPEG Image File'; ...
        '*.*',   'All Files (*.*)'}, ...
        'Save current image as');
    if (filename~=0)
        var=strcat(pathname,filename);
        imwrite(image,var);
    end
set(handles.methode,'string','rien');
set(handles.timel,'string',toc);   % Displaying elapsed time

function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

%**************************************************************************
%*********************** Rehaussement d'image *******************************
function Rehaussemnt_Callback(hObject, eventdata, handles)
% hObject    handle to Rehaussemnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Extension_Callback(hObject, eventdata, handles)
% hObject    handle to Extension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Extension de la dynamique d image.');
global IMG EIMG m2 m1 IMGM choix
choix=16;
a=255/(m1-m2);
EIMG= a*(IMG-m2);
subplot(1,1,1);   % Deleting all subplots present
imshow(EIMG);
title('Image apres extension de sa dynamique');
IMGM=EIMG;
set(handles.param,'string','Parametre de la méthode utiliser.');
set(handles.valeur,'string',0);
set(handles.slider1,'value',0);
set(handles.timel,'string',toc);   % Displaying elapsed time

function Egalisation_Callback(hObject, eventdata, handles)
% hObject    handle to Egalisation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Egalisation de l hystogramme dimage.');
global IMG HIMG IMGM choix
choix=17;
HIMG=histeq(IMG);
subplot(1,1,1);   % Deleting all subplots present
imshow(HIMG);
title('Image apres egalisation d hystogramme');
IMGM=HIMG;
set(handles.param,'string','Parametre de la méthode utiliser.');
set(handles.valeur,'string',0);
set(handles.slider1,'value',0);
set(handles.timel,'string',toc);   % Displaying elapsed time

function Renforcement_contraste_Callback(hObject, eventdata, handles)
% hObject    handle to Renforcement_contraste (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Renforcement de la contraste d image');
global IMG RIMG IMGM alpha valn choix
choix=1;
alpha=valn;
if valn<0
    alpha=0.2;
elseif valn>1
    alpha=0.2;
end
H = fspecial('unsharp',alpha);%H = FSPECIAL('unsharp',ALPHA) returns a 3-by-3 unsharp contrast
    %enhancement filter. FSPECIAL creates the unsharp filter from the
    %negative of the Laplacian filter with parameter ALPHA. ALPHA controls
    %the shape of the Laplacian and must be in the range 0.0 to 1.0.
    %The default ALPHA is 0.2.
RIMG = filter2(H,IMG)/255;
%RIMG = imfilter(IMG,H,'replicate');
subplot(1,1,1);   % Deleting all subplots present
imshow(RIMG);title(strcat('Renforcement de la contrste d image avec alpha=',num2str(alpha)));
IMGM=RIMG;
set(handles.valeur,'string',alpha);
set(handles.slider1,'value',alpha);
set(handles.param,'string','La valeur de alpha doit etre entre 0 et 1.');
set(handles.timel,'string',toc);   % Displaying elapsed time

%**************************************************************************
%******************************* Filtrage ************************************
function Filtrage_Callback(hObject, eventdata, handles)
% hObject    handle to Filtrage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Filtre_lineaire_Callback(hObject, eventdata, handles)
% hObject    handle to Filtre_lineaire (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Moyenneur_Callback(hObject, eventdata, handles)
% hObject    handle to Moyenneur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Utilisation du filtre moyenneur');
global IMG F1IMG IMGM M N  choix
choix=0;
a=5;
F1IMG=IMG;
F1=1+0*IMG;
F1=F1(1:a,1:a);
A=filter2(F1,IMG,'same');
A=A/a^2;
A=ceil(A);
for i=1:M; for j=1:N; F1IMG(i,j)=A(i,j); end; end;
subplot(1,1,1);   % Deleting all subplots present
imshow(F1IMG);title('Application du filtre moyenneur 5x5');
IMGM=F1IMG;
set(handles.param,'string','Parametre de la méthode utiliser.');
set(handles.valeur,'string',0);
set(handles.slider1,'value',0);
set(handles.timel,'string',toc);   % Displaying elapsed time

function Gaussien_Callback(hObject, eventdata, handles)
% hObject    handle to Gaussien (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Utilisation du filtre gaussien');
global IMG F2IMG IMGM M N valn segma choix
choix=2;
if valn<0
    segma=1;
elseif valn>1
    segma=1;
else
    segma=valn*5;
end
F2IMG=IMG;
a=5;  c=(a-1)/2;
F2=zeros(a,a);
for i=1:a; for j=1:a; F2(i,j)=(1/(2*pi*segma^2))*exp(-((-c-1+i)^2+(-c-1+j)^2)/(2*segma^2)); end, end;
s=sum(sum(F2));
F2=F2/s;
A=imfilter(IMG,F2,'same');
for i=1:M; for j=1:N; F2IMG(i,j)=A(i,j); end; end;
%m3=max(max(F2IMG));  m4=min(min(F2IMG));
%a=255/(m3-m4);
%F2IMG= a*(F2IMG-m4);
subplot(1,1,1);   % Deleting all subplots present
imshow(F2IMG);title(strcat('Application du filtre gaussien avec segma=',num2str(segma)));
IMGM=F2IMG;
set(handles.valeur,'string',segma/5);
set(handles.slider1,'value',segma/5);
set(handles.param,'string','La valeur de segma apartient [0,5].');
set(handles.timel,'string',toc);   % Displaying elapsed time

function Exponentiel_Callback(hObject, eventdata, handles)
% hObject    handle to Exponentiel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Utilisation du filtre exponentiel');
global IMG F3IMG IMGM M N valn beta choix
choix=3;
if valn<0
    beta=1;
elseif valn>1
    beta=1;
else
    beta=valn*5;
end
F3IMG=IMG;
a=5;  c=(a-1)/2;
F3=zeros(a,a);
for i=1:a; for j=1:a; F3(i,j)=((beta^2)/4)*exp(-beta*(abs(-c-1+i)+abs(-c-1+j))); end; end;
s=sum(sum(F3));
F3=F3/s;
A=imfilter(IMG,F3,'same');
%A=ceil(A);
for i=1:M; for j=1:N; F3IMG(i,j)=A(i,j); end; end;
%m3=max(max(F3IMG));  m4=min(min(F3IMG));
%a=255/(m3-m4);
%F3IMG= a*(F3IMG-m4);
subplot(1,1,1);   % Deleting all subplots present
imshow(F3IMG);title(strcat('Application du filtre exponentielle avec beta=',num2str(beta)));
IMGM=F3IMG;
set(handles.valeur,'string',beta/5);
set(handles.slider1,'value',beta/5);
set(handles.param,'string','La valeur de beta apartient [0,5].');
set(handles.timel,'string',toc);   % Displaying elapsed time

function Filtre_non_lineaire_Callback(hObject, eventdata, handles)
% hObject    handle to Filtre_non_lineaire (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Median_Callback(hObject, eventdata, handles)
% hObject    handle to Median (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Utilisation du filtre median.');
global IMG F4IMG IMGM choix
choix=0;
F4IMG = medfilt2(IMG);
%performs median filtering of the matrix A
 %   using the default 3-by-3 neighborhood.
subplot(1,1,1);   % Deleting all subplots present
imshow(F4IMG);title('Application du filtre median avec une fenetre 3x3');
IMGM=F4IMG;
set(handles.param,'string','Parametre de la méthode utiliser.');
set(handles.valeur,'string',0);
set(handles.slider1,'value',0);
set(handles.timel,'string',toc);   % Displaying elapsed time

%**************************************************************************
%************************ Detection de Contour *******************************
function Detect_cont_Callback(hObject, eventdata, handles)
% hObject    handle to Detect_cont (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Derive_1_Callback(hObject, eventdata, handles)
% hObject    handle to Derive_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Derive_2_Callback(hObject, eventdata, handles)
% hObject    handle to Derive_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Derive_optimal_Callback(hObject, eventdata, handles)
% hObject    handle to Derive_optimal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Canny_Callback(hObject, eventdata, handles)
% hObject    handle to Canny (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Detection de contour: "Canny".');
tic   % Starting Stopwatch Timer
global IMG C5IMG IMGM valn choix
choix=4;
if valn<0
    th=0.3;
elseif valn>=1
    th=0.3;
else
    th=valn;
end
C5IMG = edge(IMG,'canny',th);
subplot(1,1,1);   % Deleting all subplots present
imshow(C5IMG);title(strcat('Detectionde contour avec lapproche de Canny, seuil =',num2str(th)));
IMGM=C5IMG;
set(handles.valeur,'string',th);
set(handles.slider1,'value',th);
set(handles.param,'string','La valeur du seuil utiliser est entre 0 et 1');
            %BW = EDGE(I,'canny',THRESH) specifies sensitivity thresholds for the
            %Canny method. THRESH is a two-element vector in which the first element
            %is the low threshold, and the second element is the high threshold. If
            %you specify a scalar for THRESH, this value is used for the high
            %threshold and 0.4*THRESH is used for the low threshold. If you do not
            %specify THRESH, or if THRESH is empty ([]), EDGE chooses low and high 
             %values automatically.
%set(handles.methode,'string','rien');
set(handles.timel,'string',toc);   % Displaying elapsed time

function Laplacien_Callback(hObject, eventdata, handles)
% hObject    handle to Laplacien (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Detection de contour: "Laplacien".');
global IMG C6IMG IMGM valn alpha choix
choix=5;
if valn<0
    alpha=0.2;
elseif valn>1
    alpha=0.2;
else
    alpha=valn;
end
H = fspecial('laplacian',alpha);
C6IMG=edge(IMG,'zerocross',H);
%C6IMG = imfilter(IMG,H);
%m3=max(max(C6IMG));  m4=min(min(C6IMG));
%a=255/(m3-m4);
%C6IMG= a*(C6IMG-m4);
subplot(1,1,1);   % Deleting all subplots present
imshow(C6IMG);title(strcat('Detectionde contour avec lapproche Laplacien, alpha =',num2str(alpha)));
IMGM=C6IMG;
set(handles.valeur,'string',alpha);
set(handles.slider1,'value',alpha);
set(handles.param,'string','La valeur de alpha utiliser est entre 0 et 1');
        %H = FSPECIAL('laplacian',ALPHA) returns a 3-by-3 filter
        %approximating the shape of the two-dimensional Laplacian
        %operator. The parameter ALPHA controls the shape of the
        %Laplacian and must be in the range 0.0 to 1.0.
        %The default ALPHA is 0.2.
set(handles.timel,'string',toc);   % Displaying elapsed time

function Lap_Gausse_Callback(hObject, eventdata, handles)
% hObject    handle to Lap_Gausse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Detection de contour: "Laplacien Gausse".');
global IMG C7IMG IMGM segma valn choix
choix=6;
if valn<=0
    segma=0.5;
elseif valn>1
    segma=0.5;
else
    segma=valn;
end
H = fspecial('log',5,segma);
%C7IMG=edge(IMG,'zerocross',H);
C7IMG = imfilter(IMG,H);
subplot(1,1,1);   % Deleting all subplots present
imshow(C7IMG);title(strcat('Detectionde contour avec lapproche Laplacien Gausse, segma =',num2str(segma)));
IMGM=C7IMG;
set(handles.valeur,'string',segma);
set(handles.slider1,'value',segma);
set(handles.param,'string','La valeur de segma utiliser est entre 0 et 1');
            %H = FSPECIAL('log',HSIZE,SIGMA) returns a rotationally symmetric
            %Laplacian of Gaussian filter of size HSIZE with standard deviation
            %SIGMA (positive). HSIZE can be a vector specifying the number of rows
            %and columns in H or a scalar, in which case H is a square matrix.
            %The default HSIZE is [5 5], the default SIGMA is 0.5.
set(handles.timel,'string',toc);   % Displaying elapsed time

function calcul_direct_Callback(hObject, eventdata, handles)
% hObject    handle to calcul_direct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Detection de contour: "Calcule direct".');
global IMG C1IMG IMGM M N valn choix
choix=7;
if valn<0
    th=1;
elseif valn>1
    th=1;
else
    th=valn;
end
Igx=zeros(M,N); Igy=zeros(M,N);
Igdx=zeros(M,N); Igdy=zeros(M,N);
grad2=zeros(M,N); grad1=zeros(M,N);
for i=1:M-1
    for j=1:N-1
        Igx(i,j)=IMG(i+1,j)-IMG(i,j);
        Igy(i,j)=IMG(i,j+1)-IMG(i,j);  
        Igdx(i,j)=double(Igx(i,j)); Igdy(i,j)=double(Igy(i,j));
        grad2(i,j)=sqrt(((abs(Igdx(i,j)))^2+(abs(Igdy(i,j)))^2));
    end
end
S=valn*255; % le seuil de notre detection de contour
    for i=1:M
        for j=1:N
            if (grad2(i,j)>=S)
                grad1(i,j)=255;
            else
                grad1(i,j)=0;
            end
        end
    end
C1IMG=grad1;
subplot(1,1,1);   % Deleting all subplots present
imshow(C1IMG);title(strcat('Detectionde contour avec le calcul direct, seuil =',num2str(th)));
IMGM=C1IMG;
set(handles.valeur,'string',th);
set(handles.slider1,'value',th);
set(handles.param,'string','La valeur du seuil utiliser est entre 0 et 1');
set(handles.timel,'string',toc);   % Displaying elapsed time

function Prewitt_Callback(hObject, eventdata, handles)
% hObject    handle to Prewitt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Detection de contour: "Prewitt".');
global IMG C2IMG IMGM valn choix
choix=8;
if valn<0
    th=1;
elseif valn>1
    th=1;
else
    th=valn;
end
C2IMG = edge(IMG,'prewitt',th);
            %BW = EDGE(I,'prewitt',THRESH) specifies the sensitivity threshold for
            %the Prewitt method. EDGE ignores all edges that are not stronger than
            %THRESH. If you do not specify THRESH, or if THRESH is empty ([]),
            %EDGE chooses the value automatically.
subplot(1,1,1);   % Deleting all subplots present
imshow(C2IMG);title(strcat('Detectionde contour avec lapproche de Prewitt, seuil =',num2str(th)));
IMGM=C2IMG;
set(handles.valeur,'string',th);
set(handles.slider1,'value',th);
set(handles.param,'string','La valeur du seuil utiliser est entre 0 et 1');
set(handles.timel,'string',toc);   % Displaying elapsed time

function Sobel_Callback(hObject, eventdata, handles)
% hObject    handle to Sobel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Detection de contour: "Sobel".');
global IMG C3IMG IMGM valn choix
choix=9;
if valn<0
    th=1;
elseif valn>1
    th=1;
else
    th=valn;
end
C3IMG = edge(IMG,'sobel',th);
subplot(1,1,1);   % Deleting all subplots present
imshow(C3IMG);title(strcat('Detectionde contour avec lapproche de Sobel, seuil =',num2str(th)));
IMGM=C3IMG;
set(handles.valeur,'string',th);
set(handles.slider1,'value',th);
set(handles.param,'string','La valeur du seuil utiliser est entre 0 et 1');
set(handles.timel,'string',toc);   % Displaying elapsed time

function Robert_Callback(hObject, eventdata, handles)
% hObject    handle to Robert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Detection de contour: "Roberts".');
global IMG C4IMG IMGM valn choix
choix=10;
if valn<0
    th=1;
elseif valn>1
    th=1;
else
    th=valn;
end
C4IMG = edge(IMG,'roberts',th);
subplot(1,1,1);   % Deleting all subplots present
imshow(C4IMG);title(strcat('Detectionde contour avec lapproche de Roberts, seuil =',num2str(th)));
IMGM=C4IMG;
set(handles.valeur,'string',th);
set(handles.slider1,'value',th);
set(handles.param,'string','La valeur du seuil utiliser est entre 0 et 1');
set(handles.timel,'string',toc);   % Displaying elapsed time

%**************************************************************************
%************************ Morphologie mathematiques *************************
function Op_morph_Callback(hObject, eventdata, handles)
% hObject    handle to Op_morph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Dilatation_Callback(hObject, eventdata, handles)
% hObject    handle to Dilatation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Morphologie Math "dilatation".');
global IMG M1IMG IMGM choix
choix=0;
sq=ones(5,5);
M1IMG=imdilate(IMG,sq);
subplot(1,1,1);   % Deleting all subplots present
imshow(M1IMG);title('Dilatation avec l element structurant B(3x3) rempli de 1.');
IMGM=M1IMG;
set(handles.param,'string','Parametre de la méthode utiliser.');
set(handles.valeur,'string',0);
set(handles.slider1,'value',0);
set(handles.timel,'string',toc);   % Displaying elapsed time

function Erosion_Callback(hObject, eventdata, handles)
% hObject    handle to Erosion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Morphologie Math "erosion".');
global IMG M2IMG IMGM choix
choix=0;
sq=ones(5,5);
M2IMG=imerode(IMG,sq);
subplot(1,1,1);   % Deleting all subplots present
imshow(M2IMG);title('Erosion avec l element structurant B(3x3) rempli de 1.');
IMGM=M2IMG;
set(handles.param,'string','Parametre de la méthode utiliser.');
set(handles.valeur,'string',0);
set(handles.slider1,'value',0);
set(handles.timel,'string',toc);   % Displaying elapsed time

function Ouverture_Callback(hObject, eventdata, handles)
% hObject    handle to Ouverture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Morphologie Math "ouverture".');
global IMG M6IMG IMGM choix
choix=0;
sq=ones(3,3);
M6IMG=imopen(IMG,sq);
subplot(1,1,1);   % Deleting all subplots present
imshow(M6IMG);title('Ouverture de notre image avec l element B');
IMGM=M6IMG;
set(handles.param,'string','Parametre de la méthode utiliser.');
set(handles.valeur,'string',0);
set(handles.slider1,'value',0);
set(handles.timel,'string',toc);   % Displaying elapsed time

function Fermeture_Callback(hObject, eventdata, handles)
% hObject    handle to Fermeture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Morphologie Math "fermeture".');
global IMG M7IMG IMGM choix
choix=0;
sq=ones(3,3);
M7IMG=imclose(IMG,sq);
subplot(1,1,1);   % Deleting all subplots present
imshow(M7IMG);title('Fermeture de notre image avec l element B');
IMGM=M7IMG;
set(handles.param,'string','Parametre de la méthode utiliser.');
set(handles.valeur,'string',0);
set(handles.slider1,'value',0);
set(handles.timel,'string',toc);   % Displaying elapsed time

function FiltreOF_Callback(hObject, eventdata, handles)
% hObject    handle to FiltreOF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Morphologie Math "Filtrage".');
global IMG M8IMG IMGM choix 
choix=0;
sq=ones(3,3);
a=imopen(IMG,sq);
M8IMG=imclose(a,sq);
subplot(1,1,1);   % Deleting all subplots present
imshow(M8IMG);title('Filtrage de notre image avec l element B');
IMGM=M8IMG;
set(handles.param,'string','Parametre de la méthode utiliser.');
set(handles.valeur,'string',0);
set(handles.slider1,'value',0);
set(handles.timel,'string',toc);   % Displaying elapsed time

function appl_morph_Callback(hObject, eventdata, handles)
% hObject    handle to appl_morph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function contour_int_Callback(hObject, eventdata, handles)
% hObject    handle to contour_int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Morphologie Math detection de "contour interieur".');
global IMG M3IMG IMGM re choix
choix=0;
B=[1 0 1;0 1 0;1 0 1];
r=IMG>110;
re=imerode(r,B);
M3IMG=r&~re;
subplot(1,1,1);   % Deleting all subplots present
imshow(M3IMG);title('Detection du contour interieur avec MorMat');
IMGM=M3IMG;
set(handles.param,'string','Parametre de la méthode utiliser.');
set(handles.valeur,'string',0);
set(handles.slider1,'value',0);
set(handles.timel,'string',toc);   % Displaying elapsed time

function contou_ext_Callback(hObject, eventdata, handles)
% hObject    handle to contou_ext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Morphologie Math detection de "contour exterieur".');
global IMG M4IMG IMGM rd choix
choix=0;
B=[1 0 1;0 1 0;1 0 1];
r=IMG>110;
rd=imdilate(r,B);
M4IMG=rd&~r;
subplot(1,1,1);   % Deleting all subplots present
imshow(M4IMG);title('Detection du contour exterieur avec MorMat');
IMGM=M4IMG;
set(handles.param,'string','Parametre de la méthode utiliser.');
set(handles.valeur,'string',0);
set(handles.slider1,'value',0);
set(handles.timel,'string',toc);   % Displaying elapsed time

function gradient_morph_Callback(hObject, eventdata, handles)
% hObject    handle to gradient_morph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Morphologie Math detection de contour "calcul direct".');
global M5IMG IMGM re rd choix
choix=0;
M5IMG=rd&~re;
subplot(1,1,1);   % Deleting all subplots present
imshow(M5IMG);title('Detection du contour calcul direct avec MorMat');
IMGM=M5IMG;
set(handles.param,'string','Parametre de la méthode utiliser.');
set(handles.valeur,'string',0);
set(handles.slider1,'value',0);
set(handles.timel,'string',toc);   % Displaying elapsed time

%**************************************************************************
%***************************** Bruit ****************************************
function Bruit_Callback(hObject, eventdata, handles)
% hObject    handle to Bruit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function N_Gausse_Callback(hObject, eventdata, handles)
% hObject    handle to N_Gausse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Ajout du bruit a l image.');
global IMG B2IMG IMGM valn choix
choix=11;
if valn<0
    segma=0.5;
elseif valn>1
    segma=0.5;
else
    segma=valn;
end
B2IMG = imnoise(IMG,'gaussian',segma);
            %adds Gaussian white noise of mean M and
            %variance V to the image I. When unspecified, M and V default to 0 and
            %0.01 respectively.
subplot(1,1,1);   % Deleting all subplots present
imshow(B2IMG);title(strcat('Image bruite ave un bruit gausien avec segma =',num2str(segma)));
IMGM=B2IMG;
set(handles.valeur,'string',segma);
set(handles.slider1,'value',segma);
set(handles.param,'string','La valeur du segma utiliser est entre 0 et 1');
set(handles.timel,'string',toc);   % Displaying elapsed time

function N_Mulu_Callback(hObject, eventdata, handles)
% hObject    handle to N_Mulu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA).
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Ajout du bruit a l image.');
global IMG B3IMG IMGM valn choix
choix=12;
if valn<0
    V=0.4;
elseif valn>1
    V=0.4;
else
    V=valn;
end
B3IMG= imnoise(IMG,'speckle',V);
            %adds multiplicative noise to the image I,
            %using the equation J = I + n*I, where n is uniformly distributed random
            %noise with mean 0 and variance V. The default for V is 0.04.
subplot(1,1,1);   % Deleting all subplots present
imshow(B3IMG);title(strcat('Image bruite ave un bruit multiplicatif avec V =',num2str(V)));
IMGM=B3IMG;
set(handles.methode,'string','rien');
set(handles.valeur,'string',V);
set(handles.slider1,'value',V);
set(handles.param,'string','La valeur de l intensiter du bruit utiliser est entre 0 et 1');
set(handles.timel,'string',toc);   % Displaying elapsed time

function B_salt_Callback(hObject, eventdata, handles)
% hObject    handle to B_salt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Ajout du bruit a l image.');
global IMG B1IMG IMGM valn choix
choix=13;
if valn<0
    D=0.4;
elseif valn>1
    D=0.4;
else
    D=valn;
end
B1IMG = imnoise(IMG,'salt & pepper');
            %adds "salt and pepper" noise to the
            %image I, where D is the noise density.  This affects approximately
            %D*numel(I) pixels. The default for D is 0.05.
subplot(1,1,1);   % Deleting all subplots present
imshow(B1IMG);title(strcat('Image bruite ave un bruit salt & pepper avec D =',num2str(D)));
IMGM=B1IMG;
set(handles.valeur,'string',D);
set(handles.slider1,'value',D);
set(handles.param,'string','La valeur de l intensiter du bruit utiliser est entre 0 et 1');
set(handles.timel,'string',toc);   % Displaying elapsed time

function flue_Callback(hObject, eventdata, handles)%Mouvements
% hObject    handle to flue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Ajout du bruit a l image.');
global IMG B4IMG IMGM valn choix
choix=14;
if valn<0
    D=50*0.4;
elseif valn>1
    D=50*0.4;
else
    D=50*valn;
end
PSF = fspecial('motion',D,D-5); 
B4IMG = imfilter(IMG,PSF,'symmetric','conv');
subplot(1,1,1);   % Deleting all subplots present
imshow(B4IMG);title('Image bruite motion');
IMGM=B4IMG;
set(handles.valeur,'string',D);
set(handles.slider1,'value',valn);
set(handles.param,'string','La valeur de l intensiter du bruit utiliser est entre 0 et 50');
set(handles.timel,'string',toc);   % Displaying elapsed time

%**************************************************************************
%***************************** Help ****************************************
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Help_demo_Callback(hObject, eventdata, handles)
% hObject    handle to Help_demo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open ('help.pdf');

function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open ('abt.exe');

%**************************************************************************
%***************************** Configuration *********************************
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);

function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%**************************************************************************
%*************************** Approche region ********************************
function Seg_Callback(hObject, eventdata, handles)
% hObject    handle to Seg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function SplitMerge_Callback(hObject, eventdata, handles)
% hObject    handle to SplitMerge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
set(handles.timel,'string','Busy');   % Displaying state
set(handles.methode,'string','Split & Merge sur notre image.');
global IMG S1IMG IMGM valn choix M N
choix=15;
if valn<=0
    seuil=0.27;
elseif valn>=1
    seuil=0.27;
else
    seuil=valn;
end

j=1;
for i=1:2048
    if i>M
            I(i,j)=0;
    else
        for j=1:2048
        if j>N
            I(i,j)=0;
        else
            I(i,j)=IMG(i,j);
        end
    end
    end
end

S1IMG = qtdecomp(I,seuil);
blocks = repmat(uint8(0),size(S1IMG));
    %splits a block if the maximum value of the block elements minus 
    %the minimum value of the block elements is greater than threshold.
    %threshold is specified as a value between 0 and 1, even if I is of class 
    %uint8 or uint16. If I is uint8, the threshold value you supply is multiplied
    %by 255 to determine the actual threshold to use; if I is uint16, the 
    %threshold value you supply is multiplied by 65535.
for dim = [2048 1024 512 256 128 64 32 16 8 4 2 1];    
  numblocks = length(find(S1IMG==dim));    
  if (numblocks > 0)        
    values = repmat(uint8(1),[dim dim numblocks]);
    values(2:dim,2:dim,:) = 0;
    blocks = qtsetblk(blocks,S1IMG,dim,values);
  end
end
blocks(end,1:end) = 1;
blocks(1:end,end) = 1;

subplot(1,1,1);   % Deleting all subplots present
imshow(blocks,[]), axis([1 N 1 M])
title(strcat('Segmentation de l image avec Split & Merge avec s=',num2str(seuil),' et le nombre de bloc =',num2str(numblocks)));
IMGM=blocks;
set(handles.valeur,'string',seuil);
set(handles.slider1,'value',seuil);
set(handles.param,'string','La valeur de l intensiter du bruit utiliser est entre 0 et 1');
set(handles.timel,'string',toc);   % Displaying elapsed time

%**************************************************************************
%************************** Voir l'image apres traitement **********************
function imagafter_Callback(hObject, eventdata, handles)
% hObject    handle to imagafter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic   % Starting Stopwatch Timer
global IMGM choix M N
if choix~=15
        subplot(1,1,1), imshow(IMGM); title('Image apres traitement.');  % Displaying the rotated image
else
        subplot(1,1,1), imshow(IMGM,[]); axis([1 N 1 M]);
        title('Image apres traitement.');  % Displaying the rotated image
        set(handles.methode,'string','Voir limage apres traitement.');
end
set(handles.timel,'string',toc);   % Displaying elapsed time

function imagafter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imagafter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%**************************************************************************
%**************************************************************************
function Or_image_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Or_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function Histogramme_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Histogramme (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IMG choix m2 m1 filename
if (filename~=0)
    if choix==16
        a=255/(m1-m2);
        EIMG= a*(IMG-m2);
        imwrite(EIMG,'H.jpg');
        EIMG=imread('H.jpg');
        delete H.jpg
        H=hist(EIMG(:),[0:255]);
        [xmax,i]=max(H);
        figure(1);stem(H,'.');
        axis([0 255 0 xmax+xmax/10]);
    elseif choix==17
        HIMG=histeq(IMG);
        imwrite(HIMG,'H.jpg');
        HIMG=imread('H.jpg');
        delete H.jpg
        H=hist(HIMG(:),[0:255]);
        [xmax,i]=max(H);
        figure(1);stem(H,'.');
        axis([0 255 0 xmax+xmax/10]);
    else
        H=hist(IMG(:),[0:255]);
        [xmax,i]=max(H);
        figure(1);stem(H,'.');
        axis([0 255 0 xmax+xmax/10]);
    end
else
    figure(1);
end
%**************************************************************************
%**************************************************************************