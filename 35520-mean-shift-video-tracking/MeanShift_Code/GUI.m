%% Mean-Shift Video Tracking
% by Sylvain Bernhardt
% July 2008
%% Description
% GUI for the Mean-Shift Video Tracking.
% Run it by typing GUI in the command line.

function varargout = GUI(varargin)
% GUI M-file for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 31-Jul-2008 21:38:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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

%% Executes just before GUI is made visible,
% but after the objects have been created (ie after
% the Createfcn functions have been run, if any).
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for GUI
handles.output = hObject;
% No file is selected yet
handles.FileName = 0;
% Get the background colour
colour = get(handles.Video_Panel,'BackgroundColor');
% Set Icons of Play button
img = imread('Files\Play_up.bmp');
handles.icon_play_up = Set_Button_Bckgrnd(img,colour);
set(handles.Play,'CData',handles.icon_play_up);
img = imread('Files\Play_down.bmp');
handles.icon_play_down = Set_Button_Bckgrnd(img,colour);
% Set Default value of Speed slider
set(handles.Speed,'Value',10);
% Set Icons of Mark In/Out buttons
in = imread('Files\Mark_in.bmp');
out = imread('Files\Mark_out.bmp');
in = Set_Button_Bckgrnd(in,colour);
out = Set_Button_Bckgrnd(out,colour);
set(handles.Mark_in,'CData',in);
set(handles.Mark_out,'CData',out);
% Set Icon of Crop Selection button
icon = imread('Files\Crop.bmp');
icon = Set_Button_Bckgrnd(icon,colour);
set(handles.Crop,'CData',icon);
% Set Icon of Target Selection button
icon = imread('Files\Select_Target.bmp');
icon = Set_Button_Bckgrnd(icon,colour);
set(handles.Select_Target,'CData',icon);
% Set Default Kernel Options
set(handles.Gaussian,'Value',1);
handles.Kernel_type = 'Gaussian';
handles.radius = str2double(get(...
    handles.Radius_edit,'String'))/100;
% Set Default Iteration limiters
handles.f_thresh = str2double(get(...
    handles.F_thresh_edit,'String'));
handles.max_iter = str2double(get(...
    handles.Max_iter_edit,'String'));
% Update handles structure
guidata(hObject, handles);
%Display Default Images
axes(handles.Target)
img = imread('Files\Target_Default.png');
imshow(img);
axes(handles.Video)
img = imread('Files\Video_Default.png');
imshow(img);

%% Button Background Colour Function
function icon = Set_Button_Bckgrnd(icon,colour)
for i=1:size(icon,1)
    for j=1:size(icon,2)
        if mean(icon(i,j,:))>= 196
            icon(i,j,:) = icon(i,j,:)-uint8(round(...
                255*(ones(1,1,3)-permute(colour,[1 3 2]))));
        end
    end
end

%% Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% Objects Creation Functions
% Executes during object creation,
%after setting all properties.
function Video_CreateFcn(hObject, eventdata, handles)
function Vid_Path_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function Slider_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Speed_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function Mark_in_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Mark_out_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Select_Target_CreateFcn(hObject, eventdata, handles)
function Target_CreateFcn(hObject, eventdata, handles)
function Radius_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function F_thresh_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Max_iter_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Similarity_Plot_CreateFcn(hObject, eventdata, handles)

%% Close Button Callback
function Close_Callback(hObject, eventdata, handles)
% setappdata(handles.MeanShift,'mydata',matrices);
display 'GUI closed. Thanks for using it. :)'
close(handles.MeanShift);

%% Video Input Callbacks
function Browse_Callback(hObject, eventdata, handles)

[FileName,PathName] = uigetfile({'*.avi','(*.avi) AVI video file'},...
    'Select input AVI video...');
if FileName~=0
    set(handles.Vid_Path,'String',strcat(PathName,FileName));
    Vid_Path_Callback(handles.Vid_Path,[], handles);
end

function Vid_Path_Callback(hObject, eventdata, handles)
Path = get(hObject,'String');
if exist(Path,'file')==2
    L = length(Path);
    if L>3
        extension = Path(L-3:L);
        if strcmpi(extension,'.avi')==1
            set(hObject,'String',...
                'Importing video, be patient...',...
                'ForegroundColor','red',...
                'FontWeight','bold');
            drawnow;
            [handles.lngth,handles.height,handles.width,...
                handles.Movie]=Import_mov(Path);
            set(hObject,'String',Path,...
                'ForegroundColor','black',...
                'FontWeight','normal');
            for i=L:-1:1
                if strcmp(Path(i),'\')==1
                    break;
                end
            end
            handles.FileName = Path(L-i:L-3);
            Video_Init(hObject,handles);
        end
    end
end

%% Video Initialization
function Video_Init(hObject,handles)
handles.indx_start_frame = 1;
handles.indx_end_frame = handles.lngth;
guidata(hObject,handles);
set(handles.Play,'Enable','on');
set(handles.Speed,'Enable','on');
set(handles.Slider,'Min',1,'Max',handles.lngth,...
    'Value',1,'SliderStep',[0.01 0.1],'Enable','on');
Video_Callback(handles.Video,[],handles);
set(handles.Slider_edit,'Enable','on','String',1);
set(handles.Mark_in,'Enable','on');
set(handles.Mark_out,'Enable','on');
set(handles.Mark_in_edit,'Enable','on','String',1);
set(handles.Mark_out_edit,'Enable','on',...
    'String',num2str(handles.lngth));
set(handles.Crop,'Enable','on');
Set_Mark_in_pointer(handles.Mark_in_pointer,1,handles);
Set_Mark_in_pointer(handles.Mark_in_edit,1,handles);
Set_Mark_out_pointer(handles.Mark_out_pointer,...
    handles.lngth,handles);
Set_Mark_out_pointer(handles.Mark_out_edit,...
    handles.lngth,handles);
Disable_Parameters_Panels(handles);
Target_Init(handles);

%% Disable parameters access while no target selected
function Disable_Parameters_Panels(handles)
set(handles.Uniform,'Enable','off');
set(handles.Triangular,'Enable','off');
set(handles.Epanechnikov,'Enable','off');
set(handles.Gaussian,'Enable','off');
set(handles.Radius_edit,'Enable','off');
set(handles.F_thresh_edit,'Enable','off');
set(handles.Max_iter_edit,'Enable','off');
set(handles.Start,'Enable','off');

%% Target Selection Initialization
function Target_Init(handles)
set(handles.Select_Target,'Enable','on');
%Display Default Image
axes(handles.Target)
img = imread('Files\Target_Default.png');
imshow(img);


%% Video Display
function Video_Callback(hObject, eventdata, handles)
handles.index = round(get(handles.Slider,'Value'));
guidata(hObject,handles);
axes(handles.Video)
I = handles.Movie(handles.index).cdata;
imshow(I);

function Slider_Callback(hObject, eventdata, handles)
index = get(hObject,'Value');
set(handles.Slider_edit,'String',num2str(round(index)));
if handles.FileName~=0
    Video_Callback(handles.Video,[],handles);
end

function Slider_edit_Callback(hObject, eventdata, handles)
index = round(str2double(get(hObject,'String')));
if index > 0 && index <= handles.lngth
    set(handles.Slider,'Value',index);
    Video_Callback(handles.Video,[],handles);
end

%% Play Function
function Speed_Callback(hObject, eventdata, handles)

function Play_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
axes(handles.Video)
if button_state == get(hObject,'Max')
    set(handles.Play,'CData',handles.icon_play_down);
    drawnow;
    for indx=handles.index:handles.lngth
        pause(1/get(handles.Speed,'Value'));
        set(handles.Slider,'Value',indx);
        Slider_Callback(handles.Slider,[],handles);
        if get(hObject,'Min') == get(hObject,'Value')
            break;
        end
    end
    set(handles.Play,'CData',handles.icon_play_up,...
        'Value',get(hObject,'Min'));
end

%% Video Segment Selection
function Set_Mark_in_pointer(hObject,index,handles)
position = get(hObject,'Position');
position(1) = 3+index*371/handles.lngth;
set(hObject,'Position',position);
uistack(hObject,'top');

function Set_Mark_out_pointer(hObject,index,handles)
position = get(hObject,'Position');
position(1) = 42+index*371/handles.lngth;
set(hObject,'Position',position);
uistack(hObject,'top');

function Mark_in_Callback(hObject, eventdata, handles)
index = round(get(handles.Slider,'Value'));
if index < handles.indx_end_frame
    handles.indx_start_frame = index;
    guidata(hObject,handles);
    set(handles.Mark_in_edit,'String',num2str(index));
    Set_Mark_in_pointer(handles.Mark_in_pointer,index,handles);
    Set_Mark_in_pointer(handles.Mark_in_edit,index,handles);
end 

function Mark_out_Callback(hObject, eventdata, handles)
index = round(get(handles.Slider,'Value'));
if index > handles.indx_start_frame
    handles.indx_end_frame = index;
    guidata(hObject,handles);
    set(handles.Mark_out_edit,'String',num2str(index));
    Set_Mark_out_pointer(handles.Mark_out_pointer,index,handles);
    Set_Mark_out_pointer(handles.Mark_out_edit,index,handles);
end

function Mark_in_edit_Callback(hObject, eventdata, handles)
index = round(str2double(get(hObject,'String')));
if index > 0 && index < handles.indx_end_frame
    set(handles.Slider,'Value',index);
    Slider_Callback(handles.Slider,[],handles);
    Mark_in_Callback(handles.Mark_in,[],handles);
end

function Mark_out_edit_Callback(hObject, eventdata, handles)
index = round(str2double(get(hObject,'String')));
if index <= handles.lngth && index > handles.indx_start_frame
    set(handles.Slider,'Value',index);
    Slider_Callback(handles.Slider,[],handles);
    Mark_out_Callback(handles.Mark_out,[],handles);
end

function Crop_Callback(hObject, eventdata, handles)
indx_start = handles.indx_start_frame;
indx_end = handles.indx_end_frame;
handles.Movie = handles.Movie(1,indx_start:indx_end);
handles.lngth = indx_end - indx_start + 1;
guidata(hObject,handles);
Video_Init(handles.Video,handles);

%% Enable parameters access while no target selected
function Enable_Parameters_Panels(handles)
set(handles.Uniform,'Enable','on');
set(handles.Triangular,'Enable','on');
set(handles.Epanechnikov,'Enable','on');
set(handles.Gaussian,'Enable','on');
set(handles.Radius_edit,'Enable','on');
set(handles.F_thresh_edit,'Enable','on');
set(handles.Max_iter_edit,'Enable','on');
set(handles.Start,'Enable','on');

%% Target Selection Callbacks
function Select_Target_Callback(hObject, eventdata, handles)
handles.index = 1;
I = handles.Movie(1).cdata;
[handles.T,handles.x0,handles.y0,handles.H,handles.W] = ...
    Select_patch(I,0);
guidata(hObject,handles);
axes(handles.Target)
imshow(handles.T);
Enable_Parameters_Panels(handles);
set(handles.Kernel_Panel,'SelectionChangeFcn',...
    @Kernel_Select);
Kernel_Plot(hObject,handles);

%% Parzen Kernel Windows Callbacks
function Kernel_Select(hObject,eventdata)
handles = guidata(hObject);
handles.Kernel_type = get(eventdata.NewValue,'Tag');
guidata(hObject,handles);
Kernel_Plot(hObject,handles);

function Radius_edit_Callback(hObject, eventdata, handles)
Kernel_Plot(hObject,handles);

function Kernel_Plot(hObject,handles)
radius = str2double(get(handles.Radius_edit,'String'));
if radius > 0 && radius <= 100
    handles.radius = radius/100;
    [k,handles.gx,handles.gy] = Parzen_window...
        (handles.H,handles.W,handles.radius,...
        handles.Kernel_type,0);
    guidata(hObject,handles);
    axes(handles.Kernel_Plot)
    mesh(k);
    surf(k);
    shading interp
    axis([1 handles.W 1 handles.H 0 1])
end
set(handles.Radius_edit,'String',num2str(100*handles.radius));

%% Mean-Shift Iteration Parameters
function F_thresh_edit_Callback(hObject, eventdata, handles)
thresh = str2double(get(hObject,'String'));
if thresh > 0.0 && thresh < 1.0
    handles.f_thresh = thresh;
    guidata(hObject,handles);
end
set(hObject,'String',num2str(handles.f_thresh));

function Max_iter_edit_Callback(hObject, eventdata, handles)
Max = str2double(get(handles.Max_iter_edit,'String'));
if Max >= 1 && Max <= 15
    handles.max_iter = round(Max);
    guidata(hObject,handles);
end
set(hObject,'String',num2str(handles.max_iter));

%% Start Button Callback
function Start_Callback(hObject, eventdata, handles)
% Initialization
H = handles.H;
W = handles.W;
x0 = handles.x0;
y0 = handles.y0;
kernel_type = handles.Kernel_type;
Length = handles.lngth;
f_thresh = handles.f_thresh;
max_it = handles.max_iter;
% Calculation of the Parzen Kernel window
[k,gx,gy] = Parzen_window(H,W,handles.radius,kernel_type,0);
% Conversion from RGB to Indexed colours
% to compute the colour probability functions (PDFs)
[I,map] = rgb2ind(handles.Movie(1).cdata,65536);
Lmap = length(map)+1;
T = rgb2ind(handles.T,map);
% Estimation of the target PDF
q = Density_estim(T,Lmap,k,H,W,0);
% Flag for target loss
loss = 0;
% Similarity evolution along tracking
f = [];
% Sum of iterations along tracking and index of f
f_indx = 1;
% Draw the selected target in the first frame
handles.Movie(1).cdata = Draw_target(x0,y0,W,H,...
    handles.Movie(1).cdata,2);
%%%% TRACKING
WaitBar = waitbar(0,'Tracking in progress, be patient...',...
    'Name','Tracking performing...');
% From 1st frame to last one
for t=1:Length-1
    % Next frame
    I2 = rgb2ind(handles.Movie(t+1).cdata,map);
    % Apply the Mean-Shift algorithm to move (x,y)
    % to the target location in the next frame.
    [x,y,loss,f,f_indx] = MeanShift_Tracking(q,I2,Lmap,...
        handles.height,handles.width,f_thresh,max_it,...
        x0,y0,H,W,k,gx,gy,f,f_indx,loss);
    % Check for target loss. If true, end the tracking
    if loss == 1
        break;
    else
        % Drawing the target location in the next frame
        handles.Movie(t+1).cdata = Draw_target(x,y,W,H,...
            handles.Movie(t+1).cdata,2);
        % Next frame becomes current frame
        y0 = y;
        x0 = x;
        % Updating the waitbar
        waitbar(t/(Length-1));
    end
end
close(WaitBar);
%%%% End of TRACKING

guidata(hObject,handles);
axes(handles.Similarity_Plot)
cla
plot(f,'-b');
ylim([0 f_thresh+f_thresh/25])
hold on
plot(f_thresh*ones(1,Length*max_it),'--r','LineWidth',1.5);
Video_Callback(handles.Video,[], handles);

%% End of File
%%%%%%%%%%%%%%
