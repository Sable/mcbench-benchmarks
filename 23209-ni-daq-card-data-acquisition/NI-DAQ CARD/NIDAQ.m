function varargout = NIDAQ(varargin)
% NIDAQ M-file for NIDAQ.fig
%      NIDAQ, by itself, creates a new NIDAQ or raises the existing
%      singleton*.
%
%      H = NIDAQ returns the handle to a new NIDAQ or the handle to
%      the existing singleton*.
%
%      NIDAQ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NIDAQ.M with the given input arguments.
%
%      NIDAQ('Property','Value',...) creates a new NIDAQ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NIDAQ_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NIDAQ_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NIDAQ

% Last Modified by GUIDE v2.5 06-Mar-2009 10:32:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NIDAQ_OpeningFcn, ...
                   'gui_OutputFcn',  @NIDAQ_OutputFcn, ...
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


% --- Executes just before NIDAQ is made visible.
function NIDAQ_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NIDAQ (see VARARGIN)

% Choose default command line output for NIDAQ
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NIDAQ wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NIDAQ_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clc

ai = analoginput('nidaq','Dev1');           % Defining an analog object

ch = get(handles.edit1,'String');         % Determining number of channels
chann = str2double (ch);
addchannel(ai,1:chann);

dur = get(handles.edit2,'String');          % Duration of session
duration = str2double (dur);
    
sr = get(handles.edit3,'String');           % Sampling Rate
sprate = str2double (sr);
set (ai,'SampleRate',sprate);
actual = get(ai,'SampleRate');

set(ai,'SamplesPerTrigger',duration*actual);    % Samples Per Trigger

h = waitbar (0,'Please wait... ');

start(ai);  
data = getdata(ai);

for i=1:1000                                % Wait bar definition
    waitbar(i/1000,h); 
end
close(h);

fid = fopen ('data.txt','w');
fprintf (fid, 'Data and Time \t\t%s',datestr(now));
fprintf (fid, '\n\n ================================================= ');
fprintf (fid, '\n\t DATA ACQUISITION BY NIDAC CARD');
fprintf (fid, '\n ================================================= \n\n');

[r,c]=size(data);
for n = 1:c
    fprintf (fid,' Channel %d\t',n);
end
fprintf (fid,'\n');
for i=1:r
    fprintf(fid,'%s\n',num2str(data(i,:)));
end

fclose (fid);

for m =1:c
    figure,plot(data(:,m)),title(sprintf('Data from Channel %d', m));
end
delete (ai);

clear all

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


