%This Progra, develop by Renoald Tang
%University Teknologi Malaysia, Photogrammetry and Laser scanning group
%for academic purpose
%Email:renoald@live.com

function varargout = meshview(varargin)
% MESHVIEW MATLAB code for meshview.fig
%      MESHVIEW, by itself, creates a new MESHVIEW or raises the existing
%      singleton*.
%
%      H = MESHVIEW returns the handle to a new MESHVIEW or the handle to
%      the existing singleton*.
%
%      MESHVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MESHVIEW.M with the given input arguments.
%
%      MESHVIEW('Property','Value',...) creates a new MESHVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before meshview_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to meshview_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help meshview

% Last Modified by GUIDE v2.5 04-Apr-2013 10:08:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @meshview_OpeningFcn, ...
                   'gui_OutputFcn',  @meshview_OutputFcn, ...
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


% --- Executes just before meshview is made visible.
function meshview_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to meshview (see VARARGIN)

% Choose default command line output for meshview
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes meshview wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%axes(handles.axes1)
axis off 
% --- Outputs from this function are returned to the command line.
function varargout = meshview_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnopen.
function btnopen_Callback(hObject, eventdata, handles)
% hObject    handle to btnopen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)

[FileName,PathName] = uigetfile({;'*.ply';'*.off';'*.obj'},'Select the Point clouds');
F=[PathName,FileName];
n=length(F);
if n > 2 
 ext1=findstr(F,'.ply'); 
 ext2=findstr(F,'.off');
 ext3=findstr(F,'.obj');
 n1=isempty(ext1);
 n2=isempty(ext2);
 n3=isempty(ext3);
 if n1==0 
    readPly(F);
p=dlmread('point');
f=dlmread('face');
 end
 if n2==0 
    readOFF(F);
 p=dlmread('point');
f=dlmread('face');
 end
 if n3==0 
    readObj(F);
 p=dlmread('point');
f=dlmread('face');
 end
 %delete('point')
 %delete('face')
np=length(p);
nf=length(f);
cla
myview(0,0,1,0)
set(handles.pushbutton17,'enable','on')
shading faceted
set(handles.text3,'String',num2str(np));
set(handles.text4,'String',num2str(nf));
 
else
    disp('select nothing')
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rotate3d on 

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rotate3d off 

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom on

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom off


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
shading faceted
options = 1;
setappdata(meshview,'poptions',options);

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
shading flat
options = 2;
setappdata(meshview,'poptions',options);

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
shading interp
options = 3;
setappdata(meshview,'poptions',options);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
val = get(hObject,'Value');
if val==2 
    colormap(jet)
end
if val==3 
    colormap(hsv)
end
if val==4 
    colormap(hot)
end
if val==5 
    colormap(cool)
end
if val==6 
    colormap(spring)
end
if val==7 
    colormap(summer)
end
if val==8 
    colormap(autumn)
end
if val==9 
    colormap(winter)
end
if val==10 
    colormap(gray)
end
if val==11 
    colormap(bone)
end
if val==12 
    colormap(copper)
end
if val==13 
    colormap(pink)
end
if val==14 
    colormap(lines)
end

setappdata(meshview,'mymap',val);

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


% --- Executes on button press in btnapp.
function btnapp_Callback(hObject, eventdata, handles)
% hObject    handle to btnapp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btnedge.
function btnedge_Callback(hObject, eventdata, handles)
% hObject    handle to btnedge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myedge = uisetcolor;
setappdata(meshview,'edgecolor',myedge);


% --- Executes on button press in surbtn.
function surbtn_Callback(hObject, eventdata, handles)
% hObject    handle to surbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mysurf = uisetcolor;
setappdata(meshview,'surfacecolor',mysurf);

% --- Executes on button press in btn.
function btn_Callback(hObject, eventdata, handles)
% hObject    handle to btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fc=getappdata(meshview,'surfacecolor');
ec=getappdata(meshview,'edgecolor');
%cla(handles.axes3,'reset');
%disp(fc)
%disp(ec)
myview(ec,fc,1,0)


% --- Executes on button press in btnstart.
function btnstart_Callback(hObject, eventdata, handles)
% hObject    handle to btnstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
r=fopen('pause.txt');
if r > -1 
    fclose(r);
    delete('pause.txt');
end
r=fopen('pause.txt');
while r < 0 
    camorbit(10,0,'camera')
    drawnow
    r=fopen('pause.txt');
end
if r > -1 
    fclose(r);
end



% --- Executes on button press in btnpause.
function btnpause_Callback(hObject, eventdata, handles)
% hObject    handle to btnpause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
r=fopen('pause.txt','w');
fclose(r);


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(gcf) 


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

op=getappdata(meshview,'poptions');
em=isempty(op);
if em==1
    op=1;
end
if op==1
    %shading faceted
end
if op==2
    %shading flat
end
if op==3
    %shading interp
end
F=dlmread('face');
P=dlmread('point');
fc=getappdata(meshview,'surfacecolor');
ec=getappdata(meshview,'edgecolor');
%setappdata(meshview,'mymap',val);
mapop=getappdata(meshview,'mymap');
em1=isempty(mapop);
if em1==1
    mapop=0;
end
bv=isempty(fc);
figure(1)
axis on
if bv==1
    myview(0,0,op,mapop)
else
    myview(ec,fc,mapop)
end


n=length(F);
r=runique(F);
n1=length(r);


%np=length(p);
%nf=length(f);
%myview(0,0)
% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla
set(handles.pushbutton17,'Enable','off')
%retun unique value
function r=runique(value)
r=unique(value(:,1));
%return C

function C=fnum(value,f)
n=length(value);
C=0;
for i=1 : n 
    if value(i,1)==f
        C=C+1;
    end
end
function b=returnf(value,u,f)
n=length(value);
fid=fopen('value','w');
for i=1 : n 
    if value(i,1)==u
        for j=2 : u+1
           
           %disp(value(i,j))
        
            if j < u+1
            fprintf(fid,'%.d ',value(i,j));
            else
                fprintf(fid,'%.d\n',value(i,j));
            end
            
           
            
        
        end
    end
end
fclose('all');
b=dlmread('value');
[m1,m2]=size(b);
for k=1 : m1
    for j=1 : m2
    b(k,j)=b(k,j)+1;
    end
end

delete('value');


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename1, pathname1] = uiputfile({'*.ply';'*.off';'*.obj';'*.xyz'},'Save as');
F=[pathname1,filename1];
%disp(F)
n=length(F);
if n > 2 
ext1=findstr(F,'.ply'); 
ext2=findstr(F,'.off');
ext3=findstr(F,'.obj');
ext4=findstr(F,'.xyz');
n1=isempty(ext1);
 n2=isempty(ext2);
 n3=isempty(ext3);
 n4=isempty(ext4);
if n1==0 
    WritePly(F)
end
if n2==0
    WriteOFF(F)
end
if n3==0
WriteObj(F)    
end
if n4==0
    WriteXYZ(F)
end
    
    
    
end 
