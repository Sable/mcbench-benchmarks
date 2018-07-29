function varargout = recal13(varargin)
% RECAL13 M-file for recal13.fig
%      RECAL13, by itself, creates a new RECAL13 or raises the existing
%      singleton*.
%
%      H = RECAL13 returns the handle to a new RECAL13 or the handle to
%      the existing singleton*.
%
%      RECAL13('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECAL13.M with the given input arguments.
%
%      RECAL13('Property','Value',...) creates a new RECAL13 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before recal13_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to recal13_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help recal13

% Last Modified by GUIDE v2.5 06-Dec-2008 12:54:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @recal13_OpeningFcn, ...
                   'gui_OutputFcn',  @recal13_OutputFcn, ...
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


% --- Executes just before recal13 is made visible.
function recal13_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to recal13 (see VARARGIN)

% Choose default command line output for recal13
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes recal13 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = recal13_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


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















% --- Executes on selection change in p3.
function p3_Callback(hObject, eventdata, handles)
a3=get(hObject,'Value') % 'a3' is the variable and get(Syntax)

%a4=(a3*10)+a1
switch a3
    case 1
        set(handles.s3,'string','1^0')
    case 2
        set(handles.s3,'string','10')
    case 3
        set(handles.s3,'string','100')
    case 4
        set(handles.s3,'string','1000')
    case 5
        set(handles.s3,'string','10000')
    case 6
        set(handles.s3,'string','100000')
    case 7
        set(handles.s3,'string','1000000')
    case 8
        set(handles.s3,'string','10000000')
    case 9
        set(handles.s3,'string','100000000')
    case 10
        set(handles.s3,'string','1000000000')
end   











function p3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
















% --- Executes on selection change in p2.
function p2_Callback(hObject, eventdata, handles)
a2=get(hObject,'Value') % 'a' is the variable and get(Syntax)
switch a2
    case 1
        set(handles.s2,'string','0')
    case 2
        set(handles.s2,'string','1')
    case 3
        set(handles.s2,'string','2')
    case 4
        set(handles.s2,'string','3')
    case 5
        set(handles.s2,'string','4')
    case 6
        set(handles.s2,'string','5')
    case 7
        set(handles.s2,'string','6')
    case 8
        set(handles.s2,'string','7')
    case 9
        set(handles.s2,'string','8')
    case 10
        set(handles.s2,'string','9')
end   

function p2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end















% --- Executes on selection change in p1.
function p1_Callback(hObject, eventdata, handles)
a=get(hObject,'Value') % 'a' is the variable and get(Syntax)
switch a
    case 1
        set(handles.s1,'string','0')
    case 2
        set(handles.s1,'string','1')
    case 3
        set(handles.s1,'string','2')
    case 4
        set(handles.s1,'string','3')
    case 5
        set(handles.s1,'string','4')
    case 6
        set(handles.s1,'string','5')
    case 7
        set(handles.s1,'string','6')
    case 8
        set(handles.s1,'string','7')
    case 9
        set(handles.s1,'string','8')
    case 10
        set(handles.s1,'string','9')
end   


% --- Executes during object creation, after setting all properties.
function p1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function s1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in p4.
function p4_Callback(hObject, eventdata, handles)

a4=get(hObject,'Value') % 'a' is the variable and get(Syntax)
switch a4
    case 1
        set(handles.s4,'string','±5%')
    case 2
        set(handles.s4,'string','±10%')
end




% --- Executes during object creation, after setting all properties.
function p4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in p5.
function p5_Callback(hObject, eventdata, handles)
z1 = get(handles.s1,'string');

while z1==0;
    z1=z1+1;
end
z2 = get(handles.s2,'string');
while z2==0;
    z2=z2+1;
end


z3 = get(handles.s3,'string');


z4 = get(handles.s4,'string');

%Z1 AND Z2 CONTAINS THE SAME NUMBERS OF ARRAYS SO TO THEM IN HORIZANTLY
%MANNER I USE THE FOLLOWING COMMAND

%SYNTAX OF "strcat"
%Concatenate strings horizontally
%a = 'hello '
%b = 'goodbye'
%strcat(a, b)
%ans =
%hellogoodbye
%[a b]
%ans =
%hello goodbye
z1 = strcat(z1,z2);
z1 = str2num(z1);
z5 = str2num(z3);

q2=z1*z5;

if q2<1000;
  
   set(handles.t9,'string','Ohms')
set(handles.t1,'string',q2)
set(handles.t7,'string',z4)

end



if q2>=1000;
    w1=q2/1000;
   set(handles.t9,'string','Kilo Ohms')
set(handles.t1,'string',w1)
set(handles.t7,'string',z4)

end

if q2>=1000000;
    w1=(q2/1000)/1000;
   set(handles.t9,'string','Mega Ohms')
set(handles.t1,'string',w1)
set(handles.t7,'string',z4)

end



