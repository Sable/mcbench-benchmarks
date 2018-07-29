% This is a GUI for Filtering. The user has an option to choose either
% his/her voice signal for 5 complete seconds or a loaded signal on 
% his/her system. The loaded signal needs to be a .wav format. I have 
% employed Additive White Gaussian Noise (AWGN) and the filtering for the
% same is provided using a Butterworth and Chebychev filtering. A sample 
% .wav file has been provided to the user.If you have any questions or
% comments please get back to me. I will return at the earliest. 
% Author - Vijay Sridharan. 
% Date   - 26/1/2012

%% Short Note on running the file
% 1) Click on "load a sound file"(Radio Button) and hit load the sound
% file(push button).
% 2) Click on "play original" to listen to the loaded file. 
% 3) Click on "Add noise" to add a AWGN noise. 
% 4) Filter the noisy signal using either Butterworth/Chebychev Filter. 
% 5) See the waveform of the signal using the Plot signal. 

% Alternately you can follow the same procedure with your voice signal by
% clicking on "Speak into Mike".

function varargout = proj_filtering(varargin)
% PROJ_FILTERING MATLAB code for proj_filtering.fig
%      PROJ_FILTERING, by itself, creates a new PROJ_FILTERING or raises the existing
%      singleton*.
%
%      H = PROJ_FILTERING returns the handle to a new PROJ_FILTERING or the handle to
%      the existing singleton*.
%
%      PROJ_FILTERING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJ_FILTERING.M with the given input arguments.
%
%      PROJ_FILTERING('Property','Value',...) creates a new PROJ_FILTERING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before proj_filtering_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to proj_filtering_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help proj_filtering

% Last Modified by GUIDE v2.5 26-Jan-2012 05:51:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @proj_filtering_OpeningFcn, ...
                   'gui_OutputFcn',  @proj_filtering_OutputFcn, ...
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
end

% --- Executes just before proj_filtering is made visible.
function proj_filtering_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to proj_filtering (see VARARGIN)

% Choose default command line output for proj_filtering
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes proj_filtering wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = proj_filtering_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
set(handles.speak_into_mike,'Value',0);
set(handles.load_sound_file,'Value',0);
end



% --- Executes on button press in speak_into_mike.
function speak_into_mike_Callback(hObject, eventdata, handles)
% hObject    handle to speak_into_mike (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of speak_into_mike
 set(handles.speak_into_mike,'Value',1)
 set(handles.load_sound_file,'Value',0)
 set(handles.speak,'Visible','on');
 set(handles.sound_file,'Visible','off');
end


% --- Executes on button press in load_sound_file.
function load_sound_file_Callback(hObject, eventdata, handles)
% hObject    handle to load_sound_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of load_sound_file
   set(handles.load_sound_file,'Value',1)
   set(handles.speak_into_mike,'Value',0)
   set(handles.sound_file,'Visible','on');
   set(handles.speak,'Visible','off');  
end


% --- Executes on button press in speak.
function speak_Callback(hObject, eventdata, handles)
% hObject    handle to speak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
r = audiorecorder(22050, 16, 1);
 disp('speak for 5 seconds'); % Make sure you hit play Original only after 5 seconds.
 handles.r=r;
recordblocking(r,5);
myspeech=getaudiodata(r,'double');
 freq=22100;
 wavwrite(double(myspeech),freq,'myvoice.wav');
 original_sound=wavread('myvoice.wav');
 handles.original_sound=original_sound;
 guidata(hObject,handles);
end


% --- Executes on button press in sound_file.
function sound_file_Callback(hObject, eventdata, handles)
% hObject    handle to sound_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 [filename,pathname]=uigetfile('*.wav','Select an image File');
 [input_song,freq]=wavread(fullfile(pathname,filename));
 wavwrite(double(input_song),freq,'song.wav');
 original_sound=wavread('song.wav');
 handles.original_sound=original_sound;
 guidata(hObject,handles);
end


% --- Executes on button press in play_original.
function play_original_Callback(hObject, eventdata, handles)
% hObject    handle to play_original (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
freq=22100;
original_sound=handles.original_sound;      
%handles.original_sound=original_sound;
 sound(original_sound,freq)
%[sizea,sizeb]=size(original_sound);
%noise=randn(sizea,sizeb);  
%adding_noise=original_sound+noise;
handles.freq=freq;
guidata(hObject,handles);
end


% --- Executes on button press in add_noise.
function add_noise_Callback(hObject, eventdata, handles)
% hObject    handle to add_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
original_sound=handles.original_sound;      
adding_noise=awgn(original_sound,10,'measured');
freq=22100;
sound(adding_noise,freq);
 wavwrite(double(adding_noise),freq,'noisy.wav');
 noisy_signal=wavread('noisy.wav');
 handles.noisy_signal=noisy_signal;
 guidata(hObject,handles);
end



% --- Executes on button press in butterworth.
function butterworth_Callback(hObject, eventdata, handles)
% hObject    handle to butterworth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
freq=22100;
freq=handles.freq;
noisy_signal=handles.noisy_signal;
[b,a] = butter(5,0.9, 'low');
 butterworth_filtered_signal= filtfilt(b, a, noisy_signal);
 handles.butterworth_filtered_signal=butterworth_filtered_signal;
sound(butterworth_filtered_signal,freq);
guidata(hObject,handles);
end


% --- Executes on button press in Chebychev.
function Chebychev_Callback(hObject, eventdata, handles)
% hObject    handle to Chebychev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
freq=22100;
freq=handles.freq;
noisy_signal=handles.noisy_signal;
[b,a] = cheby2(5,20,0.9, 'low');
chebchev_filtered_signal = filtfilt(b, a, noisy_signal);
sound(chebchev_filtered_signal,freq);
handles.chebchev_filtered_signal=chebchev_filtered_signal;
guidata(hObject,handles);
end


% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;
clc;
end


% --- Executes on button press in chebychev_plot.
function chebychev_plot_Callback(hObject, eventdata, handles)
% hObject    handle to chebychev_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
chebchev_filtered_signal=handles.chebchev_filtered_signal;
original_sound=handles.original_sound;
figure(1)
subplot(211),plot(original_sound),title('Original Sound Plot');
subplot(212),plot(chebchev_filtered_signal),title('Chebychev Filtered Signal');
end

% --- Executes on button press in butterworth_plot.
function butterworth_plot_Callback(hObject, eventdata, handles)
% hObject    handle to butterworth_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
butterworth_filtered_signal=handles.butterworth_filtered_signal;
original_sound=handles.original_sound;
figure(2)
subplot(211),plot(original_sound),title('Original Sound Plot');
subplot(212),plot(butterworth_filtered_signal),title('Butterworth Filtered Signal');
end
