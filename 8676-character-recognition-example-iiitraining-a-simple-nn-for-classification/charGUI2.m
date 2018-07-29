function varargout = charGUI2(varargin)
% CHARGUI2 M-file for charGUI2.fig
%      CHARGUI2, by itself, creates a new CHARGUI2 or raises the existing
%      singleton*.
%
%      H = CHARGUI2 returns the handle to a new CHARGUI2 or the handle to
%      the existing singleton*.
%
%      CHARGUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHARGUI2.M with the given input arguments.
%
%      CHARGUI2('Property','Value',...) creates a new CHARGUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before charGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to charGUI2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help charGUI2

% Last Modified by GUIDE v2.5 03-Jul-2008 17:55:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @charGUI2_OpeningFcn, ...
                   'gui_OutputFcn',  @charGUI2_OutputFcn, ...
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


% --- Executes just before charGUI2 is made visible.
function charGUI2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to charGUI2 (see VARARGIN)
load data;
assignin('base','net',net);
% Choose default command line output for charGUI2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes charGUI2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = charGUI2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbLoad.
function pbLoad_Callback(hObject, eventdata, handles)
% hObject    handle to pbLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.bmp';'*.jpg';'*.gif';'*.*'}, 'Pick an Image File');
S = imread([pathname,filename]);
axes(handles.axes1);
imshow(S);

handles.S = S;
guidata(hObject, handles);


% --- Executes on button press in pbSelect.
function pbSelect_Callback(hObject, eventdata, handles)
% hObject    handle to pbSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = handles.S;
axes(handles.axes1);

% Selection of location
if isfield(handles,'api')
    handles.api.delete();
    rmfield(handles,'api');
    rmfield(handles,'hRect');
    axes(handles.axes1);
    imshow(S);
end

axes(handles.axes1);
sz = size(S);
handles.hRect = imrect(gca,[round(sz(2)/2) round(sz(1)/2) 20 20]); % Select object
handles.api = iptgetapi(handles.hRect);
guidata(hObject, handles);


% img_crop = imcrop(S);
% axes(handles.axes2);
% imshow(img_crop);
% 
% handles.img_crop = img_crop;

guidata(hObject, handles);




% --- Executes on button press in pbCrop.
function pbCrop_Callback(hObject, eventdata, handles)
% hObject    handle to pbCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.loc = handles.api.getPosition();
axes(handles.axes1);
S = handles.S;

handles.img_crop = imcrop(S,handles.loc);
axes(handles.axes2);
imshow(handles.img_crop);

% img_crop = imcrop(S);
% axes(handles.axes2);
% imshow(img_crop);
% 
% handles.img_crop = img_crop;


guidata(hObject, handles);

% --- Executes on button press in pbPreprocess.
function pbPreprocess_Callback(hObject, eventdata, handles)
% hObject    handle to pbPreprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

img_crop = handles.img_crop;
imgGray = rgb2gray(img_crop);
bw = im2bw(img_crop,graythresh(imgGray));
axes(handles.axes3);
imshow(bw);
bw2 = edu_imgcrop(bw);
axes(handles.axes4);
imshow(bw2);
handles.bw2 = bw2;
guidata(hObject, handles);


% --- Executes on button press in pbExtract.
function pbExtract_Callback(hObject, eventdata, handles)
% hObject    handle to pbExtract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bw2  = handles.bw2;
charvec = edu_imgresize(bw2);
axes(handles.axes5);
plotchar(charvec);
handles.charvec = charvec;
guidata(hObject, handles);

% --- Executes on button press in pbRecognize.
function pbRecognize_Callback(hObject, eventdata, handles)
% hObject    handle to pbRecognize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
charvec = handles.charvec;
selected_net = get(handles.editNN,'string');

selected_net = evalin('base',selected_net);

result = sim(selected_net,charvec);
[val, num] = max(result);
set(handles.editResult, 'string',num);


% --- Executes on button press in pbNN.
function pbNN_Callback(hObject, eventdata, handles)
% hObject    handle to pbNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





function editNN_Callback(hObject, eventdata, handles)
% hObject    handle to editNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNN as text
%        str2double(get(hObject,'String')) returns contents of editNN as a double


% --- Executes during object creation, after setting all properties.
function editNN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function editResult_Callback(hObject, eventdata, handles)
% hObject    handle to editResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editResult as text
%        str2double(get(hObject,'String')) returns contents of editResult as a double


% --- Executes during object creation, after setting all properties.
function editResult_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


