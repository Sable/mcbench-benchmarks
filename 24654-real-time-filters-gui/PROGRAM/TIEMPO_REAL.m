function varargout = TIEMPO_REAL(varargin)
%==========================================================================
% By: Frank Maldonado
%     Juan Pablo Ramón
%==========================================================================
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @TIEMPO_REAL_OpeningFcn, ...
    'gui_OutputFcn',  @TIEMPO_REAL_OutputFcn, ...
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


% --- Executes just before TIEMPO_REAL is made visible.
function TIEMPO_REAL_OpeningFcn(hObject, eventdata, handles, varargin)
% _________________________________________________________________________
%__________________Centering the  GUI interface____________________________
scrsz=get(0,'ScreenSize');
pos_a=get(gcf,'Position');
xr=scrsz(3)-pos_a(3);
xp=round(xr/2);
yr=scrsz(4)-pos_a(4);
yp=round(yr/2);
set(gcf,'Position',[xp yp pos_a(3) pos_a(4)]);
% _________________________________________________________________________
% ___________________Adding an image_______________________________________
a=imread('fondo.png');
image(a);
axis off;
% _________________________________________________________________________
set(handles.stop,'Visible','off');%Hides "Stop" push button,to make it
% visible just after "Start" push button has been pushed.
set(handles.volver,'Visible','off');%Hides "Define Another Filter" push
% button, to make it visible just after "Stop" push button has been pushed.

handles.output = hObject;
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = TIEMPO_REAL_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% --- Executes on button press in volver.
function volver_Callback(hObject, eventdata, handles)
FILTROS %executes the GUI file named "FILTROS", where we define the filter
% type and its features that we are going to apply to the audio signal
% incoming from the microphone.
close TIEMPO_REAL %Close the present GUI interface ("TIEMPO_REAL").


% --- Executes on button press in iniciar.
function iniciar_Callback(hObject, eventdata, handles)
global a b fsx %This are the global variables, used to import data
% from "FILTROS" GUI interface, where:
% (a)is numerator and (b)denominator of the filter transfer function.
% (fsx) is the sample frequency.

ca=analoginput('winsound');%Creates the analog input object "ca" ,
% for the sound card.
addchannel(ca,[1]);%Adds a hardware channel to the analog object "ca".
ca.SampleRate=fsx;%Defines the sample Rate.
ca.SamplesPerTrigger=1000;%Defines the sample number per trigger.
num_muestras=1000;%Defines the sample number to be extracted from the "data"
% variable.
ca.TriggerRepeat=Inf;%Specifies the trigger number executions as infinite.
ca.TriggerType='Immediate';%The trigger occurs immediately after the start
% function is used.
start(ca)%starts the acquisition.
set(handles.iniciar,'UserData',1);%initialize the flag variable, used to
% stop and resume the acquisition (stop and resume the WHILE LOOP without
% using "ctrl+c"),

while (get(handles.iniciar,'UserData') ==1)%while the flag variable be 1
    %the "while loop" will continue.
    set(handles.volver,'Visible','off');%Makes invisible
    % "Define Another Filter" push button, to prevent any error when this
    % button is clicked while the acquisition is running.
    set(handles.stop,'Visible','on');%Makes visible the "stop" push button
    %    to allow the possibility of stop the acquisition.
    
    datos=peekdata(ca,num_muestras);%stores and extracts the number of samples
    % indicated by "num_muestras" in "datos" variable.
    flushdata(ca);%Remove all logged data associated to "ca".
    
    % _____________________________________________________________________
    % ________Plots the audio signal incoming from the microphone__________
    axes(handles.axes7)
    plot(datos);%plots the signal incoming from the microphone.
    title('Incoming Signal from the Microphone');
    ylabel('Relative Amplitude');
%     ylim([-1 1]);
    % _____________________________________________________________________
    % ___Plots the FFT of the audio signal incoming from the microphone____
    axes(handles.axes8)
    Lo=length(datos);
    NFFT = 2^nextpow2(Lo); % Next power of 2 from length of dtos.
    Yo = fft(datos,NFFT)/Lo;
    fo = fsx/2*linspace(0,1,NFFT/2+1);
    plot(fo,2*abs(Yo(1:NFFT/2+1)))
    title('Original Audio Signal Spectrum');
    xlabel('Frequency (Hz)');
    ylabel('Relative Amplitude');
    % _____________________________________________________________________
    % _____________Plots the FFT of the filtered audio signal______________
    axes(handles.axes9)
    sfiltrada=filter(b, a, datos);% The audio signal "datos" is filtered
    %using the function "filter" where we specified the filter transfer
    %function (a=>numerator,b=>denominator) and the incoming signal “datos".
    L=length(sfiltrada);
    NFFT = 2^nextpow2(L);
    Y = fft(sfiltrada,NFFT)/L;
    f = fsx/2*linspace(0,1,NFFT/2+1);
    plot(f,2*abs(Y(1:NFFT/2+1)))
    title('Filtered Audio Signal Spectrum');
    xlabel('Frequency (Hz)');
    ylabel('Relative Amplitude');
    drawnow% flushes the event queue and updates the figure window.
    
end
stop(ca);%Stop the analog input object "ca".
delete(ca);%Delete the analog input object "ca".
guidata(hObject, handles);


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
set(handles.iniciar,'UserData',0);%Set the flag with 0 to stop the acquisition.
set(handles.volver,'Visible','on');%Makes visible "Define Another Filter"
% push button just after "Stop" push button has been clicked.
guidata(hObject, handles);






