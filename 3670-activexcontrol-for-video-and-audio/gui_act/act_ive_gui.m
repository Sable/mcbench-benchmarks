function varargout = act_ive_gui(varargin)


% ACT_IVE_GUI M-file for act_ive_gui.fig
%      ACT_IVE_GUI, by itself, creates a new ACT_IVE_GUI or raises the existing
%      singleton*.
%
%      H = ACT_IVE_GUI returns the handle to a new ACT_IVE_GUI or the handle to
%      the existing singleton*.
%
%      ACT_IVE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACT_IVE_GUI.M with the given input arguments.
%
%      ACT_IVE_GUI('Property','Value',...) creates a new ACT_IVE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before act_ive_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to act_ive_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help act_ive_gui

% Last Modified by GUIDE v2.5 01-Jul-2003 17:38:16

% Begin initialization code - DO NOT EDIT



%**************************************************************************
%**************************************************************************


% act_ive_gui : A graphical user interface that uses activex control with Windows Media Player .
% This graphical user interface provides almost all the controls to the Windows Media Player.
% The program is an example to show how you can interface the Windows applications with MATLAB using 
% activex control and GUIDE.




%It is recommended that you download the activex control from the following URL
% http://activex.microsoft.com/activex/activex/
%Before running this program set your screen size to 1024 by 768 pixels.
%The GUI is resizable.
 
% Press "Openfile" button to select the files(audio or video).
% Press "Start" button to play the selected file. 
% Press "Stop" button  to stop playing the file.
% Press "Mute"  togglebutton  to mute video play.Press it again to disable mute .
% Press "Pause" button to pause the play.
% Press "Start" button to continue after the pause.
% Press "Left " button to have a left balance of the sound.
% Press "Right" button to have a right balance of the sound.
% Press " FullScreen" button to have a diaplay in the fullscreen.
% Press " Standard" button to have a standard display.
% Press "1/16 diplay size" radiobutton to have a one sixteenth of the screen  size.
% Press "1/4 diplay size" radiobutton to have a one fourth of the screen size.
% Press "1/2 diplay size" radiobutton to have a one half of the screen size.

% The "Fastmotion" and "SlowMotion" slider changes the rate property of the current playback rate of video media.
% The rate property acts as a multiplier value that allows you to play a clip at a faster or slower rate. 
% Moving this slider to the right increses the speed of both the video as well as the audio .
% Moving this slider to the left decreases the speed of both the video as well as the audio .


% The "Volume" slider increses and decreases the volume of the video or the audio.

% The "Seek Position" slider allows you to changeto  new position within the clip, in seconds.
% This is  similar to performing a seek operation, and changes the position to the specified point in the clip.
% Before attempting to set this property, determine the length of the file in seconds.


% The "No.Repition" Edit Box allows the user specifies the number of times a clip diaplays.
% The default value is 1.


% **********************************************************************************************************
%************************************************************************************************************


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @act_ive_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @act_ive_gui_OutputFcn, ...
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
% --- Executes just before act_ive_gui is made visible.



function varargout=act_ive_gui_OpeningFcn(hObject, eventdata, handles, varargin)

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to act_ive_gui (see VARARGIN)

% Choose default command line output for act_ive_gui

handles.output = hObject;

% UIWAIT makes act_ive_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

set(gcf,'Color',[0 0 0]);
pos=[0 200 560 300];
MovieControl = actxcontrol('AMOVIE.ActiveMovieControl.2',pos);
assignin('base','MovieControl',MovieControl);
handles.MovieControl = MovieControl;
get(MovieControl)
mp = handles.MovieControl.MediaPlayer;
set(handles.MovieControl.MediaPlayer,'AutoSize',1);
set(handles.MovieControl.MediaPlayer,'ShowAudioControls',0);
set(handles.MovieControl.MediaPlayer,'ShowTracker',0);
set(handles.MovieControl.MediaPlayer,'ShowControls',0);
set(handles.MovieControl.MediaPlayer,'ShowDisplay',0);

% Update handles structure

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.

function varargout = act_ive_gui_OutputFcn(hObject, eventdata, handles)

% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure


varargout{1} = handles.output;

% --- Executes on button press in ope_n_fil_e.


function ope_n_fil_e_Callback(hObject, eventdata, handles)

% hObject    handle to ope_n_fil_e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[filename pathname] = uigetfile('*.*','Please select a file')
if ~filename
    return
end;
mp = handles.MovieControl.MediaPlayer;
Open(mp,[pathname filename]);

% --- Executes on button press in fu_ll_screen.

function fu_ll_screen_Callback(hObject, eventdata, handles)


% hObject    handle to fu_ll_screen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


mp = handles.MovieControl.MediaPlayer;
set(handles.MovieControl.MediaPlayer,'EnableFullScreenControls',1);
set(handles.MovieControl.MediaPlayer,'DisplaySize',3);   

% --- Executes on button press in stan_screen_size.
function stan_screen_size_Callback(hObject, eventdata, handles)

% hObject    handle to stan_screen_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mp1 = handles.MovieControl.MediaPlayer;
set(handles.MovieControl,'MovieWindowSize',3);

function Vol_CreateFcn(hObject, eventdata, handles)

% hObject    handle to Vol (see GCBO)
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

function Vol_Callback(hObject, eventdata, handles)
% hObject    handle to Vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%         get(hObject,'Min') and get(hObject,'Max') to determine range of slider


h1=get(handles.Vol,'Value');
set(handles.MovieControl.MediaPlayer,'volume',h1);

% --- Executes on button press in mu_te.

function mu_te_Callback(hObject, eventdata, handles)

% hObject    handle to mu_te (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mu_te

 mp = handles.MovieControl.MediaPlayer; 
 h=get(gcbo,'Value');
if h==0
    set(handles.MovieControl.MediaPlayer,'mute',0);
end
if h==1
    set(handles.MovieControl.MediaPlayer,'mute',1);
end       

% --- Executes on button press in one_sixteenth.

function one_sixteenth_Callback(hObject, eventdata, handles)

% hObject    handle to one_sixteenth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of one_sixteenth

drawnow;
set(findobj('tag','one_fourth'),'value',0);
set(findobj('tag','ome_half'),'value',0);
set(gcbo,'value',1); 
set(handles.MovieControl.MediaPlayer,'DisplaySize',5);



% --- Executes on button press in one_fourth.


function one_fourth_Callback(hObject, eventdata, handles)


% hObject    handle to one_fourth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of one_fourth

drawnow;
set(findobj('tag','one_sixteenth'),'value',0);
set(findobj('tag','one_half'),'value',0);
set(gcbo,'value',1); 
set(handles.MovieControl.MediaPlayer,'DisplaySize',6);



% --- Executes on button press in one_half.

function one_half_Callback(hObject, eventdata, handles)

% hObject    handle to one_half (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of one_half
drawnow;
set(findobj('tag','one_sixteenth'),'value',0);
set(findobj('tag','one_fourth'),'value',0);
set(gcbo,'value',1); 
set(handles.MovieControl.MediaPlayer,'DisplaySize',7);

% --- Executes on button press in left_bal.
function left_bal_Callback(hObject, eventdata, handles)
% hObject    handle to left_bal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.MovieControl,'Balance',-3500)

% --- Executes on button press in right_bal.

function right_bal_Callback(hObject, eventdata, handles)
% hObject    handle to right_bal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATL

% handles    structure with handles and user data (see GUIDATA)
set(handles.MovieControl,'Balance',5000)

% --- Executes during object creation, after setting all properties.
function ra_te_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ra_te (see GCBO)
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
function ra_te_Callback(hObject, eventdata, handles)

% hObject    handle to ra_te (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

h=get(gcbo,'Value');
set(handles.MovieControl.MediaPlayer,'Rate',h)


% --- Executes on button press in pla_y.
function pla_y_Callback(hObject, eventdata, handles)
% hObject    handle to pla_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mp = handles.MovieControl.MediaPlayer;   
set(handles.MovieControl.MediaPlayer,'SendPlayStateChangeEvents',1);
Play(mp);    


% --- Executes on button press in sto_p.

function sto_p_Callback(hObject, eventdata, handles)
% hObject    handle to sto_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 mp = handles.MovieControl.MediaPlayer;   
 set(handles.MovieControl.MediaPlayer,'SendPlayStateChangeEvents',1);
 Stop(mp);  


% --- Executes on button press in pau_se.

function pau_se_Callback(hObject, eventdata, handles)
% hObject    handle to pau_se (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 mp = handles.MovieControl.MediaPlayer;   
 set(handles.MovieControl.MediaPlayer,'SendPlayStateChangeEvents',1);
 Pause(mp);  

% --- Executes during object creation, after setting all properties.

function bor_der_CreateFcn(hObject, eventdata, handles)

% hObject    handle to bor_der (see GCBO)
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
function bor_der_Callback(hObject, eventdata, handles)
% hObject    handle to bor_der (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

  mp = handles.MovieControl.MediaPlayer;   
  h1=get(gcbo,'Value'); 
  set(handles.MovieControl.MediaPlayer,'VideoBorderWidth',h1);
  set(handles.MovieControl.MediaPlayer,'VideoBorderColor',000);


% --- Executes during object creation, after setting all properties.
function repeat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to repeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function repeat_Callback(hObject, eventdata, handles)

% hObject    handle to repeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of repeat as text
% str2double(get(hObject,'String')) returns contents of repeat as a double

mp = handles.MovieControl.MediaPlayer;   
c=get(handles.repeat,'String');
set(handles.MovieControl,'PlayCount',str2double(c));
Play(mp)

% --- Executes during object creation, after setting all properties.
function curr_pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to curr_pos (see GCBO)
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
function curr_pos_Callback(hObject, eventdata, handles)
% hObject    handle to curr_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

mp = handles.MovieControl.MediaPlayer; 
j=get(handles.curr_pos,'Value');
set(handles.MovieControl.MediaPlayer,'CurrentPosition',j);
