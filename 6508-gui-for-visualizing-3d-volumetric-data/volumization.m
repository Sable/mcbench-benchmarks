function varargout = volumization(varargin)
% GUI for visualizing 3D data
%
% To run type:
% >>volumization (data,'n')
% for example:voumization (data, '2')
% where data are of format [n x m x p]  and  'n' - which slice to display: 
% '1'- all, '2' - every second, '3' - every third, etc.
%
% For users with PLS_Toolbox 3.5 can type
% >> volumization
% and then load data interactively using lddlgpls routine.
%
% Includes different types of visualization:
% 1. Orthogonal slices - each slice individually, as well as three orthogonal slices on one plot
% 2. Rendered volume through showing series of z-slices. Enter the number of slices to display:
% ('1' - all, '2' - every second, etc.)
% 3. Isosurfaces:
%	- one for a single value
%	- multiple for multiple values of interest on one figure (each with different color)
%
% Options to change for orthogonal slices (1) and volumes (2):
% - transparency;
% - color scheme.
%
% Options to changes for all three types of visualization (1-3):
% - top/bottom, left/right
% - aspect ratio.
%
% To display isosurface on top of rendered volume or orthogonal slices, use controls to
% display desired view and then use Multiple isosurface slider to display the isosurface 
% of value of interest. (Single isosurface slider clears the figure on execution). 
%
% Use Clear figure button to start over.
%
% created by K.Artyushkova
% November 2004
%
% Kateryna Artyushkova
% Postdoctoral Scientist
% Department of Chemical and Nuclear Engineering
% The University of New Mexico
% (505) 277-0750
% kartyush@unm.edu 
%
% Last Modified by GUIDE v2.5 02-Feb-2006 11:38:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @volumization_OpeningFcn, ...
                   'gui_OutputFcn',  @volumization_OutputFcn, ...
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


% --- Executes just before volumization is made visible.
function volumization_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to volumization (see VARARGIN)

% Choose default command line output for volumization
handles.output = hObject;

% Update handles structure
if (nargin <4)
        H.Position=[181 477 332 275];
figure(H)
msgbox('Please load the data through the File Load menu')
    else        
    data= varargin{1};
    display=varargin{2};
    data=double(data);
[m,n,p]=size(data);
set(handles.xmin,'string',1);
set(handles.xmax,'string',n);
set(handles.xi,'string',1);
set(handles.ymin,'string',1);
set(handles.ymax,'string',m);
set(handles.yi,'string',1);
set(handles.zmin,'string',1);
set(handles.zmax,'string',p);
set(handles.zi,'string',1);
s=data;
handles.s=s;
H.Position=[181 477 332 275];
figure(H)
step=str2double(display);
hz=slice(s,[],[],[1:step:p]);
alpha('color')
axis tight
set(hz,'EdgeColor','none','FaceColor','interp', 'FaceAlpha','interp')
alphamap('rampdown')
daspect([1 1 0.5])
handles.aspect=[1 1 0.5];
handles.count=0;
colormap(jet)
 
end
handles.v={'0'};
guidata(hObject, handles);

% UIWAIT makes volumization wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = volumization_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function load_data_Callback(hObject, eventdata, handles)
% hObject    handle to load_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data =lddlgpls;
data=double(data);
[m,n,p]=size(data);
set(handles.xmin,'string',1);
set(handles.xmax,'string',n);
set(handles.xi,'string',1);
set(handles.ymin,'string',1);
set(handles.ymax,'string',m);
set(handles.yi,'string',1);
set(handles.zmin,'string',1);
set(handles.zmax,'string',p);
set(handles.zi,'string',1);
s=data;
handles.s=data;
figure(1)
hz=slice(s,[],[],[1:3:p]);
alpha('color')
axis tight
set(hz,'EdgeColor','none','FaceColor','interp', 'FaceAlpha','interp')
alphamap('rampdown')
daspect([1 1 0.5])
handles.aspect=[1 1 0.5];
handles.count=0;
colormap(jet)
guidata(hObject, handles);



% --- Executes on button press in alphaincrease.
function alphaincrease_Callback(hObject, eventdata, handles)
% hObject    handle to alphaincrease (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(1)
alphamap('increase',.1)

% --- Executes on button press in alphadecrease.
function alphadecrease_Callback(hObject, eventdata, handles)
% hObject    handle to alphadecrease (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(1)
alphamap('decrease',.1)

% --- Executes during object creation, after setting all properties.
function colormap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in colormap.
function colormap_Callback(hObject, eventdata, handles)
% hObject    handle to colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns colormap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from colormap

val = get(hObject,'Value');
figure(1)
switch val
    case 1
   colormap(jet)
case 2
   colormap(hsv)
case 3
   colormap(hot)
case 4
   colormap(gray)
case 5
    colormap(bone)
case 6
    colormap(copper)
case 7
    colormap(pink)
case 8
    colormap(white)
case 9
    colormap(colorcube)
case 10
    colormap(vga)
case 11
    colormap(jet)
case 12
    colormap(prism)
case 13
    colormap(cool)
case 14
    colormap(autumn)
case 15
    colormap(spring)
case 16
    colormap(winter)
case 17
    colormap(summer)
end

% --- Executes on button press in aspect_ratio.
function aspect_ratio_Callback(hObject, eventdata, handles)
% hObject    handle to aspect_ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt={'X:','Y:','Z:'};
def={'1','1','0.5'};
dlgTitle='Input for Aspect ratio';
lineNo=1;
answer=inputdlg(prompt,dlgTitle,lineNo,def);
M=str2double(answer);
figure(1)
daspect([M(1) M(2) M(3)])
handles.aspect=[M(1) M(2) M(3)];
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function reverse_axes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reverse_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in reverse_axes.
function reverse_axes_Callback(hObject, eventdata, handles)
% hObject    handle to reverse_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns reverse_axes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from reverse_axes

val = get(hObject,'Value');
switch val
case 1
    figure(1)
    set(gca,'Xdir','reverse')
case 2
    figure(1)
    set(gca,'Ydir','reverse')
case 3
    figure(1)
    set(gca,'Zdir','reverse')
end


% --- Executes during object creation, after setting all properties.
function display_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function display_Callback(hObject, eventdata, handles)
% hObject    handle to display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of display as text
%        returns contents of display as a double

step=str2double(get(hObject,'String'));
s=handles.s;
figure(1)
[m,n,p]=size(s);
hz=slice(s,[],[],[1:step:p]);
alpha('color')
axis tight
set(hz,'EdgeColor','none','FaceColor','interp', 'FaceAlpha','interp')
alphamap('rampdown')
aspect=handles.aspect;
daspect(aspect)
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function sliderx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function sliderx_Callback(hObject, eventdata, handles)
% hObject    handle to sliderx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

s=handles.s;
[m,n,p]=size(s);
step=1/n;
slider_step(1)=step;
slider_step(2)=step;
set(handles.sliderx, 'SliderStep', slider_step, 'Max', n, 'Min',0)
ix=get(hObject,'Value');
ix=round(ix);
set(handles.xi,'string',ix);
set(handles.ix,'string',ix);
[x,y,z] = meshgrid([1:n],[1:m],[1:p]);
figure(1)
hx=slice(x,y,z, s,ix,[],[]);
alpha('color')
set(hx,'EdgeColor','none','FaceColor','interp', 'FaceAlpha','interp')
axis tight
alphamap('rampdown')
handles.IX=ix;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slidery_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slidery (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function slidery_Callback(hObject, eventdata, handles)
% hObject    handle to slidery (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
s=handles.s;
[m,n,p]=size(s);
step=1/m;
slider_step(1)=step;
slider_step(2)=step;
set(handles.slidery, 'SliderStep', slider_step, 'Max', m, 'Min',0)
iy=get(hObject,'Value');
iy=round(iy);
set(handles.yi,'string',iy);
set(handles.iy,'string',iy);
[x,y,z] = meshgrid([1:n],[1:m],[1:p]);
figure(1)
hy=slice(x,y,z, s,[],iy,[]);
alpha('color')
set(hy,'EdgeColor','none','FaceColor','interp', 'FaceAlpha','interp')
axis tight
alphamap('rampdown')
handles.IY=iy;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function sliderz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function sliderz_Callback(hObject, eventdata, handles)
% hObject    handle to sliderz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

s=handles.s;
[m,n,p]=size(s);
step=1/p;
slider_step(1)=step;
slider_step(2)=step;
set(handles.sliderz, 'SliderStep', slider_step, 'Max', p, 'Min',0)
iz=get(hObject,'Value');
iz=round(iz);
set(handles.zi,'string',iz);
set(handles.iz,'string',iz);
figure(1)
[x,y,z] = meshgrid([1:n],[1:m],[1:p]);
figure(1)
hz=slice(x,y,z, s,[],[],iz);
alpha('color')
set(hz,'EdgeColor','none','FaceColor','interp', 'FaceAlpha','interp')
axis tight
alphamap('rampdown')
handles.IZ=iz;
guidata(hObject, handles);


% --- Executes on button press in all_three.
function all_three_Callback(hObject, eventdata, handles)
% hObject    handle to all_three (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.s;
ix=handles.IX;
iy=handles.IY;
iz=handles.IZ;
[m,n,p]=size(s);
figure(1)
[x,y,z] = meshgrid([1:n],[1:m],[1:p]);
figure(1)
hz=slice(x,y,z, s,ix,iy,iz);
alpha('color')
set(hz,'EdgeColor','none','FaceColor','interp', 'FaceAlpha','interp')
axis tight
alphamap('rampdown')
aspect=handles.aspect;
daspect(aspect)
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ix_Callback(hObject, eventdata, handles)
% hObject    handle to ix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ix as text
%        str2double(get(hObject,'String')) returns contents of ix as a double
ix=str2double(get(hObject,'String')) ;
handles.IX=ix;
s=handles.s;
iy=handles.IY;
iz=handles.IZ;
[m,n,p]=size(s);
figure(1)
[x,y,z] = meshgrid([1:n],[1:m],[1:p]);
figure(1)
hz=slice(x,y,z, s,ix,iy,iz);
alpha('color')
set(hz,'EdgeColor','none','FaceColor','interp', 'FaceAlpha','interp')
axis tight
alphamap('rampdown')
aspect=handles.aspect;
daspect(aspect)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function iy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function iy_Callback(hObject, eventdata, handles)
% hObject    handle to iy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iy as text
%        str2double(get(hObject,'String')) returns contents of iy as a double

iy=str2double(get(hObject,'String')) ;
handles.IY=iy;
s=handles.s;
ix=handles.IX;
iz=handles.IZ;
[m,n,p]=size(s);
figure(1)
[x,y,z] = meshgrid([1:n],[1:m],[1:p]);
figure(1)
hz=slice(x,y,z, s,ix,iy,iz);
alpha('color')
set(hz,'EdgeColor','none','FaceColor','interp', 'FaceAlpha','interp')
axis tight
alphamap('rampdown')
aspect=handles.aspect;
daspect(aspect)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function iz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function iz_Callback(hObject, eventdata, handles)
% hObject    handle to iz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iz as text
%        str2double(get(hObject,'String')) returns contents of iz as a double


iz=str2double(get(hObject,'String')) ;
handles.IZ=iz;
s=handles.s;
ix=handles.IX;
iy=handles.IY;
[m,n,p]=size(s);
figure(1)
[x,y,z] = meshgrid([1:n],[1:m],[1:p]);
figure(1)
hz=slice(x,y,z, s,ix,iy,iz);
alpha('color')
set(hz,'EdgeColor','none','FaceColor','interp', 'FaceAlpha','interp')
axis tight
alphamap('rampdown')
aspect=handles.aspect;
daspect(aspect)
guidata(hObject, handles);


% --------------------------------------------------------------------
function smooth_Callback(hObject, eventdata, handles)
% hObject    handle to smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure(1)
clf
s=handles.s;
size=inputdlg('Enter the size of smoothing kernel','Smoothing filter');
size=str2double(size);
s_sm = smooth3(s, 'gaussian',[size size size]);
handles.s=s_sm;
guidata(hObject, handles);





% --- Executes on slider movement.
function isosurface_Callback(hObject, eventdata, handles)
% hObject    handle to isosurface (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
s=handles.s;
aspect=handles.aspect;
Min=round(min(min(min(s))));
Max=round(max(max(max(s))));
v=[Min:1:Max];
K=Max-Min;
[m,n]=size(v);
step=1/n;
slider_step(1)=step;
slider_step(2)=step;
set(handles.isosurface, 'SliderStep', slider_step, 'Max', K, 'Min',0)
i=get(hObject,'Value');
i=round(i);
if i<=Min
    i=Min;
elseif i>=Max
    i=Max
else
end
i=i+Min;
handles.i=i;
set(handles.iso_value,'string',i);
[n,m,p]=size(s);
a=100*ones([n m p]);
s_inv=a-s;
figure(1)
clf
hiso=patch(isosurface(s,i),'FaceColor',[1,0.75,0.65], 'EdgeColor', 'none','FaceAlpha',0.7);
hcap=patch(isocaps(s_inv,(100-i)),'FaceColor',[1,0.75,0.65], 'Edgecolor','none','FaceAlpha',0.7);
view(45,30);
axis tight
daspect(aspect)
lightangle(45,30)
lighting phong
set(hcap,'AmbientStrength', 0.6)
set(hiso,'SpecularColorReflectance',0.3,'SpecularExponent', 50)
handles.count=0;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function isosurface_CreateFcn(hObject, eventdata, handles)
% hObject    handle to isosurface (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end





% --- Executes during object creation, after setting all properties.
function isosurf_multiple_CreateFcn(hObject, eventdata, handles)
% hObject    handle to isosurf_multiple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function isosurf_multiple_Callback(hObject, eventdata, handles)
% hObject    handle to isosurf_multiple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
count=handles.count;
s=handles.s;
value=handles.v;
aspect=handles.aspect;
Min=round(min(min(min(s))));
Max=round(max(max(max(s))));
v=[Min:1:Max];
K=Max-Min;
[m,n]=size(v);
step=1/n;
slider_step(1)=step;
slider_step(2)=step;
set(handles.isosurf_multiple, 'SliderStep', slider_step, 'Max', K, 'Min',0)
i=get(hObject,'Value');
i=round(i);
if i<=Min
    i=Min;
elseif i>=Max
    i=Max
else
    i=i;
end
i=i+Min;
handles.i=i;
set(handles.multiple_iso_value,'string',i);
[n,m,p]=size(s);
figure(1)
hold on
hiso=patch(isosurface(s,i),'FaceColor',[(0.85-count*0.1),(0.25+count*0.1),(0.35+count*0.1)], 'EdgeColor', 'none','FaceAlpha',0.7);
view(45,30);
axis tight
daspect(aspect)
set(hiso,'SpecularColorReflectance',0.3,'SpecularExponent', 50)
count=count+1;
handles.count=count;
value{count}=num2str(i);
outstring=textwrap(value,3);
set(handles.value,'string',outstring)
handles.v=value;
guidata(hObject, handles);


% --- Executes on button press in Clear.
function Clear_Callback(hObject, eventdata, handles)
% hObject    handle to Clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(1)
clf
handles.count=0;
handles.v={'0'};
set(handles.value,'string',{})
guidata(hObject, handles);




% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('This a GUI for visualizing 3D data. Created by K.Artyushkova. kartyush@unm.edu. December 2004','About GUI Volumization')



% --- Executes during object creation, after setting all properties.
function iso_value_multi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iso_value_multi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

count=handles.count;
s=handles.s;
value=handles.v;
aspect=handles.aspect;
Min=round(min(min(min(s))));
Max=round(max(max(max(s))));
v=[Min:1:Max];
K=Max-Min;
[m,n]=size(v);
i=str2double(get(hObject,'String'));
handles.i=i;
[n,m,p]=size(s);
figure(1)
hold on
hiso=patch(isosurface(s,i),'FaceColor',[(0.85-count*0.1),(0.25+count*0.1),(0.35+count*0.1)], 'EdgeColor', 'none','FaceAlpha',0.7);
view(45,30);
axis tight
daspect(aspect)
set(hiso,'SpecularColorReflectance',0.3,'SpecularExponent', 50)
count=count+1;
handles.count=count;
value{count}=num2str(i);
outstring=textwrap(value,3);
set(handles.value,'string',outstring)
handles.v=value;
guidata(hObject, handles);



function multiple_iso_value_Callback(hObject, eventdata, handles)
% hObject    handle to multiple_iso_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of multiple_iso_value as text
%        str2double(get(hObject,'String')) returns contents of multiple_iso_value as a double
count=handles.count;
s=handles.s;
value=handles.v;
aspect=handles.aspect;
Min=round(min(min(min(s))));
Max=round(max(max(max(s))));
v=[Min:1:Max];
K=Max-Min;
[m,n]=size(v);
i=str2double(get(hObject,'String'));
handles.i=i;
[n,m,p]=size(s);
figure(1)
hold on
hiso=patch(isosurface(s,i),'FaceColor',[(0.85-count*0.1),(0.25+count*0.1),(0.35+count*0.1)], 'EdgeColor', 'none','FaceAlpha',0.7);
view(45,30);
axis tight
daspect(aspect)
set(hiso,'SpecularColorReflectance',0.3,'SpecularExponent', 50)
count=count+1;
handles.count=count;
value{count}=num2str(i);
outstring=textwrap(value,3);
set(handles.value,'string',outstring)
handles.v=value;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function multiple_iso_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multiple_iso_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


