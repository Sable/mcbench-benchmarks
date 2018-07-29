function varargout = Rad_Dist_Func(varargin)
% RAD_DIST_FUNC M-file for Rad_Dist_Func.fig
%      RAD_DIST_FUNC, by itself, creates a new RAD_DIST_FUNC or raises the existing
%      singleton*.
%
%      H = RAD_DIST_FUNC returns the handle to a new RAD_DIST_FUNC or the handle to
%      the existing singleton*.
%
%      RAD_DIST_FUNC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RAD_DIST_FUNC.M with the given input arguments.
%
%      RAD_DIST_FUNC('Property','Value',...) creates a new RAD_DIST_FUNC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Rad_Dist_Func_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Rad_Dist_Func_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Rad_Dist_Func

% Last Modified by GUIDE v2.5 20-May-2011 03:33:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Rad_Dist_Func_OpeningFcn, ...
                   'gui_OutputFcn',  @Rad_Dist_Func_OutputFcn, ...
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


% --- Executes just before Rad_Dist_Func is made visible.
function Rad_Dist_Func_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Rad_Dist_Func (see VARARGIN)

% Choose default command line output for Rad_Dist_Func
handles.output = hObject;

%This is to share the array of centers among all the functions
handles.cent=zeros(700,2);


%This is to share the counter data among all the functions
handles.counter=0;
set(handles.text1,'String','0');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Rad_Dist_Func wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Rad_Dist_Func_OutputFcn(hObject, eventdata, handles) 
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

imfilename = get(handles.imfilename,'String');


A=imread(imfilename);

%Read the xlimits and the ylimits
x1 = str2num(get(handles.x1,'String'));
x2 = str2num(get(handles.x2,'String'));
y1 = str2num(get(handles.y1,'String'));
y2 = str2num(get(handles.y2,'String'));




fig=handles.figure1;

dcm_obj=datacursormode(fig);

c_info = getCursorInfo(dcm_obj);

xxx=c_info.Position;

k=handles.counter;
C=handles.cent;
set(handles.text3,'String',num2str(k+1) );
C(handles.counter+1,1)=xxx(1,1)-x1;
C(handles.counter+1,2)=xxx(1,2)-y1;

%drawnow
%imshow(A)
hold on
plot(xxx(1,1),xxx(1,2),'rx','MarkerSize',12.5,'LineWidth',2)

handles.cent=C;
handles.counter=handles.counter+1;
set(handles.text1,'String',num2str(handles.counter) );

guidata(hObject, handles);
% --- Executes on button press in loadimage.
function loadimage_Callback(hObject, eventdata, handles)
% hObject    handle to loadimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imfilename = get(handles.imfilename,'String');

A=imread(imfilename);
imshow(A)


% --- Executes on button press in printcenter.
function printcenter_Callback(hObject, eventdata, handles)
% hObject    handle to printcenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%save the center

%Write the file of the coordinates of the center
C=handles.cent;
k=handles.counter;
centername = get(handles.centersname,'String');
rdffile = get(handles.rdffile,'String');
centerfile=strcat(centername,rdffile,'.txt');

file_1 = fopen(centerfile,'w');
for i=1:k
fprintf(file_1,' %d \t %d \n',C(i,1),C(i,2));
end


%Print the number of centers
set(handles.noc,'String',num2str(k));

guidata(hObject, handles);


function x1_Callback(hObject, eventdata, handles)
% hObject    handle to x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x1 = str2num(get(hObject,'String'));

% Hints: get(hObject,'String') returns contents of x1 as text
%        str2double(get(hObject,'String')) returns contents of x1 as a double


% --- Executes during object creation, after setting all properties.
function x1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x2_Callback(hObject, eventdata, handles)
% hObject    handle to x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x2 as text
%        str2double(get(hObject,'String')) returns contents of x2 as a double
x2 = str2num(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function x2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y1_Callback(hObject, eventdata, handles)
% hObject    handle to y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y1 as text
%        str2double(get(hObject,'String')) returns contents of y1 as a double
y1 = str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function y1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y2_Callback(hObject, eventdata, handles)
% hObject    handle to y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y2 as text
%        str2double(get(hObject,'String')) returns contents of y2 as a double
y2 = str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function y2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in imagelim.
function imagelim_Callback(hObject, eventdata, handles)
% hObject    handle to imagelim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x1 = str2num(get(handles.x1,'String'));
x2 = str2num(get(handles.x2,'String'));
y1 = str2num(get(handles.y1,'String'));
y2 = str2num(get(handles.y2,'String'));

hold on
rectangle('Position',[x1,y1,(x2-x1),(y2-y1)],'Linewidth',2,'EdgeColor','b')



function imfilename_Callback(hObject, eventdata, handles)
% hObject    handle to imfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imfilename=get(hObject,'String');

% Hints: get(hObject,'String') returns contents of imfilename as text
%        str2double(get(hObject,'String')) returns contents of imfilename as a double


% --- Executes during object creation, after setting all properties.
function imfilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function centersname_Callback(hObject, eventdata, handles)
% hObject    handle to centersname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

centersname=get(hObject,'String');

% Hints: get(hObject,'String') returns contents of centersname as text
%        str2double(get(hObject,'String')) returns contents of centersname as a double


% --- Executes during object creation, after setting all properties.
function centersname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to centersname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rdffile_Callback(hObject, eventdata, handles)
% hObject    handle to rdffile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rdffile=get(hObject,'String');
% Hints: get(hObject,'String') returns contents of rdffile as text
%        str2double(get(hObject,'String')) returns contents of rdffile as a double


% --- Executes during object creation, after setting all properties.
function rdffile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rdffile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rdf.
function rdf_Callback(hObject, eventdata, handles)
% hObject    handle to rdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x1 = str2num(get(handles.x1,'String'));
x2 = str2num(get(handles.x2,'String'));
y1 = str2num(get(handles.y1,'String'));
y2 = str2num(get(handles.y2,'String'));

xlim=x2-x1;
ylim=y2-y1;

C1=handles.cent;
k=handles.counter;

C=C1(1:k,:);

rbin=rdfcalc(C,xlim,ylim);

rbin(:,2)=rbin(:,2)/k;
A=xlim*ylim;
numden=k/A;
rbin(:,2)=rbin(:,2)/numden;

hold off
plot(rbin(:,1),rbin(:,2),'bo-')




rdffile = get(handles.rdffile,'String');

strrdf=strcat('rbin',rdffile);

v=genvarname(strrdf);

eval([v '=rbin']);

s1=strcat(strrdf,'.mat');

save(s1,v)




% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object deletion, before destroying properties.
function y2_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
