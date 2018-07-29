%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To run:  Edit user options in npscalc.m and execute the code.
%
% This code is intended to accompany the manuscript entitled:
% 
% A simple approach to measure computed tomography (CT) modulation transfer 
% function (MTF) and noise-power spectrum (NPS) using the American College 
% of Radiology (ACR) accreditation phantom
%
% Please do not distribute.
%
% This program requires the following 4 files:
%   npscalc.m
%   SliceBrowser.m
%   SliceBrowser.fig
%   license.txt
%
% Purpose:  To calculate the 3D NPS using CT data of the American College
%           of Radiology (ACR) accreditation phantom.
%
% Input:    Two consecutive scans of the phantom are needed.  The program 
%           requires a data directory to be selected in which there are 
%           only two subdirectories containing only CT slices corresponding 
%           to the third module of the phantom.  Be careful of partial
%           volume effects with surrounding modules.
%
%           i.e.,  datadir
%                      |-> scan 1 dir
%                      |           | -> only module 3 slices
%                      |        
%                      |-> scan 2 dir
%                                  |-> only module 3 slices
%
% Copyright 2012 Saul N. Friedman
%   Distributed under the terms of the "New BSD License."  Please see
%   license.txt.
%
% N.B.:  SliceBrowser.m is an altered version of code by Marian Uhercik.
%        Please see license.txt.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
%> Last modified by Saul N. Friedman
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

xaxis = getappdata(0,'uaxis');
yaxis = getappdata(0,'vaxis');
zaxis = getappdata(0,'waxis');
axlabel = getappdata(0,'axlabel');
deltayaxis = yaxis(2) - yaxis(1);
deltaxaxis = xaxis(2) - xaxis(1);
deltazaxis = zaxis(2) - zaxis(1);

%disp('Subplot1:BtnDown');
pt=get(gca,'currentpoint');
if length(xaxis) > 0 && length(yaxis) 
    xpos=round((pt(1,2)+xaxis(end))/deltaxaxis); ypos=round((pt(1,1)+yaxis(end))/deltayaxis);
else
xpos=round(pt(1,2)); ypos=round(pt(1,1));
end
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

xaxis = getappdata(0,'uaxis');
yaxis = getappdata(0,'vaxis');
zaxis = getappdata(0,'waxis');
axlabel = getappdata(0,'axlabel');
deltayaxis = yaxis(2) - yaxis(1);
deltaxaxis = xaxis(2) - xaxis(1);
deltazaxis = zaxis(2) - zaxis(1);

%disp('Subplot2:BtnDown');
pt=get(gca,'currentpoint');
if length(xaxis) > 0 && length(zaxis) 
    xpos=round((pt(1,2)+xaxis(end))/deltaxaxis); zpos=round((pt(1,1)+zaxis(end))/deltazaxis);
else
xpos=round(pt(1,2)); zpos=round(pt(1,1));
end
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

xaxis = getappdata(0,'uaxis');
yaxis = getappdata(0,'vaxis');
zaxis = getappdata(0,'waxis');
axlabel = getappdata(0,'axlabel');
deltayaxis = yaxis(2) - yaxis(1);
deltaxaxis = xaxis(2) - xaxis(1);
deltazaxis = zaxis(2) - zaxis(1);

%disp('Subplot3:BtnDown');
pt=get(gca,'currentpoint');
if length(xaxis) > 0 && length(zaxis) 
    ypos=round((pt(1,1)+yaxis(end))/deltayaxis); zpos=round((pt(1,2)+zaxis(end))/deltazaxis);
else
zpos=round(pt(1,2)); ypos=round(pt(1,1));
end
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

xaxis = getappdata(0,'uaxis');
yaxis = getappdata(0,'vaxis');
zaxis = getappdata(0,'waxis');
axlabel = getappdata(0,'axlabel');
if length(xaxis) > 0 && length(yaxis) && length(zaxis)
deltayaxis = yaxis(2) - yaxis(1);
deltaxaxis = xaxis(2) - xaxis(1);
deltazaxis = zaxis(2) - zaxis(1);
end
    

sp1 = subplot(2,2,1);
%colorbar;
if length(xaxis) > 0 && length(yaxis) 
    imagesc([yaxis(1) yaxis(end)],[xaxis(1) xaxis(end)],sliceXY,clims)
else
imagesc(sliceXY, clims);
end
if (handles.axis_equal == 1)
    axis image;
else
    axis normal;
end;
title('Slice XY');
if exist('axlabel')
    xlabel(['Y',axlabel]);ylabel(['X',axlabel])
else
ylabel('X');xlabel('Y');
end
if length(xaxis) > 0 && length(yaxis) 
    line([handles.pointer3dt(2).*deltayaxis - yaxis(end) handles.pointer3dt(2).*deltayaxis - yaxis(end)], [-size(handles.volume,1) size(handles.volume,1)]);
    line([-size(handles.volume,2) size(handles.volume,2)], [handles.pointer3dt(1).*deltaxaxis - xaxis(end) handles.pointer3dt(1).*deltaxaxis - xaxis(end)]);
else
line([handles.pointer3dt(2) handles.pointer3dt(2)], [0 size(handles.volume,1)]);
line([0 size(handles.volume,2)], [handles.pointer3dt(1) handles.pointer3dt(1)]);
end
%set(allchild(gca),'ButtonDownFcn',@Subplot1_ButtonDownFcn);
set(allchild(gca),'ButtonDownFcn','SliceBrowser(''Subplot1_ButtonDownFcn'',gca,[],guidata(gcbo))');


sp2 = subplot(2,2,2);
if length(xaxis) > 0 &&length(zaxis) > 0 
   imagesc([zaxis(1) zaxis(end)],[xaxis(1) xaxis(end)],sliceXZ,clims)
else
imagesc(sliceXZ, clims);
end
if (handles.axis_equal == 1)
    axis image;
else
    axis normal;
end;
title('Slice XZ');
if exist('axlabel')
    ylabel(['X',axlabel]);xlabel(['Z',axlabel])
else
ylabel('X');xlabel('Z');
end
if length(xaxis) > 0 && length(zaxis) 
    line([handles.pointer3dt(3).*deltazaxis - zaxis(end) handles.pointer3dt(3).*deltazaxis - zaxis(end)], [-size(handles.volume,1).*deltaxaxis size(handles.volume,1).*deltaxaxis]);
line([-size(handles.volume,3).*deltazaxis size(handles.volume,3).*deltazaxis], [handles.pointer3dt(1).*deltaxaxis - xaxis(end) handles.pointer3dt(1).*deltaxaxis - xaxis(end)]);
else
line([handles.pointer3dt(3) handles.pointer3dt(3)], [0 size(handles.volume,1)]);
line([0 size(handles.volume,3)], [handles.pointer3dt(1) handles.pointer3dt(1)]);
end
%set(allchild(gca),'ButtonDownFcn',@Subplot2_ButtonDownFcn);
set(allchild(gca),'ButtonDownFcn','SliceBrowser(''Subplot2_ButtonDownFcn'',gca,[],guidata(gcbo))');



sp3 = subplot(2,2,3);
if length(yaxis) > 0 && length(zaxis) > 0 
   imagesc([yaxis(1) yaxis(end)],[zaxis(1) zaxis(end)],sliceZY,clims)
else
imagesc(sliceZY, clims);
end
if (handles.axis_equal == 1)
    axis image;
else
    axis normal;
end;
title('Slice ZY');
if exist('axlabel')
    ylabel(['Z',axlabel]);xlabel(['Y',axlabel])
else
ylabel('Z');xlabel('Y');
end

if length(yaxis) > 0 && length(zaxis) 
    line([-size(handles.volume,2) size(handles.volume,2)], [handles.pointer3dt(3).*deltazaxis - zaxis(end) handles.pointer3dt(3).*deltazaxis - zaxis(end)]);
    line([handles.pointer3dt(2).*deltayaxis - yaxis(end) handles.pointer3dt(2).*deltayaxis - yaxis(end)], [-size(handles.volume,3).*deltazaxis size(handles.volume,3).*deltazaxis]);
else
line([0 size(handles.volume,2)], [handles.pointer3dt(3) handles.pointer3dt(3)]);
line([handles.pointer3dt(2) handles.pointer3dt(2)], [0 size(handles.volume,3)]);
end
%set(allchild(gca),'ButtonDownFcn',@Subplot3_ButtonDownFcn);
set(allchild(gca),'ButtonDownFcn','SliceBrowser(''Subplot3_ButtonDownFcn'',gca,[],guidata(gcbo))');


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

