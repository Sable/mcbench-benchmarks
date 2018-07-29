function varargout = imlook3d(varargin)
% IMLOOK3D M-file for imlook3d.fig
%      IMLOOK3D, by itself, creates a new IMLOOK3D or raises the existing
%      singleton*.
%
%      H = IMLOOK3D returns the handle to a new IMLOOK3D or the handle to
%      the existing singleton*.
%
%      IMLOOK3D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMLOOK3D.M with the given input arguments.
%
%      IMLOOK3D('Property','Value',...) creates a new IMLOOK3D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imlook3d_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imlook3d_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% EXAMPLE:
%  Let us first load the mri image in Matlab using
%  >load mri;
%  and then run imlook3d
%  >imlook3d(squeeze(D)); % squeeze removes singleton dimensions
%
% Descriptions of Menus
% 
% ImFile:
% 
% -READ FROM WORKSPACE: Reads or displays images existing in the 
%  workspace(base).
% 
% -READ A STACK (DISK): Reads (displays)slices of images into a 3D array creating
%  a 3D image. It reads them from the disk. A file browser pups up and 
%  allows the user to pick up the first file in the series. It reads all
%  the files in the directory that has similar names except a suffix 
%  changing for each file. 
% 
%  For example: slice01.tif, slice01.tif,...,slice0N.tif 
% 
% -READ DICOM SERIES: 
%  Reads/displays series of DICOM images into a 3D array. A file browser 
%  pups up and allows users to select the first file in the series. 
%  It reads all the files in the directory that has similar names 
%  except a suffix changing for each file. 

% -SAVE SLICE AS TIFF:
%  Saves the current slice as a tiff image.

% -SAVE INTO WORKSPACE: This saves displayed 3D image into workspace as
%  a 3D variable. This may be useful to save the 3D image that is 
%  read by "read a stack (disk)".
%
% ImTools:
% 
% -PIXVAL: Allows looking at pixel intensities.
% -HISTOGRAM: Displays the histogram of the current image (slice).
% -PROFILE: Allows plotting intensity profiles across the image in an
%  interactive manner.
% -ADJUST INTENSITY RANGE: Allows adjusting the intensity range for 
%  the current slice. 
% -GLOBAL INTENSITY WINDOWING:
%  If not checked,not global, the intensity limits are set to [min(currentslice)
%  max(currentslice)]
%  
% VIEW MENU:
% 
%  This pup-up menu allows users to change the view of the image 
%  from transverse to sagittal or coronal views. It assumes that
%  original image is in transverse mode. 
%

% Copyright(c) Omer Demirkaya
% Last Modified by GUIDE v2.5 22-May-2007 21:27:00
% Begin initialization code - DO NOT EDIT

% This entire code or part of it could be modified and used if the due 
% credit to the original author is given.
%------------------------------------------------------------------

gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @imlook3d_OpeningFcn, ...
    'gui_OutputFcn',  @imlook3d_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if isempty(varargin)
    disp('There was no image to display');
    disp('USAGE: >>imlook3d(img) or use ImFile menu to load an image');
    varargin{1,1} = zeros(32,32);
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before imlook3d is made visible.
function imlook3d_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for imlook3d
if isempty(varargin{:})
    return;
end
handles.output = hObject;
Std.Interruptible = 'off';
Std.BusyAction = 'queue';
Ax       = Std; 
Ax.Units = 'Pixels'; 
Ax.ydir  = 'reverse';
Ax.XLim  = [.5 128.5]; 
Ax.YLim  = [.5 128.5]; 
Ax.XTick = []; 
Ax.YTick = [];
Ax.CLimMode = 'auto';

set(handles.axes1,Ax);

Img = Std;Img.CData = [];Img.Xdata = [];Img.Ydata = [];
Img.CDataMapping = 'Scaled';
Img.Erasemode = 'none';
handles.image = Img;
inpargs = varargin{:};
[r,c,z] = size(inpargs);
handles.image.CData     = inpargs;
handles.imSize          = [r,c,z];
handles.viewtype        = 1;
handles.imageModality   = [];
handles.hText           = [];
handles.global_windowing= 0;
handles.SliceThickness  = [];
handles.imageInfo       = [];
handles.currentSliceNumber = 1;
handle.image.SliceSensitivityFactor =[];

handles.oimage = handles.image;
cimg = handles.image.CData(:,:,1);
% Create image object and set the properties
handles.ImgObject = image(Img,'Parent',handles.axes1);
set(handles.SliceNumEdit,'String',1);
set(handles.figure1,'Colormap',gray,'Units','Pixels');
% Set the properties of the axes
cclim =[min(cimg(:)) max(cimg(:))];
if (cclim(2)>0 & cclim(2)-cclim(1) ~= 0)
    set(handles.axes1,'CLim',cclim,...
        'PlotBoxAspectRatio',[c r 1]);
end
set(handles.axes1,'XLim',[1 c],'Ylim',[1 r],...
    'PlotBoxAspectRatio',[c r 1]);
set(handles.ImgObject,'Xdata',[1 c],'Ydata',[1 r],'CData',cimg);
drawnow
% Set the slider's value and step size
if z > 1
    turnDisplayButtons(handles,'on')
    set(handles.SliceNumSlider,'Min',1,'Max',z,'Value',...
        1,'SliderStep',[1.0/double(z-1) 1.0/double(z-1)]);
end
% Define the line and associate it with the context menu
set(handles.ImgObject,'UIContextMenu',handles.ImMaps);
% Update handles structure
%--------------------------------------------------------------------------
%% Set appdata for the inntensity adjustment GUI
setappdata(0  ,  'hMainGui'    , gcf);
hMainGui = getappdata(0, 'hMainGui');
maxINT = max(max(max(handles.image.CData)));
minINT = min(min(min(handles.image.CData)));
intensityParam = struct('lowerLimit',cclim(1),'upperLimit',cclim(2),...
    'maxIntensity', maxINT, 'minIntensity',minINT);
handles.intensityParam = intensityParam;
setappdata(hMainGui,  'intensityParam'  ,intensityParam);
%% Read and display logo image
% ----------------------------------------------------------------
fdir = which('imlook3d');
txt = [fdir(1:end-10) '\imlook3d.png'];
imlogo = imread(txt);
Sz= size(imlogo);
flogo = figure('Position',[10000 10000 Sz(2) + 4 Sz(1) + 4],'name','Imlook3D',...
    'numbertitle','off','menubar','none');
movegui(flogo,'center');
set(flogo,'Units', 'pixels');
image(imlogo(:,:,1:3))
set(gca, ...
    'Visible', 'off', ...
    'Units', 'pixels', ...
    'Position', [2 2 Sz(2) Sz(1)]);
text(220,16,'3D Image Display Tool','Fontsize',12);
text(130,355,'Version 1.2: Copyright 2006, Omer Demirkaya','Fontsize',8);
pause(3);delete(flogo);clear imlogo
%% ------------------------------------
%--------------------------------------------------------------------------
guidata(hObject, handles);
%--------------------------------------------------------------------------
% --- Outputs from this function are returned to the command line.
function varargout = imlook3d_OutputFcn(hObject, eventdata, handles)
 varargout{1} = handles.output;
% --- Executes during object creation, after setting all properties.
function SliceNumSlider_CreateFcn(hObject, eventdata, handles)
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on slider movement.
%------------------------------------------------------------
function SliceNumSlider_Callback(hObject, eventdata, handles)
NewVal= round(get(hObject,'Value'));
cimg = handles.image.CData(:,:,NewVal);
if ~(handles.global_windowing)
    cclim = [min(cimg(:)) max(cimg(:))];
    if (cclim(2)>0 & cclim(2)-cclim(1) ~= 0)
        set(handles.axes1,'CLim',[min(cimg(:)) max(cimg(:))])
    end
else
    set(handles.axes1,'CLim',[handles.intensityParam.lowerLimit  handles.intensityParam.upperLimit])
end  
set(handles.ImgObject,'Cdata',cimg);
set(handles.SliceNumEdit,'String',num2str(NewVal));
drawnow
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function SliceNumEdit_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%--------------------------------------------------------------------------
function SliceNumEdit_Callback(hObject, eventdata, handles)
z= size(handles.image.CData,3);
strg = get(hObject,'String');
if str2num(strg)>=1 & str2num(strg)<=z
    set(handles.SliceNumSlider,'Value',str2num(strg));
    cimg = handles.image.CData(:,:,str2num(strg));
    set(handles.ImgObject,'Cdata',cimg);
    handles.currentSliceNumber = str2num(strg);
    drawnow
end
if ~(handles.global_windowing)
    cclim = [min(cimg(:)) max(cimg(:))];
    if (cclim(2)>0 & cclim(2)-cclim(1) ~= 0)
        set(handles.axes1,'CLim',[min(cimg(:)) max(cimg(:))])
    end
else
    set(handles.axes1,'CLim',[handles.intensityParam.lowerLimit  handles.intensityParam.upperLimit])

end 
guidata(hObject, handles);
% --------------------------------------------------------------------
% --------------------------------------------------------------------
function changeColorMaps_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function petColormaps_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function CTcolormaps_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
% --------------------------------------------------------------------
function Hot_Callback(hObject, eventdata, handles)
htable = feval('hot');
set(handles.figure1,'Colormap',htable); 
if handles.imSize(3)> 1 
    set(handles.SliceNumEdit,'BackgroundColor',[.1 .1 .1],'ForegroundColor','r');
end
guidata(hObject, handles);
% --------------------------------------------------------------------
function Gray_Callback(hObject, eventdata, handles)
htable = feval('gray');
set(handles.figure1,'Colormap',htable);
if handles.imSize(3)> 1 
    set(handles.SliceNumEdit,'BackgroundColor','k','ForegroundColor','w');
end
guidata(hObject, handles);
% --------------------------------------------------------------------
function InvGray_Callback(hObject, eventdata, handles)
htable = 1-feval('gray');
set(handles.figure1,'Colormap',htable);
if handles.imSize(3)> 1 
    set(handles.SliceNumEdit,'BackgroundColor','w','ForegroundColor','k');
end
guidata(hObject, handles);
% --------------------------------------------------------------------
function Jet_Callback(hObject, eventdata, handles)
htable = feval('jet');
set(handles.figure1,'Colormap',htable);
if handles.imSize(3)> 1 
    set(handles.SliceNumEdit,'BackgroundColor','b','ForegroundColor','y');
end
guidata(hObject, handles);
% --------------------------------------------------------------------
function boneWindow_Callback(hObject, eventdata, handles)
handles.intensityParam.lowerLimit = -250;
handles.intensityParam.upperLimit = 1250;
set(handles.axes1,'CLim',[-300 1250])
guidata(hObject,handles);
% --------------------------------------------------------------------
function lungWindow_Callback(hObject, eventdata, handles)
handles.intensityParam.lowerLimit = -2500;
handles.intensityParam.upperLimit = 1100;
set(handles.axes1,'CLim',[-2500 1100])
guidata(hObject,handles);
% --------------------------------------------------------------------
function mediasitnalWindow_Callback(hObject, eventdata, handles)
handles.intensityParam.lowerLimit = -450;
handles.intensityParam.upperLimit = 350;
set(handles.axes1,'CLim',[-450 350])
guidata(hObject,handles);
% --------------------------------------------------------------------
%---------------------------------------------------------
% Callbacks for imtoolsmenu
%----------------------------------------------------------
function imToolsMenu_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function imPixval_Callback(hObject, eventdata, handles)
if isempty(handles.hText)
handles.hText = impixelinfoval(handles.figure1,handles.ImgObject);
set(handles.hText,'FontWeight','bold');
set(handles.hText,'FontSize',10);
else
    delete(handles.hText);
    handles.hText =[];
end
guidata(hObject, handles);
% --------------------------------------------------------------------
function imHistogram_Callback(hObject, eventdata, handles)
myhistogram(1)
%-------------------------------------------------------------
function imProfile_Callback(hObject, eventdata, handles)
improfile;
title('Intensity profile');
ylabel('Intensity');
xlabel('Pixel position');
%------------------------------------------------
% Histogram function
% -----------------------------------------------
function myhistogram(htype)
img = getimage(gcbf);
if (htype==1)
    figure;hist(double(img(:)),64);
    title('Slice histogram');
    ylabel('Frequency');
    xlabel('Intensity');
elseif (htype == 2)
    figure;hist(log(double(img(:))+1),64);     
else
    htype = 0;
end
return;

% --- Executes during object creation, after setting all properties.
function popup_view_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%-------------------------------------------------------------
% --- Executes on selection change in popup_view.
%-------------------------------------------------------------
function popup_view_Callback(hObject, eventdata, handles)
v = get(hObject,'value');
if v ~=1
    nimg = convert_view(handles.oimage.CData,v);
else
    nimg = handles.oimage.CData;
end
[r,c,z]=size(nimg);
handles.image.CData = nimg;
handles.image.Xdata = [1 c];
handles.image.Ydata = [1 r];
handles.viewtype = v;
handles.imSize = [r,c,z];
reset(handles.axes1); axis off;
set(handles.SliceNumSlider,'Min',1,'Max',z,'Value',...
    round(z/2),'SliderStep',[1.0/double(z-1) 1.0/double(z-1)]);
set(handles.ImgObject,'Xdata',[1 c],'Ydata',[1 r]);
% Set the properties of the axes

set(handles.axes1,'XLim',[1 c],'YLim',[1 r],'PlotBoxAspectRatio',[c r 1]);

if ~isempty(handles.imageInfo)
    Sthick = handles.imageInfo.SliceThickness;
    if v == 2
        psize = handles.imageInfo.PixelSpacing(1);
        set(handles.axes1,'DataAspectRatio',[1 psize/Sthick  1]);
    elseif v == 3
        psize = handles.imageInfo.PixelSpacing(2);
        set(handles.axes1,'DataAspectRatio',[1 psize/Sthick  1]);
    else
        psize = handles.imageInfo.PixelSpacing;
        set(handles.axes1,'DataAspectRatio',[psize(1) psize(2)  1]);
    end
end
set(handles.SliceNumEdit,'String',num2str(round(z/2)));
cimg = handles.image.CData(:,:,round(z/2));
handles.currentSliceNumber = round(z/2);
set(handles.ImgObject,'Cdata',cimg);
guidata(hObject, handles);
drawnow
%-------------------------------------------------------------
% function s= convert_view(img,desired_view)
% img: input image
% It assumes that the original image is in transverse view(1)
% 1: transverse, 2: coronal, 3: sagittal views
% s: output image
function s= convert_view(img,desired_view)
[r,c,z]=size(img);
switch desired_view
    case 2
        s = permute(img,[3 2 1]);
        s=flipdim(s,1);
    case 3
        s = permute(img,[3 1 2]);
        s=flipdim(s,1);
    otherwise;
end
% --------------------------------------------------------------------
function readOrdinaryImageSeries_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile({'*.*'},'Image');
if isequal(filename,0)|isequal(pathname,0)
    setstatus('File not found');
else
    cd(pathname)
    k = findstr(filename,'.');
    fnames = dir(['*' filename(k+1:end)]);
    timg = imread(filename);
    [r,c,z] = size(timg);
    numSlices = size(fnames,1);
    nimg = zeros([r,c,numSlices]);
    if z == 3
        hw=warndlg('Color images will be converted to gray');
        uiwait;
        nimg(:,:,1) = rgb2gray(timg);
    else
        nimg(:,:,1) = timg;
    end
    hwb = waitbar(0,'Reading Images, please wait...');
    for i=2:numSlices
        waitbar(i/numSlices, hwb);
        timg = imread(fnames(i).name);
        [r,c,z] = size(timg);
        if z == 3
            nimg(:,:,i) = rgb2gray(timg);
        else
            nimg(:,:,i) = timg;
        end
    end
    close(hwb);
    clear timg;
    [r,c,z]=size(nimg);
    handles.image.CData = nimg;
    handles.image.Xdata = [1 c];
    handles.image.Ydata = [1 r];
    handles.imSize = [r,c,z];
    handles.SliceThickness = 1;
    if z==1
        sliderStep = 1;
    else
        sliderStep = 1.0/double(z-1);
    end
    set(handles.SliceNumSlider,'Min',1,'Max',z,'Value',...
        round(z/2),'SliderStep',[sliderStep sliderStep]);
    set(handles.ImgObject,'Xdata',[1 c],'Ydata',[1 r]);
    % Set the properties of the axes
    set(handles.axes1,'XLim',[1 c],'YLim',[1 r],'PlotBoxAspectRatio',[c r 1]);
    set(handles.SliceNumEdit,'String',num2str(round(z/2)));
    cimg = handles.image.CData(:,:,round(z/2));
    set(handles.ImgObject,'Cdata',cimg);
    handles.oimage = handles.image;
    guidata(hObject, handles);
    clear nimg;
    if z > 1
        turnDisplayButtons(handles,'on');
        set(handles.popupmenu_imageModality,'visible','off');
    end
    drawnow  
end
% --------------------------------------------------------------------
function saveImageIntoWorkspace_Callback(hObject, eventdata, handles)
assignin('base','IIMG',handles.image.CData);
% --------------------------------------------------------------------
function imfileMenu_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function ImMaps_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
% --------------------------------------------------------------------
function readWorkspaceImage_Callback(hObject, eventdata, handles)
Vars = evalin('base','who;');
if ~isempty (Vars)
    [s,v] = listdlg('PromptString','Select an image:',...
        'SelectionMode','single',...
        'Listsize',[150,200],...
        'ListString',Vars);
    if (v)
        imlook3d(evalin('base',Vars{s}));
    end
else
    disp('No workspace variable');
end

% --------------------------------------------------------------------
% Reads series of dicom images into a 3D array
% --------------------------------------------------------------------
function readDicomPETSeries_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile({'*.dcm';'*.*'},'Image');
if isequal(filename,0)|isequal(pathname,0)
    setstatus('File not found');
else
    cd(pathname)
    k = findstr(filename,'.');
    fnames = dir([filename(1:2) '*']);
    info = dicominfo(filename);
    r = info.Width;
    c = info.Height;
    numSlices = length(fnames);
    nimg = zeros([r,c,numSlices]);
    hw = waitbar(0,'Reading volume image, please wait...');
    for i=1:numSlices
        info = dicominfo(fnames(i).name);
        nimg(:,:,info.ImageIndex) = info.RescaleSlope*dicomread(info)+info.RescaleIntercept;
        waitbar(i/numSlices,hw);
    end
    close(hw);
    
    fields = {'Filename','FileModDate','FileSize','ImageType','Width','Height','BitDepth',...
        'NumberOfFrames','Rows','Columns','BitsAllocated','SmallestImagePixelValue',...
        'LargestImagePixelValue','PixelDataGroupLength','StudyDescription','SeriesDescription',...
        'StudyID','ImageID','PatientID','SliceThickness','StudyDate','AcquisitionDate',...
        'AcquisitionTime','PixelSpacing'};
    
    myinfo = keepfield(info,fields);
    
    handles.imageInfo = myinfo;
 
    [r,c,z]=size(nimg);
    handles.image.CData = nimg;
    handles.image.Xdata = [1 c];
    handles.image.Ydata = [1 r];
    handles.imSize = [r,c,z];
    set(handles.SliceNumSlider,'Min',1,'Max',z,'Value',...
        round(z/2),'SliderStep',[1.0/double(z-1) 1.0/double(z-1)]);
    set(handles.ImgObject,'Xdata',[1 c],'Ydata',[1 r]);
    % Set the properties of the axes
    set(handles.axes1,'XLim',[1 c],'YLim',[1 r],'PlotBoxAspectRatio',[c r 1]);
    set(handles.SliceNumEdit,'String',num2str(round(z/2)));
    cimg = handles.image.CData(:,:,round(z/2));
    set(handles.ImgObject,'Cdata',cimg);
    handles.oimage = handles.image;
    guidata(hObject, handles);
    clear nimg;
    if z>1
        turnDisplayButtons(handles,'on')
    end
    handles.imageModality = 1;
    set(handles.popupmenu_imageModality,'visible','on');
    set(handles.popupmenu_imageModality,'value',1);
    drawnow  
end
% --------------------------------------------------------------------
function saveCurrentSlice_Callback(hObject, eventdata, handles)
[filename, pathname,filterindex] = uiputfile({'*.png';'*.tif';'*.jpg'},'Image');
fformat = {'png','tif','jpg'}; 
if isequal(filename,0) | isequal(pathname,0)
    warndlg('No file name entered!');
else
    I= getframe(handles.axes1);
    I=frame2im(I);
    buffer=pwd;
    cd(pathname);
    imwrite(I,filename,fformat{filterindex});
    cd(buffer);
end
% --------------------------------------------------------------------
function adjust_intensity_window_Callback(hObject, eventdata, handles)
setappdata(0  ,  'hMainGui'    , gcf);
hMainGui = getappdata(0, 'hMainGui');
maxINT = max(max(max(handles.image.CData)));
minINT = min(min(min(handles.image.CData)));
cclim = get(handles.axes1,'CLim');
intensityParam = struct('lowerLimit',cclim(1),'upperLimit',cclim(2),'maxIntensity',maxINT, 'minIntensity',minINT);
setappdata(hMainGui,  'intensityParam', intensityParam);
adjustIntensityRangeGui;
uiwait;
hMainGui = getappdata(0,'hMainGui');
handles.intensityParam = getappdata(hMainGui,  'intensityParam');
guidata(hObject, handles);
% -----------------------------------------------------------------
function global_intensity_windowing_Callback(hObject, eventdata, handles)
str = get(gcbo,'Checked');
if strcmp(str,'off')
    handles.global_windowing =1;
    set(gcbo,'Checked','on');
else
    handles.global_windowing =0;
    set(gcbo,'Checked','off');
end
guidata(hObject,handles);
% --------------------------------------------------------------------
function renderVolume_Callback(hObject, eventdata, handles)
img= handles.image.CData;
if size(img,3) > 1
    prompt = {'Enter Lower Threshold:','Enter Upper Threshold:'};
    dlg_title = 'Enter Thresholds'; num_lines = 1; def = {'1','2'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    T(1) = str2num(answer{1,1});
    T(2) = str2num(answer{2,1});
    nimg = img >= T(1) & img <= T(2);
    s = size(img);
    vlim=[1 s(2) 1 s(1) 1 s(3)];
    figure;
    % set(get(hndl,'CurrentAxes'),'YDir','rev');
    [x y z D] = subvolume(nimg,vlim);
    p = patch(isosurface(x,y,z,D,0),'FaceColor','r','EdgeColor','none');
    p2 = patch(isocaps(x,y,z,D,0),'FaceColor','interp','EdgeColor','none');
    set(gca,'XTick',[],'YTick',[],'ZTick',[],'Box','on','Color','c');
    isonormals(x,y,z,D,p);
    axis tight;
    daspect([1 1 1])
    lighting gouraud
else
    msgbox('This is not a volume image','Error','modal');
end

% --------------------------------------------------------------------
% READS CT DICOM IMAGES
% --------------------------------------------------------------------
function readDicomCTSeries_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile({'*.dcm';'*.*'},'Image');
if isequal(filename,0)|isequal(pathname,0)
    setstatus('File not found');
else
    cd(pathname)
    k = findstr(filename,'.');
    fnames = dir(['*' filename(k(end)+1:end)]);
    info = dicominfo(filename);
    r = info.Width;
    c = info.Height;
    numSlices = length(fnames);
    nimg = zeros([r,c,numSlices]);
    hwb = waitbar(0,'Reading Images, please wait...');
    for i=1:numSlices
        waitbar(i/numSlices, hwb);
        info = dicominfo(fnames(i).name);
        nimg(:,:,i) = info.RescaleSlope*dicomread(info)+info.RescaleIntercept;
    end
    close(hwb);
    
    fields = {'Filename','FileModDate','FileSize','ImageType','Width','Height','BitDepth',...
        'NumberOfFrames','Rows','Columns','BitsAllocated','SmallestImagePixelValue',...
        'LargestImagePixelValue','PixelDataGroupLength','StudyDescription','SeriesDescription',...
        'StudyID','ImageID','PatientID','SliceThickness','StudyDate','AcquisitionDate','AcquisitionTime','PixelSpacing'};
    
    myinfo = keepfield(info,fields);
    handles.imageInfo = myinfo;
    
    [r,c,z]=size(nimg);
    handles.image.CData = nimg;
    handles.image.Xdata = [1 c];
    handles.image.Ydata = [1 r];
    handles.imSize = [r,c,z];
    set(handles.SliceNumSlider,'Min',1,'Max',z,'Value',...
        round(z/2),'SliderStep',[1.0/double(z-1) 1.0/double(z-1)]);
    set(handles.ImgObject,'Xdata',[1 c],'Ydata',[1 r]);
    % Set the properties of the axes
    set(handles.axes1,'XLim',[1 c],'YLim',[1 r],'PlotBoxAspectRatio',[c r 1]);
    set(handles.SliceNumEdit,'String',num2str(round(z/2)));
    cimg = handles.image.CData(:,:,round(z/2));
    set(handles.ImgObject,'Cdata',cimg);
    handles.oimage = handles.image;
    guidata(hObject, handles);
    clear nimg;
    handles.imageModality = 4;
    if z>1
        turnDisplayButtons(handles,'on')
    end
    handles.imageModality = 2;
    set(handles.popupmenu_imageModality,'visible','on');
    set(handles.popupmenu_imageModality,'value',2);
    drawnow  
end
% --------------------------------------------------------------------
function imageProcessMenu_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function imageThresholdManual_Callback(hObject, eventdata, handles)
img = getimage(gcbf);
th = cell2mat(inputdlg('Enter Threshold','Threshold',1,{'100'}));
if ~isempty(th)
    th = str2num(th);
    figure;imagesc(img>th);axis image;axis off
    title('Thresholded Image');
end
% --------------------------------------------------------------------
function automatedThresholding_Callback(hObject, eventdata, handles)
img = getimage(gcbf);
th=otsu_th(single(img(:)),64);
figure;imagesc(img>th);axis image;axis off
title('Thresholded Image');
% --------------------------------------------------------------------
% READS DICOM IMAGE SINGLE OR VOLUME
% --------------------------------------------------------------------
function readSingleDicomImage_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile({'*.dcm';'*.*'},'Image');
if isequal(filename,0)|isequal(pathname,0)
    setstatus('File not found');
else
    cd(pathname)
    info = dicominfo(filename);  
    if isfield(info,'NumberOfSlices')
        z = info.NumberOfSlices;
    elseif isfield(info,'NumberOfFrames')
        z = info.NumberOfFrames;
    end
    if isfield(info,'SliceThickness')
        handles.SliceThickness= info.SliceThickness;
    end 
    % Reading dicom image
    nimg = squeeze(dicomread(info));
    [r,c,z]=size(nimg);
    handles.image.CData = nimg;
    handles.image.Xdata = [1 c];
    handles.image.Ydata = [1 r];
    handles.imSize = [r,c,z];
    
    if z >1
        turnDisplayButtons(handles,'on');
        set(handles.SliceNumSlider,'Min',1,'Max',z,'Value',...
            round(z/2),'SliderStep',[1.0/double(z-1) 1.0/double(z-1)]);
        set(handles.SliceNumEdit,'String',num2str(round(z/2)));
        turnDisplayButtons(handles,'on');
        cimg = handles.image.CData(:,:,round(z/2));
    else
        turnDisplayButtons(handles,'off');
        cimg = handles.image.CData;
    end
    fields = {'Filename','FileModDate','FileSize','ImageType','Width','Height','BitDepth',...
        'NumberOfFrames','Rows','Columns','BitsAllocated','SmallestImagePixelValue',...
        'LargestImagePixelValue','PixelDataGroupLength','StudyDescription','SeriesDescription',...
        'StudyID','ImageID','PatientID','SliceThickness','StudyDate','AcquisitionDate','AcquisitionTime','PixelSpacing'};
    myinfo = keepfield(info,fields);
    handles.imageInfo = myinfo;
   
    % Set the properties of the axes and image object
    set(handles.ImgObject,'XData',[1 c],'YData',[1 r],'CData',cimg);
    set(handles.axes1,'XLim',[1 c],'YLim',[1 r],'PlotBoxAspectRatio',[c r 1],'DataAspectRatio',...
        [1 info.PixelSpacing(2)/info.PixelSpacing(1)  1]);
    handles.oimage = handles.image;
    guidata(hObject, handles);
    clear nimg;
    drawnow  
end
% --------------------------------------------------------------------
% --- Executes on selection change in popup_flip.
function popup_flip_Callback(hObject, eventdata, handles)
v = get(hObject,'value');
switch v
    case 1
       handles.image.CData = flipdim(handles.image.CData,2);
    case 2
        handles.image.CData = flipdim(handles.image.CData,1);
    case 3
        handles.image.CData = flipdim(handles.image.CData,3);
    case 4
    handles.image.CData = handles.oimage.CData;
    otherwise
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popup_flip_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function turnDisplayButtons(handles,bmode)
set(handles.SliceNumSlider,'visible',bmode);
set(handles.SliceNumEdit,'visible',bmode);
set(handles.popup_view,'visible',bmode);
set(handles.popup_flip,'visible',bmode);
set(handles.text1,'visible',bmode);
set(handles.text2,'visible',bmode);
set(handles.text3,'visible',bmode);
set(handles.popup_flip,'visible',bmode);     
return


% --------------------------------------------------------------------
function helpCallback_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
% --------------------------------------------------------------------
function helpMenu_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function helpAboutImlook3d_Callback(hObject, eventdata, handles)
s = sprintf(['IMLOOK3D: 3D Image Display Tool\n',...
    'Version 1.2, Copyright (2006 - Inf and Beyond)\n',...
    'Omer Demirkaya, KFSH&RC']);
msgbox(s,'About IMLOOK3D Tool','modal');
% --------------------------------------------------------------------
function helpDisclaimer_Callback(hObject, eventdata, handles)
s = {'This SOFTWARE DOES NOT (A) MAKE ANY WARRANTY, EXPRESS OR IMPLIED',
    'WITH RESPECT TO THE USE OF THE INFORMATION PROVIDED HEREBY; NOR (B)', 
    'GUARANTEE THE ACCURACY,COMPLETENESS,USEFULNESS,OR ADEQUACY OF ANY',
    'RESOURCES, INFORMATION,SYSTEM,PRODUCT,OR PROCESS AVAILABLE - AT OR', 
    'THROUGH THIS SOFTWARE.'};
msgbox(s,'Disclaimer','modal');

% --------------------------------------------------------------------
function imageInformation_Callback(hObject, eventdata, handles)
if ~isempty(handles.imageInfo)
    imageinfo(handles.imageInfo);
else
    msgbox('There is no image or no information about it','Image Info..','modal');
end

% --------------------------------------------------------------------
function readSingleOrdinaryImage_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile({'*.*'},'Image');
if isequal(filename,0)|isequal(pathname,0)
    setstatus('File not found');
else
    cd(pathname)
    info = imfinfo(filename);  
    [img, map]=imread(filename);
    [r,c,z] = size(img);
    handles.image.CData = img;
    handles.image.Xdata = [1 c];
    handles.image.Ydata = [1 r];
    handles.imSize = [r,c,z];
    
    if z > 1   % single slice
    set(handles.SliceNumSlider,'Min',1,'Max',z,'Value',...
        round(z/2),'SliderStep',[1.0/double(z-1) 1.0/double(z-1)]);
    set(handles.SliceNumEdit,'String',num2str(round(z/2)));
    turnDisplayButtons(handles,'on');
    cimg = handles.image.CData(:,:,round(z/2));
    else
        turnDisplayButtons(handles,'off');
        cimg = handles.image.CData;
    end
    handles.imageInfo = info;
   % Set the properties of the axes and image object
    set(handles.ImgObject,'XData',[1 c],'YData',[1 r],'CData',cimg);
    set(handles.axes1,'XLim',[1 c],'YLim',[1 r],'PlotBoxAspectRatio',[c r 1],'DataAspectRatio',[1 1 1]);
    handles.oimage = handles.image;
    guidata(hObject, handles);
    clear nimg;
    drawnow  
end
% --------------------------------------------------------------------
% SMOOTH IMAGE
% --------------------------------------------------------------------
function smoothVolume_Callback(hObject, eventdata, handles)
if size(handles.image.CData,3) > 1
h = waitbar(0,'Smoothing, please wait...');
handles.image.CData= smooth3(handles.image.CData,'gaussian');
close(h);
set(handles.ImgObject,'Cdata',handles.image.CData(:,:,handles.currentSliceNumber));
guidata(hObject,handles);
end
% --------------------------------------------------------------------
% Voxel dimensions
% --------------------------------------------------------------------
function voxelSize_Callback(hObject, eventdata, handles)
prompt = {'X Size:','Y Size:', 'Z Size'};
dlg_title = 'Enter Voxel Sizes'; num_lines = 1; def = {'1','1','1'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
if ~isempty(answer)
    voxdim(1) = str2num(cell2mat(answer(1,1)));
    voxdim(2) = str2num(cell2mat(answer(2,1)));
    voxdim(3) = str2num(cell2mat(answer(3,1)));
    bw = voxdim > 0; % checking for zero or negative
    if prod(double(bw))
        handles.imageInfo.PixelSpacing(1) = voxdim(1);
        handles.imageInfo.PixelSpacing(2) = voxdim(2);
        handles.imageInfo.SliceThickness  = voxdim(3);
        if handles.viewtype == 2
            set(handles.axes1,'DataAspectRatio',[1 voxdim(1)/voxdim(3)  1]);
        elseif handles.viewtype == 3
            set(handles.axes1,'DataAspectRatio',[1 voxdim(2)/voxdim(3)  1]);
        else
            set(handles.axes1,'DataAspectRatio',[1 voxdim(2)/voxdim(1)  1]);
        end

    end
end
guidata(hObject,handles);
% --------------------------------------------------------------------
% Horizontal Profile
% --------------------------------------------------------------------
function horizontalProfile_Callback(hObject, eventdata, handles)
h = warndlg('Double-click on the row','Pixel Selection');
uiwait;
[c,r,P] = impixel;
f = get(findobj(gcf,'Type','image'));
txt = ['Profile for row: ' num2str(r)];
figure;
plot(f.CData(r,:));title(txt);xlabel('Pixel location');ylabel('Intensity');
% --------------------------------------------------------------------
% Vertical Profile
% --------------------------------------------------------------------
function verticalProfile_Callback(hObject, eventdata, handles)
h = warndlg('Double-click on the column','Pixel Selection');
uiwait;
[c,r,P] = impixel;
f = get(findobj(gcf,'Type','image'));
txt = ['Profile for column: ' num2str(c)];
figure;
plot(f.CData(:,c));title(txt);xlabel('Pixel location');ylabel('Intensity');

% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
% --------------------------------------------------------------------
function popupmenu_imageModality_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --------------------------------------------------------------------
% --- Image modality selection
% --------------------------------------------------------------------
function popupmenu_imageModality_Callback(hObject, eventdata, handles)
imMod = get(hObject,'value');
handles.imageModality = imMod;

% --------------------------------------------------------------------
%  Executes MATLAB IMTOOL 
% --------------------------------------------------------------------
function imtoolMATLAB_Callback(hObject, eventdata, handles)
f = get(findobj(gcf,'Type','image'));
imtool(f.CData,[min(f.CData(:)) max(f.CData(:))]);
% --------------------------------------------------------------------
%  helpMenu on Imlook3D
% --------------------------------------------------------------------
function helpIMLOOK3D_Callback(hObject, eventdata, handles)
warndlg('Under Construction and needs help :)');
% --------------------------------------------------------------------
%  Reading MRI images
% --------------------------------------------------------------------
function readDICOMMRISeries_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile({'*.dcm';'*.*'},'Image');
if isequal(filename,0)|isequal(pathname,0)
    setstatus('File not found');
else
    cd(pathname)
    k = findstr(filename,'.');
    fnames = dir(['*' filename(k+1:end)]);
    info = dicominfo(filename);
    r = info.Width;
    c = info.Height;
    numSlices = length(fnames);
    nimg = zeros([r,c,numSlices]);
    hwb = waitbar(0,'Reading Images, please wait...');
    for i=1:numSlices
        waitbar(i/numSlices, hwb);
        info = dicominfo(fnames(i).name);
        nimg(:,:,i) = dicomread(info);
    end
    close(hwb);
    
    fields = {'Filename','FileModDate','FileSize','ImageType','Width','Height','BitDepth',...
        'NumberOfFrames','Rows','Columns','BitsAllocated','SmallestImagePixelValue',...
        'LargestImagePixelValue','PixelDataGroupLength','StudyDescription','SeriesDescription',...
        'StudyID','ImageID','PatientID','SliceThickness','StudyDate','AcquisitionDate','AcquisitionTime','PixelSpacing'};
    
    myinfo = keepfield(info,fields);
    handles.imageInfo = myinfo;
    
    [r,c,z]=size(nimg);
    handles.image.CData = nimg;
    handles.image.Xdata = [1 c];
    handles.image.Ydata = [1 r];
    handles.imSize = [r,c,z];
    set(handles.SliceNumSlider,'Min',1,'Max',z,'Value',...
        round(z/2),'SliderStep',[1.0/double(z-1) 1.0/double(z-1)]);
    set(handles.ImgObject,'Xdata',[1 c],'Ydata',[1 r]);
    % Set the properties of the axes
    set(handles.axes1,'XLim',[1 c],'YLim',[1 r],'PlotBoxAspectRatio',[c r 1]);
    set(handles.SliceNumEdit,'String',num2str(round(z/2)));
    cimg = handles.image.CData(:,:,round(z/2));
    set(handles.ImgObject,'Cdata',cimg);
    handles.oimage = handles.image;
    guidata(hObject, handles);
    clear nimg;
    if z>1
        turnDisplayButtons(handles,'on')
    end
    handles.imageModality = 4;
    set(handles.popupmenu_imageModality,'visible','on');
    set(handles.popupmenu_imageModality,'value',4);
    drawnow  
end

% --------------------------------------------------------------------
function cropVolume_Callback(hObject, eventdata, handles)
% hObject    handle to cropVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[I,rect] = imcrop; 
s = handles.image.CData;
switch handles.viewtype
    case 1
        [r,c,z]  = size(s); 
        oimg = crop3d(s,rect,[1 z]);
    case 2
%         s = permute(img,[3 2 1]);
%         s = flipdim(s,1);
        [r,c,z]  = size(s); 
        oimg = crop3d(s,rect,[1 z]);
    case 3
%         s = permute(img,[3 1 2]);
%         s = flipdim(s,1);
        [r,c,z]  = size(s); 
        oimg = crop3d(s,rect,[1 z]);
    otherwise;
end
imlook3d(oimg);



