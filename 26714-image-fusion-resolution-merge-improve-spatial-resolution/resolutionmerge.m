function varargout = resolutionmerge(varargin)
% RESOLUTIONMERGE M-file for resolutionmerge.fig
%      
% GUI for improving resolution of lower resolution image using higher
% resolution image using RGB-to-HSI conversion.
% Images have to be spatially registered.
%
% Monochromatic (gray scale) low resolution image is converged to colored
% image by false color mapping to "hot" color scheme. This RGB image is
% then converted to Hue, Saturation and Value (HSV) image. Value component is replaced
% by higher resolution image and the resulting HSV image is converted back to
% RGB. This RGB merged image converted to gray scale is a merged image with
% improved spatial resolution.
% 
% To run, type:
% >> resolutionmerge
%
% Can work with any type of color or monochromatic image. If images are colored
% they are converted to gray scale first and then merged.
% To load variables from matlab file, the file should contain variables
% LOWRES and HIGHRES
%
% created by K.Artyushkova
% February 2010
%
% 

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @resolutionmerge_OpeningFcn, ...
                   'gui_OutputFcn',  @resolutionmerge_OutputFcn, ...
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


% --- Executes just before resolutionmerge is made visible.
function resolutionmerge_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to resolutionmerge (see VARARGIN)

% Choose default command line output for resolutionmerge
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes resolutionmerge wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = resolutionmerge_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% Input section 
% --------------------------------------------------------------------
function load_low_res_1_Callback(hObject, eventdata, handles)
% hObject    handle to load_low_res_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname]=uigetfile('*.*','Open low resolution image');
cd(pathname)
[N,M]=size(filename);
image=imread(char(filename));
[n,m,p]=size(image);
if p==3
    lowres=rgb2gray(image);
else
    lowres=image;
end
axes(handles.axes1)
handles.lowres=lowres;
iptsetpref('ImshowAxesVisible', 'on')
imagesc(uint8(lowres)), colormap(gray)
guidata(hObject,handles)
    

% --------------------------------------------------------------------
function open_lowres_Callback(hObject, eventdata, handles)
% hObject    handle to open_lowres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname]=uigetfile('*.mat','Open low resolution image. Image should be saved in variable LOWRES');
cd(pathname)
D=load (filename, 'lowres');
image=D.lowres;
[n,m,p]=size(image);
if p==3
    lowres=rgb2gray(image);
else
    lowres=image;
end
axes(handles.axes1)
handles.lowres=lowres;
iptsetpref('ImshowAxesVisible', 'on')
imagesc(uint8(lowres)), colormap(gray)
guidata(hObject,handles)

% --------------------------------------------------------------------
function load_highres_Callback(hObject, eventdata, handles)
% hObject    handle to load_highres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname]=uigetfile('*.*','Open high resolution image');
cd(pathname)
[N,M]=size(filename);
image=imread(char(filename));
[n,m,p]=size(image);
if p==3
    highres=rgb2gray(image);
else
    highres=image;
end
axes(handles.axes2)
handles.highres=highres;
iptsetpref('ImshowAxesVisible', 'on')
imagesc(uint8(highres)), colormap(gray)
guidata(hObject,handles)
    
% --------------------------------------------------------------------
function Open_highres_Callback(hObject, eventdata, handles)
% hObject    handle to Open_highres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname]=uigetfile('*.mat','Open high resolution image. Image should be saved in variable LOWRES');
cd(pathname)
D=load (filename, 'highres');
image=D.highres;
[n,m,p]=size(image);
if p==3
    highres=rgb2gray(image);
else
    highres=image;
end
axes(handles.axes2) 
handles.highres=highres;
iptsetpref('ImshowAxesVisible', 'on')
imagesc(uint8(highres)), colormap(gray)
guidata(hObject,handles)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Main algorithm
% --- Executes on button press in Merge_resolution.
function Merge_resolution_Callback(hObject, eventdata, handles)
% hObject    handle to Merge_resolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
lowres=handles.lowres;
highres=handles.highres;
map=hot(256);
R=ind2rgb(lowres,map);
axes(handles.axes3) 
iptsetpref('ImshowAxesVisible', 'on')
imagesc(R), colormap(hot)
HSV=rgb2hsv(R);
HSV_sub=HSV;
HSV_sub(:,:,3)=highres;
merged=hsv2rgb(HSV_sub);
merged=uint8(merged);
mergedG=rgb2gray(merged);
axes(handles.axes4) 
iptsetpref('ImshowAxesVisible', 'on')
imagesc(uint8(mergedG)), colormap(gray)
handles.merged=merged;
handles.mergedG=mergedG;
guidata(hObject, handles);


% --- Executes on button press in displaycolor.
function displaycolor_Callback(hObject, eventdata, handles)
% hObject    handle to displaycolor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of displaycolor
merged=handles.merged;
axes(handles.axes4) 
iptsetpref('ImshowAxesVisible', 'on')
imagesc(uint8(merged))

% --- Executes on button press in disp_grayscale.
function disp_grayscale_Callback(hObject, eventdata, handles)
% hObject    handle to disp_grayscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of disp_grayscale
mergedG=handles.mergedG;
axes(handles.axes4) 
iptsetpref('ImshowAxesVisible', 'on')
imagesc(uint8(mergedG)), colormap(gray)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Output section
% --------------------------------------------------------------------
function save_mat_Callback(hObject, eventdata, handles)
% hObject    handle to save_mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mergedG=handles.mergedG;
merged=handles.merged;
datapath = uigetdir;
cd(datapath)
[filename, pathname] = uiputfile('*.mat', 'save merged image into mat file');
save(filename, 'merged','mergedG')

% --------------------------------------------------------------------
function save_tiff_Callback(hObject, eventdata, handles)
% hObject    handle to save_tiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mergedG=handles.mergedG;
merged=handles.merged;
datapath = uigetdir;
cd(datapath)
imwrite(uint8(mergedG),'mergedG.tiff','tiff')
imwrite(uint8(merged),'merged.tiff','tiff')

