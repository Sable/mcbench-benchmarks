function varargout = xtended_gui(varargin)
% XTENDED_GUI M-file for xtended_gui.fig
%      XTENDED_GUI, by itself, creates a new XTENDED_GUI or raises the existing
%      singleton*.
%
%      H = XTENDED_GUI returns the handle to a new XTENDED_GUI or the handle to
%      the existing singleton*.
%
%      XTENDED_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in XTENDED_GUI.M with the given input arguments.
%
%      XTENDED_GUI('Property','Value',...) creates a new XTENDED_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before xtended_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to xtended_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help xtended_gui

% Last Modified by GUIDE v2.5 04-Mar-2004 00:36:05
% Copyright 2004-2010 RBemis The MathWorks, Inc. 

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @xtended_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @xtended_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before xtended_gui is made visible.
function xtended_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to xtended_gui (see VARARGIN)

% Choose default command line output for xtended_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes xtended_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = xtended_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[f,p] = uigetfile({'*.png;*.jpg;*.bmp;*.tif','Supported images';...
                   '*.png','Portable Network Graphics (*.png)';...
                   '*.jpg','J-PEG (*.jpg)';...
                   '*.bmp','Bitmap (*.bmp)';...
                   '*.tif','Tagged Image File (*.tif,)';...
                   '*.*','All files (*.*)'});
if isstr(p)
  x = imread([p f]);
  imshow(x)
  title(f)
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x = getimage(handles.axes2);
bg = imopen(x,strel('disk',10));
y = imsubtract(x,bg);
imshow(y)
title Flattened


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y = getimage(handles.axes2);
bw = im2bw(y,graythresh(y)); 
imshow(bw)
title Segmented


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bw = getimage(handles.axes2);
L = bwlabel(bw);
imshow(L,[])
colormap jet
pixval(handles.axes2,'on')
title Regions


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
L = getimage(handles.axes2);
stats = regionprops(L);
A = [stats.Area];
figure
hist(A)
xlabel Area
ylabel Popularity
title('Size Distribution')
