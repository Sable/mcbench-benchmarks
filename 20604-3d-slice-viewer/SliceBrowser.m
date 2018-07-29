% ======================================================================
%> SLICEBROWSER M-file for SliceBrowser.fig
%>       SliceBrowser is an interactive viewer of 3D volumes, 
%>       it shows 3 perpendicular slices (XY, YZ, ZX) with 3D pointer.
%>   Input:  a) VOLUME - a 3D matrix with volume data
%>           b) VOLUME - a 4D matrix with volume data over time
%>   Control:
%>       - Clicking into the window changes the location of 3D pointer.
%>       - 3D pointer can be moved also by keyboard arrows.
%>       - Pressing +/- will switch to next/previous volume.
%>       - Pressing 1,2,3 will change the focus of current axis.
%>       - Pressing 'e' will print the location of 3D pointer.
%>       - Pressing 'c' switches between color-mode and grayscale.
%>       - Pressing 'q' switches scaling of axis (equal/normal).
%>   Example of usage:
%>       load mri.dat
%>       volume = squeeze(D);
%>       SliceBrowser(volume);
%>
%> Author: Marian Uhercik, CMP, CTU in Prague
%> Web: http://cmp.felk.cvut.cz/~uhercik/3DSliceViewer/3DSliceViewer.htm
%> Last Modified by 21-Jul-2011
% ======================================================================
function varargout = SliceBrowser(varargin)

% Documentation generated GUIDE:
%
%SLICEBROWSER M-file for SliceBrowser.fig
%      SLICEBROWSER, by itself, creates a new SLICEBROWSER or raises the existing
%      singleton*.
%
%      H = SLICEBROWSER returns the handle to a new SLICEBROWSER or the handle to
%      the existing singleton*.
%
%      SLICEBROWSER('Property','Value',...) creates a new SLICEBROWSER using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to SliceBrowser_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SLICEBROWSER('CALLBACK') and SLICEBROWSER('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SLICEBROWSER.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SliceBrowser

% Last Modified by GUIDE v2.5 01-Sep-2008 13:14:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SliceBrowser_OpeningFcn, ...
                   'gui_OutputFcn',  @SliceBrowser_OutputFcn, ...
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


% --- Executes just before SliceBrowser is made visible.
function SliceBrowser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for SliceBrowser
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SliceBrowser wait for user response (see UIRESUME)
% uiwait(handles.figure1);

if (length(varargin) <=0)
    error('Input volume has not been specified.');
end;
volume = varargin{1};
if (ndims(volume) ~= 3 && ndims(volume) ~= 4)
    error('Input volume must have 3 or 4 dimensions.');
end;
handles.volume = volume;

handles.axis_equal = 0;
handles.color_mode = 1;
if (size(volume,4) ~= 3)
    handles.color_mode = 0;
end;

% set main wnd title
set(gcf, 'Name', 'Slice Viewer')

% init 3D pointer
vol_sz = size(volume); 
if (ndims(volume) == 3)
    vol_sz(4) = 1;
end;
pointer3dt = floor(vol_sz/2)+1;
handles.pointer3dt = pointer3dt;
handles.vol_sz = vol_sz;

plot3slices(hObject, handles);

% stores ID of last axis window 
% (0 means that no axis was clicked yet)
handles.last_axis_id = 0;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = SliceBrowser_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over axes background.
function Subplot1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Subplot1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% This object contains the XY slice

%disp('Subplot1:BtnDown');
pt=get(gca,'currentpoint');
xpos=round(pt(1,2)); ypos=round(pt(1,1));
zpos = handles.pointer3dt(3);
tpos = handles.pointer3dt(4);
handles.pointer3dt = [xpos ypos zpos tpos];
handles.pointer3dt = clipointer3d(handles.pointer3dt,handles.vol_sz);
plot3slices(hObject, handles);
% store this axis as last clicked region
handles.last_axis_id = 1;
% Update handles structure
guidata(hObject, handles);

% --- Executes on mouse press over axes background.
function Subplot2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Subplot2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% This object contains the YZ slice

%disp('Subplot2:BtnDown');
pt=get(gca,'currentpoint');
xpos=round(pt(1,2)); zpos=round(pt(1,1));
ypos = handles.pointer3dt(2);
tpos = handles.pointer3dt(4);
handles.pointer3dt = [xpos ypos zpos tpos];
handles.pointer3dt = clipointer3d(handles.pointer3dt,handles.vol_sz);
plot3slices(hObject, handles);
% store this axis as last clicked region
handles.last_axis_id = 2;
% Update handles structure
guidata(hObject, handles);

% --- Executes on mouse press over axes background.
function Subplot3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Subplot3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% This object contains the XZ slice

%disp('Subplot3:BtnDown');
pt=get(gca,'currentpoint');
zpos=round(pt(1,2)); ypos=round(pt(1,1));
xpos = handles.pointer3dt(1);
tpos = handles.pointer3dt(4);
handles.pointer3dt = [xpos ypos zpos tpos];
handles.pointer3dt = clipointer3d(handles.pointer3dt,handles.vol_sz);
plot3slices(hObject, handles);
% store this axis as last clicked region
handles.last_axis_id = 3;
% Update handles structure
guidata(hObject, handles);

% --- Executes on key press with focus on SliceBrowserFigure and no controls selected.
function SliceBrowserFigure_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to SliceBrowserFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%disp('SliceBrowserFigure_KeyPressFcn');
curr_char = int8(get(gcf,'CurrentCharacter'));
if isempty(curr_char)
    return;
end;

xpos = handles.pointer3dt(1);
ypos = handles.pointer3dt(2);
zpos = handles.pointer3dt(3); 
tpos = handles.pointer3dt(4); 
% Keys:
% - up:   30
% - down:   31
% - left:   28
% - right:   29
% - '1': 49
% - '2': 50
% - '3': 51
% - 'e': 101
% - plus:  43
% - minus:  45
switch curr_char
    case 99 % 'c'
        handles.color_mode = 1 - handles.color_mode;
        if (handles.color_mode ==1 && size(handles.volume,4) ~= 3)
            handles.color_mode = 0;
        end;
        
    case 113 % 'q'
        handles.axis_equal = 1 - handles.axis_equal;
        
    case 30
        switch handles.last_axis_id
            case 1
                xpos = xpos -1;
            case 2
                xpos = xpos -1;
            case 3
                zpos = zpos -1;
            case 0
        end;
    case 31
        switch handles.last_axis_id
            case 1
                xpos = xpos +1;
            case 2
                xpos = xpos +1;
            case 3
                zpos = zpos +1;
            case 0
        end;
    case 28
        switch handles.last_axis_id
            case 1
                ypos = ypos -1;
            case 2
                zpos = zpos -1;
            case 3
                ypos = ypos -1;
            case 0
        end;
    case 29
        switch handles.last_axis_id
            case 1
                ypos = ypos +1;
            case 2
                zpos = zpos +1;
            case 3
                ypos = ypos +1;
            case 0
        end;
    case 43
        % plus key
        tpos = tpos+1;
    case 45
        % minus key
        tpos = tpos-1;
    case 49
        % key 1
        handles.last_axis_id = 1;
    case 50
        % key 2
        handles.last_axis_id = 2;
    case 51
        % key 3
        handles.last_axis_id = 3;
    case 101
        disp(['[' num2str(xpos) ' ' num2str(ypos) ' ' num2str(zpos) ' ' num2str(tpos) ']']);
    otherwise
        return
end;
handles.pointer3dt = [xpos ypos zpos tpos];
handles.pointer3dt = clipointer3d(handles.pointer3dt,handles.vol_sz);
plot3slices(hObject, handles);
% Update handles structure
guidata(hObject, handles);

% --- Plots all 3 slices XY, YZ, XZ into 3 subplots
function [sp1,sp2,sp3] = plot3slices(hObject, handles)
% pointer3d     3D coordinates in volume matrix (integers)

handles.pointer3dt;
size(handles.volume);
value3dt = handles.volume(handles.pointer3dt(1), handles.pointer3dt(2), handles.pointer3dt(3), handles.pointer3dt(4));

text_str = ['[X:' int2str(handles.pointer3dt(1)) ...
           ', Y:' int2str(handles.pointer3dt(2)) ...
           ', Z:' int2str(handles.pointer3dt(3)) ...
           ', Time:' int2str(handles.pointer3dt(4)) '/' int2str(handles.vol_sz(4)) ...
           '], value:' num2str(value3dt)];
set(handles.pointer3d_info, 'String', text_str);
guidata(hObject, handles);

if (handles.color_mode ==1)
    sliceXY = squeeze(handles.volume(:,:,handles.pointer3dt(3),:));
    sliceYZ = squeeze(handles.volume(handles.pointer3dt(1),:,:,:));
    sliceXZ = squeeze(handles.volume(:,handles.pointer3dt(2),:,:));

    max_xyz = max([ max(sliceXY(:)) max(sliceYZ(:)) max(sliceXZ(:)) ]);
    min_xyz = min([ min(sliceXY(:)) min(sliceYZ(:)) min(sliceXZ(:)) ]);
    clims = [ min_xyz max_xyz ];
else
    sliceXY = squeeze(handles.volume(:,:,handles.pointer3dt(3),handles.pointer3dt(4)));
    sliceYZ = squeeze(handles.volume(handles.pointer3dt(1),:,:,handles.pointer3dt(4)));
    sliceXZ = squeeze(handles.volume(:,handles.pointer3dt(2),:,handles.pointer3dt(4)));

    max_xyz = max([ max(sliceXY(:)) max(sliceYZ(:)) max(sliceXZ(:)) ]);
    min_xyz = min([ min(sliceXY(:)) min(sliceYZ(:)) min(sliceXZ(:)) ]);
    clims = [ min_xyz max_xyz ];
end;
sliceZY = squeeze(permute(sliceYZ, [2 1 3]));

sp1 = subplot(2,2,1);
%colorbar;
imagesc(sliceXY, clims);
title('Slice XY');
ylabel('X');xlabel('Y');
line([handles.pointer3dt(2) handles.pointer3dt(2)], [0 size(handles.volume,1)]);
line([0 size(handles.volume,2)], [handles.pointer3dt(1) handles.pointer3dt(1)]);
%set(allchild(gca),'ButtonDownFcn',@Subplot1_ButtonDownFcn);
set(allchild(gca),'ButtonDownFcn','SliceBrowser(''Subplot1_ButtonDownFcn'',gca,[],guidata(gcbo))');
if (handles.axis_equal == 1)
    axis image;
else
    axis normal;
end;

sp2 = subplot(2,2,2);
imagesc(sliceXZ, clims);
title('Slice XZ');
ylabel('X');xlabel('Z');
line([handles.pointer3dt(3) handles.pointer3dt(3)], [0 size(handles.volume,1)]);
line([0 size(handles.volume,3)], [handles.pointer3dt(1) handles.pointer3dt(1)]);
%set(allchild(gca),'ButtonDownFcn',@Subplot2_ButtonDownFcn);
set(allchild(gca),'ButtonDownFcn','SliceBrowser(''Subplot2_ButtonDownFcn'',gca,[],guidata(gcbo))');
if (handles.axis_equal == 1)
    axis image;
else
    axis normal;
end;

sp3 = subplot(2,2,3);
imagesc(sliceZY, clims);
title('Slice ZY');
ylabel('Z');xlabel('Y');
line([0 size(handles.volume,2)], [handles.pointer3dt(3) handles.pointer3dt(3)]);
line([handles.pointer3dt(2) handles.pointer3dt(2)], [0 size(handles.volume,3)]);
%set(allchild(gca),'ButtonDownFcn',@Subplot3_ButtonDownFcn);
set(allchild(gca),'ButtonDownFcn','SliceBrowser(''Subplot3_ButtonDownFcn'',gca,[],guidata(gcbo))');
if (handles.axis_equal == 1)
    axis image;
else
    axis normal;
end;

function pointer3d_out = clipointer3d(pointer3d_in,vol_size)
pointer3d_out = pointer3d_in;
for p_id=1:4
    if (pointer3d_in(p_id) > vol_size(p_id))
        pointer3d_out(p_id) = vol_size(p_id);
    end;
    if (pointer3d_in(p_id) < 1)
        pointer3d_out(p_id) = 1;
    end;
end;

