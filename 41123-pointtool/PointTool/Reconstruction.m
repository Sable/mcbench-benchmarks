%This Progra, develop by Renoald Tang
%University Teknologi Malaysia, Photogrammetry and Laser scanning group
%for academic purpose
%Email:renoald@live.com
%***For Cocone(cocone.exe) and Tight Cocone(tcocone.exe) software
%***please request download from http://www.cse.ohio-state.edu/~tamaldey/cocone.html
function varargout = Reconstruction(varargin)
% RECONSTRUCTION M-file for Reconstruction.fig
%      RECONSTRUCTION, by itself, creates a new RECONSTRUCTION or raises the existing
%      singleton*.
%
%      H = RECONSTRUCTION returns the handle to a new RECONSTRUCTION or the handle to
%      the existing singleton*.
%
%      RECONSTRUCTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECONSTRUCTION.M with the given input arguments.
%
%      RECONSTRUCTION('Property','Value',...) creates a new RECONSTRUCTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Reconstruction_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Reconstruction_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Reconstruction

% Last Modified by GUIDE v2.5 10-Jan-2012 16:15:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Reconstruction_OpeningFcn, ...
                   'gui_OutputFcn',  @Reconstruction_OutputFcn, ...
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


% --- Executes just before Reconstruction is made visible.
function Reconstruction_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Reconstruction (see VARARGIN)

% Choose default command line output for Reconstruction
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Reconstruction wait for user response (see UIRESUME)
% uiwait(handles.figure1);
axes(handles.axes1)
%axis off 
view(3)
grid on 
axes(handles.axes2)
view(3)
grid on 

% --- Outputs from this function are returned to the command line.
function varargout = Reconstruction_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in importbutton.
function importbutton_Callback(hObject, eventdata, handles)
% hObject    handle to importbutton (see GCBO)
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
dlmwrite('point', point, 'delimiter', '\t','precision', 6);
n2=length(point);
num=num2str(n2);
set(handles.text2,'String',num)
 setappdata(Reconstruction,'point1',point);
 axes(handles.axes1)
plot3(point(:,1),point(:,2),point(:,3),'r.')
grid on 


% --- Executes on button press in DVbutton.
function DVbutton_Callback(hObject, eventdata, handles)
% hObject    handle to DVbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p=getappdata(Reconstruction,'point1');
 [t,tnorm]=Crust(p);
 n=length(t);
 x=ones(n,1);

 num1=num2str(n);
axes(handles.axes2);
trisurf(t,p(:,1),p(:,2),p(:,3));
axis on 
grid on 
set(handles.text4,'String',num1);
 for i=1 : n
     x(i,1)=x(i,1)*3;
     t(i,1)=t(i,1)-1;
     t(i,2)=t(i,2)-1;
     t(i,3)=t(i,3)-1;
 end
t=[x t];
dlmwrite('face', t, 'delimiter', '\t','precision', 6);


% --- Executes on button press in Cbutton.
function Cbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Cbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a1 = get(handles.C_edit,'String');
C=str2num(a1);
R1=isempty(C);
if R1==1
    C=0.393;
end
b=get(handles.S_edit,'String');
S=str2num(b);
R1=isempty(S);
if R1==1
    S=1.571;
end
d=get(handles.f_edit,'String');
f=str2num(d);
R1=isempty(f);
if R1==1
    f=1.047;
end
ee=get(handles.r_edit,'String');
r=str2num(ee);
R1=isempty(r);
if R1==1 
    r=1.2;
end
command=sprintf('cocone.exe -c %2f -s %2f -f %2f -r %2f  point \n',C,S,f,r);
h = waitbar(0,'Please wait , the surface is compute......','name','surface computation');
system(command);
waitbar(1/3,h,'30 % finish');
readJV('point.jv');
waitbar(2/3,h,'60 % finish');
 readOFF('point.off');
 axes(handles.axes2);
 N=dlmread('face');
 nn=length(N);
 num1=num2str(nn);
 set(handles.text4,'String',num1);
 
myview(0,0,0,0)
axis on 
grid on 
waitbar(3/3,h,'100 % finish');
close(h);
delete('point.dl');
delete('point.jv');
delete('point.wrl');
delete('point.off');
function C_edit_Callback(hObject, eventdata, handles)
% hObject    handle to C_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of C_edit as text
%        str2double(get(hObject,'String')) returns contents of C_edit as a double
%store the contents of input1_editText as a string. if the string
%is not a number then input will be empty
input = str2num(get(hObject,'String'));

%checks to see if input is empty. if so, default input1_editText to zero
if (isempty(input))
     set(hObject,'String','0.393')
end
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function C_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to C_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function S_edit_Callback(hObject, eventdata, handles)
% hObject    handle to S_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of S_edit as text
%        str2double(get(hObject,'String')) returns contents of S_edit as a double
input = str2num(get(hObject,'String'));

%checks to see if input is empty. if so, default input1_editText to zero
if (isempty(input))
     set(hObject,'String','1.571')
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function S_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to S_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_edit_Callback(hObject, eventdata, handles)
% hObject    handle to f_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_edit as text
%        str2double(get(hObject,'String')) returns contents of f_edit as a double
input = str2num(get(hObject,'String'));

%checks to see if input is empty. if so, default input1_editText to zero
if (isempty(input))
     set(hObject,'String','1.047')
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function f_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function r_edit_Callback(hObject, eventdata, handles)
% hObject    handle to r_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of r_edit as text
%        str2double(get(hObject,'String')) returns contents of r_edit as a double
if (isempty(input))
     set(hObject,'String','1.2')
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function r_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function re_edit_Callback(hObject, eventdata, handles)
% hObject    handle to re_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of re_edit as text
%        str2double(get(hObject,'String')) returns contents of re_edit as a double
input = str2num(get(hObject,'String'));

%checks to see if input is empty. if so, default input1_editText to zero
if (isempty(input))
     set(hObject,'String','1.1')
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function re_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to re_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Tbutton.
function Tbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Tbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
aa = get(handles.re_edit,'String');
CK=str2num(aa);
R1=isempty(CK);
if R1==1
    CK=1.1;
end
command=sprintf('tcocone.exe -m -r %2f point surface\n',CK);
h = waitbar(0,'Please wait , the surface is compute......','name','surface computation');
system(command);
waitbar(1/4,h,'25 % finish');

change('surface_surf.off')
waitbar(2/4,h,'50 % finish');
     readOFF('OFF');
     waitbar(3/4,h,'75 % finish');
     axes(handles.axes2);
     N=dlmread('face');
 nn=length(N);
 num1=num2str(nn);
 set(handles.text4,'String',num1);
      myview(0,0,0,0);
      axis on 
grid on 
  waitbar(4/4,h,'100 % finish');
  close(h);
delete('surface_axis.off');
delete('surface_axis.wrl');
delete('surface_surf.wrl');
delete('surface_surf.off');
delete('OFF');


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rotate3d on

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rotate3d off


% --- Executes on button press in expbutton.
function expbutton_Callback(hObject, eventdata, handles)
% hObject    handle to expbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file1,path1] = uiputfile({'*.ply';'*.off';},'Save file name');
File2=strcat(path1,file1);
ext=findstr(File2,'.ply');
nn1=isempty(ext);
if nn1==0
    WritePly(File2);
end
ext1=findstr(File2,'.off');
nn2=isempty(ext1);
if nn2==0 
     WriteOFF(File2);
end 


% --- Executes on button press in clearbutton.
function clearbutton_Callback(hObject, eventdata, handles)
% hObject    handle to clearbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
arrayfun(@cla,findall(0,'type','axes'));
 set(handles.text2,'String','');
 set(handles.text4,'String','');
delete('face');
delete('point');