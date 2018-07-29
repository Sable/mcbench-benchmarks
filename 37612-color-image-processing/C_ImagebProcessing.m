function varargout = C_ImagebProcessing(varargin)
% C_IMAGEBPROCESSING MATLAB code for C_ImagebProcessing.fig
%      C_IMAGEBPROCESSING, by itself, creates a new C_IMAGEBPROCESSING or raises the existing
%      singleton*.
%
%      H = C_IMAGEBPROCESSING returns the handle to a new C_IMAGEBPROCESSING or the handle to
%      the existing singleton*.
%
%      C_IMAGEBPROCESSING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in C_IMAGEBPROCESSING.M with the given input arguments.
%
%      C_IMAGEBPROCESSING('Property','Value',...) creates a new C_IMAGEBPROCESSING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before C_ImagebProcessing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to C_ImagebProcessing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help C_ImagebProcessing

% Last Modified by GUIDE v2.5 17-Jun-2012 17:30:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @C_ImagebProcessing_OpeningFcn, ...
                   'gui_OutputFcn',  @C_ImagebProcessing_OutputFcn, ...
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


% --- Executes just before C_ImagebProcessing is made visible.
function C_ImagebProcessing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to C_ImagebProcessing (see VARARGIN)

% Choose default command line output for C_ImagebProcessing
handles.output = hObject;

set(handles.g1,'Visible','off');
set(handles.g2,'Visible','off');
set(handles.dim,'Enable','off');
set(handles.path,'Enable','off');
set(handles.save,'Enable','off');
set(handles.s1,'Enable','off');
set(handles.s2,'Enable','off');
set(handles.s3,'Enable','off');
set(handles.s4,'Enable','off');
set(handles.g3,'Visible','off');
set(handles.g4,'Visible','off');
set(handles.s5,'Enable','off');
set(handles.s6,'Enable','off');
set(handles.s7,'Enable','off');
set(handles.s8,'Enable','off');
set(handles.s9,'Enable','off');
set(handles.slider1,'Enable','off');
set(handles.slider2,'Enable','off');
set(handles.slider3,'Enable','off');
set(handles.slider4,'Enable','off');
set(handles.slider5,'Enable','off');
set(handles.set1,'Enable','off');
set(handles.set2,'Enable','off');
set(handles.set3,'Enable','off');
set(handles.set4,'Enable','off');
set(handles.set5,'Enable','off');
set(handles.rv,'Enable','off');
set(handles.gv,'Enable','off');
set(handles.bv,'Enable','off');
set(handles.cv,'Enable','off');
set(handles.bbv,'Enable','off');
set(handles.reset,'Enable','off');
set(handles.e1,'Enable','off');
set(handles.e2,'Enable','off');
set(handles.resize,'Enable','off');
set(handles.chres,'Enable','off');
set(handles.sres,'Enable','off');
set(handles.set5,'Enable','off');
set(handles.rrv,'Enable','off');
set(handles.slider6,'Enable','off');
set(handles.s10,'Enable','off');
set(handles.s6,'Enable','off');
set(handles.p1,'Enable','off');
set(handles.p2,'Enable','off');
set(handles.p3,'Enable','off');
set(handles.p4,'Enable','off');
set(handles.p5,'Enable','off');
set(handles.p6,'Enable','off');
set(handles.p7,'Enable','off');
set(handles.selectcm,'Enable','off');
set(handles.setcm,'Enable','off');
set(handles.invc,'Enable','off');
set(handles.autoa,'Enable','off');
set(handles.rgbo,'Enable','off');
set(handles.rgbm,'Enable','off');
set(handles.autocon,'Enable','off');
set(handles.crop,'Enable','off');
set(handles.n1,'Enable','off');
set(handles.n3,'Enable','off');
set(handles.n4,'Enable','off');
set(handles.n5,'Enable','off');
set(handles.dim2,'Enable','off');
set(handles.info,'Enable','off');
set(handles.f1,'Enable','off');
set(handles.f2,'Enable','off');
set(handles.f3,'Enable','off');
set(handles.f4,'Enable','off');
set(handles.dia,'Enable','off');
set(handles.ero,'Enable','off');
set(handles.strel,'Enable','off');
set(handles.strels,'Enable','off');
set(handles.strelv,'Enable','off');
set(handles.dfh1,'Enable','off');
set(handles.dfh2,'Enable','off');
% Update handles structure


guidata(hObject, handles);

% UIWAIT makes C_ImagebProcessing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = C_ImagebProcessing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function updateg4(handles)
r=handles.img(:,:,1);
g=handles.img(:,:,2);
b=handles.img(:,:,3);
x=size(r); x=(1:x(1,2));
r=r(1,:); g=g(1,:); b=b(1,:);
axes(handles.g4); plot(x,r,'r');
hold on
plot(x,g,'g'); plot(x,b,'b'); hold off;


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Browse the file from user
[file path]=uigetfile({'*.jpg';'*.bmp';'*.jpeg';'*.png'}, 'Load Image File within Avilable Extensions');
image=[path file];
handles.file=image;
if (file==0)
    warndlg('You did not selected any file ') ; % fille is not selected
end
 [fpath, fname, fext]=fileparts(file);
 validex=({'.bmp','.jpg','.jpeg','.png'});
 found=0;
 for (x=1:length(validex))
 if (strcmpi(fext,validex{x}))
     found=1;
     set(handles.dim,'Enable','on');
set(handles.path,'Enable','on');
set(handles.save,'Enable','on');
set(handles.s1,'Enable','on');
set(handles.s2,'Enable','on');
set(handles.s3,'Enable','on');
set(handles.s4,'Enable','on');
set(handles.s5,'Enable','on');
set(handles.s6,'Enable','on');
set(handles.s7,'Enable','on');
set(handles.s8,'Enable','on');
set(handles.s9,'Enable','on');
set(handles.slider1,'Enable','on');
set(handles.slider2,'Enable','on');
set(handles.slider3,'Enable','on');
set(handles.slider4,'Enable','on');
set(handles.slider5,'Enable','on');
set(handles.set1,'Enable','on');
set(handles.set2,'Enable','on');
set(handles.set3,'Enable','on');
set(handles.set4,'Enable','on');
set(handles.set5,'Enable','on');
set(handles.rv,'Enable','on');
set(handles.gv,'Enable','on');
set(handles.bv,'Enable','on');
set(handles.cv,'Enable','on');
set(handles.bbv,'Enable','on');
set(handles.reset,'Enable','on');
set(handles.e1,'Enable','on');
set(handles.e2,'Enable','on');
set(handles.resize,'Enable','on');
set(handles.chres,'Enable','on');
set(handles.sres,'Enable','on');
set(handles.set5,'Enable','on');
set(handles.rrv,'Enable','on');
set(handles.slider6,'Enable','on');
set(handles.s10,'Enable','on');
%set(handles.g2,'Visible','on');
set(handles.p1,'Enable','on');
set(handles.p2,'Enable','on');
set(handles.p3,'Enable','on');
set(handles.p4,'Enable','on');
set(handles.selectcm,'Enable','on');
set(handles.setcm,'Enable','on');
set(handles.invc,'Enable','on');
set(handles.autoa,'Enable','on');
set(handles.rgbo,'Enable','on');
set(handles.rgbm,'Enable','on');
set(handles.autocon,'Enable','on');
set(handles.crop,'Enable','on');
set(handles.n1,'Enable','on');
set(handles.n3,'Enable','on');
set(handles.n4,'Enable','on');
set(handles.n5,'Enable','on');
set(handles.dim2,'Enable','on');
set(handles.info,'Enable','on');
set(handles.f1,'Enable','on');
set(handles.f2,'Enable','on');
set(handles.f3,'Enable','on');
set(handles.f4,'Enable','on');
set(handles.dia,'Enable','on');
set(handles.ero,'Enable','on');
set(handles.strel,'Enable','on');
set(handles.strels,'Enable','on');
set(handles.strelv,'Enable','on');
set(handles.dfh1,'Enable','on');
set(handles.dfh2,'Enable','on');

     handles.img=imread(image);
handles.i=imread(image);
h = waitbar(0,'Please wait...');
steps = 100;
for step = 1:steps
    % computations take place here
    waitbar(step / steps)
end
close(h) 
 axes(handles.g1); cla; imshow(handles.img);
 axes(handles.g2); cla; imshow(handles.img);
 [dimen]=size(handles.img); dimen=num2str(dimen); set(handles.dim,'String',dimen);
 s=num2str(size(handles.img)); set(handles.dim2,'String',s);
 set(handles.path,'String',image);
 guidata(hObject,handles);
break; 
 end
 end
if (found==0)
     errordlg('Selected file does not match available extensions. Please select file from available extensions [ .jpg, .jpeg, .bmp, .png] ','Image Format Error');
end
% Disply image in current axes.

 set(handles.g3,'Visible','on');
set(handles.g4,'Visible','on');
 
% RGB component graph
r=handles.i(:,:,1);
g=handles.i(:,:,2);
b=handles.i(:,:,3);
x=size(r); x=(1:x(1,2));
r=r(1,:); g=g(1,:); b=b(1,:);
axes(handles.g3); plot(x,r,'r');
hold on
plot(x,g,'g'); plot(x,b,'b'); hold off;


updateg4(handles)

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file path]= uiputfile('*.jpg','Save Image as');
save=[path file]; imwrite(handles.img,save,'jpg');


function dim_Callback(hObject, eventdata, handles)
% hObject    handle to dim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dim as text
%        str2double(get(hObject,'String')) returns contents of dim as a double


% --- Executes during object creation, after setting all properties.
function dim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function path_Callback(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of path as text
%        str2double(get(hObject,'String')) returns contents of path as a double


% --- Executes during object creation, after setting all properties.
function path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=get(hObject,'Value');
r=handles.img(:,:,1);
g=handles.img(:,:,2); b=handles.img(:,:,3);
r1=r+x; rcon=cat(3,r1,g,b);
axes(handles.g2); cla; imshow(rcon)
set(handles.rv,'String',num2str(x));
handles.img=rcon;
r=handles.img(:,:,1);
g=handles.img(:,:,2);
b=handles.img(:,:,3);
x=size(r); x=(1:x(1,2));
r=r(1,:); g=g(1,:); b=b(1,:);
axes(handles.g4); plot(x,r,'r');
hold on
plot(x,g,'g'); plot(x,b,'b'); hold off;

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function rv_Callback(hObject, eventdata, handles)
% hObject    handle to rv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rv as text
%        str2double(get(hObject,'String')) returns contents of rv as a double


% --- Executes during object creation, after setting all properties.
function rv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x=get(hObject,'Value');
r=handles.img(:,:,1);
g=handles.img(:,:,2); b=handles.img(:,:,3);
g1=g+x; gcon=cat(3,r,g1,b);
axes(handles.g2); cla; imshow(gcon)
set(handles.gv,'String',num2str(x));
handles.img=gcon;

updateg4(handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function gv_Callback(hObject, eventdata, handles)
% hObject    handle to gv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gv as text
%        str2double(get(hObject,'String')) returns contents of gv as a double


% --- Executes during object creation, after setting all properties.
function gv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=get(hObject,'Value');
r=handles.img(:,:,1);
g=handles.img(:,:,2); b=handles.img(:,:,3);
b1=b+x; bcon=cat(3,r,g,b1);
axes(handles.g2); cla; imshow(bcon)
set(handles.bv,'String',num2str(x));
handles.img=bcon;
updateg4(handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function bv_Callback(hObject, eventdata, handles)
% hObject    handle to bv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bv as text
%        str2double(get(hObject,'String')) returns contents of bv as a double


% --- Executes during object creation, after setting all properties.
function bv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=get(hObject,'Value');
img=handles.img;
img=img.*x;
axes(handles.g2); cla; imshow(img)
set(handles.cv,'String',num2str(x));
handles.img=img;
updateg4(handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function cv_Callback(hObject, eventdata, handles)
% hObject    handle to cv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cv as text
%        str2double(get(hObject,'String')) returns contents of cv as a double


% --- Executes during object creation, after setting all properties.
function cv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=get(hObject,'Value');
img=handles.img;
img=img+x;
axes(handles.g2); cla; imshow(img)
set(handles.bbv,'String',num2str(x));
handles.img=img;
updateg4(handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function bbv_Callback(hObject, eventdata, handles)
% hObject    handle to bbv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bbv as text
%        str2double(get(hObject,'String')) returns contents of bbv as a double


% --- Executes during object creation, after setting all properties.
function bbv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bbv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.img=handles.i;
axes(handles.g2); cla; imshow(handles.img);
updateg4(handles);
s=num2str(size(handles.img)); set(handles.dim2,'String',s);
guidata(hObject,handles);

% --- Executes on button press in set1.
function set1_Callback(hObject, eventdata, handles)
% hObject    handle to set1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.g2); img=getimage;
handles.img=img; imshow(handles.img);
updateg4(handles);
guidata(hObject,handles);

% --- Executes on button press in set2.
function set2_Callback(hObject, eventdata, handles)
% hObject    handle to set2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.g2); img=getimage;
handles.img=img; imshow(handles.img);
updateg4(handles);
guidata(hObject,handles);



% --- Executes on button press in set3.
function set3_Callback(hObject, eventdata, handles)
% hObject    handle to set3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.g2); img=getimage;
handles.img=img; imshow(handles.img);
updateg4(handles);
guidata(hObject,handles);


% --- Executes on button press in set4.
function set4_Callback(hObject, eventdata, handles)
% hObject    handle to set4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.g2); img=getimage;
handles.img=img; imshow(handles.img);
updateg4(handles);
guidata(hObject,handles);


% --- Executes on button press in set5.
function set5_Callback(hObject, eventdata, handles)
% hObject    handle to set5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.g2); img=getimage;
handles.img=img; imshow(handles.img);
updateg4(handles);
guidata(hObject,handles);



function e1_Callback(hObject, eventdata, handles)
% hObject    handle to e1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e1 as text
%        str2double(get(hObject,'String')) returns contents of e1 as a double


% --- Executes during object creation, after setting all properties.
function e1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e2_Callback(hObject, eventdata, handles)
% hObject    handle to e2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e2 as text
%        str2double(get(hObject,'String')) returns contents of e2 as a double


% --- Executes during object creation, after setting all properties.
function e2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in resize.
function resize_Callback(hObject, eventdata, handles)
% hObject    handle to resize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=str2num(get(handles.e1,'String'));
w=str2num(get(handles.e2,'String'));
handles.img=imresize(handles.img, [h w]);
axes(handles.g2); cla; imshow(handles.img);
updateg4(handles);
s=num2str(size(handles.img)); set(handles.dim2,'String',s);
guidata(hObject,handles);


% --- Executes on selection change in chres.
function chres_Callback(hObject, eventdata, handles)
% hObject    handle to chres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=get(hObject,'Value');
switch val
    case 1
        warndlg('Please select a resolution value');
    case 2   %256x256
            handles.res=handles.img;
            axes(handles.g2); cla; 
            handles.res=imresize(imresize(handles.res,.5),1);
            imshow(handles.res);
            guidata(hObject, handles);
            handles.img=handles.res;
            updateg4(handles);
 
    case 3  % 128X128
            handles.res=handles.img;
            axes(handles.g2); cla; 
            handles.res=imresize(imresize(handles.res,1/2),2);
            imshow(handles.res);
            guidata(hObject, handles);
            handles.img=handles.res; updateg4(handles);
        
    case 4 % 64x64 
            handles.res=handles.img;
            axes(handles.g2); cla; 
            handles.res=imresize(imresize(handles.res,1/4),4);
            imshow(handles.res);
            guidata(hObject, handles);
           handles.img=handles.res;  updateg4(handles);
       
    case 5  % 32x32 
           handles.res=handles.img;
            axes(handles.g2); cla; 
            handles.res=imresize(imresize(handles.res,1/8),8);
            imshow(handles.res);
            guidata(hObject, handles);
           handles.img=handles.res;  updateg4(handles);
  
        case 6  % 16x16 
            handles.res=handles.img;
            axes(handles.g2); cla; 
            handles.res=imresize(imresize(handles.res,1/16),16);
            imshow(handles.res);
            guidata(hObject, handles);
           handles.img=handles.res;  updateg4(handles);
       
        case 7  % 8x8 
            handles.res=handles.img;
            axes(handles.g2); cla; 
            handles.res=imresize(imresize(handles.res,1/32),32);
            imshow(handles.res);
            guidata(hObject, handles);
            handles.img=handles.res; updateg4(handles);
end

        % Hints: contents = cellstr(get(hObject,'String')) returns chres contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chres


% --- Executes during object creation, after setting all properties.
function chres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sres.
function sres_Callback(hObject, eventdata, handles)
% hObject    handle to sres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.img=handles.res;
axes(handles.g2); cla; imshow(handles.img);
s=num2str(size(handles.img)); set(handles.dim2,'String',s);
guidata(hObject,handles);
updateg4(handles);


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rrv=(get(hObject,'Value'));
handles.rot=handles.img;
handles.rot=imrotate(handles.rot,rrv);
axes(handles.g2); cla; imshow(handles.rot);
guidata(hObject,handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function rrv_Callback(hObject, eventdata, handles)
% hObject    handle to rrv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rrv as text
%        str2double(get(hObject,'String')) returns contents of rrv as a double


% --- Executes during object creation, after setting all properties.
function rrv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rrv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set6.
function set6_Callback(hObject, eventdata, handles)
% hObject    handle to set6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.img=handles.rot;
axes(handles.g2); cla; imshow(handles.img);
updateg4(handles);
guidata(hObject,handles);

% --- Executes on button press in p1.
function p1_Callback(hObject, eventdata, handles)
% hObject    handle to p1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = waitbar(0,'Please wait...');
steps = 100;
for step = 1:steps
    % computations take place here
    waitbar(step / steps)
end
close(h) 
imageinfo(handles.file);

% --- Executes on button press in p2.
function p2_Callback(hObject, eventdata, handles)
% hObject    handle to p2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value')==get(hObject,'Max'))
axes(handles.g2); imdistline
elseif (get(hObject,'Value')==get(hObject,'Min'))
    axes(handles.g2); imshow(handles.img)
end
% Hint: get(hObject,'Value') returns toggle state of p2


% --- Executes on button press in p3.
function p3_Callback(hObject, eventdata, handles)
% hObject    handle to p3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
impixelinfo;
% Hint: get(hObject,'Value') returns toggle state of p3


% --- Executes on button press in p4.
function p4_Callback(hObject, eventdata, handles)
% hObject    handle to p4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value')==get(hObject,'Max'))
axes(handles.g2); impixelregion
elseif (get(hObject,'Value')==get(hObject,'Min'))
    axes(handles.g2); imshow(handles.img)
end

% Hint: get(hObject,'Value') returns toggle state of p4


% --- Executes on button press in p5.
function p5_Callback(hObject, eventdata, handles)
% hObject    handle to p5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imscrollpanel(handles.g2,handles.img);

% --- Executes on button press in p6.
function p6_Callback(hObject, eventdata, handles)
% hObject    handle to p6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imoverview(handles.image)

% --- Executes on button press in p7.
function p7_Callback(hObject, eventdata, handles)
% hObject    handle to p7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in selectcm.
function selectcm_Callback(hObject, eventdata, handles)
% hObject    handle to selectcm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.cm=handles.img;
val=get(hObject,'Value');
switch val
    case 1
        helpdlg('Please first select a color map','Color Map help');
    case 2
        handles.cm=rgb2ind(handles.cm,jet);
        handles.cm=ind2rgb(handles.cm,jet);
        axes(handles.g2); cla; imshow(handles.cm);
        guidata(hObject,handles);
        handles.img=handles.cm;
        updateg4(handles);
    case 3
        handles.cm=rgb2ind(handles.cm,HSV);
        handles.cm=ind2rgb(handles.cm,HSV);
        axes(handles.g2); cla; imshow(handles.cm);
        guidata(hObject,handles);
        handles.img=handles.cm;
        updateg4(handles);
    case 4
        handles.cm=rgb2ind(handles.cm,hot);
        handles.cm=ind2rgb(handles.cm,hot);
        axes(handles.g2); cla; imshow(handles.cm);
        guidata(hObject,handles);
        handles.img=handles.cm;
        updateg4(handles);
    case 5
        handles.cm=rgb2ind(handles.cm,cool);
        handles.cm=ind2rgb(handles.cm,cool);
        axes(handles.g2); cla; imshow(handles.cm);
        guidata(hObject,handles);
        handles.img=handles.cm;
        updateg4(handles);
    case 6
        handles.cm=rgb2ind(handles.cm,spring);
        handles.cm=ind2rgb(handles.cm,spring);
        axes(handles.g2); cla; imshow(handles.cm);
        guidata(hObject,handles);
        handles.img=handles.cm;
        updateg4(handles);
    case 7
        handles.cm=rgb2ind(handles.cm,summer);
        handles.cm=ind2rgb(handles.cm,summer);
        axes(handles.g2); cla; imshow(handles.cm);
        guidata(hObject,handles);
        handles.img=handles.cm;
       updateg4(handles);
    case 8
        handles.cm=rgb2ind(handles.cm,autumn);
        handles.cm=ind2rgb(handles.cm,autumn);
        axes(handles.g2); cla; imshow(handles.cm);
        guidata(hObject,handles);
        handles.img=handles.cm;
        updateg4(handles);
    case 9
        handles.cm=rgb2ind(handles.cm,winter);
        handles.cm=ind2rgb(handles.cm,winter);
        axes(handles.g2); cla; imshow(handles.cm);
        guidata(hObject,handles);
        handles.img=handles.cm;
        updateg4(handles);
    case 10
        handles.cm=rgb2ind(handles.cm,gray);
        handles.cm=ind2rgb(handles.cm,gray);
        axes(handles.g2); cla; imshow(handles.cm);
        guidata(hObject,handles);
        handles.img=handles.cm;
        updateg4(handles);
    case 11
        handles.cm=rgb2ind(handles.cm,bone);
        handles.cm=ind2rgb(handles.cm,bone);
        axes(handles.g2); cla; imshow(handles.cm);
        guidata(hObject,handles);
        handles.img=handles.cm;
        updateg4(handles);
    case 12
        handles.cm=rgb2ind(handles.cm,copper);
        handles.cm=ind2rgb(handles.cm,copper);
        axes(handles.g2); cla; imshow(handles.cm);
        guidata(hObject,handles);
        handles.img=handles.cm;
        updateg4(handles);
    case 13
        handles.cm=rgb2ind(handles.cm,pink);
        handles.cm=ind2rgb(handles.cm,pink);
        axes(handles.g2); cla; imshow(handles.cm);
        guidata(hObject,handles);
        handles.img=handles.cm;
        updateg4(handles);
    case 14
        handles.cm=rgb2ind(handles.cm,lines);
        handles.cm=ind2rgb(handles.cm,lines);
        axes(handles.g2); cla; imshow(handles.cm);
        guidata(hObject,handles);
        handles.img=handles.cm;
        updateg4(handles);
end
% Hints: contents = cellstr(get(hObject,'String')) returns selectcm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectcm


% --- Executes during object creation, after setting all properties.
function selectcm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectcm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setcm.
function setcm_Callback(hObject, eventdata, handles)
% hObject    handle to setcm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.img=handles.cm;
axes(handles.g2); cla; imshow(handles.img);
updateg4(handles);
guidata(hObject,handles);

% --- Executes on button press in invc.
function invc_Callback(hObject, eventdata, handles)
% hObject    handle to invc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=handles.img;
r=x(:,:,1); r=256-r;
g=x(:,:,2); g=256-g;
b=x(:,:,3); b=256-b;
handles.img=cat(3,r,g,b);
axes(handles.g2); cla; imshow(handles.img);
updateg4(handles);
guidata(hObject,handles);
% --- Executes on button press in autoa.
function autoa_Callback(hObject, eventdata, handles)
% hObject    handle to autoa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.img= imadjust(handles.img,[.2 .3 0; .6 .7 1],[]);
   axes(handles.g2); cla; imshow(handles.img);
   guidata(hObject,handles);
   updateg4(handles);

% --- Executes on button press in rgbo.
function rgbo_Callback(hObject, eventdata, handles)
% hObject    handle to rgbo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
r=handles.i(:,:,1);
g=handles.i(:,:,2);
b=handles.i(:,:,3);
figure,subplot(1,3,1)
imshow(r); title('RED Plane');
subplot(1,3,2)
imshow(g); title('Green Plane');
subplot(1,3,3)
imshow(b); title('Blue Plane');
% --- Executes on button press in rgbm.
function rgbm_Callback(hObject, eventdata, handles)
% hObject    handle to rgbm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
r=handles.img(:,:,1);
g=handles.img(:,:,2);
b=handles.img(:,:,3);
figure,subplot(1,3,1)
imshow(r); title('RED Plane');
subplot(1,3,2)
imshow(g); title('Green Plane');
subplot(1,3,3)
imshow(b); title('Blue Plane');


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;


% --- Executes on button press in autocon.
function autocon_Callback(hObject, eventdata, handles)
% hObject    handle to autocon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
r=handles.img(:,:,1);  r=histeq(r);
g=handles.img(:,:,2);  g=histeq(g);
b=handles.img(:,:,3);  b=histeq(b);
handles.img=cat(3,r,g,b);
axes(handles.g2); cla; imshow(handles.img);
guidata(hObject,handles);
updateg4(handles);


% --- Executes on button press in n1.
function n1_Callback(hObject, eventdata, handles)
% hObject    handle to n1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA
    handles.img = imnoise(handles.img,'gaussian');
    axes(handles.g2); cla; imshow(handles.img);
guidata(hObject,handles);
updateg4(handles);

% --- Executes on button press in n3.
function n3_Callback(hObject, eventdata, handles)
% hObject    handle to n3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = waitbar(0,'Please wait...');
steps = 200;
for step = 1:steps
    % computations take place here
    waitbar(step / steps)
end
close(h) 
handles.img = imnoise(handles.img,'poisson');
    axes(handles.g2); cla; imshow(handles.img);
guidata(hObject,handles);
updateg4(handles);

% --- Executes on button press in n4.
function n4_Callback(hObject, eventdata, handles)
% hObject    handle to n4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.img = imnoise(handles.img,'salt & pepper',0.02);
    axes(handles.g2); cla; imshow(handles.img);
guidata(hObject,handles);
updateg4(handles);

% --- Executes on button press in n5.
function n5_Callback(hObject, eventdata, handles)
% hObject    handle to n5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.img = imnoise(handles.img,'speckle',0.04);
    axes(handles.g2); cla; imshow(handles.img);
guidata(hObject,handles);
updateg4(handles);


% --- Executes on button press in f1.
function f1_Callback(hObject, eventdata, handles)
% hObject    handle to f1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=fspecial('average');
handles.img=imfilter(handles.img,h,'replicate');
axes(handles.g2); cla; imshow(handles.img)
guidata(hObject,handles);
updateg4(handles);


% --- Executes on button press in crop.
function crop_Callback(hObject, eventdata, handles)
% hObject    handle to crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imcrop(handles.g2);
handles.img=getimage(gca); close;
axes(handles.g2); cla; imshow(handles.img)
s=num2str(size(handles.img)); set(handles.dim2,'String',s);
guidata(hObject,handles);
updateg4(handles);



function dim2_Callback(hObject, eventdata, handles)
% hObject    handle to dim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dim2 as text
%        str2double(get(hObject,'String')) returns contents of dim2 as a double


% --- Executes during object creation, after setting all properties.
function dim2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in info.
function info_Callback(hObject, eventdata, handles)
% hObject    handle to info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = waitbar(0,'Please wait...');
steps = 100;
for step = 1:steps
    % computations take place here
    waitbar(step / steps)
end
close(h) 
imageinfo(handles.g2);


% --- Executes on button press in dia.
function dia_Callback(hObject, eventdata, handles)
% hObject    handle to dia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mori=handles.img;
str=strel(handles.strel,handles.value);
handles.mori=imdilate(handles.mori,str);
axes(handles.g2); cla; imshow(handles.mori)
guidata(hObject,handles);
handles.img=handles.mori;
updateg4(handles);

%imscrollpanel(handles.g2,handles.img);


% --- Executes on button press in f3.
function f3_Callback(hObject, eventdata, handles)
% hObject    handle to f3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
r=medfilt2(handles.img(:,:,1)); g=medfilt2(handles.img(:,:,2)); b=medfilt2(handles.img(:,:,3)); 
handles.img=cat(3,r,g,b);
axes(handles.g2); cla; imshow(handles.img);
guidata(hObject,handles);
updateg4(handles);


% --- Executes on button press in f2.
function f2_Callback(hObject, eventdata, handles)
% hObject    handle to f2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hsize=[8 8]; sigma=1.7;
h=fspecial('gaussian',hsize,sigma);
handles.img=imfilter(handles.img,h,'replicate');
axes(handles.g2); cla; imshow(handles.img);
guidata(hObject,handles);
updateg4(handles);


% --- Executes on button press in f4.
function f4_Callback(hObject, eventdata, handles)
% hObject    handle to f4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=fspecial('unsharp');
handles.img=imfilter(handles.img,h,'replicate');
axes(handles.g2); cla; imshow(handles.img)
guidata(hObject,handles);
updateg4(handles);


% --- Executes on button press in ero.
function ero_Callback(hObject, eventdata, handles)
% hObject    handle to ero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mori=handles.img;
str=strel(handles.strel,handles.value);
handles.mori=imerode(handles.mori,str);
axes(handles.g2); cla; imshow(handles.mori)
guidata(hObject,handles);
handles.img=handles.mori;
updateg4(handles);

% --- Executes on selection change in strel.
function strel_Callback(hObject, eventdata, handles)
% hObject    handle to strel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=get(hObject,'Value');
switch val
        case 1
        helpdlg('Please first select Structring Element and value ','Morphological Operations');
        case 2
        handles.strel='diamond';
        case 3
        handles.strel='disk';
        case 4
        helpdlg('Value must be a nonnegative multiple of 3.','Octagon Structure Help');
        handles.strel='octagon';
end
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns strel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from strel


% --- Executes during object creation, after setting all properties.
function strel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to strel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function strelv_Callback(hObject, eventdata, handles)
% hObject    handle to strelv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.value=str2num(get(hObject,'String'));
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of strelv as text
%        str2double(get(hObject,'String')) returns contents of strelv as a double


% --- Executes during object creation, after setting all properties.
function strelv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to strelv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in strels.
function strels_Callback(hObject, eventdata, handles)
% hObject    handle to strels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.img=handles.mori;
axes(handles.g2); cla; imshow(handles.img)
guidata(hObject,handles);
updateg4(handles);

% --- Executes on button press in dfh1.
function dfh1_Callback(hObject, eventdata, handles)
% hObject    handle to dfh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpdlg('Click and draw a free hand on ORIGNAL image & then press ENTER. ');
axes(handles.g1); improfile; grid on;

% --- Executes on button press in dfh2.
function dfh2_Callback(hObject, eventdata, handles)
% hObject    handle to dfh2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpdlg('Click and draw a free hand on MODIFIED image & then press ENTER. ');
axes(handles.g2); improfile; grid on;


% --------------------------------------------------------------------
function ex_Callback(hObject, eventdata, handles)
% hObject    handle to ex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;
