function varargout = act_ive_gui_new(varargin)
% ACT_IVE_GUI_NEW M-file for act_ive_gui_new.fig
%      ACT_IVE_GUI_NEW, by itself, creates a new ACT_IVE_GUI_NEW or raises the existing
%      singleton*.
%
%      H = ACT_IVE_GUI_NEW returns the handle to a new ACT_IVE_GUI_NEW or the handle to
%      the existing singleton*.
%
%      ACT_IVE_GUI_NEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACT_IVE_GUI_NEW.M with the given input arguments.
%
%      ACT_IVE_GUI_NEW('Property','Value',...) creates a new ACT_IVE_GUI_NEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before act_ive_gui_new_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to act_ive_gui_new_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help act_ive_gui_new

% Last Modified by GUIDE v2.5 23-Jan-2004 13:17:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @act_ive_gui_new_OpeningFcn, ...
    'gui_OutputFcn',  @act_ive_gui_new_OutputFcn, ...
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


% --- Executes just before act_ive_gui_new is made visible.
function act_ive_gui_new_OpeningFcn(hObject, eventdata, handles,varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to act_ive_gui_new (see VARARGIN)

% Choose default command line output for act_ive_gui_new

handles.output = hObject;
set(gcf,'Color',[0 0 0]);
pos=[0 200 460 450];
MovieControl = actxcontrol('WMPlayer.OCX',pos)
set(MovieControl,'uiMode','none');
assignin('base','MovieControl',MovieControl);
set(MovieControl.settings,'autoStart',0);
handles.MovieControl = MovieControl;
set(handles.edit2,'ForegroundColor',[0 1 0]);
set(handles.edit2,'BackgroundColor',[0 0 0]);
set(handles.edit1,'ForegroundColor',[0 1 0]);
set(handles.edit1,'BackgroundColor',[0 0 0]);
set(handles.edit1,'String','0');
workdir=pwd;
handles.workdir=workdir;

[a,map]=imread('play.jpg');
[r,c,d]=size(a); 
x=ceil(r/18); 
y=ceil(c/18); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.pushbutton2,'CData',g);

[a,map]=imread('stop.jpg');
[r,c,d]=size(a); 
x=ceil(r/20); 
y=ceil(c/20); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.pushbutton3,'CData',g);


[a,map]=imread('cd_eject.jpg');
[r,c,d]=size(a); 
x=ceil(r/20); 
y=ceil(c/20); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.pushbutton9,'CData',g);


[a,map]=imread('track_down.jpg');
[r,c,d]=size(a); 
x=ceil(r/18); 
y=ceil(c/18); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.pushbutton10,'CData',g);


[a,map]=imread('track_up.jpg');
[r,c,d]=size(a); 
x=ceil(r/18); 
y=ceil(c/18); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.pushbutton8,'CData',g);


[a,map]=imread('remove.jpg');
[r,c,d]=size(a); 
x=ceil(r/18); 
y=ceil(c/18); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.pushbutton12,'CData',g);


[a,map]=imread('remove.jpg');
[r,c,d]=size(a); 
x=ceil(r/18); 
y=ceil(c/18); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.pushbutton6,'CData',g);



[a,map]=imread('open_files.jpg');
[r,c,d]=size(a); 
x=ceil(r/18); 
y=ceil(c/18); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.pushbutton1,'CData',g);


[a,map]=imread('open_files.jpg');
[r,c,d]=size(a); 
x=ceil(r/18); 
y=ceil(c/18); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.pushbutton7,'CData',g);

[a,map]=imread('open_files.jpg');
[r,c,d]=size(a); 
x=ceil(r/18); 
y=ceil(c/18); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.pushbutton11,'CData',g);



[a,map]=imread('pause.jpg');
[r,c,d]=size(a); 
x=ceil(r/20); 
y=ceil(c/20); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.pushbutton4,'CData',g);


[a,map]=imread('vol.jpg');
[r,c,d]=size(a); 
x=ceil(r/18); 
y=ceil(c/18); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.togglebutton1,'CData',g);
%set(mp.settings,'Mute',0);


%set(handles.listbox1,'Value',[]);
%set(handles.pushbutton3,'Hittest','off')



% Update handles structure

guidata(hObject, handles);



% UIWAIT makes act_ive_gui_new wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = act_ive_gui_new_OutputFcn(hObject, eventdata,handles)
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


[filename pathname] = uigetfile('*.*','Please select a file')

if ~filename
    return
end;

file1=[pathname filename]
[path,name,ext,ver] = fileparts(file1);
set(handles.listbox1,'String',[name,ext],'Value',1);

% val=get(handles.listbox1,'Value');
% str1=get(handles.listbox1,'String')
% str2=isempty(str1)
% if str2==1
% set(handles.listbox1,'String',[name,ext],'Value',1);
% else    
% set(handles.listbox1,'String',[name,ext],'Value',val+1);    
% end


mp = handles.MovieControl;
mp.URL=[pathname filename];
dir_path=pathname;

% x.name=dir_path;
% dir_path=x.name;
% x.name1=file1;

handles.dir_path=dir_path;
handles.pan=file1;
handles.numind=1;
numind=handles.numind
guidata(hObject,handles)
set(handles.listbox1,'UserData',dir_path);




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mp = handles.MovieControl;
mp.controls.play
pause(1);
r=get(mp.currentMedia,'duration')
set(handles.slider3,'max',r)

j=get(handles.edit1,'String'); 
    set(mp.settings,'playCount',str2double(j));

currpos=mp.controls.currentPosition;        
    pause(1);
    r=get(mp.currentMedia,'duration');
    set(handles.slider3,'max',r)     
    for i=currpos:r        
        j=get(handles.edit1,'String'); 
        set(mp.settings,'playCount',str2double(j));
        currpos1=mp.controls.currentPosition;        
        index_selected1 = get(handles.listbox1,'Value');
        pause(1);
        r=get(mp.currentMedia,'duration');
        remaint=r-currpos1;    
        set(handles.edit2,'String',remaint);           
        j=0;
        if remaint <=0 || j==r
            break;
        end        
    end
%  set(handles.listbox1,'Value',index_selected+1);           
%end


% for i=1:r
% currpos=mp.controls.currentPosition;
% remaint=r-currpos
% 
% set(handles.edit2,'String',remaint);
% end

%y=get(handles.slider3,'max')

% --- Executes on button press in pushbutton3.

function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mp = handles.MovieControl;
stopval=get(handles.pushbutton3,'Value')
if stopval==1
    mp.controls.stop
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mp = handles.MovieControl;
mp.controls.pause

function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

mp = handles.MovieControl;
repeat=get(hObject,'String'); 
set(mp.settings,'playCount',str2double(repeat));
% handles.repeat=repeat;
% repeat=handles.repeat;
guidata(hObject,handles);    

% --- Executes on button press in togglebutton1.

function togglebutton1_Callback(hObject, eventdata, handles)

% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of togglebutton1

mp = handles.MovieControl;
h=get(hObject,'Value'); 
if h==1
[a,map]=imread('mute2.jpg');
[r,c,d]=size(a); 
x=ceil(r/18); 
y=ceil(c/18); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.togglebutton1,'CData',g);
set(mp.settings,'Mute',1);
else 
[a,map]=imread('vol.jpg');
[r,c,d]=size(a); 
x=ceil(r/18); 
y=ceil(c/18); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.togglebutton1,'CData',g);
set(mp.settings,'Mute',0);
end



% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
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
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

mp = handles.MovieControl;
k=get(handles.slider1,'Value')
set(mp.Settings,'rate',k)

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
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
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


mp = handles.MovieControl;
k=get(handles.slider2,'Value')
set(mp.settings,'Volume',k);


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
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
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

mp = handles.MovieControl;
%o=get(mp.currentMedia,'duration');
%set(hObject,'Max',o)
j=get(hObject,'Value');
set(mp.controls,'CurrentPosition',j);


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor',[0 0 0]);
else
    
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% varargout{1} = handles.output;

% --- Executes on selection change in listbox1.

function listbox1_Callback(hObject, eventdata, handles)

% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


repeat=get(handles.edit1,'String');
repeat=str2double(repeat);
if repeat >0 
    for index_selected=1:repeat   
    mp = handles.MovieControl;  
    index_selected = get(handles.listbox1,'Value')                  
    dir_path=get(handles.listbox1,'UserData');
    set(handles.listbox1,'Value',index_selected)    
    file_list1 = get(handles.listbox1,'String')        
    assignin('base','file_list1',file_list1)
    k=iscell(file_list1)
    k1=ischar(file_list1)  
    
    if k==1 & k1==0  
        filename1= file_list1{index_selected};         
    elseif k1==1 & k==0
        file_list1=cellstr(file_list1);
        filename1=file_list1{index_selected}; 
    elseif k==0
        filename1=handles.pan            
    end       
    [path,name,ext,ver] = fileparts(filename1);
    g=fullfile(dir_path,[name ext ver]);
    j=get(handles.edit1,'String'); 
    set(mp.settings,'playCount',str2double(j));
    mp.URL=g;       
    pause(0.05);
    h=get(handles.figure1,'SelectionType');
    h1=strcmp(h,'open');    
    if h1  
        mp.controls.play                                    
    else 
        return;
    end                        
    currpos=mp.controls.currentPosition;        
    pause(1);
    r=get(mp.currentMedia,'duration');
    set(handles.slider3,'max',r) 
    for i=currpos:r
        currpos1=mp.controls.currentPosition;        
        index_selected1 = get(handles.listbox1,'Value');
        pause(1);
        r=get(mp.currentMedia,'duration');
        remaint=r-currpos1;    
        set(handles.edit2,'String',remaint);        
        posend=0;
         if remaint <=0 || posend==r               
            break;
        end              
    end                                     
    continue;
    end  
  elseif repeat==0      
  end 
      
    
numind=handles.numind  
for index_selected=1:numind    
    mp = handles.MovieControl;  
    index_selected = get(handles.listbox1,'Value')                  
    dir_path=get(handles.listbox1,'UserData');
    set(handles.listbox1,'Value',index_selected)    
    file_list1 = get(handles.listbox1,'String')        
    assignin('base','file_list1',file_list1)
    k=iscell(file_list1)
    k1=ischar(file_list1)  
    
    if k==1 & k1==0  
        filename1= file_list1{index_selected};         
    elseif k1==1 & k==0
        file_list1=cellstr(file_list1);
        filename1=file_list1{index_selected}; 
    elseif k==0
        filename1=handles.pan            
    end       
    [path,name,ext,ver] = fileparts(filename1);
    g=fullfile(dir_path,[name ext ver]);
    j=get(handles.edit1,'String'); 
    set(mp.settings,'playCount',str2double(j));
    mp.URL=g;       
    pause(0.05);
    h=get(handles.figure1,'SelectionType');
    h1=strcmp(h,'open');        
    if h1 || index_selected1~=index_selected 
        mp.controls.play                                    
    else 
        return;
    end                        
    currpos=mp.controls.currentPosition;        
    pause(1);
    r=get(mp.currentMedia,'duration');
    set(handles.slider3,'max',r) 
    for i=currpos:r
        currpos1=mp.controls.currentPosition;        
        index_selected1 = get(handles.listbox1,'Value');
        pause(1);
        r=get(mp.currentMedia,'duration');
        remaint=r-currpos1;    
        set(handles.edit2,'String',remaint);        
        posend=0;
        if remaint <=0 || posend==r               
             break;
        end
    end                                
    set(handles.listbox1,'Value',index_selected+1);         
    continue;
    end



% --- Executes on button press in pushbutton6.

function pushbutton6_Callback(hObject, eventdata, handles) 

% % hObject    handle to pushbutton6 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)

mp = handles.MovieControl; 
h=get(handles.listbox1,'Value');
set(handles.listbox1,'String','');


% --- Executes on button press in pushbutton7.

function pushbutton7_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dir_path=uigetdir
set(handles.listbox1,'UserData',dir_path);
set(handles.pushbutton10,'UserData',dir_path);
cd (dir_path)
dir_struct = dir(dir_path);
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
handles.file_names = sorted_names;
handles.sorted_index = [sorted_index];
numind=length(handles.sorted_index);
handles.numind=numind
guidata(hObject,handles)
set(handles.listbox1,'String',handles.file_names,'Value',1)

% --- Executes on button press in pushbutton8.

function pushbutton8_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mp = handles.MovieControl;
mp.controls.stop;
index_selected=get(handles.listbox1,'Value')
set(handles.listbox1,'Value',(index_selected-1));
index_selected2=get(handles.listbox1,'Value')
file_list1 = get(handles.listbox1,'String');

k=iscell(file_list1)
k1=ischar(file_list1)  

if k==1 & k1==0  
    filename1= file_list1{index_selected};         
elseif k1==1 & k==0
    file_list1=cellstr(file_list1);
end

filename1= file_list1{index_selected2};
[path,name,ext,ver] = fileparts(filename1);
dir_path=get(handles.listbox1,'UserData');
g=fullfile(dir_path,[name ext ver]);
mp.URL=g;
mp.controls.play 
pause(3);
r=get(mp.currentMedia,'duration')
set(handles.slider3,'max',r) 
currpos=mp.controls.currentPosition        
for i=currpos:r
    currpos1=mp.controls.currentPosition;
    index_selected2 = get(handles.listbox1,'Value');
    pause(0.5);
    remaint=r-currpos1;    
    set(handles.edit2,'String',remaint);    
end  



% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mp = handles.MovieControl;
mp.cdromCollection.Item(0).eject;

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mp = handles.MovieControl;
mp.controls.stop;
index_selected=get(handles.listbox1,'Value')
set(handles.listbox1,'Value',(index_selected+1));
index_selected2=get(handles.listbox1,'Value')
file_list1 = get(handles.listbox1,'String');

k=iscell(file_list1)
k1=ischar(file_list1)  

if k==1 & k1==0  
    filename1= file_list1{index_selected};         
elseif k1==1 & k==0
    file_list1=cellstr(file_list1);
end


filename1= file_list1{index_selected2};
[path,name,ext,ver] = fileparts(filename1);
dir_path=get(handles.listbox1,'UserData');

g=fullfile(dir_path,[name ext ver]);
mp.URL=g;
mp.controls.play 
pause(3);
r=get(mp.currentMedia,'duration');
set(handles.slider3,'max',r) 
currpos=mp.controls.currentPosition        
for i=currpos:r
    currpos1=mp.controls.currentPosition;
    index_selected2 = get(handles.listbox1,'Value');
    pause(0.5);
    remaint=r-currpos1;    
    set(handles.edit2,'String',remaint);    
    %     if index_selected2~=index_selected
    %         break;
    
    
    %     end
    
    % if currpos1==r
    %     mp.controls.stop
    %     disp('ok')
    %     set(handles.listbox1,'Value',index_selected2+1);
    %     return;
    % end    
end  


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% cd(handles.workdir)
[filename pathname] = uigetfiles('*.*','Please select a file')
% if ~filename
%     return
% end;
% assignin('base','filename',filename);
s=cell2struct(filename,'name',length(filename));
[sorted_name,sorted_index]=sortrows({s.name}');
handles.file_name=sorted_name;
handles.sorted_index=[sorted_index];
numind=length(handles.sorted_index);
handles.numind=numind;
guidata(handles.figure1,handles)
set(handles.listbox1,'String',handles.file_name,'Value',1)
dir_path=pathname; 
set(handles.listbox1,'UserData',dir_path);


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mp = handles.MovieControl;
mp.controls.stop
SelectionLb = findobj(gcbf,'Tag','listbox1');
select_ind=get(SelectionLb,'Value');    
if any(select_ind)
    select_ind=get(SelectionLb,'Value');    
    contents =cellstr(get(SelectionLb,'String'));    
    contents(select_ind)=[];
    set(SelectionLb,'String',char(contents),'Value',select_ind);
end








