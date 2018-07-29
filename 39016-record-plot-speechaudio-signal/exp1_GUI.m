function varargout = exp1_GUI(varargin)
% exp1_GUI M-file for exp1_GUI.fig
%      exp1_GUI, by itself, creates a new exp1_GUI or raises the existing
%      singleton*.
%
%      H = exp1_GUI returns the handle to a new exp1_GUI or the handle to
%      the existing singleton*.
%
%      exp1_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in exp1_GUI.M with the given input arguments.
%
%      exp1_GUI('Property','Value',...) creates a new exp1_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before exp1_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to exp1_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help exp1_GUI

% Last Modified by GUIDE v2.5 04-Nov-2012 23:21:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @exp1_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @exp1_GUI_OutputFcn, ...
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


% --- Executes just before exp1_GUI is made visible.
function exp1_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to exp1_GUI (see VARARGIN)

% Choose default command line output for exp1_GUI
handles.output = hObject;

handles.FSQ = (get(handles.slider2,'Value'));
set(handles.edit1, 'String', [num2str(handles.FSQ) ''] );

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes exp1_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = exp1_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fs = handles.fs*(1 + handles.FSQ);
sound(handles.x, fs);


% --- Executes on button press in formant_freq.
function formant_freq_Callback(hObject, eventdata, handles)
% hObject    handle to formant_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    h = spectrum.welch;
    hs = psd(h,handles.x,'fs',handles.fs);
    figure;
plot(hs);


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cl = questdlg('Do you want to EXIT?','EXIT',...
            'Yes','No','No');
switch cl
    case 'Yes'
        close();
        clear all;
        return;
    case 'No'
        quit cancel;
end 

% --- Executes on button press in record.
function record_Callback(hObject, eventdata, handles)
% hObject    handle to record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %uiwait(gcf);
    fs = 44100;
    y = wavrecord(88200,fs);
    [filename, pathname] = uiputfile('*.wav', 'Pick an M-file');
    cd (pathname);
    wavwrite(y,fs,filename);
    sound(y,fs);
    handles.x = y;
    handles.fs = fs;
    axes(handles.axes1);
    time = 0:1/fs:(length(handles.x)-1)/fs;
    plot(time,handles.x);
    title('Original Signal');
    axes(handles.axes2);
    specgram(handles.x, 1024, handles.fs);
    title('Spectrogram of Original Signal');
guidata(hObject, handles);


% --- Executes on button press in load_file.
function load_file_Callback(hObject, eventdata, handles)
% hObject    handle to load_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clc;
    [FileName,PathName] = uigetfile({'*.wav'},'Load Wav File');
    [x,fs] = wavread([PathName '/' FileName]);
    handles.x = x;
    handles.fs = fs;
    axes(handles.axes1);
    time = 0:1/fs:(length(handles.x)-1)/fs;
    plot(time,handles.x);
    title('Original Signal');
    axes(handles.axes2);
    specgram(handles.x, 1024, handles.fs);
    title('Spectrogram of Original Signal');
guidata(hObject,handles);


% --- Executes on button press in load_random.
function load_random_Callback(hObject, eventdata, handles)
% hObject    handle to load_random (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
    fs = 8200;
    x = randn(5*fs,1);
	handles.x = x;
    handles.fs = fs;
    axes(handles.axes1);
    time = 0:1/fs:(length(handles.x)-1)/fs;
    plot(time,handles.x);
    title('Original Signal');
    axes(handles.axes2);
    specgram(handles.x, 1024, handles.fs);
    title('Spectrogram of Original Signal');
guidata(hObject, handles);


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.FSQ = (get(hObject,'Value'));
    set(handles.edit1, 'String', [sprintf('%.1f',handles.FSQ) ''] );
guidata(hObject, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



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


