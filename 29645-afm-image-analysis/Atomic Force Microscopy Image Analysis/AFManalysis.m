function varargout = AFManalysis(varargin)
% AFMANALYSIS M-file for AFManalysis.fig
%      AFMANALYSIS, by itself, creates a new AFMANALYSIS or raises the existing
%      singleton*.
%
%      H = AFMANALYSIS returns the handle to a new AFMANALYSIS or the handle to
%      the existing singleton*.
%
%      AFMANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AFMANALYSIS.M with the given input arguments.
%
%      AFMANALYSIS('Property','Value',...) creates a new AFMANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AFManalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AFManalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AFManalysis

% Last Modified by GUIDE v2.5 07-Dec-2010 22:56:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AFManalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @AFManalysis_OutputFcn, ...
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


% --- Executes just before AFManalysis is made visible.
function AFManalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AFManalysis (see VARARGIN)

% Choose default command line output for AFManalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AFManalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AFManalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbuttonBrowse.
function pushbuttonBrowse_Callback(hObject, eventdata, handles)
[FileName,PathName] = uigetfile('*.jpg','Select the image file');

if PathName ~= 0    %if user not select cancel
addpath(PathName);  %add path to file search
imagearray = imread(FileName);
handles.imagesize = size(imagearray);
axes(handles.Image);
imshow(imagearray,'InitialMagnification','fit');
%handles.imagegray = rgb2gray(imagearray);
handles.imagearray = imagearray;
guidata(hObject, handles);

end
% hObject    handle to pushbuttonBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function Image_CreateFcn(hObject, eventdata, handles)
handles.Image= hObject;
imshow('square.png');
guidata(hObject, handles);
% hObject    handle to Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate Image


% --- Executes on slider movement.
function sliderimthreshhold_Callback(hObject, eventdata, handles)
s = handles.imagesize;
handles.slidervalth = get(handles.sliderth,'Value');
handles.imagebin = im2bw(handles.imagearray, 1-handles.slidervalth);
handles.imagebin = bwareaopen(handles.imagebin, round(s(1,1)*handles.slidervalfilter));

bouparam = str2num(get(handles.boundrypara,'string')); 
h = fspecial('gaussian',bouparam,bouparam);
handles.imagebin = imfilter(handles.imagebin,h);
handles.imageedge = edge(handles.imagebin);


imagewithboundry = handles.imagearray; 
for i = 1:1:s(1,1)
    for j = 1:1:s(1,2)
        if handles.imageedge(i,j) == 1
            imagewithboundry(i,j,:)= 0;
        
        end
    end
end
%imagewithboundry = imadd(handles.imagearray(:,:,1), handles.imageedge);
imshow(imagewithboundry,'InitialMagnification','fit');

[L, num] = bwlabel(handles.imagebin);
area = bwarea(handles.imagebin)/num;
dia  = ((area*6)/pi)^(1/3); 

dianm = dia*(str2num(get(handles.imagesizenm,'string'))/s(1,1));

num = num2str(num);
set(handles.npno,'string',num)

areanm = (pi/6)*((dianm)^3);
areanm = num2str(areanm);
set(handles.nparea,'string',area)

dianm = num2str(dianm);
set(handles.npdia,'string',dianm)



guidata(hObject, handles);
 

% hObject    handle to sliderimthreshhold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderimthreshhold_CreateFcn(hObject, eventdata, handles)
handles.sliderth = hObject;
%handles.imagebin = im2bw(handles.image,0); 
guidata(hObject, handles);
% hObject    handle to sliderimthreshhold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderremovesmallpatch_Callback(hObject, eventdata, handles)
s = handles.imagesize;
handles.slidervalth = get(handles.sliderth,'Value');
handles.slidervalfilter = get(handles.sliderremovesmallpatch,'Value');
%handles.imagebin = im2bw(handles.imagearray, 1-handles.slidervalth);
handles.imagebin2 = bwareaopen(handles.imagebin, round(s(1,1)*handles.slidervalfilter));
handles.imageedge = edge(handles.imagebin2);
imagewithboundry = handles.imagearray; 
for i = 1:1:s(1,1)
    for j = 1:1:s(1,2)
        if handles.imageedge(i,j) == 1
            imagewithboundry(i,j,:)= 0;
        
        end
    end
end

imshow(imagewithboundry,'InitialMagnification','fit');

[L, num] = bwlabel(handles.imagebin2);
area = bwarea(handles.imagebin)/num;
dia  = ((area*6)/pi)^(1/3); 

dianm = dia*(str2num(get(handles.imagesizenm,'string'))/s(1,1));

num = num2str(num);
set(handles.npno,'string',num)

areanm = (pi/6)*((dianm)^3);
areanm = num2str(areanm);
set(handles.nparea,'string',area)

dianm = num2str(dianm);
set(handles.npdia,'string',dianm)

guidata(hObject, handles);
 
% hObject    handle to sliderremovesmallpatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderremovesmallpatch_CreateFcn(hObject, eventdata, handles)
handles.sliderremovesmallpatch = hObject;
handles.slidervalfilter = 0;
guidata(hObject, handles);
% hObject    handle to sliderremovesmallpatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function npno_CreateFcn(hObject, eventdata, handles)
handles.npno = hObject;
guidata(hObject, handles);
% hObject    handle to npno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function npdia_CreateFcn(hObject, eventdata, handles)
handles.npdia = hObject;
guidata(hObject, handles);
% hObject    handle to npdia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function nparea_CreateFcn(hObject, eventdata, handles)
handles.nparea = hObject;
guidata(hObject, handles);
% hObject    handle to nparea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function imagesizenm_Callback(hObject, eventdata, handles)
% hObject    handle to imagesizenm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imagesizenm as text
%        str2double(get(hObject,'String')) returns contents of imagesizenm as a double


% --- Executes during object creation, after setting all properties.
function imagesizenm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imagesizenm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function boundrypara_Callback(hObject, eventdata, handles)
s = handles.imagesize;
handles.slidervalth = get(handles.sliderth,'Value');
handles.imagebin = im2bw(handles.imagearray, 1-handles.slidervalth);
handles.imagebin = bwareaopen(handles.imagebin, round(s(1,1)*handles.slidervalfilter));

bouparam = str2num(get(handles.boundrypara,'string')); 
h = fspecial('gaussian',bouparam,bouparam);
handles.imagebin = imfilter(handles.imagebin,h);
handles.imageedge = edge(handles.imagebin);


imagewithboundry = handles.imagearray; 
for i = 1:1:s(1,1)
    for j = 1:1:s(1,2)
        if handles.imageedge(i,j) == 1
            imagewithboundry(i,j,:)= 0;
        
        end
    end
end
%imagewithboundry = imadd(handles.imagearray(:,:,1), handles.imageedge);
imshow(imagewithboundry,'InitialMagnification','fit');

[L, num] = bwlabel(handles.imagebin);
area = bwarea(handles.imagebin)/num;
dia  = ((area*6)/pi)^(1/3); 

dianm = dia*(str2num(get(handles.imagesizenm,'string'))/s(1,1));

num = num2str(num);
set(handles.npno,'string',num)

areanm = (pi/6)*((dianm)^3);
areanm = num2str(areanm);
set(handles.nparea,'string',area)

dianm = num2str(dianm);
set(handles.npdia,'string',dianm)
% hObject    handle to boundrypara (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boundrypara as text
%        str2double(get(hObject,'String')) returns contents of boundrypara as a double


% --- Executes during object creation, after setting all properties.
function boundrypara_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boundrypara (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
