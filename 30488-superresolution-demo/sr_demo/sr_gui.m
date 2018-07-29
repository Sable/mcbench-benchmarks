function varargout = sr_gui(varargin)
% SR_GUI M-file for sr_gui.fig
%      SR_GUI, by itself, creates a new SR_GUI or raises the existing
%      singleton*.
%
%      H = SR_GUI returns the handle to a new SR_GUI or the handle to
%      the existing singleton*.
%
%      SR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SR_GUI.M with the given input arguments.
%
%      SR_GUI('Property','Value',...) creates a new SR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sr_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sr_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sr_gui

% Last Modified by GUIDE v2.5 19-Feb-2011 00:22:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sr_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @sr_gui_OutputFcn, ...
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

% --- Executes just before sr_gui is made visible.
function sr_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sr_gui (see VARARGIN)

% Choose default command line output for sr_gui
handles.mouse_pressed=0;
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using sr_gui.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

% UIWAIT makes sr_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sr_gui_OutputFcn(hObject, eventdata, handles)
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

h=waitbar(0,'Registering images...');
for id=2:length(handles.images)
    clear timage;
    for color=1:3
        timage(:,:,color)=register_image(double(handles.images{1}(:,:,color)),double(handles.images{id}(:,:,color)));
        
    end
    handles.images{id}=timage;
    waitbar(id/length(handles.images),h);
end
delete(h);
guidata(hObject,handles);
frame_slider_Callback(hObject, [], handles)

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function LoadMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to LoadMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = uigetdir;
files=dir(sprintf('%s/*.jpg',folder));
tmp=dir(sprintf('%s/*.JPG',folder));
files(length(files)+1:length(files)+length(tmp))=tmp;

handles.images=[];
h=waitbar(0,'Loading images...');
for id=1:length(files)
    handles.images{id}=double(imread(sprintf('%s/%s',folder,files(id).name)))/255;
%     for color=1:3
%         timage(:,:,color)=double(flipud(handles.images{id}(:,:,color)'));
%     end
    if length(size(handles.images{id}))==2 % expand grey scale image to color image format
        t=handles.images{id};
        t=zeros([size(handles.images{id}) 3]);
        t(:,:,1)=handles.images{id};
        t(:,:,2)=handles.images{id};
        t(:,:,3)=handles.images{id};
        handles.images{id}=t;
    end
    waitbar(id/length(files),h);
%     handles.images{id}=timage;
end
delete(h);
 
% for color=1:3
%     timage(:,:,color)=double(flipud(handles.images{1}(:,:,color)'));
% end
% images{1}=timage;

% handle.ImageAxes
axes(handles.ImageAxes);
hold off;
imshow(handles.images{1});
hold on;
set(handles.FrameSlider,'min',1);
set(handles.FrameSlider,'max',length(handles.images));
set(handles.FrameSlider,'value',1);
set(handles.frame_title,'string','Frame 1');
title('Frame 1');
guidata(hObject,handles);

% if ~isequal(folder, 0)
%     open(file);
% end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


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

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --- Executes on slider movement.
function FrameSlider_Callback(hObject, eventdata, handles)
% hObject    handle to FrameSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
axes(handles.ImageAxes);
hold off;
imshow(handles.images{round(get(hObject,'value'))});
hold on;
%set(handles.frame_title,'string',sprintf('Frame %d',round(get(hObject,'value'))));
title(sprintf('Frame %d',round(get(hObject,'value'))));

% --- Executes during object creation, after setting all properties.
function FrameSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrameSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pos=get(handles.ImageAxes,'currentpoint');
pos=pos(1,1:2);
if inrange(pos,handles.ImageAxes)
    if isfield(handles,'mouse_pressed')
        if handles.mouse_pressed
           if isfield(handles,'last_box')
                if ishandle(handles.last_box)
                    delete(handles.last_box);
                end
           end
           axes(handles.ImageAxes);
           handles.last_box=drawbox(handles.start_pos,pos); 
           guidata(hObject,handles);
        end
    end
    
end

function h=drawbox(p1,p2)
x=[p1(1) p2(1) p2(1) p1(1) p1(1)];
y=[p1(2) p1(2) p2(2) p2(2) p1(2)];
h=plot(x,y);

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pos=get(handles.ImageAxes,'currentpoint');
pos=pos(1,1:2);
if inrange(pos,handles.ImageAxes)
    handles.start_pos=pos;
    handles.mouse_pressed=1;
end
guidata(hObject,handles);

%     handles.tmp_box=drawbox(
% if (pos(1) >=0 & pos(1) <=

function flag=inrange(pos,h)
s=size(get(findobj(h,'type','image'),'cdata'));

if (pos(1)>=1) && (pos(2) >=1) && (pos(2) <= s(1)) && (pos(1) <= s(2))
    flag=1;
else
    flag=0;
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pos=get(handles.ImageAxes,'currentpoint');
pos=pos(1,1:2);

if inrange(pos,handles.ImageAxes)
    handles.mouse_pressed=0;
    handles.end_pos=pos;
    guidata(hObject,handles);
end


% --- Executes on selection change in BilinearProjectionPopup.
function BilinearProjectionPopup_Callback(hObject, eventdata, handles)
% hObject    handle to BilinearProjectionPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns BilinearProjectionPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BilinearProjectionPopup
p1(1)=min([handles.start_pos(1),handles.end_pos(1)]);
p1(2)=min([handles.start_pos(2),handles.end_pos(2)]);
p2(1)=max([handles.start_pos(1),handles.end_pos(1)]);
p2(2)=max([handles.start_pos(2),handles.end_pos(2)]);
p1=round(p1); p2=round(p2);
imobj=findobj(handles.ImageAxes,'type','image');
cdata=get(imobj,'cdata');
fid=round(get(handles.FrameSlider,'value'));
cdata=handles.images{fid};
imclip=cdata(p1(2):p2(2),p1(1):p2(1),:);

contents=get(hObject,'String');
figure; 
switch contents{get(hObject,'value')}
    case 'zoom 1x'
        imshow(imclip);
        title('zoom 1x');
    case 'zoom 2x'
        imclip=bilinear_interp(double(imclip));
        imshow(imclip);         
        title('zoom 2x');
    case 'zoom 4x'
        imclip=bilinear_interp(double(imclip));
        imclip=bilinear_interp(imclip);
        imshow(imclip);
        title('zoom 4x');
end
    

% --- Executes during object creation, after setting all properties.
function BilinearProjectionPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BilinearProjectionPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [p1,p2]=get_clip_range(handles)
p1(1)=min([handles.start_pos(1),handles.end_pos(1)]);
p1(2)=min([handles.start_pos(2),handles.end_pos(2)]);
p2(1)=max([handles.start_pos(1),handles.end_pos(1)]);
p2(2)=max([handles.start_pos(2),handles.end_pos(2)]);
p1=round(p1); p2=round(p2);

% --- Executes on button press in SRBWButton.
function SRBWButton_Callback(hObject, eventdata, handles)
% hObject    handle to SRBWButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[p1,p2]=get_clip_range(handles);
for id=1:length(handles.images)
    t2{id}=handles.images{id}(p1(2):p2(2),p1(1):p2(1),1)*255;
end
h=waitbar(0,'Running super-resolution for red component...');
image=sr_bw(t2,h,0,1)/255;
delete(h);
figure; imshow(image); title('super resolution image');

% --- Executes on button press in SRColorButton.
function SRColorButton_Callback(hObject, eventdata, handles)
% hObject    handle to SRColorButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[p1,p2]=get_clip_range(handles);
h=waitbar(0,'Running super-resolution for all three components...');
for color=1:3
    for id=1:length(handles.images)
        t2{id}=handles.images{id}(p1(2):p2(2),p1(1):p2(1),color)*255;
    end
    image{color}=sr_bw(t2,h,(color-1)/3,1/3)/255;
end
delete(h);
tmpimg=zeros([size(image{color}) 3]);
for color=1:3
    tmpimg(:,:,color)=image{color};
end
figure; imshow(tmpimg); title('super resolution image');


% --- Executes on button press in RegisterImageButton.
function RegisterImageButton_Callback(hObject, eventdata, handles)
% hObject    handle to RegisterImageButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h=waitbar(0,'Registering images...');
for id=2:length(handles.images)
    clear timage;
    timage=register_color_image(double(handles.images{1}), double(handles.images{id}));
    handles.images{id}=timage;
    waitbar(id/length(handles.images),h);
end
delete(h);
guidata(hObject,handles);
FrameSlider_Callback(hObject, [], handles)


% --- Executes on button press in CaptureFramesButton.
function CaptureFramesButton_Callback(hObject, eventdata, handles)
% hObject    handle to CaptureFramesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CaptureFramesButton

if get(hObject,'value') % starting capturing
   fprintf('starting capturing...');
   handles.images=[];
   vid=videoinput('winvideo',1,'YUY2_320x240');
   vid.ReturnedColorSpace='rgb';
   fid=1;
   axes(handles.ImageAxes);
   hold off;
   while (get(hObject,'value'))
       handles.images{fid}=double(getsnapshot(vid))/255;
       imshow(handles.images{fid});
       title(sprintf('Frame %d',fid));
       fid=fid+1;
   end
   hold on;
   set(handles.FrameSlider,'min',1);
   set(handles.FrameSlider,'max',length(handles.images));
   set(handles.FrameSlider,'value',length(handles.images));
   guidata(hObject, handles);
else 
   fprintf('stoping capturing...');
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over CaptureFramesButton.
function CaptureFramesButton_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to CaptureFramesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SaveMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to SaveMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

folder = uigetdir;
h=waitbar(0,'Saving images...');
for id=1:length(handles.images)
    imwrite(handles.images{id},sprintf('%s/%d.JPG',folder,id),'quality',100);
    waitbar(id/length(handles.images),h);
end
delete(h);


% --------------------------------------------------------------------
function EditMenu_Callback(hObject, eventdata, handles)
% hObject    handle to EditMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function RotateAntiClockwiseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to RotateAntiClockwiseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h=waitbar(0,'Rotating images...');
for id=1:length(handles.images)
    clear timage;
    for color=1:3
        timage(:,:,color)=double(flipud(handles.images{id}(:,:,color)'));
    end
    handles.images{id}=timage;
    waitbar(id/length(handles.images),h);
end
delete(h);

% handle.ImageAxes
axes(handles.ImageAxes);
hold off;
imshow(handles.images{1});
hold on;
% set(handles.FrameSlider,'min',1);
% set(handles.FrameSlider,'max',length(handles.images));
set(handles.FrameSlider,'value',1);
set(handles.frame_title,'string','Frame 1');
title('Frame 1');
guidata(hObject,handles);


% --------------------------------------------------------------------
function RotateClockwiseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to RotateClockwiseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h=waitbar(0,'Rotating images...');
for id=1:length(handles.images)
    clear timage;
    for color=1:3
        timage(:,:,color)=double(flipud(handles.images{id}(:,:,color))');
    end
    handles.images{id}=timage;
    waitbar(id/length(handles.images),h);
end
delete(h);

axes(handles.ImageAxes);
hold off;
imshow(handles.images{1});
hold on;
set(handles.FrameSlider,'value',1);
set(handles.frame_title,'string','Frame 1');
title('Frame 1');
guidata(hObject,handles);


% --------------------------------------------------------------------
function DeleteMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fid=round(get(handles.FrameSlider,'value'));
handles.images(fid)=[];
if fid > length(handles.images)
    fid=length(handles.images);
end
set(handles.FrameSlider,'value',fid);
set(handles.FrameSlider,'max',length(handles.images));
axes(handles.ImageAxes);
hold off;
imshow(handles.images{fid});
hold on;
title(sprintf('Frame %d',fid));
guidata(hObject,handles);



% --------------------------------------------------------------------
function AboutMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to AboutMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

popupmessage('help.txt');


% --------------------------------------------------------------------
function HelpMenu_Callback(hObject, eventdata, handles)
% hObject    handle to HelpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
