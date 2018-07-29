function varargout = GUI_exp4_new(varargin)
% GUI_EXP4_NEW M-file for GUI_exp4_new.fig
%      GUI_EXP4_NEW, by itself, creates a new GUI_EXP4_NEW or raises the existing
%      singleton*.
%      H = GUI_EXP4_NEW returns the handle to a new GUI_EXP4_NEW or the handle to
%      the existing singleton*.
%      GUI_EXP4_NEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_EXP4_NEW.M with the given input arguments.
%      GUI_EXP4_NEW('Property','Value',...) creates a new GUI_EXP4_NEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_exp4_new_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_exp4_new_OpeningFcn via varargin.
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
% Edit the above text to modify the response to help GUI_exp4_new

% Created by Ankitkumar Chheda (ankitkumar.chheda@gmail.com)
% Last edited on 4 Nov., 2012 07:07 pm

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_exp4_new_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_exp4_new_OutputFcn, ...
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
% --- Executes just before GUI_exp4_new is made visible.
function GUI_exp4_new_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_exp4_new (see VARARGIN)

% Choose default command line output for GUI_exp4_new
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = GUI_exp4_new_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in fadein.
function fadein_Callback(hObject, eventdata, handles)
% hObject    handle to fadein (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	temp = inputdlg('Fade Length (in sec)');
    FADE_LEN = str2double(temp);
    Fs = handles.Fs;
    sig = handles.x;
    fade_samples = round(FADE_LEN.*Fs); % figure out how many samples fade is over
    fade_scale = linspace(0,1,fade_samples)'; % create fade
    time = 0:1/Fs:(length(handles.x)-1)/Fs;
    if FADE_LEN > time
        msgbox('Invalid Entry! Fade Length is much greater','ERROR');
        return;
    end
    fade_in = sig;
    fade_in(1:fade_samples) = sig(1:fade_samples).*fade_scale; % apply fade_in
    handles.m = fade_in;
	axes(handles.axes3);
    plot(time,handles.m);
    title('Fade-In Signal');
    axes(handles.axes4);
    specgram(handles.m, 1024, handles.Fs);
    title('Spectrogram of Fade-In Signal');
guidata(hObject,handles);
        
% --- Executes on button press in fadeout.
function fadeout_Callback(hObject, eventdata, handles)
% hObject    handle to fadeout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    temp = inputdlg('Fade Length (in sec)');
    FADE_LEN = str2double(temp);
    Fs = handles.Fs;
    sig = handles.x;
    fade_samples = round(FADE_LEN.*Fs); % figure out how many samples fade is over
    fade_scale = linspace(0,1,fade_samples)'; % create fade
    time = 0:1/Fs:(length(handles.x)-1)/Fs;
    if FADE_LEN > time
        msgbox('Invalid Entry! Fade Length is much greater','ERROR');
        return;
    end
    fade_out = sig;
    fade_out(end-fade_samples+1:end) = sig(end-fade_samples+1:end).*fade_scale(end:-1:1);
    handles.m = fade_out;
	axes(handles.axes3);
    plot(time,handles.m);
    title('Fade-Out Signal');
    axes(handles.axes4);
    specgram(handles.m, 1024, handles.Fs);
    title('Spectrogram of Fade-Out Signal');
guidata(hObject,handles);


% --- Executes on button press in compression.
function compression_Callback(hObject, eventdata, handles)
% hObject    handle to compression (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    x = handles.x;
    Fs = handles.Fs;
    maxm = max(max(abs(x)));
    sig = x ./ maxm;
    handles.m = sig;
	axes(handles.axes3);
    time = 0:1/Fs:(length(handles.x)-1)/Fs;
    plot(time,handles.m);
    title('Compressed Signal');
    axes(handles.axes4);
    specgram(handles.m, 1024, handles.Fs);
    title('Spectrogram of Compressed Signal');
guidata(hObject,handles);

% --- Executes on button press in ampliifcation.
function ampliifcation_Callback(hObject, eventdata, handles)
% hObject    handle to ampliifcation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    x = handles.x;
    Fs = handles.Fs;
    maxm = max(max(abs(x)));
    sig = x .* maxm;
    handles.m = sig;
	axes(handles.axes3);
    time = 0:1/Fs:(length(handles.x)-1)/Fs;
    plot(time,handles.m);
    title('Amplified Signal');
    axes(handles.axes4);
    specgram(handles.m, 1024, handles.Fs);
    title('Spectrogram of Amplified Signal');
guidata(hObject,handles);

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

% --- Executes on button press in load_file.
function load_file_Callback(hObject, eventdata, handles)
% hObject    handle to load_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clc;
    [FileName,PathName] = uigetfile({'*.wav'},'Load Wav File');
    [x,Fs] = wavread([PathName '/' FileName]);
    handles.x = x;
    handles.m = x;
    handles.Fs = Fs;
    axes(handles.axes1);
    time = 0:1/Fs:(length(handles.x)-1)/Fs;
    plot(time,handles.x);
    title('Original Signal');
    axes(handles.axes2);
    specgram(handles.x, 1024, handles.Fs);
    title('Spectrogram of Original Signal');
guidata(hObject,handles);

% --- Executes on button press in randomfile.
function randomfile_Callback(hObject, eventdata, handles)
% hObject    handle to randomfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clc;
    Fs = 8200;
    x = randn(5*Fs,1);
	handles.x = x;
    handles.Fs = Fs;
    axes(handles.axes1);
    time = 0:1/Fs:(length(handles.x)-1)/Fs;
    plot(time,handles.x);
    title('Original Signal');
    axes(handles.axes2);
    specgram(handles.x, 1024, handles.Fs);
    title('Spectrogram of Original Signal');
guidata(hObject, handles);

% --- Executes on button press in play_orig.
function play_orig_Callback(hObject, eventdata, handles)
% hObject    handle to play_orig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sound(handles.x, handles.Fs);

% --- Executes on button press in play_proc.
function play_proc_Callback(hObject, eventdata, handles)
% hObject    handle to play_proc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sound(handles.m, handles.Fs);

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile('*.wav', 'Pick an M-file');
cd (pathname);
wavwrite(handles.m,handles.Fs,filename);


