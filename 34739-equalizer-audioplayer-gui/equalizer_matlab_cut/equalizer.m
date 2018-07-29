function varargout = equalizer(varargin)
% EQUALIZER MATLAB code for equalizer.fig
%      EQUALIZER, by itself, creates a new EQUALIZER or raises the existing
%      singleton*.
%
%      H = EQUALIZER returns the handle to a new EQUALIZER or the handle to
%      the existing singleton*.
%
%      EQUALIZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EQUALIZER.M with the given input arguments.
%
%      EQUALIZER('Property','Value',...) creates a new EQUALIZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before equalizer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to equalizer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help equalizer

% Last Modified by GUIDE v2.5 13-Jan-2012 17:19:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @equalizer_OpeningFcn, ...
                   'gui_OutputFcn',  @equalizer_OutputFcn, ...
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


% --- Executes just before equalizer is made visible.
function equalizer_OpeningFcn(hObject, eventdata, handles, varargin)
global s Fs
global g1 g2 n hs
global po
global pla pau
global hdls
global vol
global Q f filts_type
global hp hpp

% g1 g2 limits og gains
% po buffer size in seconds


% s - signal
% Fs - sampling frequency
% g1 g2 limits og gains
% po buffer size in seconds


% Choose default command line output for equalizer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

hdls=handles; % save all handles to global variable

% UIWAIT makes equalizer wait for user response (see UIRESUME)
% uiwait(handles.figure1);

g1=-10;
g2=10;
n=10; % mber of sliders
f=[60  170 310  600 1e3 3e3   6e3  12e3  14e3  16e3]; % frequencyes
%f=0.7*exp(1:10);
%f=24*exp(1:6);
% f=[43 118  321 873 2374 6454 17540];
% f=[60  310  600 1e3   6e3  12e3   16e3]; % frequencyes
Q=1*ones(1,n); % Q-factors
filts_type=[1 2*ones(1,n-2) 3]; % filt types: 1-low shelving, 2-peak, 3-high shelving

po=0.2; % buffers size, seconds
pla=false; % true if play
pau=false; % true if pause

vol=0.7; % volume
ps=get(handles.szg,'position');
pu=get(handles.szg,'units');

sz=ps(4);

set(handles.vol,'value',vol);

hp=semilogx(NaN,NaN,'r-','parent',handles.axes1);
set(handles.axes1,'NextPlot','add');
hpp=semilogx(NaN,NaN,'ok','parent',handles.axes1);
xlabel(handles.axes1,'frequrency, Hz');
ylabel(handles.axes1,'gain, dB');



pg1=get(handles.g1,'position');
pg2=get(handles.g2,'position');
szy=pg2(2)-pg1(2);

x=ps(1)+sz;
y=ps(2)-1*sz-szy;

pa=get(handles.axes1,'position');
sxa=pa(3);

hs=zeros(1,n);

for nc=1:n
    hs(nc)=uicontrol('Style', 'slider',...
            'Min',g1,'Max',g2,'Value',0,...
            'units',pu,...
            'Position', [x y 1.5*sz szy],...
            'Callback', 'recalculate_filter;'); 
        
    x=x+sxa/n;
end

Fs=44100;
recalculate_filter;





% --- Outputs from this function are returned to the command line.
function varargout = equalizer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function file_Callback(hObject, eventdata, handles)
fln=get(handles.file,'string');
set(handles.reading,'visible','on');
drawnow;
read_audio(fln);
set(handles.reading,'visible','off');
drawnow;


% --- Executes during object creation, after setting all properties.
function file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
[FileName,PathName,FilterIndex] = uigetfile({'*.mp3;*.wav;*.wma;*.avi;*.mpg','media files (*.mp3,*.wav,*.wma,*.avi,*.mpg)';'*.*',  'All Files (*.*)'},'File Selector') ;
isok=true;
if length(FileName)==1
     if FileName==0
         isok=false;
     end
end
if isok
    fln=[PathName FileName];
    set(handles.file,'string',fln);
    set(handles.reading,'visible','on');
    drawnow;
    read_audio(fln);
    set(handles.reading,'visible','off');
    drawnow;
    
end




% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% disp('slider releized');


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function vol_Callback(hObject, eventdata, handles)
% hObject    handle to vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global vol
vol=get(hObject,'Value');



% --- Executes during object creation, after setting all properties.
function vol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in szg.
function szg_Callback(hObject, eventdata, handles)
global n hs
for nc=1:n
    set(hs(nc),'value',0);
end
drawnow;
recalculate_filter;


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
open_device;


% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
global pau
pau=~pau;
if pau
    set(handles.pause,'string','Unpause');
    drawnow;
else
    set(handles.pause,'string','Pause');
    drawnow;
end


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
global pla
pla=false;


% --- Executes on button press in sset.
function sset_Callback(hObject, eventdata, handles)
global po pso pco s
L=size(s,1);
v=get(handles.slider1,'value');
pco=round(v*L/pso);
if pco<1
    pco=1;
end
