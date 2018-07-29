function varargout = ImagePatchTool(varargin)
% IMAGEPATCHTOOL M-file for ImagePatchTool.fig
%      IMAGEPATCHTOOL, by itself, creates a new IMAGEPATCHTOOL or raises the existing
%      singleton*.
%
%      H = IMAGEPATCHTOOL returns the handle to a new IMAGEPATCHTOOL or the handle to
%      the existing singleton*.
%
%      IMAGEPATCHTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEPATCHTOOL.M with the given input arguments.
%
%      IMAGEPATCHTOOL('Property','Value',...) creates a new IMAGEPATCHTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImagePatchTool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImagePatchTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help ImagePatchTool
% Last Modified by GUIDE v2.5 04-Sep-2009 22:17:43
% ImagePatchTool ver 1.2
% Special characters now available.
% Amitabh Verma (amtukv@gmail.com)
% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImagePatchTool_OpeningFcn, ...
                   'gui_OutputFcn',  @ImagePatchTool_OutputFcn, ...
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


% --- Executes just before ImagePatchTool is made visible.
function ImagePatchTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImagePatchTool (see VARARGIN)
global patch_trans location a bR bG bB r g b text alpha ImagePatchTool
% Choose default command line output for ImagePatchTool
handles.output = hObject;
load patchdefaults.mat

% Update handles structure
guidata(hObject, handles);
ImagePatchTool = guihandles(); % Link for C# loader

set(handles.edit_sp,'string',native2unicode(128:255));
set(handles.popupmenu1,'value',patch_trans);
set(handles.popupmenu2,'value',location);

set(handles.bR,'string',bR);
set(handles.bG,'string',bG);
set(handles.bB,'string',bB);
a(:,:,1) = bR;
a(:,:,2) = bG;
a(:,:,3) = bB;

set(handles.R,'string',r);
set(handles.G,'string',g);
set(handles.B,'string',b);

set(handles.edit1,'string',text);

if patch_trans==3 || patch_trans==4
    set(handles.alphabox, 'Enable', 'on')
else
set(handles.alphabox, 'Enable', 'off')
end
set(handles.alphabox, 'string', alpha)
set(handles.status, 'string', 'Make Label')
axis off;

% UIWAIT makes ImagePatchTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ImagePatchTool_OutputFcn(hObject, eventdata, handles) 
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
% character to image
global i a bR bG bB RGB_patched img font r g b
set(handles.status, 'string', 'Initializing... Please wait.')
ascii(32:174) = native2unicode(32:174);
sizea=font.FontSize;
a=zeros(sizea+6,sizea+6);

bR=str2double(get(handles.bR,'string'));
bG=str2double(get(handles.bG,'string'));
bB=str2double(get(handles.bB,'string'));
a(:,:,1) = bR;
a(:,:,2) = bG;
a(:,:,3) = bB;

r=str2double(get(handles.R,'string'));
g=str2double(get(handles.G,'string'));
b=str2double(get(handles.B,'string'));

figure(1)
warning('off')
for x=32:174
t=ascii(1,x);
t=num2str(t);

    imshow(a);
    set(imtext(0.5,0.65,t,'center'),font,'color',[r,g,b])
    i{x}=getframe;
end
warning('on')
close(1)
if (size(RGB_patched,1)>0) && (size(img,1)>0)
    set(handles.status, 'string', 'Ready')
else
    set(handles.status, 'string', 'Make Label')
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global text
text = get(hObject,'String');
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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global i img a RGB

text = get(handles.edit1,'String');
for y = 1:size(text,2)
    t = text(1,y);
    seq(y)=unicode2native(t);
end

img =  zeros(size(a,1),(size(a,2)*(size(text,2))),3);

for rgb=1:3
seqc = 1;
k1 = 0; 
for k=1:size(img,2)
    j1=0;
    if k1==size(a,2)
        k1=0;
        seqc=seqc+1;
    else
    end
     
    k1=k1+1;
    
    for j=1:(size(img,1))
        j1=j1+1;
        img(j,k,rgb)=i{seq(seqc)}.cdata(j1,k1,rgb);
    end
    
end
end
%img=uint8(img);
imshow(img);
if (size(RGB,1)>0) && (size(img,1)>0)
    set(handles.status, 'string', 'Ready')
else
    set(handles.status, 'string', 'Load an Image')
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global RGB filename pathname img
[filename,pathname] = uigetfile( ...
{'*.jpg;*.tif','Image Files (*.jpg,*.tif)';
 '*.jpg','Jpg-files (*.jpg)';...
 '*.tif','Tif-files (*.tif)';...
 '*.*',  'All Files (*.*)'},...
 'Load Image');
if isequal(filename,0) || isequal(pathname,0)
%       disp('User pressed cancel')
    else
%       disp(['User selected ', fullfile(pathname, filename)])
RGB=imread(fullfile(pathname, filename));
cd(pathname);

if (size(RGB,1)>0) && (size(img,1)>0)
    set(handles.status, 'string', 'Ready')
else
    set(handles.status, 'string', 'Make Label')
end
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global alpha RGB_patched img patch_trans location RGB

RGB_patched = RGB;
if (size(RGB_patched,1)==0)
       set(handles.status, 'string', 'Please load an image first')
elseif size(img,2)>size(RGB_patched,2) || size(img,1)>size(RGB_patched,1)
    set(handles.status, 'string', 'Your Label dimensions exceed image. Currently only single line supported.')
    
else
alpha = str2double(get(handles.alphabox,'String'));

switch location
    case 1
        rx=1+size(RGB_patched,1)-size(img,1);
        ry=size(RGB_patched,1);
        cx=1+size(RGB_patched,2)-size(img,2);
        cy=size(RGB_patched,2);
    case 2
        rx=1+size(RGB_patched,1)-size(img,1);
        ry=size(RGB_patched,1);
        cx=1;
        cy=size(img,2);
    case 3
        rx=1;
        ry=size(img,1);
        cx=1+size(RGB_patched,2)-size(img,2);
        cy=size(RGB_patched,2);
    case 4
        rx=1;
        ry=size(img,1);
        cx=1;
        cy=size(img,2);
    otherwise
end



for RGB_layers = 1:size(RGB_patched,3)

p11=0;
for p1 = (rx):(ry)
p11 = p11+1;
p22 = 0;
for p2 = (cx):(cy)
p22 = p22+1;

    switch patch_trans
        case 1
        RGB_patched(p1,p2,RGB_layers) = img(p11,p22,RGB_layers);
        case 2
            if (img(p11,p22,1)==img(1,1,1)) && (img(p11,p22,2)==img(1,1,2)) && (img(p11,p22,3)==img(1,1,3))
            else
                RGB_patched(p1,p2,RGB_layers) = img(p11,p22,RGB_layers);
            end
        case 3
        RGB_patched(p1,p2,RGB_layers) = ((img(p11,p22,RGB_layers)*(alpha))+(RGB_patched(p1,p2,RGB_layers)*(1-alpha)));
        case 4
        if (img(p11,p22,1)==img(1,1,1)) && (img(p11,p22,2)==img(1,1,2)) && (img(p11,p22,3)==img(1,1,3))
        else
        RGB_patched(p1,p2,RGB_layers) = ((img(p11,p22,RGB_layers)*(alpha))+(RGB_patched(p1,p2,RGB_layers)*(1-alpha)));
        end
    otherwise
    end
end
end
end
%figure
%subplot (1, 2, 1);imshow(uint8(RGB));
%subplot (1, 2, 2);imshow(uint8(RGB_patched));
figure(1)
RGB_patched=uint8(RGB_patched);
imshow(RGB_patched);

end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global patch_trans
set(handles.alphabox, 'Enable', 'off')
    switch get(handles.popupmenu1,'Value')
    case 1
        set(handles.popupmenu1, 'Value',1);
        patch_trans = 1;
    case 2
        set(handles.popupmenu1, 'Value',2);
        patch_trans = 2;
    case 3
        set(handles.popupmenu1, 'Value',3);
        patch_trans = 3;
        set(handles.alphabox, 'Enable', 'on')
    case 4
        set(handles.popupmenu1, 'Value',4);
        patch_trans = 4;
        set(handles.alphabox, 'Enable', 'on')
        otherwise
    end
% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global location
    switch get(handles.popupmenu2,'Value')
    case 1
        set(handles.popupmenu2, 'Value',1);
        location = 1;

    case 2
        set(handles.popupmenu2, 'Value',2);
        location = 2;

    case 3
        set(handles.popupmenu2, 'Value',3);
        location = 3;

    case 4
        set(handles.popupmenu2, 'Value',4);
        location = 4;

        otherwise
    end
% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alphabox_Callback(hObject, eventdata, handles)
% hObject    handle to alphabox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global alpha
alpha = get(hObject,'String');
% Hints: get(hObject,'String') returns contents of alphabox as text
%        str2double(get(hObject,'String')) returns contents of alphabox as a double


% --- Executes during object creation, after setting all properties.
function alphabox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphabox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global RGB RGB_patched diff c
c=0;
for l0=1:size(RGB,3)
    for l1=1:size(RGB,1)
       for l2=1:size(RGB,2)
        if (RGB(l1,l2,l0))==(RGB_patched(l1,l2,l0))
            
        else
            c=c+1;
            diff{c}=[l1,l2,l0];
        end
       end
    end
end
d = [num2str(c),' pixels in ',num2str(size(RGB,1)*size(RGB,2)*size(RGB,3)),' pixels (',num2str(size(RGB,3)),' layered Image)'];
set(handles.text2,'String',d);



function R_Callback(hObject, eventdata, handles)
% hObject    handle to R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R as text
%        str2double(get(hObject,'String')) returns contents of R as a double


% --- Executes during object creation, after setting all properties.
function R_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function G_Callback(hObject, eventdata, handles)
% hObject    handle to G (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of G as text
%        str2double(get(hObject,'String')) returns contents of G as a double


% --- Executes during object creation, after setting all properties.
function G_CreateFcn(hObject, eventdata, handles)
% hObject    handle to G (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function B_Callback(hObject, eventdata, handles)
% hObject    handle to B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of B as text
%        str2double(get(hObject,'String')) returns contents of B as a double


% --- Executes during object creation, after setting all properties.
function B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bR_Callback(hObject, eventdata, handles)
% hObject    handle to bR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bR as text
%        str2double(get(hObject,'String')) returns contents of bR as a double


% --- Executes during object creation, after setting all properties.
function bR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bG_Callback(hObject, eventdata, handles)
% hObject    handle to bG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bG as text
%        str2double(get(hObject,'String')) returns contents of bG as a double


% --- Executes during object creation, after setting all properties.
function bG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bB_Callback(hObject, eventdata, handles)
% hObject    handle to bB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bB as text
%        str2double(get(hObject,'String')) returns contents of bB as a double


% --- Executes during object creation, after setting all properties.
function bB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bB (see GCBO)
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
global RGB_patched
if (size(RGB_patched,1)<=0)
    set(handles.status, 'string', 'No Patched Image Available in Memory')
%    disp('No Patched Image Available in Memory')
else
    [filename,path] = uiputfile( ...
{'*.tif','Tif Uncompressed Image Files (*.tif)';
 '*.*',  'All Files (*.*)'},...
 'Save Patched Image as');
    if isequal(filename,0) || isequal(path,0)
%       disp('User pressed cancel')
    else
%       disp(['User selected ', fullfile(path, filename)])
save(fullfile(path, filename))
imwrite(RGB_patched,fullfile(path,filename),'tiff','compression','none');
cd(path)
    end
end


% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fig=figure('name','About ImagePatchTool','position',[560 500 300 80],'color',[1 1 1],'menubar','none','NumberTitle','off');
uicontrol(fig,...
    'style','text',...
    'HorizontalAlignment','left',...
    'string','ImagePatchTool ver 1.2©      Author: Amitabh Verma          Email: amtukv@gmail.com',...
    'position',[70 10 160 45],...
    'Backgroundcolor',[1 1 1],...
    'callback',{});



% --- Executes on button press in c1.
function c1_Callback(hObject, eventdata, handles)
% hObject    handle to c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Create push button with string ABC
global font c1
c1 = uicontrol('Style', 'text', ...
     'Position', [1 1 1 1], 'String', 'Font Type');
font = uisetfont(c1);



% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global text bR bG bB r g b a i font patch_trans location alpha
clear hObject eventdata handles
save patchdefaults.mat;


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname img RGB
[filename,pathname] = uigetfile( ...
{'*.jpg;*.tif','Image Files (*.jpg,*.tif)';
 '*.jpg','Jpg-files (*.jpg)';...
 '*.tif','Tif-files (*.tif)';...
 '*.*',  'All Files (*.*)'},...
 'Load Label Image');
if isequal(filename,0) || isequal(pathname,0)
%       disp('User pressed cancel')
    else
%       disp(['User selected ', fullfile(pathname, filename)])
img=imread(fullfile(pathname, filename));
cd(pathname);
imshow(img);
if (size(RGB,1)>0) && (size(img,1)>0)
    set(handles.status, 'string', 'Ready')
else
    set(handles.status, 'string', 'Make Label')
end
end


% --- Executes on selection change in edit_sp.
function edit_sp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global special
    switch get(handles.edit_sp,'Value')
    case 1
        set(handles.edit_sp, 'Value',1);
    case 2
        set(handles.edit_sp, 'Value',2);
        special = 1;
        text = get(handles.edit1,'String');
        text(length(text)+1)=native2unicode(153);
        set(handles.edit1, 'string',text);
    case 3
        set(handles.edit_sp, 'Value',3);
        special = 2;
        text = get(handles.edit1,'String');
        text(length(text)+1)=native2unicode(169);
        set(handles.edit1, 'string',text);
    case 4
        set(handles.edit_sp, 'Value',4);
        special = 3;
        text = get(handles.edit1,'String');
        text(length(text)+1)=native2unicode(174);
        set(handles.edit1, 'string',text);
        otherwise
    end
% Hints: contents = get(hObject,'String') returns edit_sp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from edit_sp


% --- Executes during object creation, after setting all properties.
function edit_sp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on edit_sp and none of its controls.
function edit_sp_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit_sp (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
