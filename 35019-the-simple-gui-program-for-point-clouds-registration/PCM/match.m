function varargout = match(varargin)
% MATCH M-file for match.fig
%      MATCH, by itself, creates a new MATCH or raises the existing
%      singleton*.
%
%      H = MATCH returns the handle to a new MATCH or the handle to
%      the existing singleton*.
%
%      MATCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATCH.M with the given input arguments.
%
%      MATCH('Property','Value',...) creates a new MATCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before match_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to match_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help match

% Last Modified by GUIDE v2.5 05-Jan-2012 16:04:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @match_OpeningFcn, ...
                   'gui_OutputFcn',  @match_OutputFcn, ...
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


% --- Executes just before match is made visible.
function match_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to match (see VARARGIN)

% Choose default command line output for match
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
%set the axes2 as main axes
axes(handles.axes2)
axis off



% UIWAIT makes match wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = match_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button1.
function button1_Callback(hObject, eventdata, handles)
% hObject    handle to button1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Let the user select the file 
[FileName,PathName] = uigetfile({'*.xyz'},'Select the Point clouds');
%combine the filename and pathname
directory=strcat(PathName ,FileName);
%.xyz check file extension
ext=findstr(FileName,'.xyz');
n=isempty(ext);
if n==0 
    point=dlmread(directory);
   
end
 setappdata(match,'point1',point);
plot3(point(:,1),point(:,2),point(:,3),'r.')
axis off 




% --- Executes on button press in button2.
function button2_Callback(hObject, eventdata, handles)
% hObject    handle to button2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Let the user select the file 
[FileName,PathName] = uigetfile({'*.xyz'},'Select the Point clouds');
%combine the filename and pathname
directory=strcat(PathName ,FileName);
%.xyz check file extension
ext=findstr(FileName,'.xyz');
n=isempty(ext);
if n==0 
    point1=dlmread(directory);
    
end
setappdata(match,'point2',point1)
hold on
plot3(point1(:,1),point1(:,2),point1(:,3),'g.')


% --- Executes on button press in Exitbutton.
function Exitbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Exitbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(gcf) 



function edit_Callback(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit as text
%        str2double(get(hObject,'String')) returns contents of edit as a double
%store the tolerance distance 
input = str2num(get(hObject,'String'));
if (isempty(input))
     set(hObject,'String','3')
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Mergebutton.
function Mergebutton_Callback(hObject, eventdata, handles)
% hObject    handle to Mergebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = get(handles. edit,'String');
tol=str2num(t);
p=getappdata(match,'point1');
d=getappdata(match,'point2');
data1=p';
data2=d';
tic
[R, t,corr,data2,TX,RX,M,S,err,NN,NNC,K,VV] = icp(data1, data2, tol);
toc
TTq=num2str(toc);
p1=data2';
hold off 
axis off 
plot3(p1(:,1),p1(:,2),p1(:,3),'g.')
hold on 
plot3(p(:,1),p(:,2),p(:,3),'r.')
axis off 
fpoint=[p1;
        p];
%display root mean square error 
Error= num2str(err);
set(handles.text3,'String',Error);
numK=num2str(K);
set(handles.text5,'String',numK)
set(handles.text7,'String',TTq)
RR1=num2str(R(1,1));
RR2=num2str(R(2,2));
RR3=num2str(R(3,3));
set(handles.text10,'String',RR1)
set(handles.text11,'String',RR2)
set(handles.text12,'String',RR3)
TTA=num2str(t(1,1));
TTB=num2str(t(2,1));
TTC=num2str(t(3,1));
set(handles.text14,'String',TTA)
set(handles.text43,'String',TTB)
set(handles.text44,'String',TTC)

setappdata(match,'myerror',VV);
setappdata(match,'finalpoint',fpoint);
set(handles.Mergebutton,'Enable','off');
set(handles.pushbutton5,'Enable','on');
set(handles.pushbutton6,'Enable','on');
set(handles.pushbutton7,'Enable','on');
set(handles.pushbutton8,'Enable','on');
set(handles.pushbutton9,'Enable','on');
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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%on rotate
rotate3d on 

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rotate3d off 


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
VRR=getappdata(match,'myerror');
n=length(VRR');
X=ones(n,1);
Y=ones(n,1);
for i=1 :  n 
    X(i,1)=i;
    Y(i,1)=VRR(1,i);
end
figure(1)
plot(X,Y)
xlabel('number of iteration');
ylabel('rms error');
title('The Change of RMS error');
grid on 



% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file1,path1] = uiputfile({'*.xyz'},'Save file name');
%combine the filename and pathname

directory=strcat(path1,file1);
mypoint=getappdata(match,'finalpoint');
dlmwrite(directory, mypoint, 'delimiter', '\t', ...
         'precision', 6);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla reset 
axis off 
set(handles.text14,'String','')
set(handles.text43,'String','')
set(handles.text44,'String','')
set(handles.text10,'String','')
set(handles.text11,'String','')
set(handles.text12,'String','')
set(handles.text5,'String','')
set(handles.text7,'String','')
set(handles.text3,'String','');
set(handles.Mergebutton,'Enable','on');
set(handles.pushbutton5,'Enable','off');
set(handles.pushbutton6,'Enable','off');
set(handles.pushbutton7,'Enable','off');
set(handles.pushbutton8,'Enable','off');
set(handles.pushbutton9,'Enable','off');
clear 

