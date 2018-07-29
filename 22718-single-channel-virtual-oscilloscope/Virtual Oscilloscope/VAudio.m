function varargout = VAudio(varargin)
% VAUDIO M-file for VAudio.fig
%      VAUDIO, by itself, creates a new VAUDIO or raises the existing
%      singleton*.
%
%      H = VAUDIO returns the handle to a new VAUDIO or the handle to
%      the existing singleton*.
%
%      VAUDIO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VAUDIO.M with the given input arguments.
%
%      VAUDIO('Property','Value',...) creates a new VAUDIO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VAudio_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VAudio_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VAudio

% Last Modified by GUIDE v2.5 16-Jan-2009 09:06:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VAudio_OpeningFcn, ...
                   'gui_OutputFcn',  @VAudio_OutputFcn, ...
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


% --- Executes just before VAudio is made visible.
function VAudio_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VAudio (see VARARGIN)

% Choose default command line output for VAudio
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VAudio wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VAudio_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function varargout = popupmenu1_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

gdt = get(handles.popupmenu1,'value')

switch gdt
    case 1
         y=audiorecorder(8000,8,2);
         set(handles.text3,'string','SampleRate=8000, SampleSize=8, Stereo')
         handles.data=y;
    guidata(handles.popupmenu1,handles)
    case 2
        y=audiorecorder(8000,16,2);
        set(handles.text3,'string','SampleRate=8000, SampleSize=16, Stereo')
        handles.data=y;
    guidata(handles.popupmenu1,handles)
    case 3
        y=audiorecorder(11025,8,2);
        set(handles.text3,'string','SampleRate=11025, SampleSize=8, Stereo')
        handles.data=y;
    guidata(handles.popupmenu1,handles)
    case 4
        y=audiorecorder(11025,16,2);
        set(handles.text3,'string','SampleRate=11025, SampleSize=16, Stereo')
        handles.data=y;
    guidata(handles.popupmenu1,handles)
    case 5
        y=audiorecorder(22050,8,2);
        set(handles.text3,'string','SampleRate=22050, SampleSize=8, Stereo')
        handles.data=y;
    guidata(handles.popupmenu1,handles)
    case 6
        y=audiorecorder(22050,16,2);
        set(handles.text3,'string','SampleRate=22050, SampleSize=16, Stereo')
        handles.data=y;
    guidata(handles.popupmenu1,handles)
    case 7
        y=audiorecorder(44100,8,2);
        set(handles.text3,'string','SampleRate=44100, SampleSize=8, Stereo')
        handles.data=y;
    guidata(handles.popupmenu1,handles)
    case 8
        y=audiorecorder(44100,16,2);
        set(handles.text3,'string','SampleRate=44100, SampleSize=16, Stereo')
        handles.data=y;
    guidata(handles.popupmenu1,handles)
end


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


% --- Executes on button press in togglebutton1.
function varargout = togglebutton1_Callback(h, eventdata, handles, varargin)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1

if (get(handles.togglebutton1,'value')) == get(handles.togglebutton1,'Max')
    
     y=audiorecorder(8000,16,2);
% y=handles.data;
% y.samplerate=za
% set(handles.text3,'string',za)
    record(y);
    set(handles.text3,'string','Now Recording...PLease speak into mic')        
     handles.data=y;
     guidata(handles.togglebutton1,handles)
elseif (get(handles.togglebutton1,'value')) == get(handles.togglebutton1,'Min')
    y=handles.data;
    stop(y);
    set(handles.text3,'string','Recording Stopped')
    pd=getaudiodata(y,'int16');
%      t=0:0.001;100;
    plot(pd,'k')
    grid on;
%     axis([0 10])
    xlabel('Time (Second)');
    ylabel('Gain (Decibel)');
end



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % % y=handles.data;
% % % if (get(handles.togglebutton1,'value')) == get(handles.togglebutton1,'Max') && (get(handles.togglebutton2,'value')) == get(handles.togglebutton2,'Min')
% % %     set(handles.text3,'string','Cannot Play, Recording is in progress...')
% % % elseif (get(handles.togglebutton1,'value')) == get(handles.togglebutton1,'Max') && (get(handles.togglebutton2,'value')) == get(handles.togglebutton2,'Max')
% % %     play(y);
% % %     set(handles.text3,'string','Now Playing...')
% % % elseif (get(handles.togglebutton1,'value')) == get(handles.togglebutton1,'Min')
% % %     play(y);
% % %     set(handles.text3,'string','Now Playing...')
% % % end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sure






% --- Executes on button press in togglebutton2.
function varargout = togglebutton2_Callback(h, eventdata, handles, varargin)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2


if (get(handles.togglebutton2,'value')) == get(handles.togglebutton2,'Max')
    y=handles.data;
    pause(y);
    set(handles.text3,'string','Recording Paused')
elseif (get(handles.togglebutton2,'value')) == get(handles.togglebutton2,'Min')
    y=handles.data;
    resume(y);
    set(handles.text3,'string','Recording Resumed')
end





% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % % sure3




% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[F] = uigetfile('*.fig','Select any .fig file');
open(F);

% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close('VAudio');
close('sure');

% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_7_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

y=audiorecorder(8000,16,2);
% y=handles.data;
% y.samplerate=za
% set(handles.text3,'string',za)
record(y);
set(handles.text3,'string','Now Recording...PLease speak into mic')        
handles.data=y;
guidata(handles.togglebutton1,handles)

% --------------------------------------------------------------------
function Untitled_8_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

y=handles.data;
stop(y);
set(handles.text3,'string','Recording Stopped')
pd=getaudiodata(y,'int16');
%      t=0:0.001;100;
plot(pd,'k')
grid on;
%     axis([0 10])
xlabel('Time (Second)');
ylabel('Gain (Decibel)');
    
% --------------------------------------------------------------------
function Untitled_9_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
y=handles.data;
pause(y);
set(handles.text3,'string','Recording Paused')

% --------------------------------------------------------------------
function Untitled_10_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

y=handles.data;
resume(y);
set(handles.text3,'string','Recording Resumed')

% --------------------------------------------------------------------
function Untitled_11_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_12_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

open heelp.txt

% --------------------------------------------------------------------
function Untitled_13_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function Untitled_16_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sure
