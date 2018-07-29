function varargout = DTMF(varargin)
% =========================================================================
% DTMF.m
% GUI - Generation & Analysis of Dual Tone Multiple Frequency System(DTMF)
% Author:    Rajiv Singla
% Date:      12/10/2005
% Final Project    Fall 2005    SUNY New Paltz
% =========================================================================

%DTMF M-file for DTMF.fig
%      DTMF, by itself, creates a new DTMF or raises the existing
%      singleton*.
%
%      H = DTMF returns the handle to a new DTMF or the handle to
%      the existing singleton*.
%
%      DTMF('Property','Value',...) creates a new DTMF using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to DTMF_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      DTMF('CALLBACK') and DTMF('CALLBACK',hObject,...) call the
%      local function named CALLBACK in DTMF.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DTMF

% Last Modified by GUIDE v2.5 10-Dec-2005 03:51:36

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DTMF_OpeningFcn, ...
                   'gui_OutputFcn',  @DTMF_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before DTMF is made visible.
function DTMF_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for DTMF
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject,handles,false);
% UIWAIT makes DTMF wait for user response (see UIRESUME)
% uiwait(handles.DTMF);



%%=======================================================================
%
%                  GENERATION MODULE DEVELOPMENT
%
%========================================================================

% --- Outputs from this function are returned to the command line.
function varargout = DTMF_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%-------------------------------------------------------------------

% --- Executes on button press in PBNum1.
function PBNum1_Callback(hObject, eventdata, handles)
% hObject    handle to PBNum1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update Dialpad Display window
DN=get(handles.STDisplayDialedNum,'String');
DN=strcat(DN,'1');
set(handles.STDisplayDialedNum,'String',DN);

% Get corresponding frequencies 
 [f1 f2] = DialedFrequencies(1);
 
% Update Graphical controls 
UpdateGenerationGraphs(f1,f2,handles);

%-------------------------------------------------------------------

% --- Executes on button press in PBNum2.
function PBNum2_Callback(hObject, eventdata, handles)
% hObject    handle to PBNum2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update Dialpad Display window
DN=get(handles.STDisplayDialedNum,'String');
DN=strcat(DN,'2');
set(handles.STDisplayDialedNum,'String',DN);

% Get corresponding frequencies 
 [f1 f2] = DialedFrequencies(2);
 
% Update Graphical controls 
UpdateGenerationGraphs(f1,f2,handles);

%-------------------------------------------------------------------

% --- Executes on button press in PBNum3.
function PBNum3_Callback(hObject, eventdata, handles)
% hObject    handle to PBNum3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Update Dialpad Display window
DN=get(handles.STDisplayDialedNum,'String');
DN=strcat(DN,'3');
set(handles.STDisplayDialedNum,'String',DN);

% Get corresponding frequencies 
 [f1 f2] = DialedFrequencies(3);
 
% Update Graphical controls 
UpdateGenerationGraphs(f1,f2,handles);

%-------------------------------------------------------------------

% --- Executes on button press in PBNumA.
function PBNumA_Callback(hObject, eventdata, handles)
% hObject    handle to PBNumA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update Dialpad Display window
DN=get(handles.STDisplayDialedNum,'String');
DN=strcat(DN,'A');
set(handles.STDisplayDialedNum,'String',DN);

% Get corresponding frequencies 
 [f1 f2] = DialedFrequencies(11);
 
% Update Graphical controls 
UpdateGenerationGraphs(f1,f2,handles);

%-------------------------------------------------------------------

% --- Executes on button press in PBNum4.
function PBNum4_Callback(hObject, eventdata, handles)
% hObject    handle to PBNum4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update Dialpad Display window
DN=get(handles.STDisplayDialedNum,'String');
DN=strcat(DN,'4');
set(handles.STDisplayDialedNum,'String',DN);

% Get corresponding frequencies 
 [f1 f2] = DialedFrequencies(4);
 
% Update Graphical controls 
UpdateGenerationGraphs(f1,f2,handles);

%-------------------------------------------------------------------

% --- Executes on button press in PBNum5.
function PBNum5_Callback(hObject, eventdata, handles)
% hObject    handle to PBNum5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update Dialpad Display window
DN=get(handles.STDisplayDialedNum,'String');
DN=strcat(DN,'5');
set(handles.STDisplayDialedNum,'String',DN);

% Get corresponding frequencies 
 [f1 f2] = DialedFrequencies(5);
 
% Update Graphical controls 
UpdateGenerationGraphs(f1,f2,handles);

%-------------------------------------------------------------------

% --- Executes on button press in PBNum6.
function PBNum6_Callback(hObject, eventdata, handles)
% hObject    handle to PBNum6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update Dialpad Display window
DN=get(handles.STDisplayDialedNum,'String');
DN=strcat(DN,'6');
set(handles.STDisplayDialedNum,'String',DN);

% Get corresponding frequencies 
 [f1 f2] = DialedFrequencies(6);
 
% Update Graphical controls 
UpdateGenerationGraphs(f1,f2,handles);

%-------------------------------------------------------------------

% --- Executes on button press in PBNumB.
function PBNumB_Callback(hObject, eventdata, handles)
% hObject    handle to PBNumB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update Dialpad Display window
DN=get(handles.STDisplayDialedNum,'String');
DN=strcat(DN,'B');
set(handles.STDisplayDialedNum,'String',DN);

% Get corresponding frequencies 
 [f1 f2] = DialedFrequencies(12);
 
% Update Graphical controls 
UpdateGenerationGraphs(f1,f2,handles);

%-------------------------------------------------------------------

% --- Executes on button press in PBNum7.
function PBNum7_Callback(hObject, eventdata, handles)
% hObject    handle to PBNum7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update Dialpad Display window
DN=get(handles.STDisplayDialedNum,'String');
DN=strcat(DN,'7');
set(handles.STDisplayDialedNum,'String',DN);

% Get corresponding frequencies 
 [f1 f2] = DialedFrequencies(7);
 
% Update Graphical controls 
UpdateGenerationGraphs(f1,f2,handles);

%-------------------------------------------------------------------

% --- Executes on button press in PBNum8.
function PBNum8_Callback(hObject, eventdata, handles)
% hObject    handle to PBNum8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update Dialpad Display window
DN=get(handles.STDisplayDialedNum,'String');
DN=strcat(DN,'8');
set(handles.STDisplayDialedNum,'String',DN);

% Get corresponding frequencies 
 [f1 f2] = DialedFrequencies(8);
 
% Update Graphical controls 
UpdateGenerationGraphs(f1,f2,handles);

%-------------------------------------------------------------------

% --- Executes on button press in PBNum9.
function PBNum9_Callback(hObject, eventdata, handles)
% hObject    handle to PBNum9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update Dialpad Display window
DN=get(handles.STDisplayDialedNum,'String');
DN=strcat(DN,'9');
set(handles.STDisplayDialedNum,'String',DN);

% Get corresponding frequencies 
 [f1 f2] = DialedFrequencies(9);
 
% Update Graphical controls 
UpdateGenerationGraphs(f1,f2,handles);

%-------------------------------------------------------------------

% --- Executes on button press in PBNumC.
function PBNumC_Callback(hObject, eventdata, handles)
% hObject    handle to PBNumC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update Dialpad Display window
DN=get(handles.STDisplayDialedNum,'String');
DN=strcat(DN,'C');
set(handles.STDisplayDialedNum,'String',DN);

% Get corresponding frequencies 
 [f1 f2] = DialedFrequencies(13);
 
% Update Graphical controls 
UpdateGenerationGraphs(f1,f2,handles);

%-------------------------------------------------------------------

% --- Executes on button press in PBNumStar.
function PBNumStar_Callback(hObject, eventdata, handles)
% hObject    handle to PBNumStar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update Dialpad Display window
DN=get(handles.STDisplayDialedNum,'String');
DN=strcat(DN,'*');
set(handles.STDisplayDialedNum,'String',DN);

% Get corresponding frequencies 
 [f1 f2] = DialedFrequencies(15);
 
% Update Graphical controls 
UpdateGenerationGraphs(f1,f2,handles);

%-------------------------------------------------------------------

% --- Executes on button press in PBNum0.
function PBNum0_Callback(hObject, eventdata, handles)
% hObject    handle to PBNum0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update Dialpad Display window
DN=get(handles.STDisplayDialedNum,'String');
DN=strcat(DN,'0');
set(handles.STDisplayDialedNum,'String',DN);

% Get corresponding frequencies 
 [f1 f2] = DialedFrequencies(10);
 
% Update Graphical controls 
UpdateGenerationGraphs(f1,f2,handles);

%-------------------------------------------------------------------

% --- Executes on button press in PBNumTown.
function PBNumTown_Callback(hObject, eventdata, handles)
% hObject    handle to PBNumTown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update Dialpad Display window
DN=get(handles.STDisplayDialedNum,'String');
DN=strcat(DN,'#');
set(handles.STDisplayDialedNum,'String',DN);

% Get corresponding frequencies 
 [f1 f2] = DialedFrequencies(16);
 
% Update Graphical controls 
UpdateGenerationGraphs(f1,f2,handles);

%-------------------------------------------------------------------

% --- Executes on button press in PBNumD.
function PBNumD_Callback(hObject, eventdata, handles)
% hObject    handle to PBNumD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update Dialpad Display window
DN=get(handles.STDisplayDialedNum,'String');
DN=strcat(DN,'D');
set(handles.STDisplayDialedNum,'String',DN);

% Get corresponding frequencies 
 [f1 f2] = DialedFrequencies(14);
 
% Update Graphical controls 
UpdateGenerationGraphs(f1,f2,handles);


%-------------------------------------------------------------------

% --- Executes on button press in PBTouchPadDelete.
function PBTouchPadDelete_Callback(hObject, eventdata, handles)
% hObject    handle to PBTouchPadDelete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Clearing the last Digit Diplayed in Dialpad Window
DN=get(handles.STDisplayDialedNum,'String');
DN=DN(1:(end-1));
set(handles.STDisplayDialedNum,'String',DN);

%-------------------------------------------------------------------

% --- Executes on button press in PBTouchPadClear.
function PBTouchPadClear_Callback(hObject, eventdata, handles)
% hObject    handle to PBTouchPadClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Clearing all the Digits Display of Dialpad Window 
DN=get(handles.STDisplayDialedNum,'String');
DN='';
set(handles.STDisplayDialedNum,'String',DN);

%-------------------------------------------------------------------


function ETSamplingFrequency_Callback(hObject, eventdata, handles)
% hObject    handle to ETSamplingFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ETSamplingFrequency as text
%        str2double(get(hObject,'String')) returns contents of ETSamplingFrequency as a double


%-------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function ETSamplingFrequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ETSamplingFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------------------------------------------------------

function ETToneLength_Callback(hObject, eventdata, handles)
% hObject    handle to ETToneLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ETToneLength as text
%        str2double(get(hObject,'String')) returns contents of ETToneLength as a double


%-------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function ETToneLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ETToneLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------------------------------------------------------


function ETNoiseMargin_Callback(hObject, eventdata, handles)
% hObject    handle to ETNoiseMargin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ETNoiseMargin as text
%        str2double(get(hObject,'String')) returns contents of ETNoiseMargin as a double


%-------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function ETNoiseMargin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ETNoiseMargin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------------------------------------------------------

function ETDelayTime_Callback(hObject, eventdata, handles)
% hObject    handle to ETDelayTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ETDelayTime as text
%        str2double(get(hObject,'String')) returns contents of ETDelayTime as a double


%-------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function ETDelayTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ETDelayTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------

% Function used generate & Update Graphical Displays of Generation Module
function UpdateGenerationGraphs(f1,f2,handles)

Fs = str2double(get(handles.ETSamplingFrequency,'String'));%Sampling Freq.
TL = str2double(get(handles.ETToneLength,'String'))/1000;  %Tone Length(s)
DL = str2double(get(handles.ETDelayTime,'String'))/1000;   %Delay Length(s)
NM = str2double(get(handles.ETNoiseMargin,'String'));      %Noise Margin

% Using Resonator to produce sinusodial signal for input frequencies
[x x1 x2]=DigitalOscillator(f1,f2,Fs,TL);

% Adding pause to the beginning and end of generated Signal
  Ts=1/Fs;                                        %Sampling Interval
  Pause = [0:(DL/Ts)]*0;                          %Time Vector for delay
  x = [Pause x Pause];
  
% Adding Noise to the generated Signal
  x = x + NM*rand(size(x));
  
% Play Sound on a sound card enabled computer
  soundsc(x,Fs);
  
% Plot SpectalGraph of resultant Signal
  subplot(handles.AXSpecgram)
  specgram(x,512,Fs);
  

% Labelling Specgram Graph with DTMF Frequencies
rf=[697  770  852  941];   %DTMF Row frequencies
cf=[1209 1336 1477 1633];  %DTMF Column frequencies

tmax=Ts*(length(x)-1);

hold on;
for i=1:length(rf),
    plot([0 tmax],[rf(i) rf(i)],'w')
end
for i=1:length(cf),
    plot([0 tmax],[cf(i) cf(i)],'k')
end
hold off;
axis([0 tmax 0 2000])

%Plotting Generate Signal Time Graph
subplot(handles.AXOScillatorSignal)
t = linspace(0,tmax,length(x));
plot(t,x)
grid on
zoom on
ylabel('x(t)');
xlabel('time (s)');
legend('Generated Signal')
%axis([0 tmax -max(x) max(x)])

f1str=num2str(f1);
f2str=num2str(f2);

TagFreq=strcat('GENERATED SIGNAL','  F1 =    ',f1str,' Hz    ',...
                               '     F2 =    ',f2str,' Hz');
set(handles.STGeneratedSignal,'String',TagFreq);


%Updating Handle structure to store generated signal

handles.SignalData.Input = x;
guidata(DTMF,handles);

%=========================================================================
%
%                     END GENERATION MODULE
%
%%========================================================================


% -----------------------------------------------------------------------



function ETFramesLength_Callback(hObject, eventdata, handles)
% hObject    handle to ETFramesLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ETFramesLength as text
%        str2double(get(hObject,'String')) returns contents of ETFramesLength as a double


% --- Executes during object creation, after setting all properties.
function ETFramesLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ETFramesLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ETPolePosition_Callback(hObject, eventdata, handles)
% hObject    handle to ETPolePosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ETPolePosition as text
%        str2double(get(hObject,'String')) returns contents of ETPolePosition as a double


% --- Executes during object creation, after setting all properties.
function ETPolePosition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ETPolePosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ETFrameSize_Callback(hObject, eventdata, handles)
% hObject    handle to ETFrameSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ETFrameSize as text
%        str2double(get(hObject,'String')) returns contents of ETFrameSize as a double


% --- Executes during object creation, after setting all properties.
function ETFrameSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ETFrameSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in PBFrameDecode.
function PBFrameDecode_Callback(hObject, eventdata, handles)
% hObject    handle to PBFrameDecode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sound(10);
%Get editable parameters
Fs = str2double(get(handles.ETSamplingFrequency,'String'));%Sampling Freq.
FL = str2double(get(handles.ETFrameSize,'String'))/1000;   %Frame Length(s)
PP = str2double(get(handles.ETPolePosition,'String'));     %Pole Position

Ts = 1/Fs;                           %Sampling Interval
SamplesPerFrame = floor(FL/Ts);      %Rounded Samples per frame

% Get Input Signal
x = handles.SignalData.Input;
MaxFrames = floor(length(x)/SamplesPerFrame); %Maximum Number of Frames
set(handles.STMaxNumberFrames,'String',MaxFrames);

% Find the current frame location
CurrentFrame=handles.SignalData.CurrentFrame;

% Initalize Display if it is first frame of the signal
if CurrentFrame == 1
    set(handles.STDecodedSequenceDisplay,'String',[]);
end

% Check to see if Maximum allowed frames is reached
if CurrentFrame > MaxFrames
    set(handles.PBFrameDecode,'String','Max Frame Limit:Click Reset');
    return
end

%Divide the Signal in frames and make a cell 
xcell = cell(1,MaxFrames);
k=1;

for i = 1:MaxFrames
    xcell(i) = { x(k:k+SamplesPerFrame-1) };
    k=k+SamplesPerFrame;
end

% Check to see if the Frame has any energy
[Etest,EStest,Iszero] = EnergySignal(xcell{CurrentFrame});
    
if Iszero == 1;  % If the frame has no energy display 'p' for pause
    DNum=get(handles.STDecodedSequenceDisplay,'String');
    DNum=strcat(DNum,'p');
    set(handles.STDecodedSequenceDisplay,'String',DNum);
else             % Else Update graphs and decode frequencies
    E=UpdateFilterGraphs(handles,xcell{CurrentFrame},Fs,PP);
    [f1,f2,DialedNum] = DecodedFrequencies(E);
    set(handles.STDecodedFreq1,'String',f1);
    set(handles.STDecodedFreq2,'String',f2);
    DNum=get(handles.STDecodedSequenceDisplay,'String');
    DNum=strcat(DNum,DialedNum);
    set(handles.STDecodedSequenceDisplay,'String',DNum);
end

set(handles.PBFrameDecode,'String',strcat('Frame No.',num2str(CurrentFrame)));

% Pass Frame to decode final number when it is 1 before the last frame to be decoded
if CurrentFrame >=(MaxFrames-1)
    Sequence=get(handles.STDecodedSequenceDisplay,'String');
    DialedNum=FrameSequeneRules(Sequence);
    set(handles.STDecodedNumberDisplay,'String',DialedNum);
end

% If Maximum Frame Limit is not reached Increment current frame counter
if CurrentFrame <= MaxFrames
   CurrentFrame = CurrentFrame+1; 
end


% Update GUI handles
handles.SignalData.CurrentFrame = CurrentFrame;
guidata(hObject,handles)
 
% --- Executes on button press in PBAutomaticDecoding.
function PBAutomaticDecoding_Callback(hObject, eventdata, handles)
% hObject    handle to PBAutomaticDecoding (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sound(10);

Fs = str2double(get(handles.ETSamplingFrequency,'String'));%Sampling Freq.
FL = str2double(get(handles.ETFrameSize,'String'))/1000;   %Frame Length(s)
PP = str2double(get(handles.ETPolePosition,'String'));     %Pole Position

Ts = 1/Fs;               %Sampling Interval
SamplesPerFrame = floor(FL/Ts);

% Get Input Signal
x = handles.SignalData.Input;
MaxFrames = floor(length(x)/SamplesPerFrame);
set(handles.STMaxNumberFrames,'String',MaxFrames);

%Divide the Signal in frames

xcell = cell(1,MaxFrames);
k=1;

for i = 1:MaxFrames
    xcell(i) = { x(k:k+SamplesPerFrame-1) };
    k=k+SamplesPerFrame;
end

%Clear Sequence Display to Display fresh calculated Sequence
DNum=get(handles.STDecodedSequenceDisplay,'String');
DNum=[];
set(handles.STDecodedSequenceDisplay,'String',DNum);

%Pass Frames of the Frame 1 by 1 and update graphs
for i = 1:MaxFrames
    sound(10);
    % If Energy of the Frame is zero no update is necessary
    [Etest,EStest,Iszero] = EnergySignal(xcell{i});
    if Iszero == 1;
    DNum=get(handles.STDecodedSequenceDisplay,'String');
    DNum=strcat(DNum,'p');
    set(handles.STDecodedSequenceDisplay,'String',DNum);
    i=i+1;
    else
    % Update graphs when Energy is not zero
    E=UpdateFilterGraphs(handles,xcell{i},Fs,PP);
    [f1,f2,DialedNum] = DecodedFrequencies(E);
    set(handles.STDecodedFreq1,'String',f1);
    set(handles.STDecodedFreq2,'String',f2);
    DNum=get(handles.STDecodedSequenceDisplay,'String');
    DNum=strcat(DNum,DialedNum);
    set(handles.STDecodedSequenceDisplay,'String',DNum);
    end
end
% Update Sequence Display for decoded frame sequence
Sequence=get(handles.STDecodedSequenceDisplay,'String');
% Update final number decoded
DialedNum=FrameSequeneRules(Sequence);
set(handles.STDecodedNumberDisplay,'String',DialedNum);

% --- Executes on button press in PBReset.
function PBReset_Callback(hObject, eventdata, handles)
% hObject    handle to PBReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(hObject,handles,true);
%%=========================================================================
% Function for Updating Graphs for analysis 
function Energy = UpdateFilterGraphs(handles,x,Fs,PP)

Fmat = [697 770 852 941 1209 1336 1477 1633];

Axis = [handles.AXFilter1 handles.AXFilter2 handles.AXFilter3...
        handles.AXFilter4 handles.AXFilter5 handles.AXFilter6...
        handles.AXFilter7 handles.AXFilter8];
%Get Responses for input signal
Energy = [];

for i = 1:8;
 [Y,F,Yfft,Ffft] = DigitalResonator(x,Fmat(i),Fs,PP);
 Energy(i)=EnergySignal(Y);
 subplot(Axis(i))
 plot(0,0)
 hold on
 grid on
 f = linspace(-Fs/2,Fs/2,length(Yfft));
 Ynorm=Yfft/(max(Yfft));
 plot(f,Ynorm)
 Fnorm=Ffft/(max(Ffft));
 plot(f,Fnorm,'r')
 hold off
 axis([0 2000 0 1])
 
 str1=strcat('Frequency-',num2str(Fmat(i)),' Hz     ',...
             '   Signal Energy-',num2str(Energy(i)));      
 title(str1);
end

%% =======================================================================
% Function to initalize all graph varianles
function initialize_gui(fig_handle, handles, isreset)

if isfield(handles, 'SignalData') && ~isreset
    return;
end

handles.SignalData.CurrentFrame = 1;
handles.SignalData.Input= 0;

% Resetting all Graphs
Axis = [handles.AXFilter1 handles.AXFilter2 handles.AXFilter3...
        handles.AXFilter4 handles.AXFilter5 handles.AXFilter6...
        handles.AXFilter7 handles.AXFilter8];
for i = 1:8;
      subplot(Axis(i))
      plot(0,0)
end
subplot(handles.AXSpecgram)
     plot(0,0)
     
subplot(handles.AXOScillatorSignal)
     plot(0,0)
     
% Resetting all Display     
set(handles.STDecodedFreq1,'String','n/a');
set(handles.STDecodedFreq2,'String','n/a');     
set(handles.STMaxNumberFrames,'String','n/a');     
     
DN=get(handles.STDisplayDialedNum,'String');
DN=[];
set(handles.STDisplayDialedNum,'String',DN);


DNum=get(handles.STDecodedSequenceDisplay,'String');
DNum=[];
set(handles.STDecodedSequenceDisplay,'String',DNum);
set(handles.STDecodedNumberDisplay,'String',DNum);

set(handles.PBFrameDecode,'String','Decode Frame By Frame');
set(handles.STGeneratedSignal,'String','GENERATED SIGNAL');

% Update handles structure
guidata(fig_handle, handles);
%% =======================================================================
