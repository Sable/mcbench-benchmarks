function varargout = WFT(varargin)
% Function:             Windowed Fourier transform (interface)
% Initially Developed:  Dr Qian Kemao (16 May 2009)
% Last modified:        Dr Qian Kemao (17 May 2009)
% Version:              1.0
% Copyrights:           All rights reserved.
% Contact:              mkmqian@ntu.edu.sg (Dr Qian Kemao)

% pushbutton_CallWFTKernel M-file for pushbutton_CallWFTKernel.fig
%      pushbutton_CallWFTKernel, by itself, creates a new pushbutton_CallWFTKernel or raises the existing
%      singleton*.
%
%      H = pushbutton_CallWFTKernel returns the handle to a new pushbutton_CallWFTKernel or the handle to
%      the existing singleton*.
%
%      pushbutton_CallWFTKernel('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in pushbutton_CallWFTKernel.M with the given input arguments.
%
%      pushbutton_CallWFTKernel('Property','Value',...) creates a new pushbutton_CallWFTKernel or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before WFT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to WFT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pushbutton_CallWFTKernel

% Last Modified by GUIDE v2.5 20-May-2009 08:55:16

% Begin initialization code - DO NOT EDIT

%sturcture of g:
%f:                 original data
%filtered:          filtered version of f
%wrapped:           wrapped phase
%unwrapped:         unwrapped phase
%PathMap:           unwrapping path
%g.wx:              wx from wfr
%g.wy:              wy from wfr
%g.r:               r from wfr
%g.phase:           phase from wfr
%g.FringeType:      1~4
%g.AlgorithmType:   'wff' or 'wfr'
%g.a:               background intensity

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WFT_OpeningFcn, ...
                   'gui_OutputFcn',  @WFT_OutputFcn, ...
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


% --- Executes just before pushbutton_CallWFTKernel is made visible.
function WFT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pushbutton_CallWFTKernel (see VARARGIN)

% Choose default command line output for pushbutton_CallWFTKernel
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pushbutton_CallWFTKernel wait for user response (see UIRESUME)
% uiwait(handles.figure_WFT);


% --- Outputs from this function are returned to the command line.
function varargout = WFT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_LoadMat.
function pushbutton_LoadMat_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_LoadMat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile( ...
        '*.mat',  'MATLAB data (*.mat)','Pick a file');
if filterindex~=0
    load (strcat(pathname,filename));
    g.filtered=g.f;
    g.unwrapped=[];
    g.PathMap=[];
    imagesc(angle(g.f))
    colormap gray;
    save result g;
end


% --- Executes on button press in pushbutton_ReadfII.
function pushbutton_ReadfII_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ReadfII (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile( ...
        {'*.jpg;*.bmp;*.tif;', 'Image files (*.jpg, *.bmp, *.tif)'; ...
        '*.jpg',  'jpg (*.jpg)'; ...
        '*.bmp','bmp (*.bmp)'; ...
        '*.tif','tif (*.tif)'}, ...
        'Pick a file');
if filterindex~=0
    g.wrapped=double(imread(strcat(pathname,filename)));
    g.wrapped=g.wrapped(:,:,1);
    valmax=max(max(g.wrapped));
    valmin=min(min(g.wrapped));
    g.wrapped=(g.wrapped-valmin)/(valmax-valmin)*2*pi-pi;
    g.f=exp(sqrt(-1)*g.wrapped);
    g.filtered=g.f;
    g.unwrapped=[];
    g.PathMap=[];
    g.FringeType=2;
    imagesc(angle(g.f))
    colormap gray;
    save result g;
end


% --- Executes on button press in pushbutton_ReadfIII.
function pushbutton_ReadfIII_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ReadfIII (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile( ...
        {'*.jpg;*.bmp;*.tif;', 'Image files (*.jpg, *.bmp, *.tif)'; ...
        '*.jpg',  'jpg (*.jpg)'; ...
        '*.bmp','bmp (*.bmp)'; ...
        '*.tif','tif (*.tif)'}, ...
        'Pick a file');
if filterindex~=0
    g.f=double(imread(strcat(pathname,filename)));
    g.f=g.f(:,:,1);
    g.a=mean2(g.f);
    g.f=g.f-g.a;
    g.filtered=g.f;
    g.unwrapped=[];
    g.PathMap=[];
    g.FringeType=3;
    imagesc(g.f)
    colormap gray;
    save result g;
end


% --- Executes on button press in pushbutton_ReadfIV.
function pushbutton_ReadfIV_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ReadfIV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile( ...
        {'*.jpg;*.bmp;*.tif;', 'Image files (*.jpg, *.bmp, *.tif)'; ...
        '*.jpg',  'jpg (*.jpg)'; ...
        '*.bmp','bmp (*.bmp)'; ...
        '*.tif','tif (*.tif)'}, ...
        'Pick a file');
if filterindex~=0
    g.f=double(imread(strcat(pathname,filename)));
    g.f=g.f(:,:,1);
    g.a=mean2(g.f);
    g.f=g.f-g.a;
    g.filtered=g.f;
    g.unwrapped=[];
    g.PathMap=[];
    g.FringeType=4;
    imagesc(g.f)
    colormap gray;
    save result g;
end


% --- Executes on button press in pushbutton_CallWFTKernel.
function pushbutton_CallWFTKernel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_CallWFTKernel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WFTKernel;


% --- Executes on button press in pushbutton_qg.
function pushbutton_qg_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_qg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load result;
[g.unwrapped g.PathMap]=unwrapping_qg_trim(g.filtered);
imagesc(g.unwrapped)
save result g;


% --- Executes on button press in pushbutton_ViewOriginalPhase.
function pushbutton_ViewOriginalPhase_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ViewOriginalPhase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load result;
imagesc(angle(g.f));
H=findobj('Tag','checkbox_SaveOption'); 
val=get(H,'Value');
if val==1 & ~isempty(g.f)
    imwritescale(angle(g.f),'OriginalPhase.jpg');
end


% --- Executes on button press in pushbutton_ViewOriginalAmplitude.
function pushbutton_ViewOriginalAmplitude_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ViewOriginalAmplitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load result;
imagesc(abs(g.f));
H=findobj('Tag','checkbox_SaveOption'); 
val=get(H,'Value');
if val==1 & ~isempty(g.f)
    imwritescale(abs(g.f),'OriginalAmplitude.jpg');
end


% --- Executes on button press in pushbutton_ViewFilteredPhase.
function pushbutton_ViewFilteredPhase_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ViewFilteredPhase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load result
imagesc(angle(g.filtered));
H=findobj('Tag','checkbox_SaveOption'); 
val=get(H,'Value');
if val==1 & ~isempty(g.filtered)
    imwritescale(angle(g.filtered),'FilteredPhase.jpg');
end


% --- Executes on button press in pushbutton_ViewFilteredAmplitude.
function pushbutton_ViewFilteredAmplitude_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ViewFilteredAmplitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load result
imagesc(abs(g.filtered));
H=findobj('Tag','checkbox_SaveOption'); 
val=get(H,'Value');
if val==1 & ~isempty(g.filtered)
    imwritescale(abs(g.filtered),'FilteredAmplitude.jpg');
end


% --- Executes on button press in pushbutton_ViewUnwrappedPhase.
function pushbutton_ViewUnwrappedPhase_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ViewUnwrappedPhase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load result
imagesc(g.unwrapped);
H=findobj('Tag','checkbox_SaveOption'); 
val=get(H,'Value');
if val==1 & ~isempty(g.unwrapped)
    imwritescale(g.unwrapped,'UnwrappedPhase.jpg');
end


% --- Executes on button press in pushbutton_ViewUnwrappingPath.
function pushbutton_ViewUnwrappingPath_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ViewUnwrappingPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load result
imagesc(g.PathMap);
H=findobj('Tag','checkbox_SaveOption'); 
val=get(H,'Value');
if val==1 & ~isempty(g.PathMap)
    imwritescale(g.PathMap,'UnwrappingPath.jpg');
end

% --- Executes on button press in pushbutton_ViewOriginalFringePattern.
function pushbutton_ViewOriginalFringePattern_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ViewOriginalFringePattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load result
imagesc(real(g.f));
H=findobj('Tag','checkbox_SaveOption'); 
val=get(H,'Value');
if val==1 & ~isempty(g.f)
    imwritescale(real(g.f),'OriginalFringePattern.jpg');
end


% --- Executes on button press in pushbutton_ViewRealPartOfFilteredResult.
function pushbutton_ViewRealPartOfFilteredResult_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ViewRealPartOfFilteredResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load result
imagesc(real(g.filtered));
H=findobj('Tag','checkbox_SaveOption'); 
val=get(H,'Value');
if val==1 & ~isempty(g.filtered)
    imwritescale(real(g.filtered),'RealPartOfFilteredResult.jpg');
end


% --- Executes on button press in pushbutton_ViewCosineOfFilteredPhase.
function pushbutton_ViewCosineOfFilteredPhase_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ViewCosineOfFilteredPhase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load result
imagesc(cos(angle(g.filtered)));
H=findobj('Tag','checkbox_SaveOption'); 
val=get(H,'Value');
if val==1 & ~isempty(g.filtered)
    imwritescale(cos(angle(g.filtered)),'CosineOfFilteredPhase.jpg');
end


% --- Executes on button press in checkbox_SaveOption.
function checkbox_SaveOption_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_SaveOption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_SaveOption


% --- Executes on button press in checkbox_ViewColor.
function checkbox_ViewColor_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_ViewColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ViewColor


% --- Executes on button press in checkbox_ViewInColor.
function checkbox_ViewInColor_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_ViewInColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ViewInColor
if get(hObject,'Value')==1
    colormap('default');
else
    colormap(gray);
end
