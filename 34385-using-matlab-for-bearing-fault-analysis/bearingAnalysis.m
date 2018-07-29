function varargout = bearingAnalysis(varargin)
% BEARINGANALYSIS MATLAB code for bearingAnalysis.fig
%      BEARINGANALYSIS, by itself, creates a new BEARINGANALYSIS or raises the existing
%      singleton*.
%
%      H = BEARINGANALYSIS returns the handle to a new BEARINGANALYSIS or the handle to
%      the existing singleton*.
%
%      BEARINGANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BEARINGANALYSIS.M with the given input arguments.
%
%      BEARINGANALYSIS('Property','Value',...) creates a new BEARINGANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bearingAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bearingAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bearingAnalysis

% Last Modified by GUIDE v2.5 29-Dec-2011 23:59:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bearingAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @bearingAnalysis_OutputFcn, ...
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


% --- Executes just before bearingAnalysis is made visible.
function bearingAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bearingAnalysis (see VARARGIN)

% Choose default command line output for bearingAnalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bearingAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bearingAnalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in BearingPopUp.
function BearingPopUp_Callback(hObject, eventdata, handles)
% hObject    handle to BearingPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns BearingPopUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BearingPopUp


% --- Executes during object creation, after setting all properties.
function BearingPopUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BearingPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes on selection change in AnalysisPopUp.
function AnalysisPopUp_Callback(hObject, eventdata, handles)
% hObject    handle to AnalysisPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AnalysisPopUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AnalysisPopUp


% --- Executes during object creation, after setting all properties.
function AnalysisPopUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalysisPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function rotationSpeedSlider_Callback(hObject, eventdata, handles)
% hObject    handle to rotationSpeedSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

N = get(hObject,'Value');
set(handles.speedEditText,'String',num2str(N));


% --- Executes during object creation, after setting all properties.
function rotationSpeedSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotationSpeedSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in runButton.
function runButton_Callback(hObject, eventdata, handles)
% hObject    handle to runButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pulse_run = get(handles.BearingPopUp,'Value');
N = round(str2double(get(handles.speedEditText,'String'))); % Speed, rpm
spec_run = get(handles.AnalysisPopUp,'Value');
if (pulse_run == 1)
    [P, t] = pulse_in(N);
else
    [P, t] = pulse_out(N);
end
plot(handles.inputAxes, t, P, 'r');
axis(handles.inputAxes, [0 max(t) 0 1]);
xlabel(handles.inputAxes, 'Time [sec]');
ylabel(handles.inputAxes, 'Pulse (On/Off)');
[Y, t, W, M] = bearing(P, t);
loglog(handles.systemAxes, W, M, 'r');
grid(handles.systemAxes);
axis(handles.systemAxes, [min(W) max(W) min(M) max(M)]);
xlabel(handles.systemAxes, 'Frequency [rad/sec] (Logarythmic)');
ylabel(handles.systemAxes, 'Magnitude (Logarythmic)');
plot(handles.responseAxes,t,Y,'r');
axis(handles.responseAxes, [0 max(t) min(Y) max(Y)]);
xlabel(handles.responseAxes, 'Time [sec]');
ylabel(handles.responseAxes, 'Magnitude');
switch spec_run
    case 1      % Spectral Analysis
        [S, f] = spec_an(Y,t);
        W = f;
        plot(handles.analysisAxes, W, S, 'r');
        axis(handles.analysisAxes, [min(W) 2000 min(S) max(S)]);
        title(handles.analysisAxes, 'Spectral Analysis (PSD) Of The Signal','FontWeight','bold');
        xlabel(handles.analysisAxes, 'Frequency [rad/sec]');
        ylabel(handles.analysisAxes, 'PSD');
        set(handles.kur120Edit,'String','-');
        set(handles.kur500Edit,'String','-');
        set(handles.kur1500Edit,'String','-');
    case 2      % Kurtosis
        [S, f] = spec_an(Y, t);
        W = f;
        plot(handles.analysisAxes, W, S, 'r');
        axis(handles.analysisAxes, [min(W) 2000 min(S) max(S)]);
        title(handles.analysisAxes, 'Spectral Analysis (PSD) Of The Signal','FontWeight','bold');
        xlabel(handles.analysisAxes, 'Frequency [rad/sec]');
        ylabel(handles.analysisAxes, 'PSD');
        [K1, K2, K3] = kurtpar(Y, t);
        set(handles.kur120Edit,'String',num2str(K1));
        set(handles.kur500Edit,'String',num2str(K2));
        set(handles.kur1500Edit,'String',num2str(K3));
    case 3      % Calculate Envelope
        [Y, t, ~, ~] = bearing(P,t);
        env = abs(hilbert(Y));
        plot(handles.responseAxes,t,Y,'r',t,env,'k');
        title(handles.responseAxes, 'Response signal (red), Envelope (black)','FontWeight','bold')
        axis(handles.responseAxes, [0 max(t) min(Y) max(Y)]);
        xlabel(handles.responseAxes, 'Time [sec]');
        ylabel(handles.responseAxes, 'Magnitude')
        [S_env, f_env] = spec_an(env, t);
        W_env = 2*pi*f_env;
        plot(handles.analysisAxes, W_env, S_env, 'r');
        title(handles.analysisAxes, 'Spectral Analysis (PSD) Of The Envelope','FontWeight','bold');
        xlabel(handles.analysisAxes, 'Frequency [rad/sec]');
        ylabel(handles.analysisAxes, 'PSD');
    case 4
        [Y ,t, ~, ~] = bearing(P, t);
        axes(handles.analysisAxes);
        dt = t(2)-t(1);
        Nfft = length(Y);		% Number of samples per cycle.
        if (Nfft > 256)
            Nfft=256;
        end
        specgram(Y, Nfft, 2*pi/dt);
        title('Time-freq Spectrum','FontWeight','bold')
        
%         title(ax(3),'Response signal','FontWeight','bold')
%         ylabel(ax(3),'Magnitude');
end


% --- Executes on button press in filterButton.
function filterButton_Callback(hObject, eventdata, handles)
% hObject    handle to filterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.analysisAxes);
C1 = cursorg;         %create one cursor
pause
C2 = cursorg;         %create another cursor
pause
a = cursorg('read',C1);
cursorg('delete',C1);
b = cursorg('read',C2);
cursorg('delete',C2);
N = round(str2double(get(handles.speedEditText,'String'))); % Speed, rpm
fs = 100*N/60;
w1 = a/fs/2;
w2 = b/fs/2;
if w1>0.2
    w1 = 0.2;
end
if w2>1
    w2 = 0.99999;
end
[num, den] = butter(6, [w1 w2], 'stop');
pulse_run=get(handles.BearingPopUp, 'Value');
if (pulse_run == 1)
    [P, t] = pulse_in(N);
else
    [P, t] = pulse_out(N);
end
[Y, t, ~, ~] = bearing(P, t);
env = abs(hilbert(Y));
filt_env = filtfilt(num, den, env);
plot(handles.analysisAxes, t, filt_env, 'r');
title(handles.analysisAxes, 'Filtered Envelope','FontWeight','bold')
xlabel(handles.analysisAxes, 'Time [sec]')


% --- Executes on button press in instructionButton.
function instructionButton_Callback(hObject, eventdata, handles)
% hObject    handle to instructionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web('bearingAnalysis_help.html','-browser'); 


% --- Executes on button press in quitButton.
function quitButton_Callback(hObject, eventdata, handles)
% hObject    handle to quitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(gcf);
