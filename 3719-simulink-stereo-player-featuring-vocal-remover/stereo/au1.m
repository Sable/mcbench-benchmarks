function varargout = au1(varargin)
% AU1 M-file for au1.fig
%      AU1, by itself, creates a new AU1 or raises the existing
%      singleton*.
%
%      H = AU1 returns the handle to a new AU1 or the handle to
%      the existing singleton*.
%
%      AU1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AU1.M with the given input arguments.
%
%      AU1('Property','Value',...) creates a new AU1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before au1_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to au1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help au1

% Last Modified by GUIDE v2.5 14-Jul-2003 04:03:23

% Begin initialization code - DO NOT EDIT



%******************************************************************************************



% 'au_dio_equal_mod' is a simulink based "Stereo Player" . This Simulink  model has got many featues .
% One of the new featues is the Vocal remover that cuts the vocal in a song leaving only the background music . 
% The vocals are not completely removed in most cases, but they are low enough that you usually can barely hear them i.e 
% it can supress the vocals . For certain styles of music you might end up
% removing more than the vocals..
% 
% The "Stereo Player" model can only play .wav files . It requies a .wav file of 44100 Hz /2 ch /16 b (stereo input). The .wav file that 
% you will be using must be there in your current working directory .. 
% The simulink model works in the backend , front end being the GUI made by using GUIDE
% 
% Apart from these the model has got many sound effects modeled as subsystems . The following effects are there in the model :: 
% 
% - Equalizer (In order to use the Equalizer press activate equalizer button and then use the sliders to listen to ur kind of frequency range)
% -Reverberation
% -Flanging
% -Surround Effect
% -Balance(Left and Right)
% -Chorus
% -Treble 
% -Bass Booster
% -Echo 
% -Reverb-Flang (A combination of reverberation and Flanging)


% Press "Start" Pushbutton to start the song 
% Press "Pause" Pushbutton to pause the song 
% Press "continue" Pushbutton to continue the song after the pause 
% Press "Stop" Pushbutton to stop the song 
% Press "Exit" Pushbutton to exit the GUI 

% Press "Original"  Pushbutton to play the original song (with out any effect)
% Press "Activate Equalizer "  Pushbutton to activate the equalizer and then use the sliders to listen to your range of frequency. 
% Press "Reverberation" Pushbutton to have reverberation   effect in the song.
% Press "Flanging" Pushbutton to have flanging  effect in the song.
% Press "Surround Effect" Pushbutton to have surround effect in the song.
% Press "Chorus" Pushbutton to have chorus  effect in the song.
% Press "Echo"  Pushbutton to have echo  effect in the song.
% Press "Vocal remover" Pushbutton to remove vocals from the song.
% Press "Bass-Booster" Pushbutton to boost the bass effect in the song.
% Press "Treble" Pushbutton to boost the treble  effect in the song.
% Press "Balance Left"Pushbutton to have left speaker balance.
% Press "Balance Right"Pushbutton to have right speaker balance.
% Press "Reverb-Flang" Pushbutton to have a combination of reverberation and flanging effect in the song.
% Enter the song name in the edit box which you want to play .Note: The
% song should be of .wav file and must be there in the current working
% directory

% 60Hz Slider passes frequency from 60 170 Hz
% 60Hz Slider passes frequency from 60 t0 170 Hz
% 170Hz Slider passes frequency from 170 t0 310 Hz Hz
% 310Hz Slider passes frequency from 310 t0 600 Hz
% 600Hz Slider passes frequency from 600 to 1000 Hz
% 1000Hz Slider passes frequency from 1000 to 3000 Hz
% 3000Hz Slider passes frequency from 3000 to 6000 Hz
% 60000Hz Slider passes frequency from 6000 to 12000 Hz
% 12000Hz Slider passes frequency from 12000 to 14000 Hz
% 14000Hz Slider passes frequency from 14000 to 16000 Hz
% 160000Hz Slider passes frequency from 16000 to 22000 Hz


% *******************************************************************************************************



gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @au1_OpeningFcn, ...
                   'gui_OutputFcn',  @au1_OutputFcn, ...
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


% --- Executes just before au1 is made visible.

function au1_OpeningFcn(hObject, eventdata, handles, varargin)

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to au1 (see VARARGIN)

% Choose default command line output for au1
handles.output = hObject;
set(gcf,'Color',[0 0 0]);
find_system('Name','au_dio_equal_mod');open_system('au_dio_equal_mod');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes au1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.

function varargout = au1_OutputFcn(hObject, eventdata, handles)

% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;


% --- Executes on button press in orig.

function orig_Callback(hObject, eventdata, handles)

% hObject    handle to orig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set_param('au_dio_equal_mod/Constant','Value','1');


% --- Executes on button press in act_eq.

function act_eq_Callback(hObject, eventdata, handles)
% hObject    handle to act_eq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set_param('au_dio_equal_mod/Constant','Value','2');

% --- Executes on button press in reverb.

function reverb_Callback(hObject, eventdata, handles)

% hObject    handle to reverb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set_param('au_dio_equal_mod/Constant','Value','3')

% --- Executes on button press in flang.

function flang_Callback(hObject, eventdata, handles)

% hObject    handle to flang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set_param('au_dio_equal_mod/Constant','Value','4')

% --- Executes on button press in surr_eff.

function surr_eff_Callback(hObject, eventdata, handles)

% hObject    handle to surr_eff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set_param('au_dio_equal_mod/Constant','Value','5')

% --- Executes on button press in chorus.

function chorus_Callback(hObject, eventdata, handles)

% hObject    handle to chorus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set_param('au_dio_equal_mod/Constant','Value','7')


% --- Executes on button press in e_cho.

function e_cho_Callback(hObject, eventdata, handles)

% hObject    handle to e_cho (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set_param('au_dio_equal_mod/Constant','Value','9')


% --- Executes during object creation, after setting all properties.

function freq1_CreateFcn(hObject, eventdata, handles)

% hObject    handle to freq1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.

function freq1_Callback(h, eventdata, handles)

% hObject    handle to freq1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

Newval=get(h,'Value');
set_param('au_dio_equal_mod/Gain','Gain',num2str(Newval));


% --- Executes during object creation, after setting all properties.

function freq2_CreateFcn(hObject, eventdata, handles)

% hObject    handle to freq2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.

function freq2_Callback(h, eventdata, handles)

% hObject    handle to freq2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Newval=get(h,'Value');
set_param('au_dio_equal_mod/Gain1','Gain',num2str(Newval));


% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.

function freq3_CreateFcn(hObject, eventdata, handles)

% hObject    handle to freq3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.

function freq3_Callback(h, eventdata, handles)

% hObject    handle to freq3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

Newval=get(h,'Value');
set_param('au_dio_equal_mod/Gain2','Gain',num2str(Newval));

% --- Executes during object creation, after setting all properties.

function freq4_CreateFcn(hObject, eventdata, handles)

% hObject    handle to freq4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.

usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.

function freq4_Callback(h, eventdata, handles)

% hObject    handle to freq4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

Newval=get(h,'Value');
set_param('au_dio_equal_mod/Gain3','Gain',num2str(Newval));


% --- Executes during object creation, after setting all properties.

function freq5_CreateFcn(hObject, eventdata, handles)

% hObject    handle to freq5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.

function freq5_Callback(h, eventdata, handles)

% hObject    handle to freq5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

Newval=get(h,'Value');
set_param('au_dio_equal_mod/Gain4','Gain',num2str(Newval));



% --- Executes during object creation, after setting all properties.

function db_g_CreateFcn(hObject, eventdata, handles)

% hObject    handle to db_g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.

usewhitebg = 1;

if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.

function db_g_Callback(h, eventdata, handles)

% hObject    handle to db_g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


Newval=get(h,'Value');
set_param('au_dio_equal_mod/dB Gain','dB',num2str(Newval));


% --- Executes during object creation, after setting all properties.

function vol_CreateFcn(hObject, eventdata, handles)

% hObject    handle to vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.

usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.

function vol_Callback(h, eventdata, handles)


% hObject    handle to vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


Newval=get(h,'Value');
set_param('au_dio_equal_mod/Constant1','Value',num2str(Newval));


% --- Executes on button press in vrem.

function vrem_Callback(hObject, eventdata, handles)

% hObject    handle to vrem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set_param('au_dio_equal_mod/Constant','Value','11')

% --- Executes on button press in bass_boost.

function bass_boost_Callback(hObject, eventdata, handles)

% hObject    handle to bass_boost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set_param('au_dio_equal_mod/Constant','Value','12')

% --- Executes on button press in treble.

function treble_Callback(hObject, eventdata, handles)

% hObject    handle to treble (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set_param('au_dio_equal_mod/Constant','Value','8')


% --- Executes on button press in balance_left.

function balance_left_Callback(hObject, eventdata, handles)

% hObject    handle to balance_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% h=get_param('au_dio_equal_mod/Constant','Value')
% set_patram('au_dio_equal_mod/Balance2/Const','Value',h)

set_param('au_dio_equal_mod/Constant','Value','6')
set_param('au_dio_equal_mod/Balance/Constant2','Value','1')
set_param('au_dio_equal_mod/Balance/Constant3','Value','0')


% --- Executes on button press in balance_right.

function balance_right_Callback(hObject, eventdata, handles)

% hObject    handle to balance_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


set_param('au_dio_equal_mod/Constant','Value','6')
set_param('au_dio_equal_mod/Balance/Constant2','Value','0')
set_param('au_dio_equal_mod/Balance/Constant3','Value','1')



% --- Executes on button press in reverb_flang.

function reverb_flang_Callback(hObject, eventdata, handles)

% hObject    handle to reverb_flang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set_param('au_dio_equal_mod/Constant','Value','10')

% --- Executes on button press in st_art.


function st_art_Callback(hObject, eventdata, handles)

% hObject    handle to st_art (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set_param(gcs,'SimulationCommand','Start')

% --- Executes on button press in pa_use.

function pa_use_Callback(hObject, eventdata, handles)

% hObject    handle to pa_use (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set_param(gcs,'SimulationCommand','Pause')


function conti_nue_Callback(hObject, eventdata, handles)

% hObject    handle to conti_nue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set_param(gcs,'SimulationCommand','Continue')


% --- Executes on button press in st_op.

function st_op_Callback(hObject, eventdata, handles)

% hObject    handle to st_op (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set_param(gcs,'SimulationCommand','Stop')

% --- Executes on button press in exi_t.

function exi_t_Callback(hObject, eventdata, handles)

% hObject    handle to exi_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close all



% --- Executes during object creation, after setting all properties.

function freq10_CreateFcn(hObject, eventdata, handles)

% hObject    handle to freq10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.

function freq10_Callback(h, eventdata, handles)

% hObject    handle to freq10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

Newval=get(h,'Value');
set_param('au_dio_equal_mod/Gain9','Gain',num2str(Newval));

% --- Executes during object creation, after setting all properties.

function freq11_CreateFcn(hObject, eventdata, handles)

% hObject    handle to freq11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.

function freq11_Callback(h, eventdata, handles)

% hObject    handle to freq11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

Newval=get(h,'Value');
set_param('au_dio_equal_mod/Gain10','Gain',num2str(Newval));


% --- Executes during object creation, after setting all properties.

function freq12_CreateFcn(hObject, eventdata, handles)

% hObject    handle to freq12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.

function freq12_Callback(h, eventdata, handles)

% hObject    handle to freq12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

Newval=get(h,'Value');
set_param('au_dio_equal_mod/Gain11','Gain',num2str(Newval));

% --- Executes during object creation, after setting all properties.

function freq13_CreateFcn(hObject, eventdata, handles)

% hObject    handle to freq13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.

function freq13_Callback(h, eventdata, handles)

% hObject    handle to freq13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

Newval=get(h,'Value');
set_param('au_dio_equal_mod/Gain12','Gain',num2str(Newval));


% --- Executes during object creation, after setting all properties.

function freq14_CreateFcn(hObject, eventdata, handles)

% hObject    handle to freq14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.

function freq14_Callback(h, eventdata, handles)

% hObject    handle to freq14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

Newval=get(h,'Value');
set_param('au_dio_equal_mod/Gain13','Gain',num2str(Newval));


% --- Executes during object creation, after setting all properties.

function song_CreateFcn(hObject, eventdata, handles)

% hObject    handle to song (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function song_Callback(h, eventdata, handles)

% hObject    handle to song (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of song as text
%        str2double(get(hObject,'String')) returns contents of song as a double


NewStrVal=get(h,'String');
set_param('au_dio_equal_mod/From Wave File','FileName',char(NewStrVal));

