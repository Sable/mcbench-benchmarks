%This Progra, develop by Renoald Tang
%University Teknologi Malaysia, Photogrammetry and Laser scanning group
%for academic purpose
%Email:renoald@live.com
function varargout = AMLS(varargin)
% AMLS M-file for AMLS.fig
%      AMLS, by itself, creates a new AMLS or raises the existing
%      singleton*.
%
%      H = AMLS returns the handle to a new AMLS or the handle to
%      the existing singleton*.
%
%      AMLS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AMLS.M with the given input arguments.
%
%      AMLS('Property','Value',...) creates a new AMLS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AMLS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AMLS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AMLS

% Last Modified by GUIDE v2.5 01-Jul-2004 00:11:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AMLS_OpeningFcn, ...
                   'gui_OutputFcn',  @AMLS_OutputFcn, ...
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


% --- Executes just before AMLS is made visible.
function AMLS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AMLS (see VARARGIN)

% Choose default command line output for AMLS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
%axes(handles.axes1)
%axis off
%axes(handles.axes3)
%axis off 

% UIWAIT makes AMLS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AMLS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in openbutton.
function openbutton_Callback(hObject, eventdata, handles)
% hObject    handle to openbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName] = uigetfile({'*.xyz'},'Select the Point clouds');
%combine the filename and pathname
directory=strcat(PathName ,FileName);
%.xyz check file extension
ext=findstr(FileName,'.xyz');
n=isempty(ext);
if n==0 
    point=dlmread(directory);
end
n=length(point);
    dlmwrite('point.xyz', point, 'delimiter', '\t','precision', 6);
 %setappdata(AMLS,'point1',point);
 axes(handles.axes1)
 axis on 
plot3(point(:,1),point(:,2),point(:,3),'r.')
grid on
num= num2str(n);
set(handles.text2,'String',num);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
input = str2num(get(hObject,'String'));
if (isempty(input))
     set(hObject,'String','2')
end
guidata(hObject, handles);

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


% --- Executes on button press in Computebutton.
function Computebutton_Callback(hObject, eventdata, handles)
% hObject    handle to Computebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
para = get(handles.edit1,'String');
parameter=str2num(para);
myname='point.xyz';
out='mypoint';
command=sprintf('NormFet.exe %s  %s -nml -ftr \n',myname,out);
system(command);
lastfile='mypoint_bbr2.50_nn8.xyznw';
outfile='output';
factor=parameter;
command2=sprintf('AMLS.exe %s %s -hr %d\n',lastfile,outfile,factor);
system(command2);
f1='output_adpmls_hr';
f2='.00.xyz';
finalfile=strcat(f1,para,f2);
%disp(finalfile)
surface=dlmread(finalfile);
setappdata(AMLS,'surface',surface);
axes(handles.axes3)
axis on
plot3(surface(:,1),surface(:,2),surface(:,3),'g.');
grid on 
% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file1,path1] = uiputfile({'*.xyz'},'Save file name');
%combine the filename and pathname

directory=strcat(path1,file1);
mypoint=getappdata(AMLS,'surface');
dlmwrite(directory, mypoint, 'delimiter', '\t', ...
         'precision', 6);

% --- Executes on button press in exitbutton.
function exitbutton_Callback(hObject, eventdata, handles)
% hObject    handle to exitbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(gcf) 

% --- Executes on button press in clearpushbutton.
function clearpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to clearpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
arrayfun(@cla,findall(0,'type','axes'));

