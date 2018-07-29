function varargout = TakeVideoAndPlayMovie(varargin)
% This program uses Image Acquisition toolbox to take video at any time
% length as user defined.  The function imaqtool has the limitation in taking
% long duration videos.  
% By Jax Cao 
% February 2008

% TAKEVIDEOANDPLAYMOVIE M-file for TakeVideoAndPlayMovie.fig
%      TAKEVIDEOANDPLAYMOVIE, by itself, creates a new TAKEVIDEOANDPLAYMOVIE or raises the existing
%      singleton*.
%
%      H = TAKEVIDEOANDPLAYMOVIE returns the handle to a new TAKEVIDEOANDPLAYMOVIE or the handle to
%      the existing singleton*.
%
%      TAKEVIDEOANDPLAYMOVIE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TAKEVIDEOANDPLAYMOVIE.M with the given input arguments.
%
%      TAKEVIDEOANDPLAYMOVIE('Property','Value',...) creates a new TAKEVIDEOANDPLAYMOVIE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TakeVideoAndPlayMovie_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TakeVideoAndPlayMovie_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TakeVideoAndPlayMovie

% Last Modified by GUIDE v2.5 24-Feb-2008 21:31:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TakeVideoAndPlayMovie_OpeningFcn, ...
                   'gui_OutputFcn',  @TakeVideoAndPlayMovie_OutputFcn, ...
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


% --- Executes just before TakeVideoAndPlayMovie is made visible.
function TakeVideoAndPlayMovie_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TakeVideoAndPlayMovie (see VARARGIN)

% Choose default command line output for TakeVideoAndPlayMovie
delete('*asv');
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TakeVideoAndPlayMovie wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TakeVideoAndPlayMovie_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in MovieSetupPushButton.
function MovieSetupPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to MovieSetupPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Choose default command line output for TakeVideoAndPlayMovie
% This function determine which device is available and return appropriate
% paramters

% determine the camera divice ID
imaqreset;
infom = imaqhwinfo;
for k = 1:length(infom.InstalledAdaptors)
    info = imaqhwinfo(infom.InstalledAdaptors{k});
    if ~isempty(info.DeviceIDs)
        Installedadaptor = infom.InstalledAdaptors{k};
        break;
    end
end

if ~exist('Installedadaptor', 'var')
    h = warndlg('Video camera not connected !','!! Warning !!', 'replace');
    pause (5); 
    if ishandle(h), close (h); end; beep;
    return;
end

% user input camera and video directory
prompt={'Enter the video directory name:',...
        'Enter the video filename prefix:', ...
        'Enter the video total length (seconds): ', ...
        'Enter the adaptorname: ', ...
        'Enter the frames per trigger: ', ...
        'Enter the time length (seconds) for each section', ...
        'Enter the device ID (the maximum should be the total number of cameras connected): '};
name='Input for video setup';
numlines=1;
defaultanswer={'c:/tempfiles/videotest/','myvedio', '400', Installedadaptor, '1500', ...
    '10', '1'};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer=inputdlg(prompt,name,numlines,defaultanswer, options);


handles.loopnumber = ceil(str2double(answer{3})/str2double(answer{6}));
handles.directory = answer{1};
handles.filenameprefix = answer{2}; 
handles.adaptorname = answer{4};
handles.framepertrigger = str2double(answer{5});
handles.sectiontime = str2double(answer{6});
handles.deviceID = str2double(answer{7});
if ~exist(handles.directory , 'dir')
    mkdir(handles.directory); 
else
    rmdir(handles.directory, 's');
    mkdir(handles.directory); 
end;

info = imaqhwinfo(answer{4}, handles.deviceID);
[s,v] = listdlg('PromptString','Select a format:',...
    'SelectionMode','single',...
    'ListString',info.SupportedFormats);

if v 
    handles.format = info.SupportedFormats{s}; 
else
    h = warndlg('Video format not selected, redo the work','!! Warning !!');
    pause (5); 
    if ishandle(h), close (h); end;
end
            


beep;

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% --- Executes on button press in TakeVideoPushButton.
function TakeVideoPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to TakeVideoPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Choose default command line output for TakeVideoAndPlayMovie

if ~isfield(handles, 'format')
    h = warndlg('Video setting is not ready,  redo it','!! Warning !!');
    pause (5); 
    if ishandle(h), close (h); end;
    beep;  return;
end

if isfield(handles, 'vid')
    h = warndlg('Video in preview mode stop preview first!','!! Warning !!');
    pause (5); 
    if ishandle(h), close (h); end;
    beep; return;
end

% the following sections takes video according to the time specified by the
% user
k = 1;
while 1
    my_log = [handles.directory  handles.filenameprefix num2str(k) '.avi'];
    aviobj = avifile(my_log, 'compression', 'None');
    
    vid = videoinput(handles.adaptorname,handles.deviceID, handles.format);    
    vid.LoggingMode = 'disk&memory';
    vid.DiskLogger = aviobj;
    vid.TriggerRepeat = Inf;    
    set(vid,'FramesPerTrigger', handles.framepertrigger)
    
    start(vid);
    pause (handles.sectiontime)
    aviobj = close(vid.DiskLogger);  
    flushdata(vid)
    delete(vid); clear vid;
    clear my_log;
    
    k = k +1;
    if k > handles.loopnumber, break; end;
end

beep;
% update handles
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in PlayMoviePushButton.
function PlayMoviePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to PlayMoviePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% This function plays the recorded videos.  However, it is recommended to
% use the windows movie maker to play the number of recorded videos
% exceeding 5.

if ~isfield(handles, 'format')
    h = warndlg('Video setting is not ready, redo it','!! Warning !!');
    pause (5); 
    if ishandle(h), close (h); end;
    beep; return;
end

if isempty(ls([handles.directory, '*avi']))
    h = warndlg('Video not take yet, take video first!!!','!! Warning !!');
    pause (5); 
    if ishandle(h), close (h); end;
    beep; return;
end

h = warndlg(['May be very slow, and it is suggested using Windows Move Maker' ...
    'to view the movie over 30 seconds!!'],'!! Warning !!');
pause (5); 
if ishandle(h), close (h); end;

axes(handles.movieshow)
% mov = cell(1, loopnumber);
for k=1:handles.loopnumber
    mov = aviread([handles.directory  handles.filenameprefix num2str(k) '.avi']);    
    movie(mov);
    clear mov
end

beep;


% --- Executes on button press in Previewpushbutton.
function Previewpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Previewpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles, 'format')
    h = warndlg('Video setting is not ready,  redo it','!! Warning !!');
    pause (5); 
    if ishandle(h), close (h); end;
    beep;     return;
end

handles.vid = videoinput(handles.adaptorname,handles.deviceID, handles.format);

% update handles
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

vidRes = get(handles.vid, 'VideoResolution');
nBands = get(handles.vid, 'NumberOfBands');
hImage = image( zeros(vidRes(2), vidRes(1), nBands) );
preview(handles.vid, hImage);

beep;




% --- Executes on button press in StopPreviewpushbutton.
function StopPreviewpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to StopPreviewpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function stops the video preview
if ~isfield(handles, 'format') || ~isfield(handles, 'vid')
    h = warndlg('Video setting is not ready or preview not started!','!! Warning !!');
    pause (5);
    if ishandle(h), close (h); end;
    beep; return;
end

closepreview(handles.vid)

handles = rmfield(handles, 'vid'); clear handles.vid;
beep;

% update handles
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
