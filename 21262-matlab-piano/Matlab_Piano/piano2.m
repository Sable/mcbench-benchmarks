function varargout = piano2(varargin)
% PIANO2 M-file for piano2.fig
%      PIANO2, by itself, creates a new PIANO2 or raises the existing
%      singleton*.
%
%      H = PIANO2 returns the handle to a new PIANO2 or the handle to
%      the existing singleton*.
%
%      PIANO2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PIANO2.M with the given input arguments.
%
%      PIANO2('Property','Value',...) creates a new PIANO2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before piano2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to piano2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help piano2

% Last Modified by GUIDE v2.5 29-Aug-2008 11:01:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @piano2_OpeningFcn, ...
                   'gui_OutputFcn',  @piano2_OutputFcn, ...
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

% AUTHOR: MARK FRANKOSKY (MFRANKOSKY@GMAIL.COM)

% --- Executes just before piano2 is made visible.
function piano2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to piano2 (see VARARGIN)

% Choose default command line output for piano2
handles.output      = hObject;
handles.SampleRate  = 1/20000;
handles.SoundVector = 0;
handles.TimeValue   = 0.3488;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes piano2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = piano2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in GShparp3.
function GShparp3_Callback(hObject, eventdata, handles)
% hObject    handle to GShparp3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 207.65;
PlayNote(handles,freq);

% --- Executes on button press in ASharp3.
function ASharp3_Callback(hObject, eventdata, handles)
% hObject    handle to ASharp3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 233.08;
PlayNote(handles,freq);

% --- Executes on button press in FSharp5.
function FSharp5_Callback(hObject, eventdata, handles)
% hObject    handle to FSharp5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 739.99;
PlayNote(handles,freq);

% --- Executes on button press in FSharp3.
function FSharp3_Callback(hObject, eventdata, handles)
% hObject    handle to FSharp3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 185.00;
PlayNote(handles,freq);

% --- Executes on button press in ASharp4.
function ASharp4_Callback(hObject, eventdata, handles)
% hObject    handle to ASharp4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 466.16;
PlayNote(handles,freq);

% --- Executes on button press in DSharp5.
function DSharp5_Callback(hObject, eventdata, handles)
% hObject    handle to DSharp5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 622.25;
PlayNote(handles,freq);

% --- Executes on button press in CSharp5.
function CSharp5_Callback(hObject, eventdata, handles)
% hObject    handle to CSharp5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 554.37;
PlayNote(handles,freq);

% --- Executes on button press in GSharp4.
function GSharp4_Callback(hObject, eventdata, handles)
% hObject    handle to GSharp4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 415.3;
PlayNote(handles,freq);

% --- Executes on button press in CSharp4.
function CSharp4_Callback(hObject, eventdata, handles)
% hObject    handle to CSharp4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 277.18;
PlayNote(handles,freq);

% --- Executes on button press in G3.
function G3_Callback(hObject, eventdata, handles)
% hObject    handle to G3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 196;
PlayNote(handles,freq);

% --- Executes on button press in A3.
function A3_Callback(hObject, eventdata, handles)
% hObject    handle to A3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 220;
PlayNote(handles,freq);

% --- Executes on button press in B3.
function B3_Callback(hObject, eventdata, handles)
% hObject    handle to B3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 246.94;
PlayNote(handles,freq);

% --- Executes on button press in C4.
function C4_Callback(hObject, eventdata, handles)
% hObject    handle to C4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


freq = 261.625;
PlayNote(handles,freq);

% --- Executes on button press in D4.
function D4_Callback(hObject, eventdata, handles)
% hObject    handle to D4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 293.66;
PlayNote(handles,freq);

% --- Executes on button press in E4.
function E4_Callback(hObject, eventdata, handles)
% hObject    handle to E4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 329.63;
PlayNote(handles,freq);

% --- Executes on button press in F4.
function F4_Callback(hObject, eventdata, handles)
% hObject    handle to F4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 349.23;
PlayNote(handles,freq);

% --- Executes on button press in G4.
function G4_Callback(hObject, eventdata, handles)
% hObject    handle to G4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 392;
PlayNote(handles,freq);

% --- Executes on button press in A4.
function A4_Callback(hObject, eventdata, handles)
% hObject    handle to A4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 440;
PlayNote(handles,freq);

% --- Executes on button press in B4.
function B4_Callback(hObject, eventdata, handles)
% hObject    handle to B4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 493.88;
PlayNote(handles,freq);

% --- Executes on button press in C5.
function C5_Callback(hObject, eventdata, handles)
% hObject    handle to C5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 523.25;
PlayNote(handles,freq);

% --- Executes on button press in D5.
function D5_Callback(hObject, eventdata, handles)
% hObject    handle to D5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 587.33;
PlayNote(handles,freq);

% --- Executes on button press in E5.
function E5_Callback(hObject, eventdata, handles)
% hObject    handle to E5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 659.26;
PlayNote(handles,freq);

% --- Executes on button press in F5.
function F5_Callback(hObject, eventdata, handles)
% hObject    handle to F5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 698.46;
PlayNote(handles,freq);

% --- Executes on button press in FSharp4.
function FSharp4_Callback(hObject, eventdata, handles)
% hObject    handle to FSharp4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 369.99;
PlayNote(handles,freq);

% --- Executes on button press in DSharp4.
function DSharp4_Callback(hObject, eventdata, handles)
% hObject    handle to DSharp4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 311.13;
PlayNote(handles,freq);

% --- Executes on button press in G5.
function G5_Callback(hObject, eventdata, handles)
% hObject    handle to G5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 783.99;
PlayNote(handles,freq);

% --- Executes on button press in F3.
function F3_Callback(hObject, eventdata, handles)
% hObject    handle to F3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 174.61;
PlayNote(handles,freq);

% --- Executes on button press in E3.
function E3_Callback(hObject, eventdata, handles)
% hObject    handle to E3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 164.81;
PlayNote(handles,freq);

% --- Executes on button press in D3.
function D3_Callback(hObject, eventdata, handles)
% hObject    handle to D3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 146.83;
PlayNote(handles,freq);

% --- Executes on button press in A5.
function A5_Callback(hObject, eventdata, handles)
% hObject    handle to A5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 880;
PlayNote(handles,freq);

% --- Executes on button press in C3.
function C3_Callback(hObject, eventdata, handles)
% hObject    handle to C3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 130.81;
PlayNote(handles,freq);

% --- Executes on button press in B5.
function B5_Callback(hObject, eventdata, handles)
% hObject    handle to B5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 987.77;
PlayNote(handles,freq);

% --- Executes on button press in GSharp5.
function GSharp5_Callback(hObject, eventdata, handles)
% hObject    handle to GSharp5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 830.61;
PlayNote(handles,freq);

% --- Executes on button press in ASharp5.
function ASharp5_Callback(hObject, eventdata, handles)
% hObject    handle to ASharp5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 932.33;
PlayNote(handles,freq);

% --- Executes on button press in DSharp3.
function DSharp3_Callback(hObject, eventdata, handles)
% hObject    handle to DSharp3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 155.56;
PlayNote(handles,freq);

% --- Executes on button press in CSharp3.
function CSharp3_Callback(hObject, eventdata, handles)
% hObject    handle to CSharp3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

freq = 138.59;
PlayNote(handles,freq);

function PlayNote(handles,freq)
% plays the note that was pressed for 1 second
% also sets the frequency value on GUI for last played note.

strFreq = num2str(freq);
set(handles.STFreqValue, 'String', strFreq);

SampleRate  = handles.SampleRate;
TimeValue   = handles.TimeValue;
Samples     = 0:SampleRate:TimeValue;
SinOn       = get(handles.SinWave, 'Value');
SquareOn    = get(handles.SquareWave, 'Value');
SawtoothOn  = get(handles.SawtoothWave, 'Value');

if SinOn == 1
  soundVector = sin(2*pi*freq*Samples);
elseif SquareOn == 1
  soundVector = square(2*pi*freq*Samples);
elseif SawtoothOn == 1
  soundVector = sawtooth(2*pi*freq*Samples);
end

sound(soundVector, 1/SampleRate)

RecordOn = get(handles.Record, 'Value');

if RecordOn == 1
  SoundVectorLong = handles.SoundVector;
  if SoundVectorLong == 0
    SoundVectorLong = soundVector;
  else
    SoundVectorLong = cat(2, SoundVectorLong, soundVector);
  end
  handles.SoundVector = SoundVectorLong;
  guidata(handles.figure1, handles);  
end

% --- Executes on button press in Play.
function Play_Callback(hObject, eventdata, handles)
% hObject    handle to Play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

SoundVector   = handles.SoundVector;
SampleRate    = handles.SampleRate;

sound(SoundVector, 1/SampleRate)
 
% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.SoundVector = 0;
guidata(handles.figure1, handles);

function Time_Callback(hObject, eventdata, handles)
% hObject    handle to Time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Time as text
%        str2double(get(hObject,'String')) returns contents of Time as a double

Value     = str2double(get(hObject, 'String'));
TimeValue = 60/Value;

half    = get(handles.HalfNote, 'Value');
Whole   = get(handles.WholeNote, 'Value');
Eighth  = get(handles.EighthNote, 'Value');

if half == 1
    TimeValue = TimeValue * 2;
elseif Whole == 1
    TimeValue = TimeValue * 4;
elseif Eighth == 1
    TimeValue = TimeValue / 2;
end

handles.TimeValue = TimeValue;
guidata(handles.figure1, handles);

% --- Executes on button press in QuarterNote.
function QuarterNote_Callback(hObject, eventdata, handles)
% hObject    handle to QuarterNote (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.QuarterNote, 'Value', 1);
set(handles.HalfNote, 'Value', 0);
set(handles.EighthNote, 'Value', 0);
set(handles.WholeNote, 'Value', 0);

Value     = str2double(get(handles.Time, 'String'));
TimeValue = 60/Value;

handles.TimeValue = TimeValue;
guidata(handles.figure1, handles);


% --- Executes on button press in HalfNote.
function HalfNote_Callback(hObject, eventdata, handles)
% hObject    handle to HalfNote (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.QuarterNote, 'Value', 0);
set(handles.HalfNote, 'Value', 1);
set(handles.EighthNote, 'Value', 0);
set(handles.WholeNote, 'Value', 0);

Value     = str2double(get(handles.Time, 'String'));
TimeValue = 60/Value * 2;

handles.TimeValue = TimeValue;
guidata(handles.figure1, handles);

% --- Executes on button press in EighthNote.
function EighthNote_Callback(hObject, eventdata, handles)
% hObject    handle to EighthNote (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.QuarterNote, 'Value', 0);
set(handles.HalfNote, 'Value', 0);
set(handles.EighthNote, 'Value', 1);
set(handles.WholeNote, 'Value', 0);

Value     = str2double(get(handles.Time, 'String'));
TimeValue = (60/Value) / 2;

handles.TimeValue = TimeValue;
guidata(handles.figure1, handles);

% --- Executes on button press in WholeNote.
function WholeNote_Callback(hObject, eventdata, handles)
% hObject    handle to WholeNote (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.QuarterNote, 'Value', 0);
set(handles.HalfNote, 'Value', 0);
set(handles.EighthNote, 'Value', 0);
set(handles.WholeNote, 'Value', 1);

Value     = str2double(get(handles.Time, 'String'));
TimeValue = 60/Value * 4;

handles.TimeValue = TimeValue;
guidata(handles.figure1, handles);

% --- Executes during object creation, after setting all properties.
function QuarterNote_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QuarterNote (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject, 'Value', 1);

% --- Executes on button press in OutToWav.
function OutToWav_Callback(hObject, eventdata, handles)
% hObject    handle to OutToWav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

SoundVector     = handles.SoundVector;
SampleRate      = handles.SampleRate;

if SoundVector == 0
    return;
else
  Filename = get(handles.Filename, 'String');
  wavwrite(SoundVector, 1/SampleRate, 32, Filename);
end


% --- Executes on button press in SinWave.
function SinWave_Callback(hObject, eventdata, handles)
% hObject    handle to SinWave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SinWave

set(handles.SinWave, 'Value', 1);
set(handles.SquareWave, 'Value', 0);
set(handles.SawtoothWave, 'Value', 0);


% --- Executes during object creation, after setting all properties.
function SinWave_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SinWave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject, 'Value', 1);


% --- Executes on button press in SquareWave.
function SquareWave_Callback(hObject, eventdata, handles)
% hObject    handle to SquareWave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SquareWave

set(handles.SinWave, 'Value', 0);
set(handles.SquareWave, 'Value', 1);
set(handles.SawtoothWave, 'Value', 0);

% --- Executes on button press in SawtoothWave.
function SawtoothWave_Callback(hObject, eventdata, handles)
% hObject    handle to SawtoothWave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SawtoothWave

set(handles.SinWave, 'Value', 0);
set(handles.SquareWave, 'Value', 0);
set(handles.SawtoothWave, 'Value', 1);


