function varargout = MRIViewerB(varargin)
% MRIVIEWERB M-file for MRIViewerB.fig
%  By Ibraheem Al-Dhamari
%      ibr_ex@hotmail.com
% MRI 3D Interactive image viewer
% You may daownload image datasets from :
%                              http://www.fil.ion.ucl.ac.uk/spm/data/

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MRIViewerB_OpeningFcn, ...
                   'gui_OutputFcn',  @MRIViewerB_OutputFcn, ...
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


% --- Executes just before MRIViewerB is made visible.
function MRIViewerB_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MRIViewerB (see VARARGIN)
global img h w d m1 m2 m3

clc
% Choose default command line output for MRIViewerB
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%==========================================================================
set(handles.axes1,'Units','pixels');
set(handles.axes2,'Units','pixels');
set(handles.axes3,'Units','pixels');
set(handles.figure1,'Units','pixels');

img=analyze75read('fM00223_004.img');
imgh=analyze75info('fM00223_004.img');

img=round(img/256);
img=mat2gray(img);

x=imgh.Dimensions;
h=x(1);
w=x(2);
d=x(3);

m1=round(h/2);
m2=round(w/2);
m3=round(d/2);

% we need imshow before imagsc 
% if dont then images get blue
 axes(handles.axes2);
 imgb=(img(m1,1:w,1:d));
 imgbb(1:h,1:d)=imgb(1,1:h,1:d);
 imshow(imgbb);

guidata(hObject, handles);
%===============================================================


ss=struct2cell(imgh)
for i=1:length(ss)
    whos ss{i} 
    if islogical(ss{i})
       ss{i}=lo2str(ss{i}) ;
    else
        if isnumeric(ss{i})
           ss{i}=num2str(ss{i}) 
        end
    end         
end
ff=fieldnames(imgh)
sf=strcat(ff,' = ' ,ss) 
set(handles.ls,'String',sf) ;

m1=round(h/2);
m2=round(w/2);
m3=round(d/2);
axes(handles.axes1);
imga=(img(1:h,1:w,m3));
imagesc(imga);

axes(handles.axes2);
imgb=(img(m1,1:w,1:d));
imgbb(1:h,1:d)=imgb(1,1:h,1:d);
imgbb=imrotate(imgbb,90,'bilinear');
imagesc(imgbb);

axes(handles.axes3);
imgc=(img(1:h,m2,1:d));
imgcc(1:h,1:d)=imgc(1:h,1,1:d);
imgccc=imgcc';
imgccc=imrotate(imgccc,180,'bilinear');
imgccc=flipdim(imgccc,2);
imagesc(imgccc);
drawnow;

% --- Outputs from this function are returned to the command line.
function varargout = MRIViewerB_OutputFcn(hObject, eventdata, handles) 
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
% handles    structure with [f,p]=uigetfile('*.bmp'); % How to make it open in a specific directory
axes(handles.axes1);
[f,p]=uigetfile('*.*'); % How to make it open in a specific directory
%simg=imread([p,f[f,p]=uigetfile('*.bmp'); % How to make it open in a specific directory
simg=imread([p,f]);
imshow(simg);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2);
[f,p]=uigetfile('*.*'); % How to make it open in a specific directory
%simg=imread([p,f[f,p]=uigetfile('*.bmp'); % How to make it open in a specific directory
simg2=imread([p,f]);
imshow(simg2);



% --- Executes during object creation, after setting all properties.
function ls_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in Open3d.
function Open3d_Callback(hObject, eventdata, handles)
% hObject    handle to Open3d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global img i h w d m1 m2 m3
clc
i=1;
[f,p]=uigetfile('*.*'); % How to make it open in a specific directory
img=analyze75read([p,f]);
imgh=analyze75info([p,f])

img=flipdim(img,1); % correct image display (from radiology LSA to neurology RAS)

x=imgh.Dimensions;
h=x(1);
w=x(2);
d=x(3);


ss=struct2cell(imgh)
for i=1:length(ss)
    whos ss{i} 
    if islogical(ss{i})
       ss{i}=lo2str(ss{i}) ;
    else
        if isnumeric(ss{i})
           ss{i}=num2str(ss{i}) 
        end
    end         
end
ff=fieldnames(imgh)
sf=strcat(ff,' = ' ,ss) 
set(handles.ls,'String',sf) ;


m1=round(h/2);
m2=round(w/2);
m3=round(d/2);

axes(handles.axes1);
imga=(img(1:h,1:w,m3));

imagesc(imga);


axes(handles.axes2);
imgb=(img(m1,1:w,1:d));
imgbb(1:h,1:d)=imgb(1,1:h,1:d);
imgbb=imrotate(imgbb,90,'bilinear');
imagesc(imgbb);

axes(handles.axes3);
imgc=(img(1:h,m2,1:d));
imgcc(1:h,1:d)=imgc(1:h,1,1:d);
imgccc=imgcc';
imgccc=imrotate(imgccc,180,'bilinear');
imgccc=flipdim(imgccc,2);
whos imgccc
imagesc(imgccc);

set(handles.axes1,'Units','pixels')
set(handles.axes2,'Units','pixels')
set(handles.axes3,'Units','pixels')
set(handles.figure1,'Units','pixels')
drawnow;
get(gca,'DataAspectRatio')
guidata(hObject, handles);

% --- Executes on selection change in ls.
function ls_Callback(hObject, eventdata, handles)
% hObject    handle to ls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ls contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ls


% --- Executes on button press in bclose.
function bclose_Callback(hObject, eventdata, handles)
% hObject    handle to bclose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

%==========================================================================
% --- Executes on mouse motion over figure - except title and menu.

function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% change  x image





% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
global img h w d

ax1 = handles.axes1;  % get current axes handle
% Fill the structure with data.
XLM1 = get(ax1,'xlim');
YLM1 = get(ax1,'ylim');
AXP1 = get(ax1,'pos');
DFX1 = diff(XLM1);
DFY1 = diff(YLM1);

ax2 = handles.axes2 ; % get current axes handle
% Fill the structure with data.
XLM2 = get(ax2,'xlim');
YLM2 = get(ax2,'ylim');
AXP2 = get(ax2,'pos');
DFX2 = diff(XLM2);
DFY2 = diff(YLM2);

ax3 = handles.axes3  ;% get current axes handle
% Fill the structure with data.
XLM3 = get(ax3,'xlim');
YLM3 = get(ax3,'ylim');
AXP3 = get(ax3,'pos');
DFX3 = diff(XLM3);
DFY3 = diff(YLM3);

F = get(handles.figure1,'currentpoint');  % The current point w.r.t the figure.

% Figure out of the current point is over the axes or not -> logicals
tf11 = AXP1(1) <= F(1) && F(1) <= AXP1(1) + AXP1(3);
tf12 = AXP1(2) <= F(2) && F(2) <= AXP1(2) + AXP1(4);

tf21 = AXP2(1) <= F(1) && F(1) <= AXP2(1) + AXP2(3);
tf22 = AXP2(2) <= F(2) && F(2) <= AXP2(2) + AXP2(4);

tf31 = AXP3(1) <= F(1) && F(1) <= AXP3(1) + AXP3(3);
tf32 = AXP3(2) <= F(2) && F(2) <= AXP3(2) + AXP3(4);

 if tf11 && tf12

 %==============( Image A )=======================    
    % Calculate the current point w.r.t. the axes.
    Cx1 =  XLM1(1) + (F(1)-AXP1(1)).*(DFX1/AXP1(3));
    Cy1 =  YLM1(1) + (F(2)-AXP1(2)).*(DFY1/AXP1(4));
    Cx1=round(Cx1);
    Cy1=round(Cy1);
    set(handles.ptxt1,'str',num2str([Cx1,Cy1],4));  % put the mouse pointers in the string textbox
    
    % affect B (Axial) Top View only
     axes(handles.axes2);
     imgb=img(Cx1,:,:);
%      whos imgb
     imgbb(1:w,1:d)=imgb; 
     imgb=imrotate(imgbb,90,'bilinear');
     imagesc(imgb);

    % affect  C (Sagittal) Side View only  
     axes(handles.axes3);
     imgc=img(:,Cy1,:);
     imgcc(1:h,1:d)=imgc(1:h,1,1:d);
     imgccc=imgcc';
     imgccc=imrotate(imgccc,180,'bilinear');
     imgccc=flipdim(imgccc,2);
%      whos imgccc
     imagesc(imgccc)
 
 else
    if tf21 && tf22
        
    %==============( Image B )=======================    

       % Calculate the current point w.r.t. the axes.
       Cx2 =  XLM2(1) + (F(1)-AXP2(1)).*(DFX2/AXP2(3));
       Cy2 =  YLM2(1) + (F(2)-AXP2(2)).*(DFY2/AXP2(4));
       Cx2=round(Cx2)
       Cy2=round(Cy2);
       set(handles.ptxt2,'str',num2str([Cx2,Cy2],4));  % put the mouse pointers in the string textbox
       

       % affect  A (Coronal) Front View only
       axes(handles.axes1);
       imga=img(:,:,Cy2);
       %imgaa(1:256,1:54)=imga(1:256,1,1:54);
%        imgaaa=imgaa';
       imagesc(imga);
     
       %  affect C (Sagittal) Side View only
       axes(handles.axes3);
       imgc=img(:,Cx2,:);
       imgcc(1:h,1:d)=imgc(1:h,1,1:d);
       imgccc=imgcc';
       imgccc=imrotate(imgccc,180,'bilinear');
       imgccc=flipdim(imgccc,2);
%      whos imgccc
       imagesc(imgccc)

                        
    else
        if tf31 && tf32
        %==============( Image C )=======================    

           % Calculate the current point w.r.t. the axes.
           Cx3 =  XLM3(1) + (F(1)-AXP3(1)).*(DFX3/AXP3(3));
           Cy3 =  YLM3(1) + (F(2)-AXP3(2)).*(DFY3/AXP3(4));
           Cx3=round(Cx3);
           Cy3=round(Cy3);
           set(handles.ptxt3,'str',num2str([Cx3,Cy3],4));  % put the mouse pointers in the string textbox
       
           %affect  B (Axial) Top View only
           axes(handles.axes2);
           imgb=img(Cx3,:,:);
           %      whos imgb
           imgbb(1:w,1:d)=imgb; 
           imgb=imrotate(imgbb,90,'bilinear');
           imagesc(imgb);


           %affect  A (Coronal) Front View only
           axes(handles.axes1);
           imga=img(:,:,Cy3);
           %imgaa(1:256,1:54)=imga(1:256,1,1:54);
%            imgaaa=imgaa';
           imagesc(imga);
         end
    end
 end
 drawnow;
 
 
% covert from logical to string
function a=lo2str(b)
        if b
            a='true';
        else
            a='false';
        end
        