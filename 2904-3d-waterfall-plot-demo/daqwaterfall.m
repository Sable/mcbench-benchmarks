function varargout = daqwaterfall(varargin)
% daqwaterfall
%
%  Displays a waterfall plot with data streamed in from the Data
%  Acquisition Toolbox.  This demo was created using Guide in MATLAB 6.5.
%  This demo uses a lot of the code from demoai_fft.
%
%  The input source is hardcoded to channel one of the system soundcard.
%  You should be able to change this if necessary by modifying the
%  parameter in the I N P U T S section of the file daqwaterfall.m
%
% Last Modified by GUIDE v2.5 06-Jan-2003 23:34:34
% Author: Daniel Lee (dlee@mathworks.com)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @daqwaterfall_OpeningFcn, ...
                   'gui_OutputFcn',  @daqwaterfall_OutputFcn, ...
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


% --- Executes just before daqwaterfall is made visible.
function daqwaterfall_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to daqwaterfall (see VARARGIN)

% Choose default command line output for daqwaterfall
handles.output = hObject;

%%%%%%%%%%%%%%%%%%%%%%%
% ++++ I N P U T S ++++  
%%%%%%%%%%%%%%%%%%%%%%%
% Change these settings to select a different source.
handles.adaptor = 'winsound';
handles.id      = 0;
handles.chan    = 1;

handles.samplesPerTrigger = 1024;
handles.sampleRate = 44100;
handles.numTraces = 10;   % number of traces to show in the waterfall.
handles.cycleTime = .9;   % Proportional to the amount of time spent per
                          %  visualization on CycleAll setting.
%%%%%%%%%%%%%%%%%%%%%%%
% ---- I N P U T S ----
%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ++++ S E T U P   T H E   F I G U R E ++++
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*%%%%%%
set(handles.figure1,'Color',get(handles.tTitle,'BackgroundColor'));

axes(handles.axes1);
handles.hLine1 = plot(zeros(1,handles.samplesPerTrigger)'); 
set(handles.hLine1,'Color', [.1 .1 0.5]);
set(handles.axes1,'Color',[235/255 255/255 235/255])
set(handles.axes1,'XGrid','on','YGrid','on')
t=title('Time Domain Signal','Color',[.05 .05 .25],'FontWeight','Bold','FontSize',9);
xlabel('Time (s)','FontSize',8);
ylabel('Voltage (V)','FontSize',8);

axes(handles.axes2);
handles.hLine2 = plot(zeros(1,handles.samplesPerTrigger/2)'); 
set(handles.hLine2,'Color', [.1 0.5 .1]);
set(handles.axes2,'Color',[235/255 255/255 235/255])
set(handles.axes2,'XGrid','on','YGrid','on')
t=title('Frequency Domain Signal','Color',[.05 0.25 .05],'FontWeight','Bold','FontSize',9);
xlabel('Frequency (Hz)','FontSize',8);
ylabel('Magnitude (dB)','FontSize',8);

axes(handles.axes3);
set(handles.axes3,'View',[103 10]);
set(handles.axes3,'Color',[234/255 234/255 255/255]);
grid(handles.axes3,'on');
h = get(handles.axes3,'title');
set(h,'string','Waterfall Plot','FontWeight','Bold','Color',[.25 .05 .05],'FontSize',9);
h = get(handles.axes3,'ylabel');
set(h,'string','Frequency (Hz)','FontSize',8);
h = get(handles.axes3,'zlabel');
set(h,'string','Magnitude (dB)','FontSize',8);

set(hObject,'RendererMode','Manual')  %  If you don't do this, the surface plot
set(hObject,'Renderer','OpenGL')      %    will draw VERY slowly.

set(handles.tSource,'String',sprintf('%s:%d',handles.adaptor,handles.id));
set(handles.tChannel,'String',num2str(handles.chan));
set(handles.poSampleRate,'String',[{'44100'},{'22000'},{'8000'}]);
set(handles.poPlotType,'String',[{'CycleAll'},{'Classic'},{'Classic(Top)'},{'Mosaic'},{'Waterfall'},{'Rotate'}]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---- S E T U P   T H E   F I G U R E ----
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ++++ D R A W  T H E  L O G O ++++
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L = 40*membrane(1,25);
axes(handles.axes4);
set(handles.axes4,...
    'CameraPosition', [-193.4013 -265.1546  220.4819],...
    'XLim',[1 51], ...
    'YLim',[1 51], ...
    'Visible','off', ...
    'ZLim',[-13 40]);

s = surface(L, ...
    'EdgeColor','none', ...
    'FaceColor',[0.9 0.2 0.2], ...
    'FaceLighting','phong', ...
    'AmbientStrength',0.3, ...
    'DiffuseStrength',0.6, ... 
    'Clipping','off',...
    'BackFaceLighting','lit', ...
    'SpecularStrength',1.1, ...
    'SpecularColorReflectance',1, ...
    'SpecularExponent',7);
l1 = light('Position',[40 100 20], ...
    'Style','local', ...
    'Color',[0 0.8 0.8]);
l2 = light('Position',[.5 -1 .4], ...
    'Color',[0.8 0.8 0]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---- D R A W  T H E  L O G O ----
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ai=localSetupAI(handles);
handles.ai = ai;

% Update handles structure
guidata(hObject, handles);

localStartAI(ai);

% UIWAIT makes daqwaterfall wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function localStartAI(ai)
%%%%%%%%%%%%%%%%%%%%%%%%%%
% ++++ S T A R T  A I ++++
%%%%%%%%%%%%%%%%%%%%%%%%%%
start(ai);
trigger(ai);
%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---- S T A R T  A I ----
%%%%%%%%%%%%%%%%%%%%%%%%%%


function localStopAI(ai)
%%%%%%%%%%%%%%%%%%%%%%%%
% ++++ S T O P  A I ++++
%%%%%%%%%%%%%%%%%%%%%%%%
stop(ai);
delete(ai);
%%%%%%%%%%%%%%%%%%%%%%%%
% ---- S T O P  A I ----
%%%%%%%%%%%%%%%%%%%%%%%%


function ai=localSetupAI(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ++++ S E T U P   T H E   A N A L O G   I N P U T ++++
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Object Configuration.
% Create an analog input object with one channel.
ai = analoginput(handles.adaptor, handles.id);
addchannel(ai, handles.chan);

% Configure the callback to update the display.
set(ai, 'TimerFcn', @localfftShowData);

% Configure the analog input object.
set(ai, 'SampleRate', handles.sampleRate);

% Configure the analog input object to trigger manually twice.
%  We do this because we are using peekdata to acquire the data in
%   a timer callback function.
%  The first trigger will fill the buffer with handles.samplesPerTrigger
%   number of samples.  We'll know we have enough samples to start 
%   processing data when the analog input object's SamplesAvailable property
%   is equal to handles.samplesPerTrigger.
%  The analog input object will then wait for 
%   another manual trigger, and while it is waiting the object will still be 
%   in its running state, which means the timer event will run. To keep the
%   object in the running state, we need only never manually trigger this
%   second trigger.  
%  Had we set the TriggerRepeat to 0, the analog input object would stop 
%   after the first trigger and the timer functions would stop running.
%
set(ai, 'SamplesPerTrigger', handles.samplesPerTrigger);
set(ai, 'TriggerRepeat', 1);
set(ai, 'TriggerType', 'manual');

% Initialize callback parameters.  The TimerAction is initialized 
% after figure has been created.
set(ai, 'TimerPeriod', 0.01);  
set(ai, 'BufferingConfig',[handles.samplesPerTrigger*2,20]);

% Initialize time and frequency plots with lines of y=0
d=zeros(1,handles.samplesPerTrigger);
time = 1:handles.samplesPerTrigger;
f=1:handles.samplesPerTrigger/2;
mag=zeros(1,handles.samplesPerTrigger/2);

% Store state information in the analog input objects UserData area.
data.storedFFTsIndex = 1;
data.plotSurf        = 0;
data.ai              = ai;
data.getdata         = [d time];
data.daqfft          = [f mag];
data.handle          = [];
data.figureHandles   = handles;
data.view            = [103 10];
data.rotateStep      = 4;
data.counter         = 0;

% Set the object's UserData to data.
set(data.ai, 'UserData', data);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---- S E T U P   T H E   A N A L O G   I N P U T ----
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Outputs from this function are returned to the command line.
function varargout = daqwaterfall_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbExit or when you press
%     the figure close 'X' button (I set this function to
%     the figures CloseRequestFcn in GUIDE).
function pbExit_Callback(hObject, eventdata, handles)
% hObject    handle to pbExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
localStopAI(handles.ai);
closereq;


% --- Executes during object creation, after setting all properties.
function poSampleRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to poSampleRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ++++ C H A N G E   T H E   S A M P L E   R A T E  ++++
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in poSampleRate.
function poSampleRate_Callback(hObject, eventdata, handles)

% hObject    handle to poSampleRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns poSampleRate contents as cell array
%        contents{get(hObject,'Value')} returns selected item from poSampleRate

% First, stop and delete the current analog input object
localStopAI(handles.ai);

% Extract the new samplerate.
v=get(handles.poSampleRate,'Value');
s=get(handles.poSampleRate,'String');
handles.sampleRate = str2num(s{v});

% Create a new analog input with the new sample rate.
handles.ai = localSetupAI(handles);

% Update handles structure
guidata(hObject, handles);

% Restart the analog input
localStartAI(handles.ai);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---- C H A N G E   T H E   S A M P L E   R A T E  ----
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% ***********************************************************************  
% Calculate the fft of the data.  (Copied from demoai_fft.m)
function [f, mag] = localDaqfft(data,Fs,blockSize)

% Calculate the fft of the data.
xFFT = fft(data);
xfft = abs(xFFT);

% Avoid taking the log of 0.
index = find(xfft == 0);
xfft(index) = 1e-17;

mag = 20*log10(xfft);
mag = mag(1:blockSize/2);

f = (0:length(mag)-1)*Fs/blockSize;
f = f(:);


% ***********************************************************************  
% Update the plot. This routine is a Timer callback, it is called
%  automatically at a preset time interval. See line 184 for where
%  this routine is assigned as a callback
function localfftShowData(obj,event)

if (get(obj,'SamplesAvailable') >= obj.SamplesPerTrigger)
	
	% Get the handles.
	data = obj.UserData;
	
	handles = data.figureHandles;
	
	% Execute a peekdata.
	x = peekdata(obj, obj.SamplesPerTrigger);
	
	% FFT calculation.
	Fs = obj.SampleRate;
	blockSize = obj.SamplesPerTrigger;
	[f,mag] = localDaqfft(x,Fs,blockSize);
	
	% Dynamically modify Analog axis as we go.
	maxX=max(x);
	minX=min(x);
	yax1=get(handles.axes1,'YLim');
	yax1(1)=minX - .0001; % need to subtract a value to make sure yax(1) never equals yax(2)
	yax1(2)=maxX + .0001; 
	set(handles.axes1,'YLim',yax1)
	set(handles.axes1,'XLim',[0 (obj.SamplesPerTrigger-1)/obj.SampleRate])
	
	% Dynamically modify Frequency axis as we go.
	maxF=max(f);
	minF=min(f);
	xax=get(handles.axes2,'XLim');
    xax(1)=minF;
    xax(2)=maxF;
	set(handles.axes2,'XLim',xax)
	
	% Dynamically modify Magnitude axis as we go.
	maxM=max(mag);
	minM=min(mag);
	yax2=get(handles.axes2,'YLim');
	yax2(1)=minM - .0001;
	yax2(2)=maxM + .0001;
	set(handles.axes2,'YLim',yax2)
	
	% Update the line plots.
	set(handles.hLine1, 'XData', [0:(obj.SamplesPerTrigger-1)]/obj.SampleRate, 'YData', x(:,1));
	set(handles.hLine2, 'XData', f(:,1), 'YData', mag(:,1));

    % Find the frequency at which the max signal strength is at.
    [ymax,maxindex] = max(mag);
    set(handles.tFreq,'String',sprintf('%4.1d Hz',f(maxindex)));
    
    % Store the current FFT into the array of FFTs used for the waterfall.
	data.storedFFTs(data.storedFFTsIndex,:) = mag';
	
    % This circular shift is used so that when we display the 3D plot, the 
    %  newest FFT will appear in 'front' and the oldest in 'back'. 
    % To understand this, note how the plotting routines are using this fftOrder 
    %  array to reorder the FFTs stored in data.storedFFTs and also note
    %  how data.storedFFTsIndex is used to store FFTs in data.storedFFTs.
    %
	fftOrder = 1:handles.numTraces;
	fftOrder = circshift(fftOrder,[ 1 -data.storedFFTsIndex ]);  
	
	data.storedFFTsIndex = data.storedFFTsIndex + 1;
	if (data.storedFFTsIndex > handles.numTraces)
        data.storedFFTsIndex = 1;
        data.plotSurf        = 1; % Indicates a full history is stored.
	end
	
	% Update the surface plot if we have a full history.
	if (data.plotSurf)
        cla(handles.axes3);

        v=get(handles.poPlotType,'Value');
        s=get(handles.poPlotType,'String');
        switch s{v}
            case 'Classic'
                data.view  = [103 30];
                data=localClassic(handles,data,f,fftOrder);
            case 'Classic(Top)'
                data.view  = [90 -90];
                data=localClassic(handles,data,f,fftOrder);
            case 'Mosaic'
                data.view  = [90 -90];
                data=localMosaic(handles,data,f,fftOrder);
            case 'Waterfall'
                data.view = [103 30];
                data=localWaterfall(handles,data,f,fftOrder,yax2);
            case 'Rotate'
                data=localRotate(handles,data,f,fftOrder);
            case 'CycleAll'
                data=localCycleAll(handles,data,f,fftOrder);
        end
                
    end
	
	set(data.ai, 'UserData', data);
	
	drawnow;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ++++ V I S U A L I Z A T I O N ++++
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data=localClassic(handles,data,f,fftOrder)
    [X,Y] = meshgrid(1:handles.numTraces,f(1:end));
    surf(X,Y,data.storedFFTs(fftOrder,:)','parent',handles.axes3);                
  	set(handles.axes3,'XLim',[1 handles.numTraces],'YLim',[0 f(end)])
    shading(handles.axes3,'interp');
    set(handles.axes3,'View',data.view)

function data=localMosaic(handles,data,f,fftOrder)
    [X,Y] = meshgrid(1:handles.numTraces,f(1:10:end));
    surf(X,Y,data.storedFFTs(fftOrder,(1:10:end))','parent',handles.axes3);
  	set(handles.axes3,'XLim',[1 handles.numTraces],'YLim',[0 f(end)])
    set(handles.axes3,'View',data.view)
       
function data=localWaterfall(handles,data,f,fftOrder,yax2)
    [X,Y] = meshgrid(1:handles.numTraces,f(1:end));
    p=plot3(X,Y,data.storedFFTs(fftOrder,:)','parent',handles.axes3);                

    % rotate the color map of the lines in the plot3
    map  = linspace(0,1,handles.numTraces);
    map2 = linspace(1,0,handles.numTraces);
    rotatemap  = map(fftOrder);
    rotatemap2 = map2(fftOrder);
    for k=1:handles.numTraces;
        set(p(k),'Color',[rotatemap(k) .1 rotatemap2(k)]);
    end
    
  	set(handles.axes3,'XLim',[1 handles.numTraces],'YLim',[0 f(end)]);
    shading(handles.axes3,'interp');
    set(handles.axes3,'View',data.view)

function data=localRotate(handles,data,f,fftOrder)
    [X,Y] = meshgrid(1:handles.numTraces,f(1:8:end));
    surf(X,Y,data.storedFFTs(fftOrder,(1:8:end))','parent',handles.axes3);
  	set(handles.axes3,'XLim',[1 handles.numTraces],'YLim',[0 f(end)])
    set(handles.axes3,'View',data.view)
    
    % Rotate the view point.
    data.view(1) = 90;
    if data.view(2) >= 90-data.rotateStep
        data.rotateStep = -4;
    elseif data.view(2) <= -90-data.rotateStep
        data.rotateStep = 4;
    end    
    data.view(2) = data.view(2)+data.rotateStep;    

function data=localCycleAll(handles,data,f,fftOrder)
    data.counter = data.counter + get(data.ai,'TimerPeriod');
    if data.counter > 5*handles.cycleTime
        data.counter = 0;
    elseif data.counter > 4*handles.cycleTime
        data=localRotate(handles,data,f,fftOrder);
    elseif data.counter > 3*handles.cycleTime
        data.view  = [103 30];
        data=localWaterfall(handles,data,f,fftOrder);
    elseif data.counter > 2*handles.cycleTime
        data.view  = [90 -90];
        data=localMosaic(handles,data,f,fftOrder);
    elseif data.counter > 1*handles.cycleTime
        data.view  = [90 -90];
        data=localClassic(handles,data,f,fftOrder);
    else
        data.view  = [103 30];
        data=localClassic(handles,data,f,fftOrder);
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---- V I S U A L I Z A T I O N ----
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% --- Executes during object creation, after setting all properties.
function poPlotType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to poPlotType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in poPlotType.
function poPlotType_Callback(hObject, eventdata, handles)
% hObject    handle to poPlotType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns poPlotType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from poPlotType
