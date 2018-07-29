function varargout = waveformm(varargin)
% WAVEFORMM M-file for waveformm.fig
%      WAVEFORMM, by itself, creates a new WAVEFORMM or raises the existing
%      singleton*.
%
%      H = WAVEFORMM returns the handle to a new WAVEFORMM or the handle to
%      the existing singleton*.
%
%      WAVEFORMM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WAVEFORMM.M with the given input arguments.
%
%      WAVEFORMM('Property','Value',...) creates a new WAVEFORMM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before waveformm_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to waveformm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help waveformm

% Last Modified by GUIDE v2.5 21-Jan-2008 06:58:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @waveformm_OpeningFcn, ...
                   'gui_OutputFcn',  @waveformm_OutputFcn, ...
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


% --- Executes just before waveformm is made visible.
function waveformm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to waveformm (see VARARGIN)

% Choose default command line output for waveformm
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes waveformm wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = waveformm_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

s=serial('com1');
fopen(s);

fprintf(s,':measure:fall?')
out1=fscanf(s);
set(handles.text31,'string',out1)

fprintf(s,':measure:frequency?')
out2=fscanf(s);
set(handles.text30,'string',out2)

fprintf(s,':measure:nwidth?')
out3=fscanf(s);
set(handles.text29,'string',out3)

fprintf(s,':measure:pduty?')
out4=fscanf(s);
set(handles.text28,'string',out4)

fprintf(s,':measure:period?')
out5=fscanf(s);
set(handles.text27,'string',out5)

fprintf(s,':measure:pwidth?')
out6=fscanf(s);
set(handles.text26,'string',out6)

fprintf(s,':measure:rise?')
out7=fscanf(s);
set(handles.text25,'string',out7)

fprintf(s,':measure:vamplitude?')
out8=fscanf(s);
set(handles.text24,'string',out8)

fprintf(s,':measure:vaverage?')
out9=fscanf(s);
set(handles.text23,'string',out9)

fprintf(s,':measure:vhi?')
out10=fscanf(s);
set(handles.text22,'string',out10)

fprintf(s,':measure:vlo?')
out11=fscanf(s);
set(handles.text21,'string',out11)

fprintf(s,':measure:vmax?')
out12=fscanf(s);
set(handles.text20,'string',out12)

fprintf(s,':measure:vmin?')
out13=fscanf(s);
set(handles.text19,'string',out13)

fprintf(s,':measure:vpp?')
out14=fscanf(s);
set(handles.text18,'string',out14)

fprintf(s,':measure:vrms?')
out15=fscanf(s);
set(handles.text17,'string',out15)

fclose(s);

out2=out2(1:4)
%out5=out5(1:3)
out8=out8(1:3)

        
out2=str2num(out2)
out2=out2*1000

outt=1/out2
% % out5=str2num(out5)
% % out5=out5*0.000001

out8=str2num(out8)

% %  out2=char(out2)
% %  out5=char(out5)
% %  out8=char(out8)

t=-2:0.01:2;

y=out8*square(2*pi*out2*t)
axis(handles.axes1)
plot(t,y)






% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=serial('com1');
fopen(s);

fprintf(s,':measure:fall?')
out1=fscanf(s);
set(handles.text31,'string',out1)

fprintf(s,':measure:frequency?')
out2=fscanf(s);
set(handles.text30,'string',out2)

fprintf(s,':measure:nwidth?')
out3=fscanf(s);
set(handles.text29,'string',out3)

fprintf(s,':measure:pduty?')
out4=fscanf(s);
set(handles.text28,'string',out4)

fprintf(s,':measure:period?')
out5=fscanf(s);
set(handles.text27,'string',out5)

fprintf(s,':measure:pwidth?')
out6=fscanf(s);
set(handles.text26,'string',out6)

fprintf(s,':measure:rise?')
out7=fscanf(s);
set(handles.text25,'string',out7)

fprintf(s,':measure:vamplitude?')
out8=fscanf(s);
set(handles.text24,'string',out8)

fprintf(s,':measure:vaverage?')
out9=fscanf(s);
set(handles.text23,'string',out9)

fprintf(s,':measure:vhi?')
out10=fscanf(s);
set(handles.text22,'string',out10)

fprintf(s,':measure:vlo?')
out11=fscanf(s);
set(handles.text21,'string',out11)

fprintf(s,':measure:vmax?')
out12=fscanf(s);
set(handles.text20,'string',out12)

fprintf(s,':measure:vmin?')
out13=fscanf(s);
set(handles.text19,'string',out13)

fprintf(s,':measure:vpp?')
out14=fscanf(s);
set(handles.text18,'string',out14)

fprintf(s,':measure:vrms?')
out15=fscanf(s);
set(handles.text17,'string',out15)

fclose(s);

out2=out2(1:4)
%out5=out5(1:3)
out8=out8(1:2)

        
out2=str2num(out2)
out2=out2*1000

outt=1/out2
% % out5=str2num(out5)
% % out5=out5*0.000001

out8=str2num(out8)

% %  out2=char(out2)
% %  out5=char(out5)
% %  out8=char(out8)

t=-2:0.01:2;
y=out8*square(2*pi*out2*t)
axis(handles.axes1)
plot(t,y)




% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close('waveformm')


