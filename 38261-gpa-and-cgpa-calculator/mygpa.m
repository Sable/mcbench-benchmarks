function varargout = mygpa(varargin)
% MYGPA M-file for mygpa.fig
%      MYGPA, by itself, creates a new MYGPA or raises the existing
%      singleton*.
%
%      H = MYGPA returns the handle to a new MYGPA or the handle to
%      the existing singleton*.
%
%      MYGPA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYGPA.M with the given input arguments.
%
%      MYGPA('Property','Value',...) creates a new MYGPA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mygpa_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mygpa_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mygpa

% Last Modified by GUIDE v2.5 14-Apr-2012 03:41:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mygpa_OpeningFcn, ...
                   'gui_OutputFcn',  @mygpa_OutputFcn, ...
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


% --- Executes just before mygpa is made visible.
function mygpa_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mygpa (see VARARGIN)

% Choose default command line output for mygpa
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mygpa wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mygpa_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in c1.
function c1_Callback(hObject, eventdata, handles)
% hObject    handle to c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns c1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from c1


% --- Executes during object creation, after setting all properties.
function c1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in g1.
function g1_Callback(hObject, eventdata, handles)
% hObject    handle to g1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns g1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from g1


% --- Executes during object creation, after setting all properties.
function g1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in g2.
function g2_Callback(hObject, eventdata, handles)
% hObject    handle to g2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns g2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from g2


% --- Executes during object creation, after setting all properties.
function g2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in c2.
function c2_Callback(hObject, eventdata, handles)
% hObject    handle to c2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns c2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from c2


% --- Executes during object creation, after setting all properties.
function c2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in g3.
function g3_Callback(hObject, eventdata, handles)
% hObject    handle to g3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns g3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from g3


% --- Executes during object creation, after setting all properties.
function g3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in c3.
function c3_Callback(hObject, eventdata, handles)
% hObject    handle to c3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns c3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from c3


% --- Executes during object creation, after setting all properties.
function c3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in g4.
function g4_Callback(hObject, eventdata, handles)
% hObject    handle to g4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns g4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from g4


% --- Executes during object creation, after setting all properties.
function g4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in c4.
function c4_Callback(hObject, eventdata, handles)
% hObject    handle to c4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns c4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from c4


% --- Executes during object creation, after setting all properties.
function c4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in c6.
function c6_Callback(hObject, eventdata, handles)
% hObject    handle to c6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns c6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from c6


% --- Executes during object creation, after setting all properties.
function c6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in g6.
function g6_Callback(hObject, eventdata, handles)
% hObject    handle to g6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns g6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from g6


% --- Executes during object creation, after setting all properties.
function g6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in g5.
function g5_Callback(hObject, eventdata, handles)
% hObject    handle to g5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns g5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from g5


% --- Executes during object creation, after setting all properties.
function g5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in c5.
function c5_Callback(hObject, eventdata, handles)
% hObject    handle to c5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns c5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from c5


% --- Executes during object creation, after setting all properties.
function c5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in c7.
function c7_Callback(hObject, eventdata, handles)
% hObject    handle to c7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns c7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from c7


% --- Executes during object creation, after setting all properties.
function c7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on selection change in g7.
function g7_Callback(hObject, eventdata, handles)
% hObject    handle to g7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns g7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from g7


% --- Executes during object creation, after setting all properties.
function g7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in g8.
function g8_Callback(hObject, eventdata, handles)
% hObject    handle to g8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns g8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from g8


% --- Executes during object creation, after setting all properties.
function g8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on selection change in c8.
function c8_Callback(hObject, eventdata, handles)
% hObject    handle to c8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns c8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from c8


% --- Executes during object creation, after setting all properties.
function c8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
C=[0 4 3 2 1];
G=[0 4.00 3.75 3.50 3.00 2.50 2.00 1.50 1.00 0.00];
cc(1)=C(get(handles.c1,'Value'));
gg(1)=G(get(handles.g1,'Value'));
cc(2)=C(get(handles.c2,'Value'));
gg(2)=G(get(handles.g2,'Value'));
cc(3)=C(get(handles.c3,'Value'));
gg(3)=G(get(handles.g3,'Value'));
cc(4)=C(get(handles.c4,'Value'));
gg(4)=G(get(handles.g4,'Value'));
cc(5)=C(get(handles.c5,'Value'));
gg(5)=G(get(handles.g5,'Value'));
cc(6)=C(get(handles.c6,'Value'));
gg(6)=G(get(handles.g6,'Value'));
cc(7)=C(get(handles.c7,'Value'));
gg(7)=G(get(handles.g7,'Value'));
cc(8)=C(get(handles.c8,'Value'));
gg(8)=G(get(handles.g8,'Value'));
GPA=sum(cc.*gg)/sum(cc);
set(handles.GPA,'String',GPA)
global ABCXYZ ;
ABCXYZ=(sum(cc));
XX(GPA);

function cgpa0_Callback(hObject, eventdata, handles)
% hObject    handle to cgpa0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cgpa0 as text
%        str2double(get(hObject,'String')) returns contents of cgpa0 as a double


% --- Executes during object creation, after setting all properties.
function cgpa0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cgpa0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ch0_Callback(hObject, eventdata, handles)
% hObject    handle to ch0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch0 as text
%        str2double(get(hObject,'String')) returns contents of ch0 as a double


% --- Executes during object creation, after setting all properties.
function ch0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cgpa_previous=(get(handles.cgpa0 ,'String'));
ch_previous=(get(handles.ch0 ,'String'));
gpa_current=(get(handles.GPA ,'String'));
cgpa_previous=str2num(cgpa_previous);
ch_previous=str2num(ch_previous);
gpa_current=str2num(gpa_current);
global ABCXYZ;
ccgpa=(gpa_current.*ABCXYZ+cgpa_previous.*ch_previous)./(ABCXYZ+ch_previous);
set(handles.CCGPA,'String',ccgpa);
XX(ccgpa);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function XX(t)
if   t==4
    msgbox('Parable Performance!','CGPA','replace');return;
end
if   t>=3.5
    msgbox('Excellent Performance!','CGPA','replace');return;
end
if    t>=3
    msgbox('Fair!','CGPA','replace');return;
end
if     t>=2 
    msgbox('You Need To work evenmore!','CGPA','replace');return;
end
if       t<2 
    msgbox('Bad Perfprmance!','CGPA','replace');return;
end
 