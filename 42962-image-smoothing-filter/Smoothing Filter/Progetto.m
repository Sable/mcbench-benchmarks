

function varargout = Progetto(varargin)
% Questo M-file ha lo scopo principale della gestione dell'interfaccia,
% inoltre al suo interno sono implementate le funzioni più semplici per il
% trattamento delle immagini. 
% Funzioni più complesse richiamano file scritti a parte.

% Begin initialization code - DO NOT EDIT


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Progetto_OpeningFcn, ...
                   'gui_OutputFcn',  @Progetto_OutputFcn, ...
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


% --- Executes just before Progetto is made visible.
function Progetto_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Progetto (see VARARGIN)

% Choose default command line output for Progetto

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Progetto wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Progetto_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% il programma inizia qua!!!
% definizione delle variabili globali 
global I;
global IR;
global IP;
global IG;

I=0;
IR=0;
IP=0;
IG=0;

% questa funzione ha lo scopo di caricare l'immagine scelta e azzerare le
% cariabili globali
function Carica_Callback(hObject, eventdata, handles)
global I;
global IR;
global IP;
global IG;
IR=0;
IP=0;
IG=0;

nome=get(handles.name,'String');                        % gestione interfaccia
if isempty(nome)                                        
    set(handles.errori,'String','Insert Image path')
else
    
I=imread(nome);                                         % caricamento dell'immagine 
figure(1)                                               % mostra a video
imshow(I)
s=size(I);

set(handles.S1,'String',num2str(s(1)))                  % gestione interfaccia, mostra la risoluzione dell'immagine
set(handles.S2,'String',num2str(s(2)))
set(handles.x,'String','x')
set(handles.errori,'String','');
end



% le prossime 3 funzioni sono relative alla gestione dei 3 push-button che
% mostrano le immagini carichate, sporche e dopo il trattamento.
function immagine_iniziale_Callback(hObject, eventdata, handles)
global I
if I==0
    set(handles.errori,'String','No Loaded Images');
else
    figure(1)
    imshow(I);
    set(handles.errori,'String','');
end

function Immagine_sporca_Callback(hObject, eventdata, handles)
global IR
if IR==0
   set(handles.errori,'String','No Dirty Images');
else
    figure(2)
    imshow(IR);
    set(handles.errori,'String','');
end

function Immagine_pulita_Callback(hObject, eventdata, handles)
global IP
if IP==0
   set(handles.errori,'String','No Processed Images');
else
    figure(3)
    imshow(IP);
    set(handles.errori,'String','');
end




% questa funzione ha lo scopo di convertire l'immagine caricata in livelli
% di grigio
function pushbutton5_Callback(hObject, eventdata, handles)
global IG
global IR
global IP
global I

if I==0                                                             % gestione interfaccia
    set(handles.errori,'String','No Loaded Images');
else
    if IG==0
    IG=0.299*I(:,:,1)+0.587*I(:,:,2)+0.114*I(:,:,3);                % converaione dell'immagine
    I=IG;
    IR=0;
    IP=0;
    figure(4)
    imshow(IG)
    set(handles.errori,'String','');
    end
end


% le prossime 3 funzioni hanno lo scopo di inserire nell'immagine caricata
% un certo tipo di rumore

% rumore gaussiano
function rumore_gauss_Callback(hObject, eventdata, handles)
global I
global IR
if I==0                                                             % gestione interfaccia
    set(handles.errori,'String','No Loaded Images');   
else
    if  (isempty(get(handles.var_R,'String')))
    set(handles.var_R,'String','0.01')
    end
    v=str2num(get(handles.var_R,'String'));
    
    IR=imnoise(I,'gaussian',0,v);                                   % inserimento di rumore Gaussiano
    figure(2)
    imshow(IR)
    
    set(handles.errori,'String','');
end

% Rumore speckle
function speckle_Callback(hObject, eventdata, handles)
global I
global IR
if I==0                                                             % gestione interfaccia
    set(handles.errori,'String','No Loaded Images');
else
    if  (isempty(get(handles.var_S,'String')))
    set(handles.var_S,'String','0.04')
    end
    v=str2num(get(handles.var_S,'String'));
    IR=imnoise(I,'speckle',v);                                      % inserimento di rumore speckle
    figure(2)
    imshow(IR)
    set(handles.errori,'String','');
end

% Rumore sale e Pepe
function rumore_sale_Callback(hObject, eventdata, handles)
global IG
global IR
if IG==0                                                            % gestione interfaccia, controllo della presenza di immagini in scale di grigio
    set(handles.errori,'String','No Gray-Scale Images');
else
    if  (isempty(get(handles.S_P_per,'String')))
    set(handles.S_P_per,'String','0.05')
    end
    per=str2num(get(handles.S_P_per,'String'));
    
    IR=imnoise(IG,'salt & pepper',per);                             % inserimento del rumore
    figure(2)
    imshow(IR)
    
    set(handles.errori,'String','');
end

% le prossime funzione implementeranno i vari tipi di filtri
% filtro Gaussiano
function filtro_gauss_Callback(hObject, eventdata, handles)
global IR
global IP
global I

IT=IR;
if (IR==0 & I==0)                                                      % gestione interfaccia
    set(handles.errori,'String','No Images to be Processed');
else
    if IR==0
    IT=I;
    end
    if  (isempty(get(handles.dimG,'String')))
    set(handles.dimG,'String','7')
    end
    d=str2num(get(handles.dimG,'String'));
    if  (isempty(get(handles.varG,'String')))
    v=d/6;
    v=num2str(v);
    set(handles.varG,'String',v)
    end
    v=str2num(get(handles.varG,'String'));      
    
    
    FG=fspecial('gaussian',d,v);                     % creazione del filtro Gaussiano di parametri desiderati
    IP=imfilter(IT,FG);                              % filtraggio
    figure(3)
    imshow(IP)
    
    set(handles.errori,'String','');
end

% filtro Mediano
function mediano_Callback(hObject, eventdata, handles)
global IR
global IP
global I
IT=IR;
if (IR==0 & I==0)                                   % gestione interfaccia
    set(handles.errori,'String','No Images to be Processed');
else
    if IR==0
    IT=I;
    end
    if  (isempty(get(handles.dimM,'String')))
    set(handles.dimM,'String','5')
    end
    d=str2num(get(handles.dimM,'String'));
    
    
    if length(size(IT))==2;                         % controllo dell'immagine, se e in livelli di grigio o a colori
       IP=medfilt2(IT,[d d]);                       % filtraggio dell'immagine in livelli di grigio
    else
        IP=IT;                                      % Filtraggio dell'immagine in a colori
        red=IT(:,:,1);                              % si esegue il filtraggio un colore alla volta
        green=IT(:,:,2);     
        blue=IT(:,:,3);
        redM=medfilt2(red,[d d]);
        greenM=medfilt2(green,[d d]);
        blueM=medfilt2(blue,[d d]);
        IP(:,:,1)=redM;
        IP(:,:,2)=greenM;
        IP(:,:,3)=blueM;
    end
    figure(3)
    imshow(IP)
    set(handles.errori,'String','');
end



% Filtro Medio
function Media_Callback(hObject, eventdata, handles)
global IR
global IP
global I

IT=IR;
if (IR==0 & I==0)                                           % gestione interfaccia
    set(handles.errori,'String','No Images to be Processed');
else
    if IR==0
    IT=I;
    end
    if  (isempty(get(handles.DimA,'String')))
    set(handles.DimA,'String','7')
    end
    d=str2num(get(handles.DimA,'String'));
    
    FA=fspecial('average',d);                               % operazioni di filtraggio coi parametri desiderati
    IP=imfilter(IT,FA);
    figure(3)
    imshow(IP)
    set(handles.errori,'String','');
    
end

% filtro manuale, richiama un'interfaccia a parte
function manuale_Callback(hObject, eventdata, handles)
filtro_m

% filtraggio nel dominio della frequenza, richiama un m-file a parte
function frequenza_Callback(hObject, eventdata, handles)
global IR
global IP
global I
global IT

IT=IR;
if (IR==0 & I==0)
    set(handles.errori,'String','No Images to be Processed');
else
    if IR==0
    IT=I;
    end
    if  (isempty(get(handles.taglio,'String')))
    set(handles.taglio,'String','25')
    end
    f=str2num(get(handles.taglio,'String'));

    frequencyFilter(f);
    
    set(handles.errori,'String','');
end

% questa funzione implemento un filtro di sharpening per l'esaltazione dei
% contorni di un'immagine
function sharp_Callback(hObject, eventdata, handles)
global IP
global I

IT=IP;
if (IP==0 & I==0)                                   % gestione interfaccia
    set(handles.errori,'String','No Images to be Processed');
else
    if IP==0
    IT=I;
    end
    sharp=[-1, -1, -1; -1 9 -1; -1 -1 -1];          % filtro utilizzato
    ID=imfilter(IT,sharp);                          % filtraggio
    figure(5)
    imshow(ID)
end



% la seguente funzione he il compito di mostrare a video l'ampiezza della trasformata di
% Fourier dell'immagine, una per ciascuna componente di colore
function Fourier_Callback(hObject, eventdata, handles)
global IR
global I

IT=IR;
if (IR==0 & I==0)                                   % gestione interfaccia
    set(handles.errori,'String','No Images to be Processed');
else
    if IR==0
    IT=I;
    end
    IT=double(IT);
    if length(size(IT))==2;                         % se l'immagine è a livelli di grigio
        IF=fft2(IT);                                % fa la traformata
        IF=fftshift(IF);                            % trasla la trasformata per renderla più leggibile
        figure(6)
        imagesc(0.5*log(1+abs(IF)));                % la mostra secondo una legge logaritmica, che la rende di più facile interpretazione
    else                                            % se l'immagine è a colori fa la stessa operazione per ogni componente
        ITR=IT(:,:,1);
        IFR=fft2(ITR);
        IFR=fftshift(IFR);
        
        ITB=IT(:,:,2);
        IFB=fft2(ITB);
        IFB=fftshift(IFB);
        
        ITV=IT(:,:,3);
        IFV=fft2(ITV);
        IFV=fftshift(IFV);
        
        figure(6)
        subplot(1,3,1)
        imagesc(0.5*log(1+abs(IFR)));
        title('Red')     
        subplot(1,3,2)
        imagesc(0.5*log(1+abs(IFB)));
        title('Blue')
        subplot(1,3,3)
        imagesc(0.5*log(1+abs(IFV)));
        title('Green')
    end
        
end



% le successive funzione sono state create dal matlab per la gestione
% dell'interfaccia, non sono state modificate




function taglio_Callback(hObject, eventdata, handles)
function taglio_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function dimG_Callback(hObject, eventdata, handles)
function dimG_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function dimM_Callback(hObject, eventdata, handles)
function dimM_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function DimA_Callback(hObject, eventdata, handles)
function DimA_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function varG_Callback(hObject, eventdata, handles)
function varG_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function var_R_Callback(hObject, eventdata, handles)
function var_R_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function S_P_per_Callback(hObject, eventdata, handles)
function S_P_per_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function var_S_Callback(hObject, eventdata, handles)
function var_S_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function name_Callback(hObject, eventdata, handles)
function name_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


