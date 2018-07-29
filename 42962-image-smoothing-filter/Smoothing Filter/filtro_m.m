function varargout = filtro_m(varargin)
% Questo M-file ha lo scopo principale di gestire l'interfaccia del filtro
% manuale. Al suo interno è implementato il codice per il filtraggio
% dell'immagine


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @filtro_m_OpeningFcn, ...
                   'gui_OutputFcn',  @filtro_m_OutputFcn, ...
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


% --- Executes just before filtro_m is made visible.
function filtro_m_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to filtro_m (see VARARGIN)

% Choose default command line output for filtro_m
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes filtro_m wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = filtro_m_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% la seguente funzione gestice la callback del push-button apllica filtro
function filtra_Callback(hObject, eventdata, handles)

% definizione di variabili globali e altre utili in seguito
global IR
global IP
global I

IT=IR;
FM=zeros(9,9);

if (IR==0 & I==0)                               % gestione interfaccia
    set(handles.errori,'String','No Image to be Processed');
else
    if IR==0
    IT=I;
    end

% controllo delle varie caselle, se son vuote riempile con 0
if  (isempty(get(handles.e1x1,'String')))
set(handles.e1x1,'String','0')
end
if  (isempty(get(handles.e1x2,'String')))
set(handles.e1x2,'String','0')
end
if  (isempty(get(handles.e1x3,'String')))
set(handles.e1x3,'String','0')
end
if  (isempty(get(handles.e1x4,'String')))
set(handles.e1x4,'String','0')
end
if  (isempty(get(handles.e1x5,'String')))
set(handles.e1x5,'String','0')
end
if  (isempty(get(handles.e1x6,'String')))
set(handles.e1x6,'String','0')
end
if  (isempty(get(handles.e1x7,'String')))
set(handles.e1x7,'String','0')
end
if  (isempty(get(handles.e1x8,'String')))
set(handles.e1x8,'String','0')
end
if  (isempty(get(handles.e1x9,'String')))
set(handles.e1x9,'String','0')
end
if  (isempty(get(handles.e2x1,'String')))
set(handles.e2x1,'String','0')
end
if  (isempty(get(handles.e2x2,'String')))
set(handles.e2x2,'String','0')
end
if  (isempty(get(handles.e2x3,'String')))
set(handles.e2x3,'String','0')
end
if  (isempty(get(handles.e2x4,'String')))
set(handles.e2x4,'String','0')
end
if  (isempty(get(handles.e2x5,'String')))
set(handles.e2x5,'String','0')
end
if  (isempty(get(handles.e2x6,'String')))
set(handles.e2x6,'String','0')
end
if  (isempty(get(handles.e2x7,'String')))
set(handles.e2x7,'String','0')
end
if  (isempty(get(handles.e2x8,'String')))
set(handles.e2x8,'String','0')
end
if  (isempty(get(handles.e2x9,'String')))
set(handles.e2x9,'String','0')
end
if  (isempty(get(handles.e3x1,'String')))
set(handles.e3x1,'String','0')
end
if  (isempty(get(handles.e3x2,'String')))
set(handles.e3x2,'String','0')
end
if  (isempty(get(handles.e3x3,'String')))
set(handles.e3x3,'String','0')
end
if  (isempty(get(handles.e3x4,'String')))
set(handles.e3x4,'String','0')
end
if  (isempty(get(handles.e3x5,'String')))
set(handles.e3x5,'String','0')
end
if  (isempty(get(handles.e3x6,'String')))
set(handles.e3x6,'String','0')
end
if  (isempty(get(handles.e3x7,'String')))
set(handles.e3x7,'String','0')
end
if  (isempty(get(handles.e3x8,'String')))
set(handles.e3x8,'String','0')
end
if  (isempty(get(handles.e3x9,'String')))
set(handles.e3x9,'String','0')
end
if  (isempty(get(handles.e4x1,'String')))
set(handles.e4x1,'String','0')
end
if  (isempty(get(handles.e4x2,'String')))
set(handles.e4x2,'String','0')
end
if  (isempty(get(handles.e4x3,'String')))
set(handles.e4x3,'String','0')
end
if  (isempty(get(handles.e4x4,'String')))
set(handles.e4x4,'String','0')
end
if  (isempty(get(handles.e4x5,'String')))
set(handles.e4x5,'String','0')
end
if  (isempty(get(handles.e4x6,'String')))
set(handles.e4x6,'String','0')
end
if  (isempty(get(handles.e4x7,'String')))
set(handles.e4x7,'String','0')
end
if  (isempty(get(handles.e4x8,'String')))
set(handles.e4x8,'String','0')
end
if  (isempty(get(handles.e4x9,'String')))
set(handles.e4x9,'String','0')
end
if  (isempty(get(handles.e5x1,'String')))
set(handles.e5x1,'String','0')
end
if  (isempty(get(handles.e5x2,'String')))
set(handles.e5x2,'String','0')
end
if  (isempty(get(handles.e5x3,'String')))
set(handles.e5x3,'String','0')
end
if  (isempty(get(handles.e5x4,'String')))
set(handles.e5x4,'String','0')
end
if  (isempty(get(handles.e5x5,'String')))
set(handles.e5x5,'String','1')
end
if  (isempty(get(handles.e5x6,'String')))
set(handles.e5x6,'String','0')
end
if  (isempty(get(handles.e5x7,'String')))
set(handles.e5x7,'String','0')
end
if  (isempty(get(handles.e5x8,'String')))
set(handles.e5x8,'String','0')
end
if  (isempty(get(handles.e5x9,'String')))
set(handles.e5x9,'String','0')
end
if  (isempty(get(handles.e6x1,'String')))
set(handles.e6x1,'String','0')
end
if  (isempty(get(handles.e6x2,'String')))
set(handles.e6x2,'String','0')
end
if  (isempty(get(handles.e6x3,'String')))
set(handles.e6x3,'String','0')
end
if  (isempty(get(handles.e6x4,'String')))
set(handles.e6x4,'String','0')
end
if  (isempty(get(handles.e6x5,'String')))
set(handles.e6x5,'String','0')
end
if  (isempty(get(handles.e6x6,'String')))
set(handles.e6x6,'String','0')
end
if  (isempty(get(handles.e6x7,'String')))
set(handles.e6x7,'String','0')
end
if  (isempty(get(handles.e6x8,'String')))
set(handles.e6x8,'String','0')
end
if  (isempty(get(handles.e6x9,'String')))
set(handles.e6x9,'String','0')
end
if  (isempty(get(handles.e7x1,'String')))
set(handles.e7x1,'String','0')
end
if  (isempty(get(handles.e7x2,'String')))
set(handles.e7x2,'String','0')
end
if  (isempty(get(handles.e7x3,'String')))
set(handles.e7x3,'String','0')
end
if  (isempty(get(handles.e7x4,'String')))
set(handles.e7x4,'String','0')
end
if  (isempty(get(handles.e7x5,'String')))
set(handles.e7x5,'String','0')
end
if  (isempty(get(handles.e7x6,'String')))
set(handles.e7x6,'String','0')
end
if  (isempty(get(handles.e7x7,'String')))
set(handles.e7x7,'String','0')
end
if  (isempty(get(handles.e7x8,'String')))
set(handles.e7x8,'String','0')
end
if  (isempty(get(handles.e7x9,'String')))
set(handles.e7x9,'String','0')
end
if  (isempty(get(handles.e8x1,'String')))
set(handles.e8x1,'String','0')
end
if  (isempty(get(handles.e8x2,'String')))
set(handles.e8x2,'String','0')
end
if  (isempty(get(handles.e8x3,'String')))
set(handles.e8x3,'String','0')
end
if  (isempty(get(handles.e8x4,'String')))
set(handles.e8x4,'String','0')
end
if  (isempty(get(handles.e8x5,'String')))
set(handles.e8x5,'String','0')
end
if  (isempty(get(handles.e8x6,'String')))
set(handles.e8x6,'String','0')
end
if  (isempty(get(handles.e8x7,'String')))
set(handles.e8x7,'String','0')
end
if  (isempty(get(handles.e8x8,'String')))
set(handles.e8x8,'String','0')
end
if  (isempty(get(handles.e8x9,'String')))
set(handles.e8x9,'String','0')
end
if  (isempty(get(handles.e9x1,'String')))
set(handles.e9x1,'String','0')
end
if  (isempty(get(handles.e9x2,'String')))
set(handles.e9x2,'String','0')
end
if  (isempty(get(handles.e9x3,'String')))
set(handles.e9x3,'String','0')
end
if  (isempty(get(handles.e9x4,'String')))
set(handles.e9x4,'String','0')
end
if  (isempty(get(handles.e9x5,'String')))
set(handles.e9x5,'String','0')
end
if  (isempty(get(handles.e9x6,'String')))
set(handles.e9x6,'String','0')
end
if  (isempty(get(handles.e9x7,'String')))
set(handles.e9x7,'String','0')
end
if  (isempty(get(handles.e9x8,'String')))
set(handles.e9x8,'String','0')
end
if  (isempty(get(handles.e9x9,'String')))
set(handles.e9x9,'String','0')
end

% assegnazione dei parametri inseriti nel filtro.
FM(1,1)=str2num(get(handles.e1x1,'String'));
FM(1,2)=str2num(get(handles.e1x2,'String'));
FM(1,3)=str2num(get(handles.e1x3,'String'));
FM(1,4)=str2num(get(handles.e1x4,'String'));
FM(1,5)=str2num(get(handles.e1x5,'String'));
FM(1,6)=str2num(get(handles.e1x6,'String'));
FM(1,7)=str2num(get(handles.e1x7,'String'));
FM(1,8)=str2num(get(handles.e1x8,'String'));
FM(1,9)=str2num(get(handles.e1x9,'String'));
FM(2,1)=str2num(get(handles.e2x1,'String'));
FM(2,2)=str2num(get(handles.e2x2,'String'));
FM(2,3)=str2num(get(handles.e2x3,'String'));
FM(2,4)=str2num(get(handles.e2x4,'String'));
FM(2,5)=str2num(get(handles.e2x5,'String'));
FM(2,6)=str2num(get(handles.e2x6,'String'));
FM(2,7)=str2num(get(handles.e2x7,'String'));
FM(2,8)=str2num(get(handles.e2x8,'String'));
FM(2,9)=str2num(get(handles.e2x9,'String'));
FM(3,1)=str2num(get(handles.e3x1,'String'));
FM(3,2)=str2num(get(handles.e3x2,'String'));
FM(3,3)=str2num(get(handles.e3x3,'String'));
FM(3,4)=str2num(get(handles.e3x4,'String'));
FM(3,5)=str2num(get(handles.e3x5,'String'));
FM(3,6)=str2num(get(handles.e3x6,'String'));
FM(3,7)=str2num(get(handles.e3x7,'String'));
FM(3,8)=str2num(get(handles.e3x8,'String'));
FM(3,9)=str2num(get(handles.e3x9,'String'));
FM(4,1)=str2num(get(handles.e4x1,'String'));
FM(4,2)=str2num(get(handles.e4x2,'String'));
FM(4,3)=str2num(get(handles.e4x3,'String'));
FM(4,4)=str2num(get(handles.e4x4,'String'));
FM(4,5)=str2num(get(handles.e4x5,'String'));
FM(4,6)=str2num(get(handles.e4x6,'String'));
FM(4,7)=str2num(get(handles.e4x7,'String'));
FM(4,8)=str2num(get(handles.e4x8,'String'));
FM(4,9)=str2num(get(handles.e4x9,'String'));
FM(5,1)=str2num(get(handles.e5x1,'String'));
FM(5,2)=str2num(get(handles.e5x2,'String'));
FM(5,3)=str2num(get(handles.e5x3,'String'));
FM(5,4)=str2num(get(handles.e5x4,'String'));
FM(5,5)=str2num(get(handles.e5x5,'String'));
FM(5,6)=str2num(get(handles.e5x6,'String'));
FM(5,7)=str2num(get(handles.e5x7,'String'));
FM(5,8)=str2num(get(handles.e5x8,'String'));
FM(5,9)=str2num(get(handles.e5x9,'String'));
FM(6,1)=str2num(get(handles.e6x1,'String'));
FM(6,2)=str2num(get(handles.e6x2,'String'));
FM(6,3)=str2num(get(handles.e6x3,'String'));
FM(6,4)=str2num(get(handles.e6x4,'String'));
FM(6,5)=str2num(get(handles.e6x5,'String'));
FM(6,6)=str2num(get(handles.e6x6,'String'));
FM(6,7)=str2num(get(handles.e6x7,'String'));
FM(6,8)=str2num(get(handles.e6x8,'String'));
FM(6,9)=str2num(get(handles.e6x9,'String'));
FM(7,1)=str2num(get(handles.e7x1,'String'));
FM(7,2)=str2num(get(handles.e7x2,'String'));
FM(7,3)=str2num(get(handles.e7x3,'String'));
FM(7,4)=str2num(get(handles.e7x4,'String'));
FM(7,5)=str2num(get(handles.e7x5,'String'));
FM(7,6)=str2num(get(handles.e7x6,'String'));
FM(7,7)=str2num(get(handles.e7x7,'String'));
FM(7,8)=str2num(get(handles.e7x8,'String'));
FM(7,9)=str2num(get(handles.e7x9,'String'));
FM(8,1)=str2num(get(handles.e8x1,'String'));
FM(8,2)=str2num(get(handles.e8x2,'String'));
FM(8,3)=str2num(get(handles.e8x3,'String'));
FM(8,4)=str2num(get(handles.e8x4,'String'));
FM(8,5)=str2num(get(handles.e8x5,'String'));
FM(8,6)=str2num(get(handles.e8x6,'String'));
FM(8,7)=str2num(get(handles.e8x7,'String'));
FM(8,8)=str2num(get(handles.e8x8,'String'));
FM(8,9)=str2num(get(handles.e8x9,'String'));
FM(9,1)=str2num(get(handles.e9x1,'String'));
FM(9,2)=str2num(get(handles.e9x2,'String'));
FM(9,3)=str2num(get(handles.e9x3,'String'));
FM(9,4)=str2num(get(handles.e9x4,'String'));
FM(9,5)=str2num(get(handles.e9x5,'String'));
FM(9,6)=str2num(get(handles.e9x6,'String'));
FM(9,7)=str2num(get(handles.e9x7,'String'));
FM(9,8)=str2num(get(handles.e9x8,'String'));
FM(9,9)=str2num(get(handles.e9x9,'String'));


if sum(sum(FM))~=0         % controllo sul filtro, se la somma di tutti gli elementi non è pari a 0 normalizza il filtro 
    FM=FM/sum(sum(FM)); 
end
IP=imfilter(IT,FM);         % filtraggio
figure(3)
imshow(IP)
set(handles.errori,'String','');
end


% le seguenti funzioni sono state create dal matlab , non sono state
% modificate




function e1x1_Callback(hObject, eventdata, handles)
function e1x1_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e2x1_Callback(hObject, eventdata, handles)


function e2x1_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e3x1_Callback(hObject, eventdata, handles)


function e3x1_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e4x1_Callback(hObject, eventdata, handles)


function e4x1_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e5x1_Callback(hObject, eventdata, handles)


function e5x1_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e6x1_Callback(hObject, eventdata, handles)


function e6x1_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e7x1_Callback(hObject, eventdata, handles)


function e7x1_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e8x1_Callback(hObject, eventdata, handles)


function e8x1_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e9x1_Callback(hObject, eventdata, handles)


function e9x1_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e1x2_Callback(hObject, eventdata, handles)


function e1x2_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e1x3_Callback(hObject, eventdata, handles)


function e1x3_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e1x4_Callback(hObject, eventdata, handles)


function e1x4_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e1x5_Callback(hObject, eventdata, handles)


function e1x5_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e1x6_Callback(hObject, eventdata, handles)


function e1x6_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e1x7_Callback(hObject, eventdata, handles)


function e1x7_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e1x8_Callback(hObject, eventdata, handles)


function e1x8_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e1x9_Callback(hObject, eventdata, handles)


function e1x9_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e2x2_Callback(hObject, eventdata, handles)


function e2x2_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e2x3_Callback(hObject, eventdata, handles)


function e2x3_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e2x4_Callback(hObject, eventdata, handles)


function e2x4_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e2x5_Callback(hObject, eventdata, handles)


function e2x5_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e2x6_Callback(hObject, eventdata, handles)


function e2x6_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e2x7_Callback(hObject, eventdata, handles)


function e2x7_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e2x8_Callback(hObject, eventdata, handles)


function e2x8_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e2x9_Callback(hObject, eventdata, handles)


function e2x9_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e3x2_Callback(hObject, eventdata, handles)


function e3x2_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e4x3_Callback(hObject, eventdata, handles)


function e4x3_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e3x4_Callback(hObject, eventdata, handles)


function e3x4_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e3x3_Callback(hObject, eventdata, handles)


function e3x3_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e5x5_Callback(hObject, eventdata, handles)


function e5x5_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e4x5_Callback(hObject, eventdata, handles)


function e4x5_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e7x9_Callback(hObject, eventdata, handles)


function e7x9_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e6x6_Callback(hObject, eventdata, handles)


function e6x6_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e3x5_Callback(hObject, eventdata, handles)


function e3x5_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e5x6_Callback(hObject, eventdata, handles)


function e5x6_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e4x6_Callback(hObject, eventdata, handles)


function e4x6_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e3x6_Callback(hObject, eventdata, handles)


function e3x6_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e6x7_Callback(hObject, eventdata, handles)


function e6x7_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e6x8_Callback(hObject, eventdata, handles)


function e6x8_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e6x9_Callback(hObject, eventdata, handles)


function e6x9_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e5x7_Callback(hObject, eventdata, handles)


function e5x7_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e5x8_Callback(hObject, eventdata, handles)


function e5x8_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e5x9_Callback(hObject, eventdata, handles)


function e5x9_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e4x7_Callback(hObject, eventdata, handles)


function e4x7_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e3x8_Callback(hObject, eventdata, handles)


function e3x8_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e4x8_Callback(hObject, eventdata, handles)


function e4x8_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e4x9_Callback(hObject, eventdata, handles)


function e4x9_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit48_Callback(hObject, eventdata, handles)


function edit48_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e3x9_Callback(hObject, eventdata, handles)


function e3x9_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e9x2_Callback(hObject, eventdata, handles)


function e9x2_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e8x2_Callback(hObject, eventdata, handles)


function e8x2_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e7x2_Callback(hObject, eventdata, handles)


function e7x2_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e6x2_Callback(hObject, eventdata, handles)


function e6x2_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e5x2_Callback(hObject, eventdata, handles)


function e5x2_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e4x2_Callback(hObject, eventdata, handles)


function e4x2_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e7x4_Callback(hObject, eventdata, handles)


function e7x4_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e7x3_Callback(hObject, eventdata, handles)


function e7x3_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e6x5_Callback(hObject, eventdata, handles)


function e6x5_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e6x4_Callback(hObject, eventdata, handles)


function e6x4_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e6x3_Callback(hObject, eventdata, handles)


function e6x3_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e5x4_Callback(hObject, eventdata, handles)


function e5x4_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e5x3_Callback(hObject, eventdata, handles)


function e5x3_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e4x4_Callback(hObject, eventdata, handles)


function e4x4_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e8x7_Callback(hObject, eventdata, handles)


function e8x7_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e8x8_Callback(hObject, eventdata, handles)


function e8x8_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e7x6_Callback(hObject, eventdata, handles)


function e7x6_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e7x7_Callback(hObject, eventdata, handles)


function e7x7_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e7x8_Callback(hObject, eventdata, handles)


function e7x8_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e8x9_Callback(hObject, eventdata, handles)


function e8x9_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e8x4_Callback(hObject, eventdata, handles)


function e8x4_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e9x3_Callback(hObject, eventdata, handles)


function e9x3_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e8x3_Callback(hObject, eventdata, handles)


function e8x3_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e7x5_Callback(hObject, eventdata, handles)


function e7x5_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e9x4_Callback(hObject, eventdata, handles)


function e9x4_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e9x6_Callback(hObject, eventdata, handles)


function e9x6_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e9x7_Callback(hObject, eventdata, handles)


function e9x7_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e9x8_Callback(hObject, eventdata, handles)


function e9x8_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e9x9_Callback(hObject, eventdata, handles)


function e9x9_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e8x5_Callback(hObject, eventdata, handles)


function e8x5_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e9x5_Callback(hObject, eventdata, handles)


function e9x5_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e8x6_Callback(hObject, eventdata, handles)


function e8x6_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e3x7_Callback(hObject, eventdata, handles)


function e3x7_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


