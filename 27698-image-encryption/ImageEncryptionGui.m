function varargout = ImageEncryptionGui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageEncryptionGui_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageEncryptionGui_OutputFcn, ...
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

function ImageEncryptionGui_OpeningFcn(hObject, eventdata, handles, varargin)


handles.output = hObject;
axes(handles.axes4)
BackGr = imread('leaf.jpg');
  imshow(BackGr);

guidata(hObject, handles);
clear all;
clc;
global Img;
global EncImg;
global DecImg;

function varargout = ImageEncryptionGui_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


function pushbutton1_Callback(hObject, eventdata, handles)

global Img;
global key;
X = uigetfile('*.jpg;*.tiff;*.ppm;*.pgm;*.png','pick a jpge file');
Img = imread(X);
  axes(handles.axes1)
  imshow(Img);
  
[n m k] = size(Img);
  key = keyGen(n*m);
guidata(hObject, handles);
function pushbutton2_Callback(hObject, eventdata, handles)
global Img ;
global EncImg; 
global key;
EncImg = imageProcess(Img,key);
axes(handles.axes2)
imshow(EncImg);
imwrite(EncImg,'Encoded.jpg','jpg');
guidata(hObject, handles);

function pushbutton3_Callback(hObject, eventdata, handles)
global DecImg;
global EncImg;
global key;
DecImg = imageProcess(EncImg,key);
axes(handles.axes3);
imshow(DecImg);
imwrite(DecImg,'Decoded.jpg','jpg');
guidata(hObject, handles);