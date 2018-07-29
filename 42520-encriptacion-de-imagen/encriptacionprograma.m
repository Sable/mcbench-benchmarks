function varargout = encriptacionprograma(varargin)
%ENCRIPTACIONPROGRAMA M-file for encriptacionprograma.fig
%      ENCRIPTACIONPROGRAMA, by itself, creates a new ENCRIPTACIONPROGRAMA or raises the existing
%      singleton*.
%
%      H = ENCRIPTACIONPROGRAMA returns the handle to a new ENCRIPTACIONPROGRAMA or the handle to
%      the existing singleton*.
%
%      ENCRIPTACIONPROGRAMA('Property','Value',...) creates a new ENCRIPTACIONPROGRAMA using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to encriptacionprograma_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      ENCRIPTACIONPROGRAMA('CALLBACK') and ENCRIPTACIONPROGRAMA('CALLBACK',hObject,...) call the
%      local function named CALLBACK in ENCRIPTACIONPROGRAMA.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help encriptacionprograma

% Last Modified by GUIDE v2.5 11-Jun-2013 18:21:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @encriptacionprograma_OpeningFcn, ...
                   'gui_OutputFcn',  @encriptacionprograma_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before encriptacionprograma is made visible.
function encriptacionprograma_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for encriptacionprograma
handles.output = hObject;
axes(handles.axes5);
BackGr = imread('encrip.gif');
  imshow(BackGr);

% Update handles structure
guidata(hObject, handles);
clc;
global Img;
global EncImg;
global DecImg;
% UIWAIT makes encriptacionprograma wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = encriptacionprograma_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% --- Executes during object creation, after setting all properties.
function imagenin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imagenin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate imagenin


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Img;
global key;
X = uigetfile('*.jpg;*.tiff;*.ppm;*.pgm;*.png','pick a jpge file');
Img = imread(X);
  axes(handles.imagenin);
  imshow(Img);
  
[n m k] = size(Img);
  key = keyGen(n*m);
guidata(hObject, handles);
function [proImageOut] = imageProcess(ImgInp,key)
[n m k] = size(ImgInp);
% key =cell2mat(struct2cell( load('key5.mat')));
% key = keyGen(n*m);
for ind = 1 : m    
    Fkey(:,ind) = key((1+(ind-1)*n) : (((ind-1)*n)+n));
end
len = n;
bre = m;
for ind = 1 : k
    Img = ImgInp(:,:,ind);
for ind1 = 1 : len
    for ind2 = 1 : bre        
        proImage(ind1,ind2) = bitxor(Img(ind1,ind2),Fkey(ind1,ind2));        
    end
end
proImageOut(:,:,ind) = proImage(:,:,1);
end
figure,imshow(proImageOut);
return;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Img ;
global EncImg; 
global key;
EncImg = imageProcess(Img,key);
axes(handles.axes2)
imshow(EncImg);
imwrite(EncImg,'nueva imagen encriptada.jpg','jpg');


guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DecImg;
global EncImg;
global key;
DecImg = imageProcess(EncImg,key);
axes(handles.axes3);
imshow(DecImg);
imwrite(DecImg,'imagen decriptada.jpg','jpg');
guidata(hObject, handles);
function [key] = keyGen(n)
n = n*4;
% n = 2048*2048*16;
%n = 24 * 24 * 8;
bin_x = zeros(n,1,'uint8');
r = 3.9999998;
bin_x_N_Minus_1 =  0.300001;
x_N = 0;
tic
for ind = 2 : n
    x_N = 1 - 2* bin_x_N_Minus_1 * bin_x_N_Minus_1;    
     if (x_N > 0.0)
        bin_x(ind-1) = 1;
    end 
     bin_x_N_Minus_1 =  x_N;
     
end
toc
save bin_sec bin_x;
t = int8(0);
key = zeros(n/4,1,'uint8');
for ind1 = 1 : n/4
    
    for ind2 = 1 : 4
    key(ind1) = key(ind1) + bin_x(ind2*ind1)* 2 ^ (ind2-1);
    end
  
   
end
