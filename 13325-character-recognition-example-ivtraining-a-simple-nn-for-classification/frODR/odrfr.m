function varargout = odrfr(varargin)
% ODRFR M-file for odrfr.fig
%      ODRFR, by itself, creates a new ODRFR or raises the existing
%      singleton*.
%
%      H = ODRFR returns the handle to a new ODRFR or the handle to
%      the existing singleton*.
%
%      ODRFR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ODRFR.M with the given input arguments.
%
%      ODRFR('Property','Value',...) creates a new ODRFR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before odrfr_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to odrfr_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help odrfr

% Last Modified by GUIDE v2.5 10-Oct-2004 00:15:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @odrfr_OpeningFcn, ...
                   'gui_OutputFcn',  @odrfr_OutputFcn, ...
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


% --- Executes just before odrfr is made visible.
function odrfr_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to odrfr (see VARARGIN)




% Choose default command line output for odrfr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes odrfr wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = odrfr_OutputFcn(hObject, eventdata, handles) 
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

[filename, pathname] = uigetfile({'*.bmp';'*.jpg';'*.gif';'*.*'}, 'Pick an Image File');
S = imread([pathname,filename]);
axes(handles.axes1);
imshow(S);

handles.S = S;
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

S = handles.S;
axes(handles.axes1);
img_crop = imcrop(S);
axes(handles.axes2);
imshow(img_crop);
handles.img_crop = img_crop;

axes(handles.axes7);
I=S;
Igray = rgb2gray(I);
Ibw = im2bw(Igray,graythresh(Igray));
Iedge = edge(uint8(Ibw));
se = strel('square',2);
Iedge2 = imdilate(Iedge, se); 
Ifill= imfill(Iedge2,'holes');
[Ilabel num] = bwlabel(Ifill);
Iprops = regionprops(Ilabel);
Ibox = [Iprops.BoundingBox];
[y,x]=size(Ibox);%
x=x/4;%
Ibox = reshape(Ibox,[4 x]);%

handles.Ibox=Ibox;
imshow(I)

selected_col = get(handles.edit5,'string');
selected_col = evalin('base',selected_col);

selected_ln = get(handles.edit6,'string');
selected_ln = evalin('base',selected_ln);

for cnt = 1:selected_ln * selected_col
    rectangle('position',Ibox(:,cnt),'edgecolor','r');
end
guidata(hObject, handles);
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

img_crop = handles.img_crop;
imgGray = rgb2gray(img_crop);
bw = im2bw(img_crop,graythresh(imgGray));
axes(handles.axes3);
imshow(bw);
bw2 = charcrop(bw);
axes(handles.axes4);
imshow(bw2);
handles.bw2 = bw2;

guidata(hObject, handles);
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

bw2  = handles.bw2;
charvec = figresize(bw2);
axes(handles.axes5);
plotchar(charvec);

handles.charvec = charvec;
guidata(hObject, handles);
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
net = handles.net ;
charvec = handles.charvec;
%selected_net = get(handles.edit1,'string');

result = sim(net,charvec);
[val, num] = max(result);
set(handles.edit2, 'string',num);
guidata(hObject, handles);

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile({'*.bmp';'*.jpg';'*.gif';'*.*'}, 'Pick an Image File');
trimg = imread([pathname,filename]);

selected_col = get(handles.edit5,'string');
selected_col = evalin('base',selected_col);

selected_ln = get(handles.edit6,'string');
selected_ln = evalin('base',selected_ln);

img = preprocess(trimg,selected_col,selected_ln);

for cnt = 1:selected_ln * selected_col;
    bw2 = charcrop(img{cnt});
    charvec = figresize(bw2);
    out(:,cnt) = charvec;
end
P = out(:,1:40); 
T = [eye(10) eye(10) eye(10) eye(10)];
%Ptest = out(:,(selected_ln -2)* selected_col :selected_ln * selected_col);

%% Creating and training of the Neural Network
net = createnn(P,T);
handles.net = net;

%% Testing the Neural Network
%[a,b]=max(sim(net,Ptest));
%disp(b);
assignin('base','net',net);
guidata(hObject, handles);
function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


