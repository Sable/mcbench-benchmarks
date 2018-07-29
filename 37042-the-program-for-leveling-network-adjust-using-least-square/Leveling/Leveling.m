%This program write by Renoald
%Any questions or error in this program please email to Renoald@live.com
function varargout = Leveling(varargin)
% LEVELING M-file for Leveling.fig
%      LEVELING, by itself, creates a new LEVELING or raises the existing
%      singleton*.
%
%      H = LEVELING returns the handle to a new LEVELING or the handle to
%      the existing singleton*.
%
%      LEVELING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LEVELING.M with the given input arguments.
%
%      LEVELING('Property','Value',...) creates a new LEVELING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Leveling_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Leveling_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Leveling

% Last Modified by GUIDE v2.5 06-Jun-2012 18:22:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Leveling_OpeningFcn, ...
                   'gui_OutputFcn',  @Leveling_OutputFcn, ...
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


% --- Executes just before Leveling is made visible.
function Leveling_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Leveling (see VARARGIN)

% Choose default command line output for Leveling
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Leveling wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Leveling_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName] = uigetfile({'*.dat';'*.txt';'*.*'},'Select the data file');
if FileName~=0
  directory=strcat(PathName ,FileName);
  setappdata(Leveling,'myfile',directory);
   setappdata(Leveling,'file',FileName);
  [ben,V1]=benmark(directory);%ben=bnckmark V=benmark value 
[sta1,sta2,V,std]=station(directory);%sta1 and sta1 -stn1 and 2 V=value std=standard deviation
n=length(V1);
fid=fopen('Info','w');
fprintf(fid,'Benchmark\n');
fprintf(fid,'station    Elevation value\n');
num=ones(n,1);
for i=1 : n 
    fprintf(fid,'%s           %.4f\n',ben{1,i},V1(i,1));
end
fprintf(fid,'********************************\n');
fprintf(fid,'observations\n');
fprintf(fid,'From   To     Elevation value    (+/-)std\n');
n1=length(V);
num1=ones(n1,1);
num2=ones(n1,1);
for i=1 : n1 
    C1=sta1{1,i};
      num1(i,1)=unicode2native(C1);
C2=sta2{1,i};
 num2(i,1)=unicode2native(C2);
end
 for i=1 : n1 
    fprintf(fid,'%s      %s       %.5f          %.4f \n',sta1{1,i},sta2{1,i},V(i,1),std(i,1));
 end
  to_tum=[num1
       num2];
 to=unique(to_tum);
 %number of station 
 numT=length(to);
 %fprintf('number of station:%d\n',numT);
 %number of parameter 
 
numA=numT-n;
TT=to;
  %fprintf('number of parameter:%d\n',numA);
  for i=1 :  n
      for j=1 : numT
           if num(i,1)==TT(j,1)
              TT(j,1)=0;
           end
               
               
          %fprintf('%d : %d \n',i,j)
      end
  end
  K=0;
  para=ones(numA,1);
  for j=1 : numT 
  if TT(j,1) ~=0
      K=K+1;
      para(K)=TT(j,1);
  end
  end
 
  %A matrrik

  A=zeros(n1,numA);
  for i=1 : numA 
      for j=1 : n1
           if para(i,1)==num1(j,1)
               A(j,i)=1;
           
           end
          %fprintf('%d : %d \n',i,j)
      end
  end
  for i=1 : numA 
      for j=1 : n1
           if para(i,1)==num2(j,1)
               A(j,i)=-1;
           end
          %fprintf('%d : %d \n',i,j)
      end
  end
 %B matric
B=zeros(n1,1);
for i=1 : n 
    for j=1 : n1 
        if num(i,1)==num1(j,1)
            B(j,1)=V1(i,1);
        end
    end
end
 for i=1 : n 
    for j=1 : n1 
        if num(i,1)==num2(j,1)
            B(j,1)=-V1(i,1);
        end
    end
end
%fprintf('%.4f\n',B)
fprintf(fid,'number of benchmark:%d\n',n);
fprintf(fid,'number of station:%d\n',numT);
fprintf(fid,'number of observation:%d\n',n1);
fprintf(fid,'number of parameter:%d\n',numA);
fclose(fid);
fid1=fopen('Info');
indic = 1;
    while 1
         tline = fgetl(fid1);
         if ~ischar(tline), 
             break
         end
         strings{indic}=tline; 
         indic = indic + 1;
    end
    fclose(fid1);
set(handles.edit1,'String', strings)
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fc=getappdata(Leveling,'myfile');
fN=getappdata(Leveling,'file');
[a1,a2]=size(fN);
%disp(a2)
if a2 > 0 
ind=findstr(fN,'.');
%disp(fN(1:ind-1))
output=strcat(fN(1:ind-1) ,'.out') ;   
 adj(fc,output) 
 fid1=fopen(output);
indic = 1;
    while 1
         tline = fgetl(fid1);
         if ~ischar(tline), 
             break
         end
         strings{indic}=tline; 
         indic = indic + 1;
    end
    fclose(fid1);
set(handles.edit2,'String', strings)
set(handles.pushbutton3,'Enable','on');
end 



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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit1,'String', '')
set(handles.edit2,'String', '')

clear fN
set(handles.pushbutton3,'Enable','off');


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(Leveling)
