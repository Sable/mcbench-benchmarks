function varargout = simplelpcgui(varargin)
% SIMPLELPCGUI M-file for simplelpcgui.fig
%      SIMPLELPCGUI, by itself, creates a new SIMPLELPCGUI or raises the existing
%      singleton*.
%
%      H = SIMPLELPCGUI returns the handle to a new SIMPLELPCGUI or the handle to
%      the existing singleton*.
%
%      SIMPLELPCGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMPLELPCGUI.M with the given input arguments.
%
%      SIMPLELPCGUI('Property','Value',...) creates a new SIMPLELPCGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simplelpcgui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simplelpcgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simplelpcgui

% Last Modified by GUIDE v2.5 30-Jul-2003 22:36:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simplelpcgui_OpeningFcn, ...
                   'gui_OutputFcn',  @simplelpcgui_OutputFcn, ...
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


% --- Executes just before simplelpcgui is made visible.
function simplelpcgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simplelpcgui (see VARARGIN)

% Choose default command line output for simplelpcgui
handles.output = hObject;
handles.pointer_switch=1;
handles.filecnt=1;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simplelpcgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simplelpcgui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;


% --- Executes on button press in pbLoad.
function pbLoad_Callback(hObject, eventdata, handles)
% hObject    handle to pbLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Load speech data 
temp = cd;
[filename, pathname] = uigetfile('*.mat'); 
S = load([pathname filename]);
cd(temp);
axes(handles.axes1);
plot(S.data);
xlabel('Time(t)','fontsize',12);
ylabel('Amplitude','fontsize',12);
dualcursor;
handles.data=S.data;
handles.Fs=8000;
N=256;
data2=zeros(N,1);
data2(1)=S.data(1);
data2=S.data(2:end)-0.95*S.data(1:end-1);
handles.data2=data2;

guidata(hObject,handles);




% --- Executes during object creation, after setting all properties.
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


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pbFormants.
function pbFormants_Callback(hObject, eventdata, handles)
% hObject    handle to pbFormants (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1);
val=dualcursor;
axes(handles.axes2);
pointer_switch=handles.pointer_switch;
%pointer_switch = str2num(pointer_switch);
if pointer_switch==2
    pointer_switch=3;
end

% Plotting LPC Spectrum

if get(handles.checkbox2,'value')==1
data=handles.data2;
else
data=handles.data;
end


Fs=handles.Fs;
N=256;
p=8;
x=data([val(pointer_switch)-(N/2-1)]:val(pointer_switch)+N/2);
a = lpc(x,p);
f = Fs*(0:N/2)/N;
h=(1./ fft([a zeros(1,N-(p+1))])).';
plot(f,abs(h(1:N/2+1)))
xlabel('Frequency(Hz)','fontsize',12);
ylabel('Amplitude','fontsize',12);

% Calculating Formants
roots_a=roots(a);
formants_a=angle(roots_a)/(2*pi)*8000;
a_sorted = sort(abs(formants_a));

% Displaying Data
set(handles.edit1,'string',num2str(a_sorted(2)));
set(handles.edit2,'string',num2str(a_sorted(4)));
set(handles.edit3,'string',num2str(a_sorted(6)));

fm = [a_sorted(2) a_sorted(4) a_sorted(6)];
handles.fm=fm;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

pointer_switch = get(hObject,'value');
handles.pointer_switch=pointer_switch;
guidata(hObject,handles);



% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2

function pbRecord_Callback(hObject, eventdata, handles)

AI = analoginput('winsound');
chan = addchannel(AI,1);
duration = 1; %1 second acquisition
set(AI,'SampleRate',8000);
ActualRate = get(AI,'SampleRate');
set(AI,'SamplesPerTrigger',duration*ActualRate);
set(AI,'TriggerType','Manual');
blocksize = get(AI,'SamplesPerTrigger');
S.Fs = ActualRate;
t=linspace(0,duration,duration*ActualRate);
start(AI);
trigger(AI);
S.data = getdata(AI);
delete(AI);
clear AI;

axes(handles.axes1);
plot(S.data);
xlabel('Time(t)','fontsize',12);
ylabel('Amplitude','fontsize',12);

dualcursor;
handles.data=S.data;
handles.Fs=S.Fs;
N=256;
data2=zeros(N,1);
data2(1)=S.data(1);
data2=S.data(2:end)-0.95*S.data(1:end-1);
handles.data2=data2;

guidata(hObject,handles);



% --- Executes on button press in pbFFT.
function pbFFT_Callback(hObject, eventdata, handles)
% hObject    handle to pbFFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


axes(handles.axes1);
val=dualcursor;
axes(handles.axes2);
pointer_switch=handles.pointer_switch;
%pointer_switch = str2num(pointer_switch);
if pointer_switch==2
    pointer_switch=3;
end

% Plotting LPC Spectrum

if get(handles.checkbox2,'value')==1
data=handles.data2;
else
data=handles.data;
end


Fs=handles.Fs;
N=256;
x=data([val(pointer_switch)-(N/2-1)]:val(pointer_switch)+N/2);
a = fft(x,N);
f = Fs*(0:N/2)/N;
plot(f,abs(a(1:N/2+1)));
xlabel('Frequency(Hz)','fontsize',12);
ylabel('Amplitude','fontsize',12);



% Displaying Data
set(handles.edit1,'string','N/A');
set(handles.edit2,'string','N/A');


% --- Executes on button press in pbExport.
function pbExport_Callback(hObject, eventdata, handles)
% hObject    handle to pbExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filecnt=handles.filecnt;
cdata=handles.fm'/4000;
if filecnt == 1
    fdata=cdata;
    save fdata.mat fdata;
else
    load fdata;
    fdata = [fdata cdata];
    save fdata.mat fdata;
end
filecnt=filecnt+1;
handles.filecnt=filecnt;
guidata(hObject,handles);