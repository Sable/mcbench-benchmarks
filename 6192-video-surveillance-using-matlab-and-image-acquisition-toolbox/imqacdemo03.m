function varargout = imqacdemo03(varargin)
% IMQACDEMO03 M-file for imqacdemo03.fig
%      IMQACDEMO03, by itself, creates a new IMQACDEMO03 or raises the existing
%      singleton*.
%
%      H = IMQACDEMO03 returns the handle to a new IMQACDEMO03 or the
%      handle to
%      the existing singleton*.
%
%      IMQACDEMO03('CALLBACK',hObject,eventData,handles,...) calls the
%      local
%      function named CALLBACK in IMQACDEMO03.M with the given input arguments.
%
%      IMQACDEMO03('Property','Value',...) creates a new IMQACDEMO03 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imqacdemo03_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imqacdemo03_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help imqacdemo03

% Last Modified by GUIDE v2.5 23-Jul-2004 12:45:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imqacdemo03_OpeningFcn, ...
                   'gui_OutputFcn',  @imqacdemo03_OutputFcn, ...
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


% --- Executes just before imqacdemo03 is made visible.
function imqacdemo03_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imqacdemo03 (see VARARGIN)


handles.output = hObject;
Monitor_Mode(hObject, eventdata, handles);
S = imread('autumn.tif');
handles.S = S;
axes(handles.axes1);
subimage(S);
S2 = imread('autumn.tif');
axes(handles.axes2);
subimage(S2);
handles.S2 = S2;
guidata(hObject, handles);

% UIWAIT makes imqacdemo03 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = imqacdemo03_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pbStart.
function pbStart_Callback(hObject, eventdata, handles)
% hObject    handle to pbStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'outdata')
    handles = rmfield(handles,'outdata');
end
guidata(hObject, handles);
set(handles.pbStart,'enable','off');
set(handles.pbStop,'enable','on');

set(handles.pbStop,'UserData',0);

vid = videoinput('winvideo');
handles.vid = vid;
set(handles.vid,'FramesPerTrigger',1);
set(handles.vid,'TriggerRepeat',Inf);
triggerconfig(handles.vid, 'Manual');

guidata(hObject, handles);

start(handles.vid);
trigger(handles.vid);
y = (getdata(handles.vid,1,'uint8'));
cnt_move = 0;
cnt_unmove = 0;
cntsnap = 1;
while 1
    trigger(handles.vid);
    yprev = y;
    set(handles.editTime,'string',datestr(clock));
    if get(handles.pbStop,'UserData')
        break
    else
        y = (getdata(handles.vid,1,'uint8'));
        diff = abs(y-yprev);
        abs_img = mean(diff(:));
        set(handles.editAbs,'string',abs_img);
        axes(handles.axes1);subimage(y);
        axes(handles.axes2);subimage(diff);
        out = imaqmem;
        mem_left = out.FrameMemoryLimit - out.FrameMemoryUsed;
        set(handles.editMemLeft,'string',mem_left/10^6);
        set(handles.editMemLoad,'string',out.MemoryLoad);
        if abs_img > str2num(get(handles.editThresh,'string'));
            cnt_move = cnt_move + 1;
            set(handles.editObj,'string',cnt_move);
            if cnt_move >= str2num(get(handles.editSnapCnt,'string'));
                handles.outdata.image(:,:,:,cntsnap) = y;
                handles.outdata.time{cntsnap} = datestr(clock);
                cntsnap = cntsnap + 1;
                cnt_move = 0;
                set(handles.editSnap,'string',cntsnap-1);
            end
            cnt_unmove = 0;
        else
            cnt_unmove = cnt_unmove + 1;
            cnt_move = 0;
            set(handles.editObj,'string',cnt_move);
        end
        
        
    end
end


axes(handles.axes1);
cla;
subimage(handles.S);
axes(handles.axes2);
cla;
subimage(handles.S2);
delete(handles.vid);
clear handles.vid;
imaqreset;     
guidata(hObject, handles);


% --- Executes on button press in pbStop.
function pbStop_Callback(hObject, eventdata, handles)
% hObject    handle to pbStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.pbStart,'enable','on');
set(handles.pbStop,'enable','off');

set(handles.pbStop,'UserData',1);
set(handles.pbStop,'UserData',1);
set(handles.pbStop,'UserData',1);
set(handles.pbStop,'UserData',1);
set(handles.pbStop,'UserData',1);
guidata(hObject, handles);





function editAbs_Callback(hObject, eventdata, handles)
% hObject    handle to editAbs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAbs as text
%        str2double(get(hObject,'String')) returns contents of editAbs as a double


% --- Executes during object creation, after setting all properties.
function editAbs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAbs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function editMemLeft_Callback(hObject, eventdata, handles)
% hObject    handle to editMemLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMemLeft as text
%        str2double(get(hObject,'String')) returns contents of editMemLeft as a double


% --- Executes during object creation, after setting all properties.
function editMemLeft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMemLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function editMemLoad_Callback(hObject, eventdata, handles)
% hObject    handle to editMemLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMemLoad as text
%        str2double(get(hObject,'String')) returns contents of editMemLoad as a double


% --- Executes during object creation, after setting all properties.
function editMemLoad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMemLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end





function editThresh_Callback(hObject, eventdata, handles)
% hObject    handle to editThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editThresh as text
%        str2double(get(hObject,'String')) returns contents of editThresh as a double


% --- Executes during object creation, after setting all properties.
function editThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function editObj_Callback(hObject, eventdata, handles)
% hObject    handle to editObj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editObj as text
%        str2double(get(hObject,'String')) returns contents of editObj as a double


% --- Executes during object creation, after setting all properties.
function editObj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editObj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function editSnap_Callback(hObject, eventdata, handles)
% hObject    handle to editSnap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSnap as text
%        str2double(get(hObject,'String')) returns contents of editSnap as a double


% --- Executes during object creation, after setting all properties.
function editSnap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSnap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on button press in pbPlay.
function pbPlay_Callback(hObject, eventdata, handles)
% hObject    handle to pbPlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'value'))

    set(hObject,'string','Play');
    recorded_data = handles.outdata;
    sz = size(recorded_data.image);
    frm_num = sz(4);
    cntstart = round(get(handles.sldFrame,'value'));

    for cnt = cntstart:frm_num
        axes(handles.axes1);
        subimage(recorded_data.image(:,:,:,cnt));
        axes(handles.axes2);
        St = edge(rgb2gray(recorded_data.image(:,:,:,cnt)));
        subimage(St);
        set(handles.sldFrame,'value',cnt);
        set(handles.editTime2,'string',recorded_data.time{cnt});
        set(handles.txtCurrent,'string',cnt);   
        
        if ~(get(hObject,'value'))
            break
        end
        pause(0.01);
    end
else
    set(hObject,'string','Pause');
end
set(hObject,'value',0);
set(hObject,'string','Pause');

function editTime_Callback(hObject, eventdata, handles)
% hObject    handle to editTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTime as text
%        str2double(get(hObject,'String')) returns contents of editTime as a double


% --- Executes during object creation, after setting all properties.
function editTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on slider movement.
function sldFrame_Callback(hObject, eventdata, handles)
% hObject    handle to sldFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% 

recorded_data = handles.outdata;
cnt = round(get(handles.sldFrame,'value'));
set(handles.sldFrame,'value',cnt)

axes(handles.axes1);
subimage(recorded_data.image(:,:,:,cnt));
axes(handles.axes2);
St = edge(rgb2gray(recorded_data.image(:,:,:,cnt)));
subimage(St);
set(handles.editTime2,'string',recorded_data.time{cnt});
set(handles.txtCurrent,'string',cnt);







% --- Executes during object creation, after setting all properties.
function sldFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldFrame (see GCBO)
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





function editTime2_Callback(hObject, eventdata, handles)
% hObject    handle to editTime2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTime2 as text
%        str2double(get(hObject,'String')) returns contents of editTime2 as a double


% --- Executes during object creation, after setting all properties.
function editTime2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTime2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end





function editSnapCnt_Callback(hObject, eventdata, handles)
% hObject    handle to editSnapCnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSnapCnt as text
%        str2double(get(hObject,'String')) returns contents of editSnapCnt as a double


% --- Executes during object creation, after setting all properties.
function editSnapCnt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSnapCnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Monitor_Mode(hObject, eventdata, handles)
set(handles.pbStart,'enable','on');
set(handles.pbStop,'enable','off');
set(handles.pbPlay,'enable','off');
set(handles.sldFrame,'enable','off');
set(handles.txtMin,'enable','off');
set(handles.txtMax,'enable','off');
set(handles.txtCurrent,'enable','off');

function PlayBack_Mode(hObject, eventdata, handles)
set(handles.pbStart,'enable','off');
set(handles.pbStop,'enable','off');
set(handles.pbPlay,'enable','on');
set(handles.sldFrame,'enable','on');
set(handles.txtMin,'enable','on');
set(handles.txtMax,'enable','on');
set(handles.txtCurrent,'enable','on');


% % --------------------------------------------------------------------
% function modeSelect_SelectionChangeFcn(hObject, eventdata, handles)
% % hObject    handle to modeSelect (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% if get(handles.radioMonitor,'Value')==1
%     Monitor_Mode(hObject, eventdata, handles);
% else
%     PlayBack_Mode(hObject, eventdata, handles);
% end



% --- Executes on button press in radioMonitor.
function radioMonitor_Callback(hObject, eventdata, handles)
% hObject    handle to radioMonitor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radioMonitor

selected_mode = 1;
set(hObject,'value',selected_mode);
set(handles.radioPlayBack,'value',~selected_mode);
Monitor_Mode(hObject, eventdata, handles);


% --- Executes on button press in radioPlayBack.
function radioPlayBack_Callback(hObject, eventdata, handles)
% hObject    handle to radioPlayBack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radioPlayBack
selected_mode = 1;
set(hObject,'value',selected_mode);
set(handles.radioMonitor,'value',~selected_mode);

recorded_data = handles.outdata;
sz = size(recorded_data.image);
frm_num = sz(4);

set(handles.sldFrame,'min',1);
set(handles.sldFrame,'max',frm_num);
set(handles.sldFrame,'SliderStep',[1/frm_num 5/frm_num]);
set(handles.txtMin,'string',1);
set(handles.txtMax,'string',frm_num);

set(handles.sldFrame,'value',1);
PlayBack_Mode(hObject, eventdata, handles);


