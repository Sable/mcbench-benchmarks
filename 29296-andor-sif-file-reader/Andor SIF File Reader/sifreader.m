function varargout = sifreader(varargin)
% SIFREADER M-file for sifreader.fig
%      SIFREADER, by itself, creates a new SIFREADER or raises the existing
%      singleton*.
%
%      H = SIFREADER returns the handle to a new SIFREADER or the handle to
%      the existing singleton*.
%
%      SIFREADER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIFREADER.M with the given input arguments.
%
%      SIFREADER('Property','Value',...) creates a new SIFREADER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sifreader_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sifreader_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sifreader

% Written by Sathish Kumar Ramakrishnan
% E- mail: sathishkrishna12@gmail.com


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sifreader_OpeningFcn, ...
                   'gui_OutputFcn',  @sifreader_OutputFcn, ...
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


% --- Executes just before sifreader is made visible.
function sifreader_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sifreader (see VARARGIN)

% Choose default command line output for sifreader
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% movegui(hObject,'onscreen')% To display application onscreen
movegui(hObject,'center')  % Display GUI at the center


% UIWAIT makes sifreader wait for user response (see UIRESUME)
% uiwait(handles.figure1);
clear
clear all
clc
box off   % Remove the border around the axes 
axis off  % Show the axis  
hold off  % Remove any retained graph in the figure
setappdata(0,'sif', gcf);


% --- Outputs from this function are returned to the command line.
function varargout = sifreader_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
 msgbox('This Version supports for  4.13 and 4.15  Andor Solis Software version.','Welcome to Andor SIF File Reader (ASFR)','modal')
 uiwait(gcf); 


% --- Executes on button press in loadsif.
function loadsif_Callback(hObject, eventdata, handles)
% hObject    handle to loadsif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic;
[handles.file,pathname] = uigetfile('*.sif', 'Select the sif file');
guidata(hObject,handles)
file = handles.file;
f=fopen(file,'r'); % read the file
if f < 0
   errordlg('Could not open the file.'); % Unable or damaged 
end
tline=fgetl(f);
if ~isequal(tline,'Andor Technology Multi-Channel File')
   fclose(f);
   errordlg('Not an Andor SIF image file.');
end
[data]=read2(f);
date    = data.date;
temp    = data.temperature;
exptime = data.exposureTime;
cyctime = data.cycleTime;
accyclc = data.accumulateCycles;
acyctim = data.accumulateCycleTime;
stcyctim= data.stackCycleTime;
pxrtime = data.pixelReadoutTime;
gain    = data.gainDAC;
% Sno     = data.SerialNumber;
SoftVno = data.SoftwareVersion;
dettype = data.detectorType;
detsize = data.detectorSize;
file    = data.fileName;
shtime  = data.shutterTime;
fraaxis = data.frameAxis;
datatype= data.dataType;
sif = getappdata(0,'sif');
setappdata(sif,'date',date);
setappdata(sif,'temp',temp);
setappdata(sif,'exptime',exptime);
setappdata(sif,'cyctime',cyctime);
setappdata(sif,'accyclc',accyclc);
setappdata(sif,'acyctim',acyctim);
setappdata(sif,'stcyctim',stcyctim);
setappdata(sif,'pxrtime',pxrtime);
setappdata(sif,'gain',gain);
% setappdata(sif,'Sno',Sno);
setappdata(sif,'SoftVno',SoftVno);
setappdata(sif,'dettype',dettype);
setappdata(sif,'detsize',detsize);
setappdata(sif,'file',file);
setappdata(sif,'shtime',shtime);
setappdata(sif,'fraaxis',fraaxis);
setappdata(sif,'datatype',datatype);
handles.img = data.imageData;
guidata(hObject,handles)
img = handles.img;
imgsize = size(img,1);
imgsize2 = size(img,2);
handles.nFrames = size(img,3);
guidata(hObject,handles)
sliderimg_Callback(handles.sliderimg, eventdata, handles)
clear data
set(handles.pixelX,'string',imgsize);
set(handles.pixelY,'string',imgsize2);
set(handles.actionpanel,'string','File loaded');
set(handles.time,'string',toc);   % Displaying elapsed time
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function loadsif_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loadsif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on slider movement.
function sliderimg_Callback(hObject, eventdata, handles)
% hObject    handle to sliderimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
 tic;
 handles.val = floor(get(hObject,'Value'));
 set(hObject, 'SliderStep', [1/(handles.nFrames) 10/(handles.nFrames)],'Min', 1,'Max',handles.nFrames)
 set(handles.totframes, 'string',handles.nFrames)
 set(handles.curframe, 'string',handles.val)
 updateAxes(handles.imgaxes, eventdata, handles);
 sliderStatus = ['Image no: ' num2str(handles.val)];
 set(handles.actionpanel, 'string', sliderStatus)
 set(handles.time,'string',toc);
%  saveimgdata_Callback(handles.saveimgdata, eventdata, handles);
 guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function sliderimg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function updateAxes(hObject, eventdata, handles)
 handles.imgaxes;imagesc(handles.img(:,:,handles.val))
 colormap_Callback(handles.colormap, eventdata, handles);
 refresh;drawnow;
 guidata(hObject,handles)


% --- Executes on selection change in colormap.
function colormap_Callback(hObject, eventdata, handles)
% hObject    handle to colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns colormap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from colormap
tic
contents       = get(hObject,'String'); 
selectedText   = contents{get(hObject,'Value')};
set(handles.actionpanel, 'string', [selectedText ' colormap applied']);
colormap(selectedText)
set(handles.time,'string',toc);   % Displaying elapsed time
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function colormap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in loadsiffile2.
function loadsiffile2_Callback(hObject, eventdata, handles)
% hObject    handle to loadsiffile2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic;
[handles.file,pathname] = uigetfile('*.sif', 'Select the sif file');
guidata(hObject,handles)
file = handles.file;
f=fopen(file,'r'); % read the file
if f < 0
   errordlg('Could not open the file.'); % Unable or damaged 
end
tline=fgetl(f);
if ~isequal(tline,'Andor Technology Multi-Channel File')
   fclose(f);
   errordlg('Not an Andor SIF image file.');
end
[data]=read(f);
date    = data.date;
temp    = data.temperature;
exptime = data.exposureTime;
cyctime = data.cycleTime;
accyclc = data.accumulateCycles;
acyctim = data.accumulateCycleTime;
stcyctim= data.stackCycleTime;
pxrtime = data.pixelReadoutTime;
gain    = data.gainDAC;
% Sno     = data.SerialNumber;
SoftVno = data.SoftwareVersion;
dettype = data.detectorType;
detsize = data.detectorSize;
file    = data.fileName;
shtime  = data.shutterTime;
fraaxis = data.frameAxis;
datatype= data.dataType;
sif = getappdata(0,'sif');
setappdata(sif,'date',date);
setappdata(sif,'temp',temp);
setappdata(sif,'exptime',exptime);
setappdata(sif,'cyctime',cyctime);
setappdata(sif,'accyclc',accyclc);
setappdata(sif,'acyctim',acyctim);
setappdata(sif,'stcyctim',stcyctim);
setappdata(sif,'pxrtime',pxrtime);
setappdata(sif,'gain',gain);
% setappdata(sif,'Sno',Sno);
setappdata(sif,'SoftVno',SoftVno);
setappdata(sif,'dettype',dettype);
setappdata(sif,'detsize',detsize);
setappdata(sif,'file',file);
setappdata(sif,'shtime',shtime);
setappdata(sif,'fraaxis',fraaxis);
setappdata(sif,'datatype',datatype);
handles.img = data.imageData;
guidata(hObject,handles)
img = handles.img;
imgsize = size(img,1);
imgsize2 = size(img,2);
handles.nFrames = size(img,3);
guidata(hObject,handles)
sliderimg_Callback(handles.sliderimg, eventdata, handles)
% clear data
set(handles.pixelX,'string',imgsize);
set(handles.pixelY,'string',imgsize2);
set(handles.actionpanel,'string','File loaded');
set(handles.time,'string',toc);   % Displaying elapsed time
guidata(hObject,handles)

function [info] = read(f)
skipBytes(f,8);
o=fscanf(f,'%f',6);
info.date=datestr(o(5)/86400 + 719529);
info.temperature=o(6);
skipBytes(f,10);
o=fscanf(f,'%f',5);
info.exposureTime=o(2);
info.cycleTime=o(3);
info.accumulateCycles=o(5);
info.accumulateCycleTime=o(4);
skipBytes(f,2);
o=fscanf(f,'%f',5);
info.stackCycleTime=o(1);
info.pixelReadoutTime=o(2);
info.gainDAC=o(5);
skipBytes(f,49);
info.SerialNumber=fscanf(f,'%d',1);
skipBytes(f,29);
o=fscanf(f,'%d',5);
info.SoftwareVersion = [o(1) o(2) o(3) o(4) o(5)];
skipBytes(f,5);
info.detectorType=deblank(fgetl(f));
info.detectorSize=fscanf(f,'%d',[1 2]);
info.fileName=readString(f);
skipLines(f,3);
skipBytes(f,14);
info.shutterTime=fscanf(f,'%f',[1 2]);
skipLines(f,17);
info.frameAxis=readString(f);
info.dataType=readString(f);
info.imageAxis=readString(f);
o=fscanf(f,'%d',16);
info.imageArea=[o(2) o(5) o(7);o(4) o(3) o(6)];
info.frameArea=[o(11) o(14);o(13) o(12)]; % pixel frame 256x 256
info.frameBins=[o(16) o(15)];
s=(1 + diff(info.frameArea))./info.frameBins;
z=1 + diff(info.imageArea(5:6));
if prod(s) ~= o(9) || o(9)*z ~= o(8)
   fclose(f);
   error('Inconsistent image header.');
end
o=readString(f);
fprintf('%s\n',o);
skipLines(f,z);             
info.imageData=reshape(fread(f,prod(s)*z,'*single'),[s z]);

function [info] = read2(f)
skipBytes(f,8);
o=fscanf(f,'%f',6);
info.date=datestr(o(5)/86400 + 719529);
info.temperature=o(6);
skipBytes(f,10);
o=fscanf(f,'%f',5);
info.exposureTime=o(2);
info.cycleTime=o(3);
info.accumulateCycles=o(5);
info.accumulateCycleTime=o(4);
skipBytes(f,2);
o=fscanf(f,'%f',5);
info.stackCycleTime=o(1);
info.pixelReadoutTime=o(2);
info.gainDAC=o(5);
skipBytes(f,57);
info.SerialNumber=fscanf(f,'%d',1);
skipBytes(f,22);
o=fscanf(f,'%d',5);
info.SoftwareVersion = [o(1) o(2) o(3) o(4) o(5)];
skipBytes(f,5);
info.detectorType=deblank(fgetl(f));
info.detectorSize=fscanf(f,'%d',[1 2]);
info.fileName=readString(f);
skipLines(f,3);
skipBytes(f,14);
info.shutterTime=fscanf(f,'%f',[1 2]);
skipLines(f,17);
info.frameAxis=readString(f);
info.dataType=readString(f);
info.imageAxis=readString(f);
o=fscanf(f,'%d',16);
info.imageArea=[o(2) o(5) o(7);o(4) o(3) o(6)];
info.frameArea=[o(11) o(14);o(13) o(12)]; % pixel frame 256x 256
info.frameBins=[o(16) o(15)];
s=(1 + diff(info.frameArea))./info.frameBins;
z=1 + diff(info.imageArea(5:6));
if prod(s) ~= o(9) || o(9)*z ~= o(8)
   fclose(f);
   error('Inconsistent image header.');
end
o=readString(f);
fprintf('%s\n',o);
skipLines(f,z);             
info.imageData=reshape(fread(f,prod(s)*z,'*single'),[s z]);

function skipBytes(f,N)
[n]=fread(f,N,'*uint8');

function skipLines(f,N)
for n=1:N
   if isequal(fgetl(f),-1)
      fclose(f);
      error('Inconsistent image header.');
   end
end

function o=readString(f)
n=fscanf(f,'%f',1);  % Base 10
if isempty(n) || n < 0 || isequal(fgetl(f),-1)
   fclose(f);
   error('Inconsistent string.');
end
o=fread(f,[1 n],'uint8=>char');

% ***********************************************************************
% ***********************************************************************
% ***********************************************************************


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[aboutsel] = sprintf('Author: Sathish Kumar Ramakrishnan \n\n Email: sathishkrishna12@gmail.com \n\nVersion No: 1.0');
msgbox(aboutsel, 'About');


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[help] = sprintf(' Check your Andor Solis Version and choose load button for your version.\n Get the file header information by clicking Metadatainfo Menu. \n Navigate the frames using Slider. \n Action and time panel display your action and elasped time \n Apply different colormaps to your image. \n Export the image frames to workspace.');
msgbox(help, 'Help');

% --------------------------------------------------------------------
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --------------------------------------------------------------------
function metadatainfo_Callback(hObject, eventdata, handles)
% hObject    handle to metadatainfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
metadata;


% --- Executes on button press in saveimgdata.
function saveimgdata_Callback(hObject, eventdata, handles)
% hObject    handle to saveimgdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = handles.img;
checkLabels = {'Save the image info to variable named:'}; 
varNames = {'Imagedata'}; 
items = {img};
export2wsdlg(checkLabels,varNames,items,...
             'Save Image frames to Workspace');



